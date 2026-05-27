## Why

`super_player` 已声明 OHOS 平台并内置 LiteAVSDK HAR，但当前 OHOS 侧只有占位 MethodChannel，Dart 渲染 Widget 也会直接拒绝 OHOS，导致播放器控制器无法在鸿蒙端创建可用播放链路。

本变更按照 `docs/OHOS适配分析.md` 的结论补齐 OHOS 适配契约，使插件至少具备与 Android/iOS 一致的渲染绑定、Pigeon 通信、点播/直播基础播放、事件回调、全局配置和下载预下载接入路径。

## What Changes

- 为 Dart `TXPlayerVideo` 增加 OHOS 平台视图分支，使用与 Android/iOS 一致的 `FTXRenderViewType` 和 `viewId` 绑定语义。
- 在 OHOS 插件侧引入 Pigeon ArkTS 生成代码并注册全局 HostApi、播放器实例 HostApi、FlutterApi 回调。
- 实现 OHOS 平台视图工厂和 ArkUI `XComponent` 渲染容器，按 `viewId` 缓存多个 render view，并把 `surfaceId` 绑定给 LiteAVSDK。
- 封装 OHOS `TXVodPlayer` 和 `V2TXLivePlayer` 的基础生命周期、播放控制、渲染绑定、事件和网络状态回调。
- 接入全局 License、环境、缓存路径/大小、用户标识等基础配置。
- 接入下载和预下载管理的基础通道，使 Dart 下载 API 在 OHOS 上不再缺失。
- 更新 Pigeon 生成命令文档，明确需要从仓库根目录使用 `fvm dart run pigeon` 并包含 `--arkts_out`。
- 更新 OHOS 示例工程所需权限和基础验证路径。

## Capabilities

### New Capabilities

- `super-player-ohos-playback`: 定义 SuperPlayer Flutter 插件在 OHOS 上的渲染、通信、点播、直播、事件、全局配置、下载预下载和示例可用性要求。

### Modified Capabilities

无。当前 `openspec/specs/` 下没有既有能力规格，本次新增 OHOS 播放能力规格。

## Impact

- 影响 Dart 对外 API 的平台分支行为，但不改变现有 Android/iOS API 签名。
- 影响 `generator/txplayer_message.dart` 和生成产物，新增 OHOS ArkTS Pigeon 消息代码。
- 影响 `ohos/src/main/ets` 插件实现，包括插件入口、平台视图、播放器封装、API 注册、事件分发、下载管理和全局配置。
- 影响 `ohos/oh-package.json5`、`ohos/src/main/module.json5`、`example/ohos` 的依赖、权限和构建配置。
- 依赖本地 FVM 配置、支持 OHOS 的 Pigeon 分支，以及 OHOS LiteAVSDK HAR 暴露的 `TXVodPlayer`、`V2TXLivePlayer`、下载/预下载相关 API。
