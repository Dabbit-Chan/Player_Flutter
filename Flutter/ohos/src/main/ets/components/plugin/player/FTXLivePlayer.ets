import common from '@ohos.app.ability.common';
import image from '@ohos.multimedia.image';
import {
  createV2TXLivePlayer,
  releaseV2TXLivePlayer,
  V2TXLiveFillMode,
  V2TXLivePlayer,
  V2TXLivePlayerObserver,
  V2TXLivePlayerStatistics
} from '@tencentcloud/liteavsdk_professional/src/main/ets/h/i';
import FTXEventUtils from '../FTXEventUtils';
import {
  BoolMsg,
  BoolPlayerMsg,
  FTXLivePlayConfigPlayerMsg,
  IntMsg,
  IntPlayerMsg,
  ListMsg,
  PipParamsPlayerMsg,
  PlayerMsg,
  StringPlayerMsg,
  TXFlutterLivePlayerApi,
  TXLivePlayerFlutterAPI
} from '../messages/FtxMessages';
import FTXRenderTarget from '../render/FTXRenderTarget';
import FTXRenderView from '../render/FTXRenderView';
import FTXRenderViewFactory from '../render/FTXRenderViewFactory';

export default class FTXLivePlayer extends TXFlutterLivePlayerApi implements FTXRenderTarget {
  private readonly playerId: number;
  private readonly player: V2TXLivePlayer;
  private readonly flutterApi: TXLivePlayerFlutterAPI;
  private readonly renderFactory: FTXRenderViewFactory;
  private renderView?: FTXRenderView;
  private surfaceId?: string;
  private muted: boolean = false;
  private volume: number = 100;
  private lastPlayEvent: number = 0;

  constructor(context: common.Context, playerId: number, renderFactory: FTXRenderViewFactory, flutterApi: TXLivePlayerFlutterAPI) {
    super();
    this.playerId = playerId;
    this.renderFactory = renderFactory;
    this.flutterApi = flutterApi;
    this.player = createV2TXLivePlayer(context);
    this.player.setObserver(this.createObserver());
  }

  release(): void {
    this.detachRenderView();
    this.player.stopPlay();
    releaseV2TXLivePlayer(this.player);
  }

  attachSurface(surfaceId: string): void {
    this.surfaceId = surfaceId;
    this.player.setRenderView(surfaceId);
  }

  detachSurface(surfaceId?: string): void {
    if (surfaceId === undefined || surfaceId === this.surfaceId) {
      this.surfaceId = undefined;
    }
  }

  initialize(onlyAudio: BoolPlayerMsg): IntMsg {
    return new IntMsg(this.playerId);
  }

  startLivePlay(playerMsg: StringPlayerMsg): BoolMsg {
    const url = playerMsg.getValue() ?? '';
    if (url.length === 0) {
      return new BoolMsg(false);
    }
    this.attachCurrentSurface();
    return new BoolMsg(this.player.startPlay(url) === 0);
  }

  stop(isNeedClear: BoolPlayerMsg): BoolMsg {
    return new BoolMsg(this.player.stopPlay() === 0);
  }

  isPlaying(playerMsg: PlayerMsg): BoolMsg {
    return new BoolMsg(this.player.isPlaying() === 1);
  }

  pause(playerMsg: PlayerMsg): void {
    this.player.pauseAudio();
    this.player.pauseVideo();
  }

  resume(playerMsg: PlayerMsg): void {
    this.player.resumeAudio();
    this.player.resumeVideo();
  }

  setLiveMode(mode: IntPlayerMsg): void {}

  setVolume(volume: IntPlayerMsg): void {
    this.volume = volume.getValue() ?? 100;
    this.player.setPlayoutVolume(this.muted ? 0 : this.volume);
  }

  setMute(mute: BoolPlayerMsg): void {
    this.muted = mute.getValue() ?? false;
    this.player.setPlayoutVolume(this.muted ? 0 : this.volume);
  }

  switchStream(url: StringPlayerMsg): IntMsg {
    return new IntMsg(this.player.switchStream(url.getValue() ?? ''));
  }

  setAppID(appId: StringPlayerMsg): void {}

  setConfig(config: FTXLivePlayConfigPlayerMsg): void {
    const minTime = config.getMinAutoAdjustCacheTime() ?? config.getCacheTime() ?? 1;
    const maxTime = config.getMaxAutoAdjustCacheTime() ?? config.getCacheTime() ?? 5;
    this.player.setCacheParams(minTime, maxTime);
  }

  enableHardwareDecode(enable: BoolPlayerMsg): BoolMsg {
    return new BoolMsg(false);
  }

  enterPictureInPictureMode(pipParamsMsg: PipParamsPlayerMsg): IntMsg {
    return new IntMsg(-102);
  }

  exitPictureInPictureMode(playerMsg: PlayerMsg): void {}

  enableReceiveSeiMessage(playerMsg: PlayerMsg, isEnabled: boolean, payloadType: number): number {
    return this.player.enableReceiveSeiMessage(isEnabled, payloadType);
  }

  showDebugView(playerMsg: PlayerMsg, isShow: boolean): void {
    this.player.showDebugView(isShow);
  }

  setProperty(playerMsg: PlayerMsg, key: string, value: Object): number {
    return this.player.setProperty(key, value);
  }

  getSupportedBitrate(playerMsg: PlayerMsg): ListMsg {
    return new ListMsg([]);
  }

  setCacheParams(playerMsg: PlayerMsg, minTime: number, maxTime: number): number {
    return this.player.setCacheParams(minTime, maxTime);
  }

  enablePictureInPicture(msg: BoolPlayerMsg): number {
    return -102;
  }

  setPlayerView(renderViewId: number): void {
    const nextView = this.renderFactory.getRenderView(renderViewId);
    if (nextView === undefined) {
      this.detachRenderView();
      return;
    }
    if (this.renderView !== nextView) {
      this.detachRenderView();
      this.renderView = nextView;
      nextView.bindTarget(this);
    }
    this.attachCurrentSurface();
  }

  setRenderMode(renderMode: number): void {
    if (renderMode === 1) {
      this.player.setRenderFillMode(V2TXLiveFillMode.V2TXLiveFillModeFit);
    } else {
      this.player.setRenderFillMode(V2TXLiveFillMode.V2TXLiveFillModeFill);
    }
  }

  startLocalRecording(localRecordingParams: Map<string, Object>): void {}

  stopLocalRecording(): void {}

  snapshot(): void {
    this.player.snapshot();
  }

  private attachCurrentSurface(): void {
    const currentSurface = this.renderView?.getSurfaceId();
    if (currentSurface !== undefined) {
      this.attachSurface(currentSurface);
    }
  }

  private detachRenderView(): void {
    if (this.renderView !== undefined) {
      this.renderView.bindTarget(undefined);
      this.renderView = undefined;
    }
    this.surfaceId = undefined;
  }

  private createObserver(): V2TXLivePlayerObserver {
    return {
      onError: (_player: V2TXLivePlayer, code: number, msg: string): void => {
        this.notifyPlayerEvent(code, FTXEventUtils.withMessage(msg));
      },
      onWarning: (_player: V2TXLivePlayer, code: number, msg: string): void => {
        this.notifyPlayerEvent(code, FTXEventUtils.withMessage(msg));
      },
      onVideoResolutionChanged: (_player: V2TXLivePlayer, width: number, height: number): void => {
        const params = new Map<string, Object>([
          ['EVT_WIDTH', width],
          ['EVT_HEIGHT', height],
          ['EVT_PARAM1', width],
          ['EVT_PARAM2', height],
          ['EVT_MSG', `Resolution changed. resolution:${width}x${height}`]
        ]);
        this.notifyPlayerEvent(FTXEventUtils.PLAY_EVT_CHANGE_RESOLUTION, params);
      },
      onConnected: (_player: V2TXLivePlayer): void => {
        this.notifyPlayerEvent(FTXEventUtils.PLAY_EVT_CONNECT_SUCC);
      },
      onVideoPlaying: (_player: V2TXLivePlayer, firstPlay: boolean): void => {
        if (this.lastPlayEvent === FTXEventUtils.PLAY_EVT_PLAY_LOADING) {
          this.notifyPlayerEvent(FTXEventUtils.PLAY_EVT_VOD_LOADING_END);
        }
        this.notifyPlayerEvent(FTXEventUtils.PLAY_EVT_PLAY_BEGIN);
        if (firstPlay) {
          this.notifyPlayerEvent(FTXEventUtils.PLAY_EVT_RCV_FIRST_I_FRAME);
        }
      },
      onAudioPlaying: (_player: V2TXLivePlayer): void => {
        this.notifyPlayerEvent(FTXEventUtils.PLAY_EVT_RCV_FIRST_AUDIO_FRAME);
      },
      onVideoLoading: (_player: V2TXLivePlayer): void => {
        this.notifyPlayerEvent(FTXEventUtils.PLAY_EVT_PLAY_LOADING);
      },
      onAudioLoading: (_player: V2TXLivePlayer): void => {
        this.notifyPlayerEvent(FTXEventUtils.PLAY_EVT_PLAY_LOADING);
      },
      onStatisticsUpdate: (_player: V2TXLivePlayer, statistics: V2TXLivePlayerStatistics): void => {
        this.flutterApi.onNetEvent(FTXEventUtils.eventMap(0, this.statisticsMap(statistics)), FTXEventUtils.noopReply());
      },
      onSnapshotComplete: (_player: V2TXLivePlayer, _pixelMap: image.PixelMap): void => {
        this.flutterApi.onSnapshotComplete([], FTXEventUtils.noopReply());
      },
      onReceiveSeiMessage: (_player: V2TXLivePlayer, payloadType: number, data: ArrayBuffer): void => {
        const params = new Map<string, Object>([
          ['EVT_GET_MSG', FTXEventUtils.bytesFromArrayBuffer(data)],
          ['EVT_GET_MSG_TYPE', payloadType]
        ]);
        this.notifyPlayerEvent(FTXEventUtils.PLAY_EVT_GET_MESSAGE, params);
      },
      onStreamSwitched: (_player: V2TXLivePlayer, _url: string, code: number): void => {
        const event = code === 0 ? FTXEventUtils.PLAY_EVT_STREAM_SWITCH_SUCC : FTXEventUtils.PLAY_ERR_STREAM_SWITCH_FAIL;
        const msg = code === 0 ? 'Switch stream success.' : 'Switch stream failed.';
        this.notifyPlayerEvent(event, FTXEventUtils.withMessage(msg));
      },
      onLocalRecordBegin: (_player: V2TXLivePlayer, code: number, storagePath: string): void => {
        this.flutterApi.onLocalRecordBegin(code, storagePath, FTXEventUtils.noopReply());
      },
      onLocalRecording: (_player: V2TXLivePlayer, durationMs: number, storagePath: string): void => {
        this.flutterApi.onLocalRecording(durationMs, storagePath, FTXEventUtils.noopReply());
      },
      onLocalRecordComplete: (_player: V2TXLivePlayer, code: number, storagePath: string): void => {
        this.flutterApi.onLocalRecordComplete(code, storagePath, FTXEventUtils.noopReply());
      }
    };
  }

  private notifyPlayerEvent(event: number, params?: Map<string, Object>): void {
    this.lastPlayEvent = event;
    this.flutterApi.onPlayerEvent(FTXEventUtils.eventMap(event, params), FTXEventUtils.noopReply());
  }

  private statisticsMap(statistics: V2TXLivePlayerStatistics): Map<string, Object> {
    return new Map<string, Object>([
      ['CPU_USAGE', statistics.appCpu],
      ['VIDEO_WIDTH', statistics.width],
      ['VIDEO_HEIGHT', statistics.height],
      ['NET_SPEED', statistics.netSpeed],
      ['VIDEO_FPS', statistics.fps],
      ['VIDEO_BITRATE', statistics.videoBitrate],
      ['AUDIO_BITRATE', statistics.audioBitrate],
      ['NET_JITTER', statistics.jitterBufferDelay],
      ['SYSTEM_CPU', statistics.systemCpu],
      ['VIDEO_PACKET_LOSS', statistics.videoPacketLoss],
      ['AUDIO_PACKET_LOSS', statistics.audioPacketLoss],
      ['AUDIO_TOTAL_BLOCK_TIME', statistics.audioTotalBlockTime],
      ['VIDEO_TOTAL_BLOCK_TIME', statistics.videoTotalBlockTime],
      ['VIDEO_BLOCK_RATE', statistics.videoBlockRate],
      ['AUDIO_BLOCK_RATE', statistics.audioBlockRate],
      ['RTT', statistics.rtt]
    ]);
  }
}
