import common from '@ohos.app.ability.common';
import { ITXVodPlayCallback, TXVodPlayConfig, TXVodPlayer, TXVodDef } from 'liteavsdk/src/main/ets/k/Index';
import { TXBitrateItem, TXPlayInfoParams, TXSubtitleRenderModel, TXTrackInfo } from 'liteavsdk/src/main/ets/k/a3/h3';
import FTXEventUtils from '../FTXEventUtils';
import {
  BoolMsg,
  BoolPlayerMsg,
  DoubleMsg,
  DoublePlayerMsg,
  FTXVodPlayConfigPlayerMsg,
  IntMsg,
  IntPlayerMsg,
  ListMsg,
  PipParamsPlayerMsg,
  PlayerMsg,
  StringListPlayerMsg,
  StringOptionPlayerMsg,
  StringPlayerMsg,
  SubTitlePlayerMsg,
  SubTitleRenderModelPlayerMsg,
  TXFlutterVodPlayerApi,
  TXVodPlayerFlutterAPI,
  TXPlayInfoParamsPlayerMsg,
  TXPlayerDrmMsg,
  UInt8ListMsg
} from '../messages/FtxMessages';
import FTXRenderTarget from '../render/FTXRenderTarget';
import FTXRenderView from '../render/FTXRenderView';
import FTXRenderViewFactory from '../render/FTXRenderViewFactory';

export default class FTXVodPlayer extends TXFlutterVodPlayerApi implements FTXRenderTarget {
  private readonly playerId: number;
  private readonly player: TXVodPlayer;
  private readonly flutterApi: TXVodPlayerFlutterAPI;
  private readonly renderFactory: FTXRenderViewFactory;
  private renderView?: FTXRenderView;
  private surfaceId?: string;

  constructor(context: common.Context, playerId: number, renderFactory: FTXRenderViewFactory, flutterApi: TXVodPlayerFlutterAPI) {
    super();
    this.playerId = playerId;
    this.renderFactory = renderFactory;
    this.flutterApi = flutterApi;
    this.player = new TXVodPlayer(context);
    this.player.setVodPlayCallback(this.createVodCallback());
  }

  release(): void {
    this.detachRenderView();
    this.player.stopPlay(true);
  }

  attachSurface(surfaceId: string): void {
    this.surfaceId = surfaceId;
    this.player.setVideoRenderTarget(surfaceId);
  }

  detachSurface(surfaceId?: string): void {
    if (surfaceId === undefined || surfaceId === this.surfaceId) {
      this.surfaceId = undefined;
    }
  }

  initialize(onlyAudio: BoolPlayerMsg): IntMsg {
    return new IntMsg(this.playerId);
  }

  startVodPlay(url: StringPlayerMsg): BoolMsg {
    const playUrl = url.getValue() ?? '';
    if (playUrl.length === 0) {
      return new BoolMsg(false);
    }
    this.attachCurrentSurface();
    this.player.startVodPlay(TXPlayInfoParams.createWithUrl(playUrl));
    return new BoolMsg(true);
  }

  startVodPlayWithParams(params: TXPlayInfoParamsPlayerMsg): void {
    const url = params.getUrl();
    let playInfo: TXPlayInfoParams;
    if (url !== undefined && url.length > 0) {
      playInfo = TXPlayInfoParams.createWithUrl(url);
    } else {
      playInfo = TXPlayInfoParams.createWithFileId(params.getAppId() ?? 0, params.getFileId() ?? '', params.getPsign() ?? '');
    }
    this.attachCurrentSurface();
    this.player.startVodPlay(playInfo);
  }

  startPlayDrm(params: TXPlayerDrmMsg): IntMsg {
    return new IntMsg(-1);
  }

  setAutoPlay(isAutoPlay: BoolPlayerMsg): void {
    this.player.setAutoPlay(isAutoPlay.getValue() ?? true);
  }

  stop(isNeedClear: BoolPlayerMsg): BoolMsg {
    return new BoolMsg(this.player.stopPlay(isNeedClear.getValue() ?? true) === 0);
  }

  isPlaying(playerMsg: PlayerMsg): BoolMsg {
    return new BoolMsg(this.player.isPlaying());
  }

  pause(playerMsg: PlayerMsg): void {
    this.player.pause();
  }

  resume(playerMsg: PlayerMsg): void {
    this.player.resume();
  }

  setMute(mute: BoolPlayerMsg): void {
    this.player.setMute(mute.getValue() ?? false);
  }

  setLoop(loop: BoolPlayerMsg): void {
    this.player.setLoop(loop.getValue() ?? false);
  }

  seek(progress: DoublePlayerMsg): void {
    this.player.seek(progress.getValue() ?? 0, true);
  }

  seekToPdtTime(pdtTimeMs: IntPlayerMsg): void {}

  setRate(rate: DoublePlayerMsg): void {
    this.player.setRate(rate.getValue() ?? 1);
  }

  getSupportedBitrate(playerMsg: PlayerMsg): ListMsg {
    const items = this.player.getSupportedBitrates();
    return new ListMsg(items.map((item: TXBitrateItem): Object => {
      return new Map<string, Object>([
        ['index', item.index],
        ['width', item.width],
        ['height', item.height],
        ['bitrate', item.bitrate]
      ]);
    }));
  }

  getBitrateIndex(playerMsg: PlayerMsg): IntMsg {
    return new IntMsg(this.player.getBitrateIndex());
  }

  setBitrateIndex(index: IntPlayerMsg): void {
    this.player.setBitrateIndex(index.getValue() ?? -1);
  }

  setStartTime(startTime: DoublePlayerMsg): void {
    this.player.setStartTime(startTime.getValue() ?? 0);
  }

  setAudioPlayOutVolume(volume: IntPlayerMsg): void {
    this.player.setAudioPlayoutVolume(volume.getValue() ?? 100);
  }

  setRequestAudioFocus(focus: BoolPlayerMsg): BoolMsg {
    return new BoolMsg(false);
  }

  setConfig(config: FTXVodPlayConfigPlayerMsg): void {
    const vodConfig = new TXVodPlayConfig();
    if (config.getConnectRetryCount() !== undefined) {
      vodConfig.connectRetryCount = config.getConnectRetryCount()!;
    }
    if (config.getConnectRetryInterval() !== undefined) {
      vodConfig.connectRetryInterval = config.getConnectRetryInterval()!;
    }
    if (config.getTimeout() !== undefined) {
      vodConfig.timeout = config.getTimeout()!;
    }
    if (config.getHeaders() !== undefined) {
      vodConfig.headers = config.getHeaders() as Map<string, string>;
    }
    if (config.getEnableAccurateSeek() !== undefined) {
      vodConfig.enableAccurateSeek = config.getEnableAccurateSeek()!;
    }
    if (config.getProgressInterval() !== undefined) {
      vodConfig.progressInterval = config.getProgressInterval()!;
    }
    if (config.getPreferredResolution() !== undefined) {
      vodConfig.preferredResolution = config.getPreferredResolution()!;
    }
    this.player.setConfig(vodConfig);
  }

  getCurrentPlaybackTime(playerMsg: PlayerMsg): DoubleMsg {
    return new DoubleMsg(this.player.getCurrentPlaybackTime());
  }

  getBufferDuration(playerMsg: PlayerMsg): DoubleMsg {
    return new DoubleMsg(this.player.getBufferDuration());
  }

  getPlayableDuration(playerMsg: PlayerMsg): DoubleMsg {
    return new DoubleMsg(this.player.getPlayableDuration());
  }

  getWidth(playerMsg: PlayerMsg): IntMsg {
    return new IntMsg(this.player.getWidth());
  }

  getHeight(playerMsg: PlayerMsg): IntMsg {
    return new IntMsg(this.player.getHeight());
  }

  setToken(token: StringPlayerMsg): void {}

  isLoop(playerMsg: PlayerMsg): BoolMsg {
    return new BoolMsg(this.player.isLoop());
  }

  enableHardwareDecode(enable: BoolPlayerMsg): BoolMsg {
    return new BoolMsg(false);
  }

  enterPictureInPictureMode(pipParamsMsg: PipParamsPlayerMsg): IntMsg {
    return new IntMsg(-102);
  }

  exitPictureInPictureMode(playerMsg: PlayerMsg): void {}

  initImageSprite(spriteInfo: StringListPlayerMsg): void {}

  getImageSprite(time: DoublePlayerMsg): UInt8ListMsg {
    return new UInt8ListMsg([]);
  }

  getDuration(playerMsg: PlayerMsg): DoubleMsg {
    return new DoubleMsg(this.player.getDuration());
  }

  addSubtitleSource(playerMsg: SubTitlePlayerMsg): void {
    this.player.addSubtitleSource(playerMsg.getUrl() ?? '', playerMsg.getName() ?? '', playerMsg.getMimeType() ?? '');
  }

  getSubtitleTrackInfo(playerMsg: PlayerMsg): ListMsg {
    return new ListMsg(this.trackInfoList(this.player.getSubtitleTrackInfo()));
  }

  getAudioTrackInfo(playerMsg: PlayerMsg): ListMsg {
    return new ListMsg(this.trackInfoList(this.player.getAudioTrackInfo()));
  }

  selectTrack(playerMsg: IntPlayerMsg): void {
    this.player.selectTrack(playerMsg.getValue() ?? -1);
  }

  deselectTrack(playerMsg: IntPlayerMsg): void {
    this.player.deselectTrack(playerMsg.getValue() ?? -1);
  }

  setSubtitleStyle(playerMsg: SubTitleRenderModelPlayerMsg): void {
    this.player.vodPlayer.setSubtitleStyle(this.subtitleRenderModel(playerMsg));
  }

  setStringOption(playerMsg: StringOptionPlayerMsg): void {}

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

  setRenderMode(renderMode: number): void {}

  reDraw(): void {
    this.attachCurrentSurface();
  }

  enableTRTC(isEnabled: boolean): void {}

  publishVideo(): void {}

  unpublishVideo(): void {}

  publishAudio(): void {}

  unpublishAudio(): void {}

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

  private trackInfoList(items: TXTrackInfo[]): Object[] {
    return items.map((item: TXTrackInfo): Object => {
      return new Map<string, Object>([
        ['trackType', item.trackType],
        ['trackIndex', item.trackIndex],
        ['name', item.name ?? ''],
        ['isSelected', item.isSelected],
        ['isExclusive', item.isExclusive],
        ['isInternal', item.isInternal]
      ]);
    });
  }

  private createVodCallback(): ITXVodPlayCallback {
    return {
      onPlayEvent: (_player: TXVodPlayer, event: number, eventData?: Map<string, TXVodDef.ParamType>): void => {
        this.flutterApi.onPlayerEvent(FTXEventUtils.eventMap(event, this.toObjectMap(eventData)), FTXEventUtils.noopReply());
      },
      onNetStatus: (_player: TXVodPlayer, statusData: Map<string, TXVodDef.ParamType>): void => {
        this.flutterApi.onNetEvent(FTXEventUtils.eventMap(0, this.toObjectMap(statusData)), FTXEventUtils.noopReply());
      },
      onSnapshotComplete: (_player: TXVodPlayer): void => {},
      onSubtitleData: (_player: TXVodPlayer, subtitleData: TXVodDef.TXVodSubtitleData): void => {
        const params = new Map<string, Object>([
          ['subtitleText', subtitleData.subtitleText ?? ''],
          ['startPositionMs', subtitleData.startPositionMs ?? 0],
          ['trackIndex', subtitleData.trackIndex ?? -1]
        ]);
        this.flutterApi.onPlayerEvent(FTXEventUtils.eventMap(0, params), FTXEventUtils.noopReply());
      }
    };
  }

  private toObjectMap(source?: Map<string, TXVodDef.ParamType>): Map<string, Object> | undefined {
    if (source === undefined) {
      return undefined;
    }
    const result = new Map<string, Object>();
    source.forEach((value: TXVodDef.ParamType, key: string): void => {
      if (value !== undefined && value !== null) {
        result.set(key, value as Object);
      }
    });
    return result;
  }

  private subtitleRenderModel(msg: SubTitleRenderModelPlayerMsg): TXSubtitleRenderModel {
    const model = new TXSubtitleRenderModel();
    if (msg.getCanvasWidth() !== undefined) {
      model.canvasWidth = msg.getCanvasWidth()!;
    }
    if (msg.getCanvasHeight() !== undefined) {
      model.canvasHeight = msg.getCanvasHeight()!;
    }
    if (msg.getFamilyName() !== undefined) {
      model.familyName = msg.getFamilyName()!;
    }
    if (msg.getFontSize() !== undefined) {
      model.fontSize = msg.getFontSize()!;
    }
    if (msg.getFontScale() !== undefined) {
      model.fontScale = msg.getFontScale()!;
    }
    if (msg.getFontColor() !== undefined) {
      model.fontColor = msg.getFontColor()!;
    }
    if (msg.getIsBondFontStyle() !== undefined) {
      model.isBondFontStyle = msg.getIsBondFontStyle()!;
    }
    if (msg.getOutlineWidth() !== undefined) {
      model.outlineWidth = msg.getOutlineWidth()!;
    }
    if (msg.getOutlineColor() !== undefined) {
      model.outlineColor = msg.getOutlineColor()!;
    }
    if (msg.getLineSpace() !== undefined) {
      model.lineSpace = msg.getLineSpace()!;
    }
    if (msg.getStartMargin() !== undefined) {
      model.startMargin = msg.getStartMargin()!;
    }
    if (msg.getEndMargin() !== undefined) {
      model.endMargin = msg.getEndMargin()!;
    }
    if (msg.getVerticalMargin() !== undefined) {
      model.verticalMargin = msg.getVerticalMargin()!;
    }
    return model;
  }
}
