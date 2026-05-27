## Context

`super_player` 是腾讯云播放器 SDK 的 Flutter 插件，Android/iOS 已有较完整原生实现。当前 OHOS 目录只提供 HAR 插件壳和一个 `MethodChannel("super_player")` 占位实现，尚未注册平台视图、Pigeon HostApi/FlutterApi，也没有播放器、下载和事件封装。Dart 侧 `TXPlayerVideo` 只支持 `AndroidView` 与 `UiKitView`，在 OHOS 上会抛 `platform not support`。

本设计以 `docs/OHOS适配分析.md` 为适配依据，目标是在不改变现有 Dart 控制器语义的前提下补齐 OHOS 原生链路。实现时必须从仓库根目录使用 `fvm dart` / `fvm flutter`，不直接执行 `dart` / `flutter`。既有 Dart 文件仅做小范围修改，不运行全量格式化。

## Goals / Non-Goals

**Goals:**

- 保持 `TXPlayerVideo(onRenderViewCreatedListener: controller.setPlayerView)` 的跨端语义一致。
- 在 OHOS 上注册 `FTXRenderViewType` 平台视图，并通过 ArkUI `XComponent` 获取 `surfaceId` 绑定 LiteAVSDK。
- 使用 OHOS Pigeon `--arkts_out` 生成消息代码，注册全局 API、播放器实例 API 和 Flutter 回调 API。
- 打通点播 URL 播放、直播 URL 播放、基础控制、事件回调、全局 License/环境/缓存配置。
- 为下载、预下载、多音轨、外挂字幕、SEI、H.264 截图等鸿蒙播放器 SDK 支持能力建立可落地实现路径。
- 对 PIP、商业 DRM、PDT Seek、TRTC/推流发布、系统亮度、显示效果等非基础播放器能力给出稳定降级行为。

**Non-Goals:**

- 不修改 Android/iOS 原生实现的行为。
- 不重写 Dart 对外 API，不引入 OHOS 专属播放器控制器。
- 不修改 OHOS Pigeon 生成器；播放器实例通道 suffix 通过生成产物外的薄封装解决。
- 不在第一阶段实现鸿蒙播放器 SDK 未明确支持的 PIP、商业 DRM、雪碧图预览、TRTC/推流发布和复杂 UI 能力。

## Decisions

### 1. Dart 入口只增加 OHOS 平台视图分支

`TXPlayerVideoState.build` 增加 `TargetPlatform.ohos` 分支，构造 `OhosView`，继续使用 `viewType = "FTXRenderViewType"`、`StandardMessageCodec` 和 `renderViewType` creation param。新增 `_onCreateOhosView` 复用 Android/iOS 的 viewId 完成和回调逻辑。

理由：现有控制器已通过 `setPlayerView(viewId)` 完成播放器与渲染容器绑定。保持同一个 viewId 语义可以复用业务代码，也能支持横竖屏和多渲染视图切换。

备选方案是在 Dart 层新增 OHOS 专用 Widget 或控制器。该方案会扩大 API 面并破坏现有跨端写法，因此不采用。

### 2. OHOS 渲染使用 PlatformView + ArkUI XComponent

OHOS 插件在 `onAttachedToEngine` 注册 `FTXRenderViewFactory`。Factory 使用 `Map<number, FTXRenderView>` 按 Flutter 分配的 viewId 缓存视图。`FTXRenderView` 返回 `WrappedBuilder<[Params]>`，ArkUI 组件内部创建 `XComponentType.SURFACE`，在 `onLoad` 后设置 surface rect 并读取 `surfaceId`。

点播播放器通过 `TXVodPlayer.setVideoRenderTarget(surfaceId)` 绑定；直播播放器通过 `V2TXLivePlayer.setRenderView(surfaceId)` 绑定。`setPlayerView` 和 `XComponent.onLoad` 顺序不固定，因此 view 和 player 都必须支持 pending attach。

备选方案是只维护一个全局 render view。该方案无法满足现有 Dart 注释中“记录多个 viewId 并切换”的场景，因此不采用。

### 3. Pigeon 生成代码负责数据结构，实例通道 suffix 用薄封装补齐

从 `generator/txplayer_message.dart` 生成 `ohos/src/main/ets/components/plugin/messages/FtxMessages.ets`。全局 API 直接使用生成的 `setup(binaryMessenger, api)` 注册。由于 OHOS Pigeon 生成的 ArkTS setup/FlutterApi 构造不支持 `messageChannelSuffix`，Vod/Live 实例 API 和回调 API 由额外工具类按 `.<playerId>` 拼接通道名并复用生成 codec 与消息结构。

理由：Dart 控制器会使用 `messageChannelSuffix: _playerId.toString()` 调用实例通道，如果 OHOS 只注册无 suffix 通道，会产生 MissingPlugin。薄封装能解决当前项目需求，同时避免维护自定义 Pigeon fork。

备选方案是手写全部 Pigeon codec 或修改生成器。前者风险高且容易与 Dart 消息结构漂移；后者增加工具链维护成本，因此不采用。

### 4. 播放器实例集中由插件入口管理生命周期

`SuperPlayerPlugin.ets` 保存 `Map<number, FTXVodPlayer>` 和 `Map<number, FTXLivePlayer>`，负责分配 playerId、注册实例 HostApi、创建 FlutterApi 回调、释放播放器和注销通道。播放器 wrapper 只负责 SDK 对象封装、render view attach/detach、API 映射和事件转换。

理由：playerId 是 Dart 侧实例通道 suffix 的核心索引，集中管理可以减少重复注册和泄漏风险。

### 5. 事件转换以 Dart 现有状态机为准

OHOS SDK 回调必须转换成 Dart 已使用的事件码和字段名，例如播放开始、首帧、缓冲、进度、结束、错误、分辨率变化、License 加载结果。网络状态字段尽量对齐 Android/iOS map key。

理由：Dart 控制器当前依赖既有事件码更新 `TXPlayerValue`、广播事件和网络状态。只在 OHOS 原生侧做转换，可以降低 Dart 改动范围。

### 6. 非支持能力必须稳定降级

PIP、商业 DRM、PDT Seek、TRTC/推流发布、雪碧图预览、系统亮度、复杂显示效果等不作为 P0/P1 必须交付能力。对应 Dart API 在 OHOS 上必须返回明确不支持、false、默认值或 no-op，不能抛未捕获异常或卡住 Future。

理由：这些能力涉及 OHOS 系统能力或其他 SDK，不属于打通基础播放链路的必要条件。稳定降级比半实现更可控。

## Risks / Trade-offs

- Pigeon ArkTS 生成代码与 Dart 消息结构不一致 → 使用仓库内同一个 `generator/txplayer_message.dart` 生成，并在任务中加入生成命令和编译验证。
- 实例通道 suffix 注册遗漏 → 为 Vod/Live 创建和释放流程增加集中注册/注销工具，并用 `startVodPlay.<playerId>`、`startLivePlay.<playerId>` 做端到端验证。
- `setPlayerView` 早于 `XComponent.onLoad` 或晚于 surface ready → render view 和 player 双方保存当前状态，surface ready 后重复 attach。
- 多 view 切换导致旧 surface 泄漏 → `FTXRenderView.setPlayer(undefined)`、`onSurfaceDestroyed`、`dispose` 均执行 detach，并从 Factory Map 移除 viewId。
- LiteAVSDK HAR 版本与插件版本不一致 → 实施前核对 `ohos/oh-package.json5` 与 HAR 文件版本，无法升级时建立差异表，对缺失接口做降级。
- 事件码字段不一致导致 Dart 状态不更新 → 以 Android/iOS 已有事件 map 为对照实现 OHOS 转换层，并在 example 中验证播放、缓冲、进度、结束、错误。
- OHOS 文件权限影响下载 → 下载目录优先使用应用沙箱路径，公共目录需求单独补权限和迁移说明。
- 系统亮度、PIP、TRTC 等平台能力边界不清 → 第一阶段明确返回不支持或 no-op，避免阻塞基础播放器交付。

## Migration Plan

1. 先实现 Dart `OhosView` 和 OHOS 平台视图注册，验证 `viewId` 能回调。
2. 生成并接入 `FtxMessages.ets`，实现全局 API、实例 suffix 注册工具和最小点播 HostApi。
3. 实现 `FTXVodPlayer` URL 点播、render target 绑定和基础事件回调，完成 P0 验收。
4. 扩展直播播放器、基础控制、配置映射和网络状态回调，完成 P1 验收。
5. 接入下载/预下载、字幕、音轨、SEI、截图、缓存和高级配置，完成 P2 验收。
6. 对 P3 平台增强能力建立独立 issue 或后续 OpenSpec 变更。

回滚策略：Dart 侧 OHOS 分支可独立回退为抛不支持；OHOS 原生新增文件可从插件注册入口移除。Android/iOS 不受影响。

## Open Questions

- 当前内置 `LiteAVSDK_Professional_13.2.0.8729.har` 是否需要升级到与插件版本 `13.3.0` 匹配的 OHOS HAR？
- 本地 OHOS Flutter SDK 的 `OhosView` 构造参数是否与文档示例完全一致，还是需要按实际 SDK API 微调？
- LiteAVSDK OHOS 是否公开 License flexible valid、日志配置、字幕样式、硬解开关、截图回调等全部接口？
- 下载文件是否必须进入公共目录或媒体库；若必须，需要补充 OHOS 权限和用户授权流程。
