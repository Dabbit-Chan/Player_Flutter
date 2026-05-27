## ADDED Requirements

### Requirement: OHOS render widget support

`TXPlayerVideo` SHALL support OHOS by creating an OHOS platform view with the same render view contract used by Android and iOS.

#### Scenario: OHOS view is created

- **WHEN** `TXPlayerVideo` builds on `TargetPlatform.ohos`
- **THEN** it MUST create an `OhosView` with `viewType` equal to `FTXRenderViewType`
- **AND** it MUST pass `renderViewType` through `creationParams` using `StandardMessageCodec`
- **AND** it MUST call `onRenderViewCreatedListener` with the platform `viewId`

#### Scenario: unsupported platforms remain rejected

- **WHEN** `TXPlayerVideo` builds on a platform other than Android, iOS, or OHOS
- **THEN** it MUST fail with the existing unsupported platform behavior

### Requirement: OHOS render view factory and lifecycle

The OHOS plugin SHALL register a platform view factory for `FTXRenderViewType` and manage render views by Flutter `viewId`.

#### Scenario: render view factory is registered

- **WHEN** `SuperPlayerPlugin.onAttachedToEngine` is called on OHOS
- **THEN** the plugin MUST register `FTXRenderViewType` with the platform view registry

#### Scenario: multiple render views are cached

- **WHEN** Flutter creates more than one OHOS render view
- **THEN** the factory MUST cache each `FTXRenderView` by its `viewId`
- **AND** `setPlayerView(viewId)` MUST resolve the matching render view instead of using a singleton view

#### Scenario: render view is disposed

- **WHEN** an OHOS render view is destroyed or disposed
- **THEN** it MUST detach any bound player
- **AND** it MUST clear its `surfaceId`
- **AND** it MUST remove its `viewId` from the factory cache

### Requirement: ArkUI surface binding

The OHOS render view SHALL use ArkUI `XComponent` to provide a LiteAVSDK render surface.

#### Scenario: surface becomes ready

- **WHEN** the ArkUI `XComponent` finishes loading
- **THEN** the render view MUST obtain the `surfaceId`
- **AND** it MUST set the XComponent surface rect before binding the player when size information is available
- **AND** it MUST attach any pending player to the ready surface

#### Scenario: player is assigned before surface is ready

- **WHEN** `setPlayerView(viewId)` is called before the `XComponent` has a `surfaceId`
- **THEN** the render view MUST remember the player
- **AND** it MUST bind the player after the surface becomes ready

#### Scenario: surface is destroyed

- **WHEN** the ArkUI `XComponent` is destroyed
- **THEN** the render view MUST detach the bound player from the old surface
- **AND** subsequent playback MUST wait for a new ready surface before rendering

### Requirement: Pigeon messaging on OHOS

The OHOS implementation SHALL use Pigeon-generated ArkTS messages for the Flutter/native API contract and SHALL support player-specific message channel suffixes.

#### Scenario: global APIs are registered

- **WHEN** the OHOS plugin attaches to the engine
- **THEN** it MUST register global HostApi handlers for `TXFlutterSuperPlayerPluginAPI`, `TXFlutterNativeAPI`, and `TXFlutterDownloadApi`

#### Scenario: player instance APIs are registered

- **WHEN** Dart creates a VOD or live player and receives a `playerId`
- **THEN** the OHOS plugin MUST register the corresponding HostApi channels with `.<playerId>` suffixes
- **AND** FlutterApi callbacks for that player MUST use the same suffix

#### Scenario: player instance APIs are released

- **WHEN** Dart releases a player
- **THEN** the OHOS plugin MUST stop and release the SDK player
- **AND** it MUST unregister or disable the suffixed HostApi handlers for that `playerId`

### Requirement: VOD playback support

The OHOS implementation SHALL support core `TXVodPlayerController` playback through LiteAVSDK `TXVodPlayer`.

#### Scenario: URL VOD playback starts

- **WHEN** Dart calls `startVodPlay(url)` on an OHOS VOD player
- **THEN** the plugin MUST start playback using the OHOS LiteAVSDK VOD player
- **AND** if a render view surface is available it MUST bind that surface with `setVideoRenderTarget(surfaceId)`

#### Scenario: VOD render view is changed

- **WHEN** Dart calls `setPlayerView(renderViewId)` for a VOD player
- **THEN** the OHOS implementation MUST detach the previous render view if present
- **AND** it MUST attach the VOD player to the render view matching `renderViewId`

#### Scenario: VOD basic controls are invoked

- **WHEN** Dart invokes stop, pause, resume, seek, mute, loop, rate, volume, duration, current time, width, height, or isPlaying on a VOD player
- **THEN** the OHOS implementation MUST map the call to the matching LiteAVSDK API where available
- **AND** it MUST return a stable unsupported/default result where the OHOS SDK does not expose that capability

#### Scenario: VOD FileId playback is invoked

- **WHEN** Dart calls `startVodPlayWithParams` with appId, fileId, and optional psign
- **THEN** the OHOS implementation MUST construct the matching OHOS LiteAVSDK play info parameters
- **AND** it MUST start playback through the VOD player

### Requirement: Live playback support

The OHOS implementation SHALL support core `TXLivePlayerController` playback through LiteAVSDK `V2TXLivePlayer`.

#### Scenario: live playback starts

- **WHEN** Dart calls `startLivePlay(url)` on an OHOS live player
- **THEN** the plugin MUST start playback using the OHOS LiteAVSDK live player
- **AND** if a render view surface is available it MUST bind that surface with `setRenderView(surfaceId)`

#### Scenario: live render view is changed

- **WHEN** Dart calls `setPlayerView(renderViewId)` for a live player
- **THEN** the OHOS implementation MUST detach the previous render view if present
- **AND** it MUST attach the live player to the render view matching `renderViewId`

#### Scenario: live basic controls are invoked

- **WHEN** Dart invokes stop, pause, resume, mute, volume, cache params, stream switch, SEI receive, hardware decode, property, snapshot, or isPlaying on a live player
- **THEN** the OHOS implementation MUST map the call to the matching LiteAVSDK API where available
- **AND** it MUST return a stable unsupported/default result where the OHOS SDK does not expose that capability

### Requirement: Player event callbacks

The OHOS implementation SHALL translate LiteAVSDK callbacks into the Dart event and net status contracts already used by Android and iOS.

#### Scenario: VOD events are emitted

- **WHEN** the OHOS VOD SDK reports play events or network status
- **THEN** the plugin MUST call the suffixed `TXVodPlayerFlutterAPI`
- **AND** event maps MUST use Dart-compatible event codes and field names for begin, first frame, loading, progress, end, errors, width, height, and duration

#### Scenario: live events are emitted

- **WHEN** the OHOS live SDK reports observer callbacks
- **THEN** the plugin MUST call the suffixed `TXLivePlayerFlutterAPI`
- **AND** event maps MUST use Dart-compatible event codes and field names for connection, first frame, begin, loading, errors, resolution, SEI, statistics, snapshot, and stream switch where available

#### Scenario: license events are emitted

- **WHEN** the OHOS SDK reports License load completion
- **THEN** the plugin MUST call `TXPluginFlutterAPI.onSDKListener`
- **AND** the event map MUST include result and reason fields compatible with existing Dart listeners

### Requirement: Global plugin configuration

The OHOS implementation SHALL support global plugin APIs needed before playback.

#### Scenario: License and SDK environment are configured

- **WHEN** Dart calls `setGlobalLicense`, `setGlobalEnv`, `setUserId`, `setConsoleEnabled`, or `getLiteAVSDKVersion`
- **THEN** the OHOS plugin MUST call the corresponding LiteAVSDK global or premier API where available
- **AND** it MUST return a stable unsupported/default result where the OHOS SDK does not expose that capability

#### Scenario: global cache is configured

- **WHEN** Dart calls global cache folder or max cache size APIs
- **THEN** the OHOS plugin MUST apply those settings to the OHOS LiteAVSDK global settings where available
- **AND** cache paths SHOULD use an app-accessible sandbox location unless the caller provides another valid path

### Requirement: Native platform utilities

The OHOS implementation SHALL provide stable behavior for native utility APIs exposed by `TXFlutterNativeAPI`.

#### Scenario: volume utilities are invoked

- **WHEN** Dart gets or sets system media volume on OHOS
- **THEN** the plugin MUST use OHOS system audio APIs where available
- **AND** it MUST return a bounded value from `0.0` to `1.0`

#### Scenario: unsupported native utilities are invoked

- **WHEN** Dart invokes OHOS unsupported utilities such as PIP, audio focus, or brightness APIs before a dedicated implementation exists
- **THEN** the plugin MUST return the established unsupported code, false, default value, or no-op result
- **AND** it MUST NOT throw an uncaught exception or leave the Dart Future unresolved

### Requirement: Download and preload support

The OHOS implementation SHALL expose VOD download and preload APIs through the existing Dart download controller contract.

#### Scenario: preload starts and stops

- **WHEN** Dart starts or stops URL/FileId preload on OHOS
- **THEN** the plugin MUST use `TXVodPreloadManager` where available
- **AND** it MUST return a task identifier for started preload tasks
- **AND** it MUST emit preload start, complete, and error callbacks through `TXDownloadFlutterAPI`

#### Scenario: download lifecycle is controlled

- **WHEN** Dart starts, resumes, stops, lists, queries, or deletes VOD downloads on OHOS
- **THEN** the plugin MUST use `TXVodDownloadManager` where available
- **AND** it MUST translate download media info into Dart-compatible message objects
- **AND** it MUST emit download start, progress, stop, complete, and error callbacks

### Requirement: Unsupported advanced capabilities

Capabilities not supported by the OHOS LiteAVSDK or not included in the first adaptation phase SHALL degrade predictably.

#### Scenario: PIP is requested

- **WHEN** Dart checks PIP support or attempts to enter PIP on OHOS
- **THEN** the plugin MUST return the existing PIP not-supported result code
- **AND** `exitPictureInPictureMode` MUST be safe to call as a no-op

#### Scenario: commercial DRM or PDT seek is requested

- **WHEN** Dart invokes commercial DRM playback or PDT seek on OHOS
- **THEN** the plugin MUST return an unsupported/default result
- **AND** it MUST NOT crash the player instance

#### Scenario: TRTC or publishing APIs are requested

- **WHEN** Dart invokes TRTC enablement or publish/unpublish APIs on OHOS before a dedicated wrapper exists
- **THEN** the plugin MUST return an unsupported/default result or no-op
- **AND** it MUST leave normal VOD/live playback unaffected

### Requirement: OHOS example verification

The example OHOS app SHALL demonstrate the adapted playback path.

#### Scenario: example app plays VOD

- **WHEN** the OHOS example app runs with a valid License and VOD URL
- **THEN** it MUST create `TXPlayerVideo`
- **AND** it MUST call `controller.setPlayerView(viewId)` from `onRenderViewCreatedListener`
- **AND** it MUST render video and receive playback events

#### Scenario: example app has required permissions

- **WHEN** the OHOS example app is built
- **THEN** its module configuration MUST include network permissions required for playback
- **AND** download-related permissions MUST be added only if the implementation writes outside the app sandbox
