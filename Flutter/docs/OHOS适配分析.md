# Super Player Flutter 插件 OHOS 适配分析

## 1. 项目是什么

本项目是腾讯云播放器 SDK 的 Flutter 插件，包名为 `super_player`，当前版本为 `13.3.0`。它把腾讯云 LiteAVSDK 的点播、直播、下载、预下载、播放器渲染、全局 License、音量亮度等原生能力封装成 Flutter 可调用的 Dart API。

项目主要目录如下：

| 目录 | 作用 |
| --- | --- |
| `lib/` | Flutter/Dart 对外 API，包括播放器控制器、Pigeon 消息、渲染 Widget、配置对象。 |
| `android/` | Android 原生插件实现，包含播放器封装、平台视图、下载、PIP、事件分发。 |
| `ios/` | iOS 原生插件实现，包含播放器封装、平台视图、下载、PIP、事件分发。 |
| `ohos/` | OHOS HAR 插件壳和 LiteAVSDK HAR 依赖。当前只有极少量占位实现。 |
| `example/` | Flutter Demo，已存在 `example/ohos` 工程壳。 |
| `generator/txplayer_message.dart` | Pigeon 源文件，用于生成 Dart/Android/iOS/OHOS 通信代码。项目使用支持 OHOS 的 Pigeon，注释命令需要补上 `--arkts_out` 示例。 |
| `docs/` | 项目文档。 |

## 2. 项目已有功能

从 Dart API 和 Android/iOS 原生实现看，本插件包含以下功能面：

| 功能 | Dart 入口 | 原生对应 |
| --- | --- | --- |
| 全局插件能力 | `SuperPlayerPlugin` | `TXFlutterSuperPlayerPluginAPI`、`TXFlutterNativeAPI` |
| 点播播放 | `TXVodPlayerController` | `FTXVodPlayer` / `TXVodPlayer` |
| 直播播放 | `TXLivePlayerController` | `FTXLivePlayer` / `V2TXLivePlayer` |
| 视频渲染 | `TXPlayerVideo` + `setPlayerView(viewId)` | `FTXRenderViewFactory` / `FTXRenderView` |
| 播放器事件 | `onPlayerState`、`onPlayerEventBroadcast`、`onPlayerNetStatusBroadcast` | Pigeon FlutterApi 回调 |
| 下载和预下载 | `TXVodDownloadController` | `FTXDownloadManager` |
| 全局缓存 | `setGlobalCacheFolderPath`、`setGlobalMaxCacheSize` | `TXPlayerGlobalSetting` / `TXVodGlobalSetting` |
| License / SDK 环境 | `setGlobalLicense`、`setGlobalEnv`、`setUserId` | `TXLiveBase` / `V2TXLivePremier` |
| 音量和亮度 | `setBrightness`、`setSystemVolume` 等 | Android/iOS 系统 API |
| 画中画 | `enterPictureInPictureMode`、`exitPictureInPictureMode` | Android/iOS PIP |
| 高级点播能力 | DRM、字幕、多音轨、截图、雪碧图、码率切换 | LiteAVSDK Premium 能力 |
| 高级直播能力 | SEI、调试浮层、码率、缓存、录制、截图 | `V2TXLivePlayer` 能力 |

## 3. 当前 OHOS 现状

项目已经有 OHOS 平台声明和目录，但只是初始状态，不能认为已经完成适配。

已存在内容：

- `pubspec.yaml` 已声明：

```yaml
flutter:
  plugin:
    platforms:
      ohos:
        package: com.tencent.vod.flutter
        pluginClass: SuperPlayerPlugin
```

- `ohos/oh-package.json5` 已依赖本地 HAR：

```json5
"dependencies": {
  "liteavsdk": "file:libs/LiteAVSDK_Professional_13.2.0.8729.har"
}
```

- `ohos/src/main/ets/components/plugin/SuperPlayerPlugin.ets` 目前只注册了一个普通 `MethodChannel("super_player")`，只实现了 `getPlatformVersion`。

缺失内容：

- Dart `TXPlayerVideo` 只支持 Android `AndroidView` 和 iOS `UiKitView`，OHOS 会直接抛 `platform not support`。
- OHOS 侧没有注册 `FTXRenderViewType` 平台视图工厂。
- OHOS 侧还没有把 Pigeon 生成的 ETS HostApi / FlutterApi 注册进插件，Dart 控制器调用仍无法到达 LiteAVSDK。
- OHOS 侧没有 `TXVodPlayer`、`V2TXLivePlayer`、下载、预下载、事件回调、全局配置等封装。
- 支持 OHOS 的 Pigeon 已在 `pubspec.yaml` 接入，能通过 `--arkts_out` 生成 `FtxMessages.ets`；当前还未生成并落地到 `ohos/src/main/ets`。
- `example/ohos` 只配置了基础网络权限，还没有验证播放器功能。

因此，OHOS 适配的核心工作不是只在 Dart 增加 `OhosView`，而是需要补齐完整的 ETS 插件实现。

## 4. 适配总体方案

建议按四层推进：

1. Dart 层增加 OHOS 分支，保证 Widget 能创建 `OhosView`，控制器不再拒绝 OHOS。
2. OHOS 插件层使用支持 OHOS 的 Pigeon 生成 ETS 消息代码，再实现并注册 `TXFlutterSuperPlayerPluginAPI`、`TXFlutterVodPlayerApi`、`TXFlutterLivePlayerApi`、`TXFlutterDownloadApi`、`TXFlutterNativeAPI`。
3. OHOS 渲染层实现 `FTXRenderViewFactory` / `FTXRenderView`，内部用 ArkUI `XComponent` 拿到 `surfaceId`，再绑定给 LiteAVSDK。
4. OHOS 播放器层封装 LiteAVSDK 的 `TXVodPlayer`、`V2TXLivePlayer`、`TXVodDownloadManager`、`TXVodPreloadManager` 等能力，并通过 FlutterApi 把事件回传给 Dart。

推荐优先级：

| 优先级 | 内容 | 原因 |
| --- | --- | --- |
| P0 | Pigeon/消息通道 + 渲染 + 点播 URL 播放 | 没有这些就无法播放视频。 |
| P1 | 直播播放 + 基础事件 + 音量/静音/seek/暂停恢复 | 覆盖主功能。 |
| P2 | 配置、缓存、码率、字幕、多音轨、截图、下载/预下载 | 完整功能对齐。 |
| P3 | PIP、系统亮度、音频焦点、方向监听、TRTC/推流发布 | 平台差异较大；其中 TRTC/推流和方向/旋转在当前 HAR 中已有公开接口，PIP 和音频焦点需要按 OHOS 系统能力单独评估。 |

## 5. 最重要功能：渲染如何用 OhosView 绑定到 ArkUI

### 5.1 现有 Android/iOS 渲染机制

Dart 侧入口是 `lib/Core/txplayer_widget.dart`：

```dart
TXPlayerVideo(
  onRenderViewCreatedListener: (viewId) {
    controller.setPlayerView(viewId);
  },
)
```

关键常量在 `lib/Core/txplayer_define.dart`：

```dart
const _kFTXPlayerRenderViewType = "FTXRenderViewType";
const _kFTXAndroidRenderTypeKey = "renderViewType";
```

Android/iOS 的流程是：

1. Flutter 创建平台视图，`viewType = "FTXRenderViewType"`。
2. 原生插件注册同名 ViewFactory。
3. ViewFactory 创建原生渲染 View，并用 Flutter 分配的 `viewId` 缓存它。
4. Dart 收到 `onPlatformViewCreated(viewId)`。
5. 业务调用 `controller.setPlayerView(viewId)`。
6. 原生播放器通过 `viewId` 找到渲染 View，并绑定播放器实例。

OHOS 应保持完全相同的 Dart 语义：`TXPlayerVideo` 只负责创建渲染容器，真正的播放器绑定仍由 `controller.setPlayerView(viewId)` 完成。

### 5.2 Dart 侧需要增加 OhosView 分支

在 `TXPlayerVideoState.build` 中增加 OHOS：

```dart
if (defaultTargetPlatform == TargetPlatform.android) {
  return IgnorePointer(
    ignoring: true,
    child: AndroidView(
      key: _platformViewKey,
      viewType: _kFTXPlayerRenderViewType,
      onPlatformViewCreated: _onCreateAndroidView,
      layoutDirection: TextDirection.ltr,
      creationParams: {
        _kFTXAndroidRenderTypeKey: widget.renderViewType.index,
      },
      creationParamsCodec: const StandardMessageCodec(),
    ),
  );
} else if (defaultTargetPlatform == TargetPlatform.iOS) {
  return IgnorePointer(
    ignoring: true,
    child: UiKitView(
      key: _platformViewKey,
      viewType: _kFTXPlayerRenderViewType,
      layoutDirection: TextDirection.ltr,
      creationParams: const {},
      creationParamsCodec: const StandardMessageCodec(),
      onPlatformViewCreated: _onCreateIOSView,
    ),
  );
} else if (defaultTargetPlatform == TargetPlatform.ohos) {
  return IgnorePointer(
    ignoring: true,
    child: OhosView(
      key: _platformViewKey,
      viewType: _kFTXPlayerRenderViewType,
      layoutDirection: TextDirection.ltr,
      creationParams: {
        _kFTXAndroidRenderTypeKey: widget.renderViewType.index,
      },
      creationParamsCodec: const StandardMessageCodec(),
      onPlatformViewCreated: _onCreateOhosView,
    ),
  );
}
```

并新增：

```dart
void _onCreateOhosView(int id) {
  if (_viewIdCompleter.isCompleted) {
    _viewIdCompleter = Completer();
  }
  _viewId = id;
  _viewIdCompleter.complete(id);
  widget.onRenderViewCreatedListener?.call(id);
}
```

注意点：

- `viewType` 必须仍然是 `"FTXRenderViewType"`，并且 OHOS ETS 侧注册同名工厂。
- `creationParamsCodec` 建议继续使用 `StandardMessageCodec`，与 Android 保持一致。
- `creationParams.renderViewType` 在 OHOS 上可以保留，但第一阶段建议只实现 `SURFACE_VIEW` 路线，因为 LiteAVSDK OHOS 渲染依赖 ArkUI `XComponent` 的 `surfaceId`。
- 如果当前 OHOS Flutter SDK 的 Dart API 名称或构造参数与上面略有不同，应以本地 SDK 的 `OhosView` 定义为准，但绑定原则不变。

### 5.3 OHOS 插件侧注册 ArkUI 平台视图

`SuperPlayerPlugin.ets` 的 `onAttachedToEngine` 里需要注册平台视图：

```ts
import {
  FlutterPlugin,
  FlutterPluginBinding,
  PlatformViewFactory,
  PlatformView,
  StandardMessageCodec,
} from '@ohos/flutter_ohos';

const FTX_RENDER_VIEW = 'FTXRenderViewType';

export default class SuperPlayerPlugin implements FlutterPlugin {
  private renderViewFactory?: FTXRenderViewFactory;

  onAttachedToEngine(binding: FlutterPluginBinding): void {
    this.renderViewFactory = new FTXRenderViewFactory(binding.getApplicationContext());
    binding.getPlatformViewRegistry()
      .registerViewFactory(FTX_RENDER_VIEW, this.renderViewFactory);

    // 同时在这里 setup Pigeon HostApi / FlutterApi。
  }
}
```

参考本机已有 OHOS 插件写法，`PlatformViewFactory` 的构造需要传 `StandardMessageCodec.INSTANCE`，`create(context, viewId, args)` 返回 `PlatformView`。

### 5.4 OHOS FTXRenderViewFactory 需要缓存 viewId

Android/iOS 都通过 `viewId` 找回平台视图。OHOS 也要保留这个映射：

```ts
export class FTXRenderViewFactory extends PlatformViewFactory {
  private views: Map<number, FTXRenderView> = new Map();

  constructor(private appContext: Context) {
    super(StandardMessageCodec.INSTANCE);
  }

  create(context: Context, viewId: number, args: ESObject): PlatformView {
    const renderType = Number(args?.renderViewType ?? 1);
    const view = new FTXRenderView(viewId, context, renderType, this);
    this.views.set(viewId, view);
    return view;
  }

  findViewById(viewId: number): FTXRenderView | undefined {
    return this.views.get(viewId);
  }

  removeByViewId(viewId: number): void {
    this.views.delete(viewId);
  }
}
```

不要像某些简单 Demo 一样只保存一个 `mLiveView`。本插件的 Dart 注释明确支持记录多个 `viewId` 并在横竖屏、多个纹理间切换，因此 OHOS 侧必须按 `viewId` 缓存多个视图。

### 5.5 OHOS FTXRenderView 用 WrappedBuilder 返回 ArkUI 组件

OHOS `PlatformView` 的 `getView()` 返回 `WrappedBuilder<[Params]>`。在 builder 里创建 `XComponent`：

```ts
export class FTXRenderView extends PlatformView {
  private builder?: WrappedBuilder<[Params]>;
  private surfaceId?: string;
  private boundPlayer?: FTXOhosPlayer;

  constructor(
    private viewId: number,
    private context: Context,
    private renderType: number,
    private factory: FTXRenderViewFactory,
  ) {
    super();
  }

  getView(): WrappedBuilder<[Params]> {
    if (!this.builder) {
      this.builder = new WrappedBuilder(FTXRenderViewBuilder);
    }
    return this.builder;
  }

  onSurfaceReady(surfaceId: string): void {
    this.surfaceId = surfaceId;
    this.boundPlayer?.attachRenderView(this);
  }

  setPlayer(player?: FTXOhosPlayer): void {
    if (this.boundPlayer && this.boundPlayer !== player) {
      this.boundPlayer.detachRenderView(this);
    }
    this.boundPlayer = player;
    if (this.surfaceId && player) {
      player.attachRenderView(this);
    }
  }

  getSurfaceId(): string | undefined {
    return this.surfaceId;
  }

  getViewId(): number {
    return this.viewId;
  }

  onSurfaceDestroyed(): void {
    this.boundPlayer?.detachRenderView(this);
    this.surfaceId = undefined;
  }

  dispose(): void {
    this.boundPlayer?.detachRenderView(this);
    this.boundPlayer = undefined;
    this.surfaceId = undefined;
    this.factory.removeByViewId(this.viewId);
  }
}
```

组件侧：

```ts
@Builder
function FTXRenderViewBuilder(params: Params) {
  FTXRenderViewComponent({ params: params });
}

@Component
struct FTXRenderViewComponent {
  @Prop params: Params;
  customView: FTXRenderView = this.params.platformView as FTXRenderView;
  xComponentController: XComponentController = new XComponentController();

  build() {
    XComponent({
      id: `FTXRenderView_${this.customView.getViewId()}`,
      type: XComponentType.SURFACE,
      libraryname: 'flutter',
      controller: this.xComponentController,
    })
      .width('100%')
      .height('100%')
      .onLoad(() => {
        this.xComponentController.setXComponentSurfaceRect({
          surfaceWidth: /* 当前组件宽度 */,
          surfaceHeight: /* 当前组件高度 */,
        });
        const surfaceId = this.xComponentController.getXComponentSurfaceId();
        this.customView.onSurfaceReady(surfaceId);
      })
      .onDestroy(() => {
        this.customView.onSurfaceDestroyed();
      });
  }
}
```

关键点：

- 点播 SDK 文档要求设置 render target 前确认 target 宽高正确，否则可能前几帧宽高不正确。`onLoad` 后应调用 `setXComponentSurfaceRect`。
- `XComponentType.SURFACE` 是主路线。`TextureView` / `SurfaceView` 的 Android 概念不能原样照搬到 OHOS。
- `surfaceId` 创建和播放器绑定存在竞态：可能先 `setPlayerView(viewId)`，也可能先 `onLoad(surfaceId)`。`FTXRenderView` 和播放器 wrapper 都要能处理这两种顺序。
- `dispose` 时要解除播放器和 surface 的关系，避免播放器继续向已销毁 surface 输出。

### 5.6 setPlayerView 在 OHOS 的绑定逻辑

Dart 的 `TXVodPlayerController.setPlayerView(renderViewId)` 和 `TXLivePlayerController.setPlayerView(renderViewId)` 已经通过 Pigeon 调原生：

```dart
await _vodPlayerApi.setPlayerView(renderViewId);
await _livePlayerApi.setPlayerView(renderViewId);
```

OHOS 对应实现应与 Android/iOS 一致：

```ts
setPlayerView(renderViewId: number): void {
  const renderView = this.renderViewFactory.findViewById(renderViewId);
  if (!renderView) {
    this.currentRenderView?.setPlayer(undefined);
    this.currentRenderView = undefined;
    this.detachRenderTarget();
    return;
  }

  this.currentRenderView = renderView;
  renderView.setPlayer(this);
}
```

点播播放器绑定到 LiteAVSDK：

```ts
attachRenderView(view: FTXRenderView): void {
  const surfaceId = view.getSurfaceId();
  if (!surfaceId || !this.vodPlayer) {
    return;
  }
  this.vodPlayer.setVideoRenderTarget(surfaceId);
}
```

直播播放器绑定到 LiteAVSDK：

```ts
attachRenderView(view: FTXRenderView): void {
  const surfaceId = view.getSurfaceId();
  if (!surfaceId || !this.livePlayer) {
    return;
  }
  this.livePlayer.setRenderView(surfaceId);
}
```

这里的接口来自当前工程的 OHOS LiteAVSDK 类型定义：

- `TXVodPlayer.setVideoRenderTarget(surfaceId: string)`
- `V2TXLivePlayer.setRenderView(view: string)`

## 6. 每个功能点的 OHOS 适配方式

### 6.1 工程和依赖

当前状态：

- `ohos/` 是 HAR 模块。
- 已内置 `LiteAVSDK_Professional_13.2.0.8729.har`。
- `example/ohos` 已有基础工程。

需要做：

- 确认 `ohos/oh-package.json5` 中 `liteavsdk` 版本与插件版本 `13.3.0` 是否匹配。当前 HAR 文件名是 `13.2.0.8729`，可能低于 Dart 插件版本。
- 补齐 `ohos/src/main/module.json5` 的设备类型和必要声明。
- 示例工程 `example/ohos/entry/src/main/module.json5` 至少保留：
  - `ohos.permission.INTERNET`
  - `ohos.permission.GET_NETWORK_INFO`
- 如果下载到公共目录或媒体库，需按 OHOS 文件权限模型追加对应权限或改用应用沙箱目录。

### 6.2 Pigeon / 消息通道

当前状态：

- Dart 侧 `lib/Core/txplayer_messages.dart` 已生成。
- Android/iOS 已有 Pigeon 生成代码。
- `pubspec.yaml` 的 `dev_dependencies.pigeon` 指向 `br_pigeon-v26.1.5_ohos`，该分支基于 `pigeon@26.1.5` 增加 `--arkts_out`。
- 当前工程可通过 `fvm dart run pigeon --arkts_out ...` 从 `generator/txplayer_message.dart` 生成 `FtxMessages.ets`，因此不需要从零手写全部 Pigeon 编解码和通道代码。
- 需要把生成的 `FtxMessages.ets` 落到 `ohos/src/main/ets`，并在 `SuperPlayerPlugin.ets` 中注册 HostApi / FlutterApi。

需要做：

- 使用支持 OHOS 的 Pigeon 生成 ArkTS/ETS 消息代码，建议输出到：
  - `ohos/src/main/ets/components/plugin/messages/FtxMessages.ets`
- 更新 `generator/txplayer_message.dart` 顶部注释命令，把 OHOS 输出纳入标准生成流程。
- 在 `SuperPlayerPlugin.ets` 中 import 生成的 `FtxMessages.ets`，调用各 HostApi 的 `setup(...)` 注册消息处理器。
- 不建议手写完整 Pigeon codec。针对实例通道 suffix 这类生成器未覆盖的项目需求，在生成产物外增加薄封装即可。

推荐生成命令：

```bash
fvm dart run pigeon \
  --input generator/txplayer_message.dart \
  --dart_out lib/Core/txplayer_messages.dart \
  --objc_header_out ios/Classes/messages/FtxMessages.h \
  --objc_source_out ios/Classes/messages/FtxMessages.m \
  --java_out ./android/src/main/java/com/tencent/vod/flutter/messages/FtxMessages.java \
  --java_package "com.tencent.vod.flutter.messages" \
  --arkts_out ohos/src/main/ets/components/plugin/messages/FtxMessages.ets \
  --copyright_header generator/txplayer_copy_right.txt
```

注意：本仓库要求从仓库根目录执行 `fvm dart`，不要直接用 `dart run`。

通道名示例：

```text
dev.flutter.pigeon.super_player.TXFlutterSuperPlayerPluginAPI.createVodPlayer
dev.flutter.pigeon.super_player.TXFlutterVodPlayerApi.startVodPlay.<playerId>
dev.flutter.pigeon.super_player.TXFlutterLivePlayerApi.startLivePlay.<playerId>
dev.flutter.pigeon.super_player.TXFlutterDownloadApi.startPreLoad
```

控制器创建播放器后会使用 `messageChannelSuffix: _playerId.toString()`，因此每个播放器实例都要注册一组带 suffix 的 HostApi。

播放器实例通道需要单独处理 suffix：

- Dart 生成代码、Android 生成代码、iOS 生成代码都支持 `messageChannelSuffix`，播放器控制器实际会调用带 `.<playerId>` 后缀的通道。
- OHOS Pigeon 能生成 ArkTS 文件，但生成的 ArkTS `HostApi.setup(binaryMessenger, api)` 和 `FlutterApi` 构造函数没有 `messageChannelSuffix` 参数，通道名是固定的无后缀形式。
- 适配时在生成后的 `FtxMessages.ets` 外包一层手写注册工具，用 `BasicMessageChannel` 注册带 `.<playerId>` 的 Vod/Live HostApi，并用带后缀的 FlutterApi 回调 Dart。
- 不修改 ohos Pigeon 的 ArkTS 生成器。薄封装只负责实例级通道名拼接和消息转发，数据结构、codec、全局 API 仍使用 Pigeon 生成代码。

需要实现的 API 组：

- `TXFlutterSuperPlayerPluginAPI`
- `TXFlutterNativeAPI`
- `TXFlutterVodPlayerApi`
- `TXFlutterLivePlayerApi`
- `TXFlutterDownloadApi`

需要回调 Dart 的 API 组：

- `TXPluginFlutterAPI`
- `TXPipFlutterAPI`
- `TXVodPlayerFlutterAPI`
- `TXLivePlayerFlutterAPI`
- `TXDownloadFlutterAPI`

接入方式建议：

```ts
// 全局 API：无 suffix，插件 attach 时注册一次。
TXFlutterSuperPlayerPluginAPI.setup(binaryMessenger, pluginApi);
TXFlutterNativeAPI.setup(binaryMessenger, nativeApi);
TXFlutterDownloadApi.setup(binaryMessenger, downloadApi);

// 播放器 API：createVodPlayer/createLivePlayer 分配 playerId 后注册带 suffix 的实例 API。
TXFlutterVodPlayerApi.setup(binaryMessenger, `${playerId}`, vodPlayerApi);
TXFlutterLivePlayerApi.setup(binaryMessenger, `${playerId}`, livePlayerApi);

// 回调 Dart：每个播放器实例使用相同 playerId suffix。
const vodFlutterApi = new TXVodPlayerFlutterAPI(binaryMessenger, `${playerId}`);
const liveFlutterApi = new TXLivePlayerFlutterAPI(binaryMessenger, `${playerId}`);
```

上面的签名是目标形态；实际落地时通过实例通道薄封装实现同等通道名，不修改 ohos Pigeon 生成器。

### 6.3 全局插件能力

Dart 入口：`SuperPlayerPlugin`

需要适配：

| Dart 方法 | OHOS 实现建议 |
| --- | --- |
| `getPlatformVersion` | 返回 OHOS 系统版本或固定标识，替换当前占位实现。 |
| `createVodPlayer` | 创建 `FTXOhosVodPlayer`，分配 `playerId`，缓存到 Map，并为该 playerId 注册 Vod HostApi suffix。 |
| `createLivePlayer` | 创建 `FTXOhosLivePlayer`，分配 `playerId`，缓存到 Map，并为该 playerId 注册 Live HostApi suffix。 |
| `releasePlayer` | 根据 `playerId` 找到播放器，停止播放、解除渲染、释放 SDK 对象、移除 HostApi。 |
| `setConsoleEnabled` | 使用 LiteAVSDK 对应日志配置；如只有 `V2TXLivePremier.setLogConfig`，需映射日志开关。 |
| `setGlobalLicense` | 使用 `getV2TXLivePremierShareInstance(context).setLicence(url, key)`。 |
| `getLiteAVSDKVersion` | 使用 `V2TXLivePremier.getSDKVersionStr()`。 |
| `setGlobalEnv` | 使用 `V2TXLivePremier.setEnvironment(envConfig)`。 |
| `setUserId` | 使用 `V2TXLivePremier.setUserId(userId)`。 |
| `setLicenseFlexibleValid` | 当前 OHOS LiteAVSDK 类型中存在内部 `setLicenseFlexibleValid`，需确认是否开放；不可用则返回 no-op 并记录。 |
| `setDrmProvisionEnv` | OHOS 类型中未看到直接公开接口，需确认 SDK 支持；不支持则文档化为暂不支持。 |

License 回调：

- OHOS `V2TXLivePremierObserver.onLicenceLoaded(result, reason)` 应转成 Dart `TXPluginFlutterAPI.onSDKListener`。
- event map 需要沿用 `TXVodPlayEvent.EVENT_ON_LICENCE_LOADED`、`EVENT_RESULT`、`EVENT_REASON` 的字段名。

### 6.4 原生系统能力

Dart 入口：`TXFlutterNativeAPI`

需要适配：

| 功能 | Android/iOS 语义 | OHOS 建议 |
| --- | --- | --- |
| 页面亮度 | 当前页面窗口亮度 | 用 OHOS window API 设置当前 Ability window 亮度。 |
| 恢复亮度 | 恢复系统默认或进入前亮度 | 记录设置前亮度，恢复时写回。 |
| 获取页面亮度 | 0.0 到 1.0 | 从当前 window 属性读取。 |
| 获取系统亮度 | 0.0 到 1.0 | 使用系统设置 API；若权限受限则返回当前页面亮度。 |
| 系统音量 | 0.0 到 1.0 | 使用 audio manager 获取/设置媒体音量。 |
| 音频焦点 | Android 专用 | 当前 HAR 未公开 `requestAudioFocus`/`abandonAudioFocus` 类接口，OHOS 应按系统 audio manager / audio session 能力实现；第一阶段可 no-op。 |
| PIP 支持判断 | 返回固定错误码体系 | 当前 HAR 的公开 ArkTS 声明未暴露 PIP API，先返回 `ERROR_PIP_FEATURE_NOT_SUPPORT`；如后续要支持，需基于 OHOS 窗口/小窗能力或 LiteAVSDK 的开放接口单独验证。 |
| 系统亮度监听 | Android 专用 | OHOS 可选实现；初期 no-op。 |

### 6.5 点播播放

Dart 入口：`TXVodPlayerController`

OHOS LiteAVSDK 已有 `TXVodPlayer`，类型定义包含 `startVodPlay`、`pause`、`resume`、`seek`、`getDuration`、`setVideoRenderTarget` 等接口。

需要适配：

| 功能 | Dart 方法 | OHOS 实现 |
| --- | --- | --- |
| 创建播放器 | `createVodPlayer` | `new TXVodPlayer(context)` |
| URL 播放 | `startVodPlay(url)` | 构造 `TXVodDef.TXPlayInfoParams.createWithUrl(url)` 后调用 `player.startVodPlay(params)` |
| FileId 播放 | `startVodPlayWithParams` | 构造 `TXPlayInfoParams.createWithFileId(appId, fileId, psign)` |
| DRM 播放 | `startPlayDrm` | 检查 OHOS SDK Widevine/DRM 接口是否开放；可用则映射，缺失则返回错误。 |
| 停止 | `stop(isNeedClear)` | `player.stopPlay(isNeedClear)` |
| 播放状态 | `isPlaying` | `player.isPlaying()` |
| 暂停/恢复 | `pause` / `resume` | `player.pause()` / `player.resume()` |
| 静音 | `setMute` | `player.setMute(mute)` |
| 循环 | `setLoop` / `isLoop` | `player.setLoop(loop)` / `player.isLoop()` |
| seek | `seek` | `player.seek(seconds, accurate)` |
| PDT seek | `seekToPdtTime` | 当前类型定义有 `seekToPdtTime(ms)`，直接映射。 |
| 倍速 | `setRate` | `player.setRate(rate)` |
| 码率 | `getSupportedBitrates`、`setBitrateIndex`、`getBitrateIndex` | 映射到 LiteAVSDK 对应接口，并转换为 Dart 期望的 Map/List。 |
| 起播时间 | `setStartTime` | `player.setStartTime(seconds)` |
| 音量 | `setAudioPlayoutVolume` | `player.setAudioPlayoutVolume(volume)` |
| 配置 | `setConfig` | 构造 `TXVodPlayConfig`，映射重试、headers、seek、缓存、preferredResolution 等字段。 |
| 播放时间 | `getCurrentPlaybackTime` 等 | 映射到秒单位接口；如果底层是 ms，需要除以 1000。 |
| 视频宽高 | `getWidth` / `getHeight` | `player.getWidth()` / `player.getHeight()` |
| token | `setToken` | 确认 OHOS SDK 是否有 token 接口；没有则作为 FileId 参数的一部分处理。 |
| 字幕 | `addSubtitleSource`、`getSubtitleTrackInfo` | OHOS 类型定义已有字幕接口，可映射。 |
| 音轨 | `getAudioTrackInfo`、`selectTrack`、`deselectTrack` | OHOS 类型定义已有轨道接口，可映射。 |
| 字幕样式 | `setSubtitleStyle` | OHOS `TXCVodPlayer` 类型有 `setSubtitleStyle`，如果外层 `TXVodPlayer` 未公开，需确认可用性。 |
| 截图 | `snapshot` / `getImageSprite` | VOD 类型有 `snapshotAsync(uiContext, nativeXComponentID)`；雪碧图接口需确认 OHOS SDK 支持。 |
| HEVC/扩展配置 | `setStringOption` | 按 SDK 支持映射，不支持的 key 记录 no-op。 |

点播事件：

- `TXVodPlayer.setVodPlayCallback` 的 `onPlayEvent` 转发到 `TXVodPlayerFlutterAPI.onPlayerEvent`。
- `onNetStatus` 转发到 `TXVodPlayerFlutterAPI.onNetEvent`。
- Map 字段名应尽量保持和 Android/iOS 一致，例如 `event`、`EVT_PLAY_PROGRESS`、`EVT_PLAY_DURATION`、`EVT_WIDTH`、`EVT_HEIGHT`。
- `PLAY_EVT_CHANGE_RESOLUTION` 时，Dart 当前只在 Android 分支读取裁剪信息。OHOS 可按 Android 一样补充 `videoLeft`、`videoTop`、`videoRight`、`videoBottom`，后续 Dart 可把判断扩到 OHOS。

### 6.6 直播播放

Dart 入口：`TXLivePlayerController`

OHOS LiteAVSDK 类型定义包含 `createV2TXLivePlayer(context)`、`releaseV2TXLivePlayer(player)`、`V2TXLivePlayer.setRenderView(surfaceId)` 等。

需要适配：

| 功能 | Dart 方法 | OHOS 实现 |
| --- | --- | --- |
| 创建播放器 | `createLivePlayer` | `createV2TXLivePlayer(context)` |
| 开始播放 | `startLivePlay(url)` | `livePlayer.startLivePlay(url)` |
| 停止 | `stop` | `livePlayer.stopPlay()` 或 SDK 对应停止接口 |
| 播放状态 | `isPlaying` | 根据 SDK 返回状态或维护状态机 |
| 暂停/恢复 | `pause` / `resume` | `pauseAudio`/`pauseVideo` 或 SDK 对应接口；需保持 Android/iOS 语义 |
| 直播模式 | `setLiveMode` | 如果 OHOS SDK 创建时才设置 mode，需要在创建时保存或重建。 |
| 音量/静音 | `setVolume` / `setMute` | 映射 `setPlayoutVolume` / `setMute` 等接口。 |
| 切流 | `switchStream` | `livePlayer.switchStream(url)` |
| appId | `setAppID` | 确认 OHOS SDK 是否仍需此接口；不支持则 no-op。 |
| 配置 | `setConfig` | 映射重试、缓存上下限；废弃字段不必强行支持。 |
| 硬解 | `enableHardwareDecode` | 映射 SDK 硬解开关；若无接口，返回 false。 |
| SEI | `enableReceiveSeiMessage` | OHOS V2TXLivePlayer 类型包含 SEI 相关能力，应映射。 |
| 调试浮层 | `showDebugView` | 映射 SDK 接口；不支持则 no-op。 |
| 高级属性 | `setProperty` | 映射 `setProperty(key, value)`。 |
| 码流信息 | `getSupportedBitrate` | 映射 SDK 返回结构到 `FSteamInfo` 期望字段。 |
| 缓存参数 | `setCacheParams` | 映射 `setCacheParams(minTime, maxTime)`。 |
| 本地录制 | `startLocalRecording` / `stopLocalRecording` | OHOS V2TXLivePlayer 类型定义包含本地录制参数，应映射。 |
| 截图 | `snapshot` | 映射 SDK snapshot，回调 `onSnapshotComplete`。 |

直播事件：

- 实现 `V2TXLivePlayerObserver`。
- 连接、播放、缓冲、错误、分辨率变化、SEI、音量、统计、切流、录制、截图等回调需要转成 Dart 事件。
- Dart 当前状态机依赖 `PLAY_EVT_RCV_FIRST_I_FRAME`、`PLAY_EVT_PLAY_BEGIN`、`PLAY_EVT_PLAY_LOADING`、`PLAY_ERR_NET_DISCONNECT` 等事件码。OHOS 侧应尽量复用这些事件码，避免 Dart 侧大改。

### 6.7 渲染模式和画面比例

Dart 入口：

```dart
controller.setRenderMode(FTXPlayerRenderMode.ADJUST_RESOLUTION);
controller.setRenderMode(FTXPlayerRenderMode.FULL_FILL_CONTAINER);
```

Android/iOS 当前自己维护缩放和裁剪逻辑。OHOS 建议：

- 直播优先使用 `V2TXLivePlayer.setRenderFillMode`：
  - `ADJUST_RESOLUTION` -> `V2TXLiveFillModeFit`
  - `FULL_FILL_CONTAINER` -> `V2TXLiveFillModeFill`
- 点播如果 `TXVodPlayer` 没有直接 fill mode 接口，需要在 `XComponent` 容器层做尺寸计算，或确认底层 `TXCVodPlayer` 是否提供 render mode。
- 需要监听视频宽高变化，按容器宽高计算实际显示区域。Dart 已经有 `resizeVideoWidth`、`resizeVideoHeight`、`videoLeft`、`videoTop`、`videoRight`、`videoBottom` 字段，OHOS 可复用这套数据。

### 6.8 下载和预下载

Dart 入口：`TXVodDownloadController`

OHOS LiteAVSDK 类型定义已导出：

- `TXVodDownloadManager`
- `TXVodPreloadManager`
- `TXVodDownloadDataSource`
- `TXVodDownloadMediaInfo`
- `ITXVodDownloadCallback`
- `ITXVodPreloadCallback`

需要适配：

| 功能 | Dart 方法 | OHOS 实现 |
| --- | --- | --- |
| URL 预下载 | `startPreLoad` | `TXVodPreloadManager` 创建任务，返回 taskId。 |
| FileId 预下载 | `startPreload(TXPlayInfoParams)` | 构造 fileId 预下载参数，回调时把临时 taskId 替换为真实 taskId。 |
| 停止预下载 | `stopPreLoad` | 调 SDK 停止接口。 |
| 开始下载 | `startDownload` | 构造 `TXVodDownloadMediaInfo` 或 `TXVodDownloadDataSource`。 |
| 续传 | `resumeDownload` | 调 SDK resume。 |
| 停止下载 | `stopDownload` | 调 SDK stop。 |
| 请求头 | `setDownloadHeaders` | 映射到下载 manager header 设置。 |
| 下载列表 | `getDownloadList` | 转成 `TXDownloadListMsg`。 |
| 下载信息 | `getDownloadInfo` | 转成 Dart 需要的 `TXVodDownloadMediaMsg`。 |
| 删除下载 | `deleteDownloadMediaInfo` | 调 SDK delete，返回 bool。 |

事件回调：

- 预下载完成/失败/开始分别映射到 `EVENT_PREDOWNLOAD_ON_COMPLETE`、`EVENT_PREDOWNLOAD_ON_ERROR`、`EVENT_PREDOWNLOAD_ON_START`。
- 下载开始/进度/停止/完成/错误分别映射到 `EVENT_DOWNLOAD_START` 等事件码。

### 6.9 画中画

Android/iOS 已实现 PIP。当前 `LiteAVSDK_Professional_13.2.0.8729.har` 的公开 ArkTS 声明没有暴露可直接调用的 PIP / PictureInPicture API。PIP 在 OHOS 上应作为独立平台能力处理，不能直接复用 Android 的 Activity PIP 实现。

建议：

- 第一阶段返回“不支持”错误码，保证 API 不崩溃。
- `isDeviceSupportPip` 返回 `ERROR_PIP_FEATURE_NOT_SUPPORT`。
- `enterPictureInPictureMode` 返回同样错误码。
- `exitPictureInPictureMode` no-op。
- 如业务必须支持，再基于 OHOS 窗口/小窗能力，或 LiteAVSDK 后续公开的 PIP ArkTS API 单独设计。

### 6.10 TRTC / 发布相关能力

`TXVodPlayerController` 中有：

- `enableTRTC`
- `publishVideo`
- `unpublishVideo`
- `publishAudio`
- `unpublishAudio`

这些在当前插件里更偏 Android 特殊能力。OHOS 适配建议：

- `TRTCCloud` 可用于 TRTC 房间内发布：`getTRTCShareInstance`、`enterRoom`、`startLocalPreview`、`startLocalAudio`、`muteLocalVideo`、`muteLocalAudio`、`startPublishMediaStream`、`stopPublishMediaStream` 等。
- `V2TXLivePusher` 可用于直播推流：`createV2TXLivePusher`、`startCamera`、`startMicrophone`、`startPush`、`stopPush`、`pauseVideo`、`pauseAudio` 等。
- 方向和旋转能力可用：`V2TXLivePlayer.setRenderRotation`、`V2TXLivePusher.setRenderRotation`、`TRTCCloud.setGravitySensorAdaptiveMode`、`LiteavAppRotationMonitor` 等。
- Dart 现有 `TXVodPlayerController.enableTRTC/publishVideo/publishAudio` 是播放器插件内的跨端封装语义。OHOS 侧需要单独设计 wrapper，明确使用 `TRTCCloud` 进房发布还是使用 `V2TXLivePusher` 推 URL 流，并补齐 license、权限、surface 绑定和事件回调。
- 第一阶段不实现时，接口返回“暂未适配”或 no-op。
- 这些接口放在点播和直播基础适配之后处理。

### 6.11 示例工程

需要补齐：

- `example/ohos` 依赖本地插件 HAR。
- `GeneratedPluginRegistrant.ets` 能注册 `SuperPlayerPlugin`。
- Demo 启动时调用 `SuperPlayerPlugin.setGlobalLicense`。
- 使用 `TXPlayerVideo(onRenderViewCreatedListener: controller.setPlayerView)` 验证画面。
- 验证 URL 点播、直播流播放、暂停恢复、seek、静音、事件回调。

## 7. 建议新增 OHOS 文件结构

建议在 `ohos/src/main/ets/components/plugin` 下按 Android/iOS 结构拆分：

```text
ohos/src/main/ets/components/plugin/
  SuperPlayerPlugin.ets
  common/
    FTXEvent.ets
    FTXPlayerConstants.ets
  messages/
    FtxMessages.ets
  player/
    FTXBasePlayer.ets
    FTXVodPlayer.ets
    FTXLivePlayer.ets
  render/
    FTXRenderViewFactory.ets
    FTXRenderView.ets
  download/
    FTXDownloadManager.ets
  tools/
    TXCommonUtil.ets
    FTXTransformation.ets
```

其中：

- `FtxMessages.ets` 由 ohos 版 Pigeon 通过 `--arkts_out` 生成，负责 Pigeon 数据结构、codec、HostApi/FlutterApi 通道基础代码。
- `SuperPlayerPlugin.ets` 负责全局注册、播放器 Map、全局 API。
- `FTXVodPlayer.ets` / `FTXLivePlayer.ets` 负责每个播放器实例的 HostApi 和 SDK 封装。
- `FTXRenderViewFactory.ets` / `FTXRenderView.ets` 负责 ArkUI `XComponent` 和 surface 绑定。

## 8. 关键风险

| 风险 | 说明 | 建议 |
| --- | --- | --- |
| Pigeon ETS 未生成/未注册 | OHOS 侧没生成并注册 HostApi 会导致 MissingPlugin。 | 用支持 OHOS 的 Pigeon `--arkts_out` 生成 `FtxMessages.ets` 并接入 `SuperPlayerPlugin.ets`。 |
| ArkTS suffix 支持不足 | OHOS Pigeon 生成的 `setup`/FlutterApi 不带 `messageChannelSuffix`，而播放器实例依赖 `.<playerId>` 通道。 | 不修改 Pigeon 生成器；在生成产物外增加 Vod/Live 实例 API 和回调 API 的薄封装。 |
| 渲染 surface 生命周期 | `OhosView` 创建、ArkUI `XComponent.onLoad`、`setPlayerView` 调用顺序不固定。 | View 和 Player 都做 pending 绑定，surface ready 后再次 attach。 |
| 多 View 切换 | Dart 注释明确支持多个 viewId 切换。 | Factory 必须 Map 缓存，不要单例 View。 |
| 渲染尺寸 | LiteAVSDK 文档要求 render target 设置前确保宽高正确。 | `onLoad` 和尺寸变化时更新 `setXComponentSurfaceRect`。 |
| 事件码不一致 | Dart 状态机依赖 Android/iOS 事件码。 | OHOS 侧转换成现有事件码。 |
| SDK 版本不一致 | 插件版本 13.3.0，OHOS HAR 文件为 13.2.0。 | 升级 HAR 或建立能力差异表。 |
| PIP 能力未见公开 ArkTS API | HAR 公开声明未暴露 PIP API。 | PIP 先返回不支持；后续基于 OHOS 窗口/小窗能力或 LiteAVSDK 公开接口单独验证。 |
| 音频焦点需走系统能力 | HAR 未公开播放器层 `requestAudioFocus`/`abandonAudioFocus`，该能力应由 OHOS 系统 audio manager / audio session 承担。 | 第一阶段 no-op 或按 OHOS 系统音频会话实现。 |
| TRTC/推流 wrapper 未适配 | HAR 已导出 `TRTCCloud` 和 `V2TXLivePusher`，但 Dart 现有 TRTC 发布接口语义需要重新设计 OHOS wrapper。 | 按业务优先级补 wrapper；第一阶段返回“暂未适配”或 no-op。 |
| 方向/旋转策略需重做 | HAR 有 `setRenderRotation`、`setGravitySensorAdaptiveMode`、`LiteavAppRotationMonitor` 等能力，但不能直接照搬 Android 方向服务。 | 结合 OHOS 传感器/显示方向和 SDK 旋转接口实现，先保证播放器渲染方向正确。 |
| 下载文件权限 | OHOS 文件系统和权限模型不同。 | 优先使用应用沙箱缓存目录。 |

## 9. 分阶段验收清单

### P0：能播放点播画面

- `TXPlayerVideo` 在 OHOS 不再抛异常。
- OHOS `SuperPlayerPlugin` 注册 `FTXRenderViewType`。
- `OhosView` 创建后能回调 `viewId`。
- `controller.setPlayerView(viewId)` 能找到 `FTXRenderView`。
- ArkUI `XComponent` 能拿到 `surfaceId`。
- `TXVodPlayer.setVideoRenderTarget(surfaceId)` 成功。
- `startVodPlay(url)` 能出首帧、能播放声音。
- Dart 能收到播放开始、缓冲、进度、结束、错误事件。

### P1：直播和基础控制

- `TXLivePlayerController.startLivePlay(url)` 可播放。
- pause/resume/stop/isPlaying 正常。
- 静音、音量、seek、循环、倍速可用。
- `setRenderMode` 的 Fit/Fill 行为正确。
- 横竖屏或 Widget 重建后重新绑定 viewId 不黑屏。

### P2：完整播放器能力

- 点播 fileId 播放。
- 全局缓存目录和缓存大小生效。
- 码率列表、码率切换。
- 字幕、多音轨、字幕样式。
- 截图、雪碧图。
- 下载、预下载和回调。
- License 回调、SDK 版本、日志级别、环境切换。

### P3：平台增强能力

- PIP 明确不支持，或基于 OHOS 小窗/公开 API 验证后再支持。
- 页面亮度、系统音量、音频焦点。
- 方向监听和旋转策略，复用 HAR 已公开的 `setRenderRotation` / `setGravitySensorAdaptiveMode` 等接口。
- 直播 SEI、debug view、本地录制、snapshot。
- TRTC/推流发布 wrapper，基于 HAR 已公开的 `TRTCCloud` / `V2TXLivePusher` 能力适配。

## 10. 最小可行开发顺序

1. 修改 `lib/Core/txplayer_widget.dart`，增加 `OhosView` 分支和 `_onCreateOhosView`。
2. 在 OHOS `SuperPlayerPlugin.ets` 注册 `FTXRenderViewType` 平台视图。
3. 实现 `FTXRenderViewFactory.ets` 和 `FTXRenderView.ets`，用 `XComponentType.SURFACE` 获取 `surfaceId`。
4. 用支持 OHOS 的 Pigeon 生成 `FtxMessages.ets`，并增加实例通道薄封装处理 `messageChannelSuffix`。
5. 实现最小 Pigeon HostApi：
   - `createVodPlayer`
   - `releasePlayer`
   - `setGlobalLicense`
   - `getLiteAVSDKVersion`
   - `TXFlutterVodPlayerApi.startVodPlay`
   - `TXFlutterVodPlayerApi.setPlayerView`
   - `TXFlutterVodPlayerApi.stop/pause/resume/isPlaying`
6. 实现 `TXVodPlayer` wrapper，打通 URL 点播。
7. 实现点播事件回调到 Dart，确认状态机正常。
8. 再补直播、下载和高级能力。

## 11. 结论

这个项目的 OHOS 适配工作量主要在原生 ETS 层。Dart 层只需要少量增加 `OhosView` 和平台判断，但真正能出画面的关键是：

1. `OhosView.viewType` 与 OHOS `registerViewFactory("FTXRenderViewType", factory)` 必须一致。
2. `FTXRenderViewFactory` 必须用 Flutter 分配的 `viewId` 缓存 ArkUI 平台视图。
3. `FTXRenderView` 必须通过 ArkUI `XComponent` 获取 `surfaceId`。
4. `controller.setPlayerView(viewId)` 必须在 OHOS 原生侧找到对应 `FTXRenderView`。
5. 点播用 `TXVodPlayer.setVideoRenderTarget(surfaceId)`，直播用 `V2TXLivePlayer.setRenderView(surfaceId)`。
6. Pigeon HostApi / FlutterApi 必须通过 `--arkts_out` 生成并接入；播放器实例通道还必须支持 `messageChannelSuffix`，否则 Dart 控制器无法调用 OHOS LiteAVSDK，也无法接收播放事件。

先按 P0 打通点播 URL 播放和渲染，再逐步补齐直播、下载、字幕、音轨、PIP 等能力，是风险最低的适配路径。
