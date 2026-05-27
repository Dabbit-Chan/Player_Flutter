## 1. 工具链与消息代码

- [ ] 1.1 核对 `ohos/oh-package.json5` 中 LiteAVSDK HAR 版本与当前插件版本的差异，并记录缺失或需降级的 OHOS SDK 接口。
- [ ] 1.2 更新 `generator/txplayer_message.dart` 顶部生成命令，使用 `fvm dart run pigeon` 并加入 `--arkts_out ohos/src/main/ets/components/plugin/messages/FtxMessages.ets`。
- [ ] 1.3 从仓库根目录执行 Pigeon 生成命令，生成或刷新 Dart、Android、iOS、OHOS 消息代码。
- [ ] 1.4 在 OHOS 侧新增实例通道 suffix 注册工具，复用 Pigeon 生成的消息结构和 codec，为 Vod/Live HostApi 与 FlutterApi 拼接 `.<playerId>` 通道。

## 2. Dart OHOS 渲染入口

- [ ] 2.1 在 `lib/Core/txplayer_widget.dart` 中为 `TargetPlatform.ohos` 增加 `OhosView` 分支，保持 `FTXRenderViewType`、`renderViewType` 参数和 `StandardMessageCodec`。
- [ ] 2.2 新增 `_onCreateOhosView`，复用 Android/iOS 的 viewId completer 和 `onRenderViewCreatedListener` 回调逻辑。
- [ ] 2.3 确认本地 OHOS Flutter SDK 的 `OhosView` 构造参数并调整 import 或 API 调用。

## 3. OHOS 插件入口与渲染视图

- [ ] 3.1 重构 `ohos/src/main/ets/components/plugin/SuperPlayerPlugin.ets`，保留插件唯一类名并接入 BinaryMessenger、ApplicationContext、平台视图注册和 API 注册。
- [ ] 3.2 新增 `render/FTXRenderViewFactory.ets`，继承 OHOS Flutter `PlatformViewFactory`，按 `viewId` 缓存和查询多个 `FTXRenderView`。
- [ ] 3.3 新增 `render/FTXRenderView.ets`，实现 `PlatformView`、`WrappedBuilder`、绑定播放器、解绑播放器、surface ready、surface destroyed 和 dispose 生命周期。
- [ ] 3.4 在 ArkUI builder 中创建 `XComponentType.SURFACE`，设置组件宽高和 surface rect，并把 `surfaceId` 回传给 `FTXRenderView`。
- [ ] 3.5 实现 `setPlayerView(viewId)` 的 pending attach 逻辑，覆盖先调用 setPlayerView 和先获得 surfaceId 两种顺序。

## 4. 全局 API 与生命周期管理

- [ ] 4.1 实现 `TXFlutterSuperPlayerPluginAPI` 的 OHOS HostApi，包括 `createVodPlayer`、`createLivePlayer`、`releasePlayer`、`getPlatformVersion` 和 SDK 版本查询。
- [ ] 4.2 在 `SuperPlayerPlugin.ets` 中维护 Vod/Live playerId Map，创建播放器时注册 suffixed HostApi，释放播放器时停止播放、解绑渲染、释放 SDK 对象并移除实例。
- [ ] 4.3 接入 `setGlobalLicense`、License 回调、`setGlobalEnv`、`setUserId`、日志开关和全局缓存配置。
- [ ] 4.4 实现 `TXFlutterNativeAPI` 的音量能力，并为 PIP、亮度、音频焦点等未实现能力返回稳定不支持或 no-op 结果。

## 5. 点播播放器

- [ ] 5.1 新增 `player/FTXVodPlayer.ets`，封装 OHOS LiteAVSDK `TXVodPlayer` 创建、释放、停止和基础状态维护。
- [ ] 5.2 实现 URL 点播 `startVodPlay(url)`，并在 render surface 可用时调用 `setVideoRenderTarget(surfaceId)`。
- [ ] 5.3 实现 FileId 点播 `startVodPlayWithParams`，映射 appId、fileId、psign 和 URL 参数。
- [ ] 5.4 实现点播基础控制：stop、pause、resume、isPlaying、seek、mute、loop、rate、volume、startTime、duration、current time、width、height。
- [ ] 5.5 实现点播配置映射：重试、超时、headers、精准 seek、缓存、进度回调间隔、preferredResolution 等 OHOS SDK 可用字段。
- [ ] 5.6 实现点播高级可用能力：码率列表/切换、多音轨、外挂字幕、字幕样式、H.264 截图。
- [ ] 5.7 对商业 DRM、PDT Seek、雪碧图预览、HEVC 降级等不支持能力返回稳定不支持或 no-op 结果。
- [ ] 5.8 将点播播放事件和网络状态转换为 Dart 兼容事件码与 map 字段，并通过 suffixed `TXVodPlayerFlutterAPI` 回调。

## 6. 直播播放器

- [ ] 6.1 新增 `player/FTXLivePlayer.ets`，封装 OHOS LiteAVSDK `V2TXLivePlayer` 创建、释放、停止和基础状态维护。
- [ ] 6.2 实现直播 `startLivePlay(url)`，并在 render surface 可用时调用 `setRenderView(surfaceId)`。
- [ ] 6.3 实现直播基础控制：stop、pause、resume、isPlaying、mute、volume、live mode、appId、hardware decode、cache params 和 stream switch。
- [ ] 6.4 实现直播可用高级能力：SEI 接收、setProperty、码流信息、H.264 截图。
- [ ] 6.5 对本地录制、调试浮层或 OHOS SDK 不支持能力返回稳定不支持或 no-op 结果。
- [ ] 6.6 将直播 observer 回调转换为 Dart 兼容事件码与 map 字段，并通过 suffixed `TXLivePlayerFlutterAPI` 回调。

## 7. 下载与预下载

- [ ] 7.1 新增 `download/FTXDownloadManager.ets`，封装 `TXVodDownloadManager`、`TXVodPreloadManager` 和下载/预下载回调。
- [ ] 7.2 实现 URL/FileId 预下载 start/stop，返回 taskId 并回调开始、完成和错误事件。
- [ ] 7.3 实现下载 start、resume、stop、list、info、delete 和 headers 设置，优先使用应用沙箱路径。
- [ ] 7.4 将 OHOS 下载媒体信息转换为 Dart `TXVodDownloadMediaMsg` / `TXDownloadListMsg` 兼容结构。
- [ ] 7.5 将下载开始、进度、停止、完成和错误事件通过 `TXDownloadFlutterAPI` 回调给 Dart。

## 8. 示例工程与权限

- [ ] 8.1 核对 `example/ohos` 插件注册链路，确保 `GeneratedPluginRegistrant.ets` 能注册 `SuperPlayerPlugin`。
- [ ] 8.2 核对 `example/ohos/entry/src/main/module.json5`，保留播放所需网络权限，并仅在写公共目录时增加下载相关权限。
- [ ] 8.3 在示例播放路径中验证 License 设置、`TXPlayerVideo` 创建、`setPlayerView(viewId)`、点播 URL 播放、暂停恢复、seek、静音和事件回调。
- [ ] 8.4 增加或更新 OHOS 适配说明，记录 P0/P1/P2/P3 能力边界和已知不支持项。

## 9. 验证

- [ ] 9.1 从仓库根目录执行 `fvm dart analyze` 或项目当前可用的等效静态检查，并修复本变更引入的问题。
- [ ] 9.2 构建 OHOS 插件或 example，确认 ArkTS 编译通过、Pigeon 通道注册无 MissingPlugin。
- [ ] 9.3 在 OHOS 设备或模拟器上验证 P0：点播 URL 出首帧、播放声音、进度回调、停止释放和重新进入页面。
- [ ] 9.4 在 OHOS 设备或模拟器上验证 P1：直播播放、基础控制、横竖屏或 Widget 重建后的 viewId 重新绑定。
- [ ] 9.5 验证不支持能力的降级行为：PIP、商业 DRM、PDT Seek、TRTC/推流发布接口不崩溃且 Future 正常完成。
