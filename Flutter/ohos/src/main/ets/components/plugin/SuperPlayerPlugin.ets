import common from '@ohos.app.ability.common';
import {
  BinaryMessenger,
  FlutterPlugin,
  FlutterPluginBinding
} from '@ohos/flutter_ohos';
import FTXEventUtils from './FTXEventUtils';
import {
  BoolMsg,
  CachePathMsg,
  DoubleMsg,
  IntMsg,
  LicenseMsg,
  PlayerMsg,
  StringMsg,
  TXFlutterNativeAPI,
  TXFlutterSuperPlayerPluginAPI,
  TXPluginFlutterAPI
} from './messages/FtxMessages';
import {
  getV2TXLivePremierShareInstance,
  V2TXLiveLogConfig,
  V2TXLiveLogLevel,
  V2TXLivePremier,
  V2TXLivePremierObserver
} from '@tencentcloud/liteavsdk_professional/src/main/ets/h/i';
import { TXVodGlobalSetting } from '@tencentcloud/liteavsdk_professional/src/main/ets/k/Index';
import SuffixBinaryMessenger from './channel/SuffixBinaryMessenger';
import FTXDownloadManager from './download/FTXDownloadManager';
import FTXLivePlayer from './player/FTXLivePlayer';
import FTXVodPlayer from './player/FTXVodPlayer';
import FTXRenderViewFactory from './render/FTXRenderViewFactory';
import {
  TXDownloadFlutterAPI,
  TXFlutterDownloadApi,
  TXFlutterLivePlayerApi,
  TXFlutterVodPlayerApi,
  TXLivePlayerFlutterAPI,
  TXVodPlayerFlutterAPI
} from './messages/FtxMessages';

class SuperPlayerGlobalApi extends TXFlutterSuperPlayerPluginAPI {
  private readonly plugin: SuperPlayerPlugin;

  constructor(plugin: SuperPlayerPlugin) {
    super();
    this.plugin = plugin;
  }

  getPlatformVersion(): StringMsg {
    return new StringMsg('OpenHarmony');
  }

  createVodPlayer(onlyAudio: boolean): PlayerMsg {
    return new PlayerMsg(this.plugin.createVodPlayer());
  }

  createLivePlayer(onlyAudio: boolean): PlayerMsg {
    return new PlayerMsg(this.plugin.createLivePlayer());
  }

  setConsoleEnabled(enabled: BoolMsg): void {}

  releasePlayer(playerId: PlayerMsg): void {
    this.plugin.releasePlayer(playerId.getPlayerId() ?? -1);
  }

  setGlobalMaxCacheSize(size: IntMsg): void {
    TXVodGlobalSetting.setMaxCacheSize(size.getValue() ?? 0);
  }

  setGlobalCacheFolderPath(postfixPath: StringMsg): BoolMsg {
    return this.plugin.setCachePath(postfixPath.getValue() ?? '');
  }

  setGlobalCacheFolderCustomPath(cacheMsg: CachePathMsg): BoolMsg {
    return this.plugin.setCachePath(cacheMsg.getAndroidAbsolutePath() ?? cacheMsg.getIOSAbsolutePath() ?? '');
  }

  setGlobalLicense(licenseMsg: LicenseMsg): void {
    this.plugin.getPremier().setLicence(licenseMsg.getLicenseUrl() ?? '', licenseMsg.getLicenseKey() ?? '');
  }

  setLogLevel(logLevel: IntMsg): void {
    const config = new V2TXLiveLogConfig();
    config.logLevel = (logLevel.getValue() ?? V2TXLiveLogLevel.V2TXLiveLogLevelInfo) as V2TXLiveLogLevel;
    this.plugin.getPremier().setLogConfig(config);
  }

  getLiteAVSDKVersion(): StringMsg {
    return new StringMsg(this.plugin.getPremier().getSDKVersionStr());
  }

  setGlobalEnv(envConfig: StringMsg): IntMsg {
    this.plugin.getPremier().setEnvironment(envConfig.getValue() ?? 'default');
    return new IntMsg(0);
  }

  startVideoOrientationService(): BoolMsg {
    return new BoolMsg(false);
  }

  setUserId(msg: StringMsg): void {
    this.plugin.getPremier().setUserId(msg.getValue() ?? '');
  }

  setLicenseFlexibleValid(msg: BoolMsg): void {}

  setDrmProvisionEnv(env: number): void {}
}

class SuperPlayerNativeApi extends TXFlutterNativeAPI {
  private currentVolume: number = 1;

  setBrightness(brightness: DoubleMsg): void {}

  restorePageBrightness(): void {}

  getBrightness(): DoubleMsg {
    return new DoubleMsg(1);
  }

  getSysBrightness(): DoubleMsg {
    return new DoubleMsg(1);
  }

  setSystemVolume(volume: DoubleMsg): void {
    this.currentVolume = this.bound(volume.getValue() ?? 1);
  }

  getSystemVolume(): DoubleMsg {
    return new DoubleMsg(this.currentVolume);
  }

  abandonAudioFocus(): void {}

  requestAudioFocus(): void {}

  isDeviceSupportPip(): IntMsg {
    return new IntMsg(-102);
  }

  registerSysBrightness(isRegister: BoolMsg): void {}

  private bound(value: number): number {
    return Math.max(0, Math.min(1, value));
  }
}

export default class SuperPlayerPlugin implements FlutterPlugin {
  private context?: common.Context;
  private messenger?: BinaryMessenger;
  private renderFactory: FTXRenderViewFactory = new FTXRenderViewFactory();
  private downloadManager?: FTXDownloadManager;
  private nextPlayerId: number = 1;
  private vodPlayers: Map<number, FTXVodPlayer> = new Map<number, FTXVodPlayer>();
  private livePlayers: Map<number, FTXLivePlayer> = new Map<number, FTXLivePlayer>();
  private premier?: V2TXLivePremier;
  private pluginFlutterApi?: TXPluginFlutterAPI;

  getUniqueClassName(): string {
    return 'SuperPlayerPlugin';
  }

  onAttachedToEngine(binding: FlutterPluginBinding): void {
    const context = binding.getApplicationContext();
    const messenger = binding.getBinaryMessenger();
    this.context = context;
    this.messenger = messenger;
    this.pluginFlutterApi = new TXPluginFlutterAPI(messenger);
    this.renderFactory = new FTXRenderViewFactory();
    const downloadManager = new FTXDownloadManager(context, new TXDownloadFlutterAPI(messenger));
    this.downloadManager = downloadManager;
    binding.getPlatformViewRegistry().registerViewFactory('FTXRenderViewType', this.renderFactory);
    TXFlutterSuperPlayerPluginAPI.setup(messenger, new SuperPlayerGlobalApi(this));
    TXFlutterNativeAPI.setup(messenger, new SuperPlayerNativeApi());
    TXFlutterDownloadApi.setup(messenger, downloadManager);
  }

  onDetachedFromEngine(binding: FlutterPluginBinding): void {
    this.vodPlayers.forEach((player: FTXVodPlayer) => player.release());
    this.livePlayers.forEach((player: FTXLivePlayer) => player.release());
    this.vodPlayers.clear();
    this.livePlayers.clear();
    if (this.messenger !== undefined) {
      TXFlutterSuperPlayerPluginAPI.setup(this.messenger, null);
      TXFlutterNativeAPI.setup(this.messenger, null);
      TXFlutterDownloadApi.setup(this.messenger, null);
    }
    this.renderFactory.clear();
    this.downloadManager = undefined;
    this.pluginFlutterApi = undefined;
    this.context = undefined;
    this.messenger = undefined;
  }

  createVodPlayer(): number {
    const playerId = this.nextPlayerId++;
    const suffixMessenger = this.suffixMessenger(playerId);
    const player = new FTXVodPlayer(this.requireContext(), playerId, this.renderFactory, new TXVodPlayerFlutterAPI(suffixMessenger));
    this.vodPlayers.set(playerId, player);
    TXFlutterVodPlayerApi.setup(suffixMessenger, player);
    return playerId;
  }

  createLivePlayer(): number {
    const playerId = this.nextPlayerId++;
    const suffixMessenger = this.suffixMessenger(playerId);
    const player = new FTXLivePlayer(this.requireContext(), playerId, this.renderFactory, new TXLivePlayerFlutterAPI(suffixMessenger));
    this.livePlayers.set(playerId, player);
    TXFlutterLivePlayerApi.setup(suffixMessenger, player);
    return playerId;
  }

  releasePlayer(playerId: number): void {
    const vodPlayer = this.vodPlayers.get(playerId);
    if (vodPlayer !== undefined) {
      vodPlayer.release();
      TXFlutterVodPlayerApi.setup(this.suffixMessenger(playerId), null);
      this.vodPlayers.delete(playerId);
      return;
    }
    const livePlayer = this.livePlayers.get(playerId);
    if (livePlayer !== undefined) {
      livePlayer.release();
      TXFlutterLivePlayerApi.setup(this.suffixMessenger(playerId), null);
      this.livePlayers.delete(playerId);
    }
  }

  getPremier(): V2TXLivePremier {
    if (this.premier === undefined) {
      this.premier = getV2TXLivePremierShareInstance(this.requireContext());
      this.premier.setObserver(this.createPremierObserver());
    }
    return this.premier;
  }

  setCachePath(path: string): BoolMsg {
    if (path.length === 0) {
      return new BoolMsg(false);
    }
    TXVodGlobalSetting.setCacheFolderPath(path);
    return new BoolMsg(true);
  }

  private requireContext(): common.Context {
    if (this.context === undefined) {
      throw new Error('SuperPlayerPlugin is not attached to engine.');
    }
    return this.context;
  }

  private suffixMessenger(playerId: number): BinaryMessenger {
    if (this.messenger === undefined) {
      throw new Error('SuperPlayerPlugin is not attached to engine.');
    }
    return new SuffixBinaryMessenger(this.messenger, playerId.toString());
  }

  private createPremierObserver(): V2TXLivePremierObserver {
    return {
      onLicenceLoaded: (result: number, reason: string): void => {
        const api = this.pluginFlutterApi;
        if (api === undefined) {
          return;
        }
        api.onSDKListener(FTXEventUtils.eventMap(FTXEventUtils.EVENT_ON_LICENCE_LOADED, new Map<string, Object>([
          ['result', result],
          ['reason', reason]
        ])), FTXEventUtils.noopReply());
      }
    };
  }
}
