import common from '@ohos.app.ability.common';
import {
  ITXVodDownloadCallback,
  ITXVodPreloadCallback,
  TXVodDownloadDataSource,
  TXVodDownloadManager,
  TXVodDownloadMediaInfo,
  TXVodPreloadManager
} from 'liteavsdk/src/main/ets/k/Index';
import FTXEventUtils from '../FTXEventUtils';
import {
  BoolMsg,
  IntMsg,
  MapMsg,
  PreLoadInfoMsg,
  PreLoadMsg,
  TXDownloadFlutterAPI,
  TXDownloadListMsg,
  TXFlutterDownloadApi,
  TXVodDownloadMediaMsg
} from '../messages/FtxMessages';

export default class FTXDownloadManager extends TXFlutterDownloadApi {
  private nextTaskId: number = 1;
  private readonly downloads: Map<string, TXVodDownloadMediaMsg> = new Map<string, TXVodDownloadMediaMsg>();
  private readonly nativeDownloads: Map<string, TXVodDownloadMediaInfo> = new Map<string, TXVodDownloadMediaInfo>();
  private readonly context: common.Context;
  private readonly flutterApi: TXDownloadFlutterAPI;
  private headers: Map<string, string> = new Map<string, string>();

  constructor(context: common.Context, flutterApi: TXDownloadFlutterAPI) {
    super();
    this.context = context;
    this.flutterApi = flutterApi;
    this.downloadManager().setDownloadCallback(this.createDownloadCallback());
  }

  startPreLoad(msg: PreLoadMsg): IntMsg {
    const playUrl = msg.getPlayUrl() ?? '';
    if (playUrl.length === 0) {
      const fallbackTaskId = this.nextTaskId++;
      this.sendPreloadError(-1, fallbackTaskId, playUrl, -1, 'Preload url is empty.');
      return new IntMsg(fallbackTaskId);
    }
    const taskId = this.preloadManager().startPreloadUrl(
      playUrl,
      msg.getPreloadSizeMB() ?? 0,
      msg.getPreferredResolution() ?? -1,
      this.headers,
      this.createPreloadCallback(-1)
    );
    return new IntMsg(taskId);
  }

  startPreLoadByParams(msg: PreLoadInfoMsg): void {
    const tmpTaskId = msg.getTmpPreloadTaskId() ?? -1;
    const playUrl = msg.getPlayUrl() ?? '';
    if (playUrl.length === 0) {
      this.sendPreloadError(tmpTaskId, -1, playUrl, -1, 'OHOS LiteAVSDK 13.2.0 exposes URL preload only.');
      return;
    }
    const taskId = this.preloadManager().startPreloadUrl(
      playUrl,
      msg.getPreloadSizeMB() ?? 0,
      msg.getPreferredResolution() ?? -1,
      msg.getHttpHeader() ?? this.headers,
      this.createPreloadCallback(tmpTaskId)
    );
    this.sendPreloadStart(tmpTaskId, taskId, msg.getFileId() ?? '', playUrl, msg.getHttpHeader() ?? new Map<string, string>());
  }

  stopPreLoad(msg: IntMsg): void {
    this.preloadManager().stopPreload(msg.getValue() ?? -1);
  }

  startDownload(msg: TXVodDownloadMediaMsg): void {
    this.startOrResumeDownload(msg);
  }

  resumeDownload(msg: TXVodDownloadMediaMsg): void {
    this.startOrResumeDownload(msg);
  }

  stopDownload(msg: TXVodDownloadMediaMsg): void {
    const mediaInfo = this.findNativeDownload(msg);
    if (mediaInfo !== undefined) {
      this.downloadManager().stopDownload(mediaInfo);
    }
  }

  setDownloadHeaders(headers: MapMsg): void {
    this.headers = headers.getMap() ?? new Map<string, string>();
    this.downloadManager().setHeaders(this.headers);
  }

  getDownloadList(): TXDownloadListMsg {
    const infos = this.downloadManager().syncGetDownloadMediaInfoList();
    return new TXDownloadListMsg(infos.map((info: TXVodDownloadMediaInfo): TXVodDownloadMediaMsg => this.msgFromNative(info)));
  }

  getDownloadInfo(msg: TXVodDownloadMediaMsg): TXVodDownloadMediaMsg {
    const mediaInfo = this.findNativeDownload(msg);
    return mediaInfo !== undefined ? this.msgFromNative(mediaInfo) : (this.downloads.get(this.keyFor(msg)) ?? msg);
  }

  deleteDownloadMediaInfo(msg: TXVodDownloadMediaMsg): BoolMsg {
    const mediaInfo = this.findNativeDownload(msg);
    if (mediaInfo === undefined) {
      return new BoolMsg(this.downloads.delete(this.keyFor(msg)));
    }
    this.downloadManager().stopDownload(mediaInfo);
    const deleted = this.downloadManager().deleteDownloadMediaInfo(mediaInfo);
    if (deleted) {
      this.downloads.delete(this.keyFor(msg));
      this.nativeDownloads.delete(this.keyFor(msg));
    }
    return new BoolMsg(deleted);
  }

  private keyFor(msg: TXVodDownloadMediaMsg): string {
    return msg.getUrl() ?? msg.getPlayPath() ?? `${msg.getAppId() ?? 0}:${msg.getFileId() ?? ''}:${msg.getQuality() ?? 0}`;
  }

  private startOrResumeDownload(msg: TXVodDownloadMediaMsg): void {
    this.downloadManager().setHeaders(this.headers);
    let mediaInfo: TXVodDownloadMediaInfo | undefined;
    const url = msg.getUrl() ?? '';
    if (url.length > 0) {
      mediaInfo = this.downloadManager().startDownloadUrl(url, msg.getQuality() ?? -1);
    } else if (msg.getAppId() !== undefined && msg.getFileId() !== undefined) {
      const dataSource = new TXVodDownloadDataSource(msg.getAppId()!, msg.getFileId()!, msg.getQuality() ?? -1, msg.getPSign() ?? '');
      if (msg.getToken() !== undefined) {
        dataSource.setToken(msg.getToken()!);
      }
      if (msg.getUserName() !== undefined) {
        dataSource.userName = msg.getUserName()!;
      }
      mediaInfo = this.downloadManager().startDownloadDataSource(dataSource);
    }
    if (mediaInfo !== undefined) {
      const mediaMsg = this.msgFromNative(mediaInfo);
      this.downloads.set(this.keyFor(mediaMsg), mediaMsg);
      this.nativeDownloads.set(this.keyFor(mediaMsg), mediaInfo);
    } else {
      this.sendDownloadEvent(FTXEventUtils.EVENT_DOWNLOAD_ERROR, msg, new Map<string, Object>([
        ['errorCode', -1],
        ['errorMsg', 'Neither url nor fileId download parameters are available.']
      ]));
    }
  }

  private findNativeDownload(msg: TXVodDownloadMediaMsg): TXVodDownloadMediaInfo | undefined {
    const cached = this.nativeDownloads.get(this.keyFor(msg));
    if (cached !== undefined) {
      return cached;
    }
    if ((msg.getUrl() ?? '').length > 0) {
      const byUrl = this.downloadManager().syncGetDownloadMediaInfoByUrl(msg.getUrl()!, msg.getQuality() ?? -1);
      return byUrl === null ? undefined : byUrl;
    }
    if (msg.getAppId() !== undefined && msg.getFileId() !== undefined) {
      const byFileId = this.downloadManager().syncGetDownloadMediaInfoByFileId(msg.getAppId()!, msg.getFileId()!, msg.getQuality() ?? -1);
      return byFileId === null ? undefined : byFileId;
    }
    return undefined;
  }

  private msgFromNative(info: TXVodDownloadMediaInfo): TXVodDownloadMediaMsg {
    const msg = new TXVodDownloadMediaMsg();
    msg.setPlayPath(info.getPlayPath() ?? '');
    msg.setProgress(info.getProgress());
    msg.setDownloadState(FTXEventUtils.downloadStateToEvent(info.getDownloadState()));
    msg.setUserName(info.getUserName() ?? '');
    msg.setDuration(info.getDuration());
    msg.setPlayableDuration(info.getPlayableDuration());
    msg.setSize(info.getSize());
    msg.setDownloadSize(info.getDownloadSize());
    msg.setUrl(info.getUrl() ?? '');
    msg.setQuality(info.getPreferredResolution());
    msg.setSpeed(info.getSpeed());
    msg.setIsResourceBroken(info.isResourceBroken);
    const dataSource = info.getDataSource();
    if (dataSource !== undefined && dataSource !== null) {
      msg.setAppId(dataSource.getAppId());
      msg.setFileId(dataSource.getFileId() ?? '');
      msg.setPSign(dataSource.getPSign() ?? '');
      msg.setQuality(dataSource.getQuality());
      msg.setToken(dataSource.getToken() ?? '');
    }
    return msg;
  }

  private createDownloadCallback(): ITXVodDownloadCallback {
    return {
      onDownloadStart: (mediaInfo: TXVodDownloadMediaInfo): void => this.onNativeDownload(FTXEventUtils.EVENT_DOWNLOAD_START, mediaInfo),
      onDownloadProgress: (mediaInfo: TXVodDownloadMediaInfo): void => this.onNativeDownload(FTXEventUtils.EVENT_DOWNLOAD_PROGRESS, mediaInfo),
      onDownloadStop: (mediaInfo: TXVodDownloadMediaInfo): void => this.onNativeDownload(FTXEventUtils.EVENT_DOWNLOAD_STOP, mediaInfo),
      onDownloadFinish: (mediaInfo: TXVodDownloadMediaInfo): void => this.onNativeDownload(FTXEventUtils.EVENT_DOWNLOAD_FINISH, mediaInfo),
      onDownloadError: (mediaInfo: TXVodDownloadMediaInfo, error: number, reason: string): void => {
        this.sendDownloadEvent(FTXEventUtils.EVENT_DOWNLOAD_ERROR, this.msgFromNative(mediaInfo), new Map<string, Object>([
          ['errorCode', error],
          ['errorMsg', reason]
        ]));
      }
    };
  }

  private onNativeDownload(event: number, mediaInfo: TXVodDownloadMediaInfo): void {
    const msg = this.msgFromNative(mediaInfo);
    this.downloads.set(this.keyFor(msg), msg);
    this.nativeDownloads.set(this.keyFor(msg), mediaInfo);
    this.sendDownloadEvent(event, msg);
  }

  private sendDownloadEvent(event: number, media: TXVodDownloadMediaMsg, extras?: Map<string, Object>): void {
    const params = this.mediaEventMap(media);
    if (extras !== undefined) {
      extras.forEach((value: Object, key: string): void => {
        params.set(key, value);
      });
    }
    this.flutterApi.onDownloadEvent(FTXEventUtils.eventMap(event, params), FTXEventUtils.noopReply());
  }

  private mediaEventMap(media: TXVodDownloadMediaMsg): Map<string, Object> {
    const params = new Map<string, Object>();
    this.setIfPresent(params, 'playPath', media.getPlayPath());
    this.setIfPresent(params, 'progress', media.getProgress());
    this.setIfPresent(params, 'downloadState', media.getDownloadState());
    this.setIfPresent(params, 'userName', media.getUserName());
    this.setIfPresent(params, 'duration', media.getDuration());
    this.setIfPresent(params, 'playableDuration', media.getPlayableDuration());
    this.setIfPresent(params, 'size', media.getSize());
    this.setIfPresent(params, 'downloadSize', media.getDownloadSize());
    this.setIfPresent(params, 'url', media.getUrl());
    this.setIfPresent(params, 'appId', media.getAppId());
    this.setIfPresent(params, 'fileId', media.getFileId());
    this.setIfPresent(params, 'pSign', media.getPSign());
    this.setIfPresent(params, 'quality', media.getQuality());
    this.setIfPresent(params, 'token', media.getToken());
    this.setIfPresent(params, 'speed', media.getSpeed());
    this.setIfPresent(params, 'isResourceBroken', media.getIsResourceBroken());
    return params;
  }

  private createPreloadCallback(tmpTaskId: number): ITXVodPreloadCallback {
    return {
      onComplete: (taskId: number, url: string): void => {
        this.flutterApi.onPreDownloadEvent(FTXEventUtils.eventMap(FTXEventUtils.EVENT_PREDOWNLOAD_ON_COMPLETE, new Map<string, Object>([
          ['taskId', taskId],
          ['url', url]
        ])), FTXEventUtils.noopReply());
      },
      onError: (taskId: number, url: string, code: number, msg: string): void => {
        this.sendPreloadError(tmpTaskId, taskId, url, code, msg);
      }
    };
  }

  private sendPreloadStart(tmpTaskId: number, taskId: number, fileId: string, url: string, params: Map<string, string>): void {
    this.flutterApi.onPreDownloadEvent(FTXEventUtils.eventMap(FTXEventUtils.EVENT_PREDOWNLOAD_ON_START, new Map<string, Object>([
      ['tmpTaskId', tmpTaskId],
      ['taskId', taskId],
      ['fileId', fileId],
      ['url', url],
      ['params', params]
    ])), FTXEventUtils.noopReply());
  }

  private sendPreloadError(tmpTaskId: number, taskId: number, url: string, code: number, msg: string): void {
    const params = new Map<string, Object>([
      ['taskId', taskId],
      ['url', url],
      ['code', code],
      ['msg', msg]
    ]);
    if (tmpTaskId >= 0) {
      params.set('tmpTaskId', tmpTaskId);
    }
    this.flutterApi.onPreDownloadEvent(FTXEventUtils.eventMap(FTXEventUtils.EVENT_PREDOWNLOAD_ON_ERROR, params), FTXEventUtils.noopReply());
  }

  private downloadManager(): TXVodDownloadManager {
    return TXVodDownloadManager.getInstance(this.context);
  }

  private preloadManager(): TXVodPreloadManager {
    return TXVodPreloadManager.getInstance(this.context);
  }

  private setIfPresent(params: Map<string, Object>, key: string, value: Object | undefined): void {
    if (value !== undefined && value !== null) {
      params.set(key, value);
    }
  }
}
