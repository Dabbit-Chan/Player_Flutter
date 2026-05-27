/*
* Copyright (c) 2022 Tencent. All rights reserved.
*/
import StandardMessageCodec from '@ohos/flutter_ohos/src/main/ets/plugin/common/StandardMessageCodec';
import BasicMessageChannel, { Reply } from '@ohos/flutter_ohos/src/main/ets/plugin/common/BasicMessageChannel';
import { BinaryMessenger,TaskQueue } from '@ohos/flutter_ohos/src/main/ets/plugin/common/BinaryMessenger';
import MessageCodec from '@ohos/flutter_ohos/src/main/ets/plugin/common/MessageCodec';
import { ByteBuffer } from '@ohos/flutter_ohos/src/main/ets/util/ByteBuffer';


/** Error class for passing custom error details to Flutter via a thrown PlatformException. */
export class FlutterError implements Error {

  /** The error code. */
  public code: string;

  /** The error name. */
  public name: string;

  /** The error message. */
  public message: string;
  /** The error stack. */
  public stack?: string;

  constructor(code: string, name: string,  message: string, stack?: string) 
  {
    this.code = code;
    this.name = name;
    this.message = message;
    this.stack = stack;
  }
}

function wrapError(error: Error): Array<Object> {
  let errorList: Array<Object> = new Array<Object>(3);
  if (error instanceof FlutterError) {
    let err: FlutterError = error as FlutterError;
    errorList[0] = err.code;
    errorList[1] = err.name;
    errorList[2] = err.message;
  } else {
    errorList[0] = error.toString();
    errorList[1] = error.name;
    errorList[2] = "Cause: " + error.message + ", Stacktrace: " + error.stack;
  }
  return errorList;
}


/*
*  Pigeon original component, used to generate native communication code for `messages`.
*  The generation command is as follows. When using the generation command,
*  the two import statements above need to be implemented or commented out.
* 
*  pigeon原始原件，由此文件生成messages原生通信代码
*  生成命令如下，使用生成命令的时候，需要实现注释掉以上两个import导入
* 
*  Generated class from Pigeon that represents data sent in messages.
*/
export class PlayerMsg {
  private playerId?: number;

  public setPlayerId(playerId:number):void {
    this.playerId = playerId;
  }

  getPlayerId(): number | undefined{
    return this.playerId;
  }

  constructor(playerId?: number) {
    this.playerId = playerId;
  }

  toList(): Object[] {
    let arr: Object[] = new Array();
    if(this.playerId !==undefined){
      arr.push(this.playerId);
    }
    return arr;
  }

  static fromList(arr: Object[]): PlayerMsg {
    let pigeonResult: PlayerMsg = new PlayerMsg();
    let playerId: Object = arr[0];
    pigeonResult.setPlayerId(playerId as number);
    return pigeonResult;
  }
}

/* Generated class from Pigeon that represents data sent in messages.*/
export class LicenseMsg {
  private licenseUrl?: string;

  public setLicenseUrl(licenseUrl:string):void {
    this.licenseUrl = licenseUrl;
  }

  getLicenseUrl(): string | undefined{
    return this.licenseUrl;
  }

  private licenseKey?: string;

  public setLicenseKey(licenseKey:string):void {
    this.licenseKey = licenseKey;
  }

  getLicenseKey(): string | undefined{
    return this.licenseKey;
  }

  constructor(licenseUrl?: string, licenseKey?: string) {
    this.licenseUrl = licenseUrl;
    this.licenseKey = licenseKey;
  }

  toList(): Object[] {
    let arr: Object[] = new Array();
    if(this.licenseUrl !==undefined){
      arr.push(this.licenseUrl);
    }
    if(this.licenseKey !==undefined){
      arr.push(this.licenseKey);
    }
    return arr;
  }

  static fromList(arr: Object[]): LicenseMsg {
    let pigeonResult: LicenseMsg = new LicenseMsg();
    let licenseUrl: Object = arr[0];
    pigeonResult.setLicenseUrl(licenseUrl as string);
    let licenseKey: Object = arr[1];
    pigeonResult.setLicenseKey(licenseKey as string);
    return pigeonResult;
  }
}

/* Generated class from Pigeon that represents data sent in messages.*/
export class TXPlayInfoParamsPlayerMsg {
  private playerId?: number;

  public setPlayerId(playerId:number):void {
    this.playerId = playerId;
  }

  getPlayerId(): number | undefined{
    return this.playerId;
  }

  private appId?: number;

  public setAppId(appId:number):void {
    this.appId = appId;
  }

  getAppId(): number | undefined{
    return this.appId;
  }

  private fileId?: string;

  public setFileId(fileId:string):void {
    this.fileId = fileId;
  }

  getFileId(): string | undefined{
    return this.fileId;
  }

  private psign?: string;

  public setPsign(psign:string):void {
    this.psign = psign;
  }

  getPsign(): string | undefined{
    return this.psign;
  }

  private url?: string;

  public setUrl(url:string):void {
    this.url = url;
  }

  getUrl(): string | undefined{
    return this.url;
  }

  constructor(playerId?: number, appId?: number, fileId?: string, psign?: string, url?: string) {
    this.playerId = playerId;
    this.appId = appId;
    this.fileId = fileId;
    this.psign = psign;
    this.url = url;
  }

  toList(): Object[] {
    let arr: Object[] = new Array();
    if(this.playerId !==undefined){
      arr.push(this.playerId);
    }
    if(this.appId !==undefined){
      arr.push(this.appId);
    }
    if(this.fileId !==undefined){
      arr.push(this.fileId);
    }
    if(this.psign !==undefined){
      arr.push(this.psign);
    }
    if(this.url !==undefined){
      arr.push(this.url);
    }
    return arr;
  }

  static fromList(arr: Object[]): TXPlayInfoParamsPlayerMsg {
    let pigeonResult: TXPlayInfoParamsPlayerMsg = new TXPlayInfoParamsPlayerMsg();
    let playerId: Object = arr[0];
    pigeonResult.setPlayerId(playerId as number);
    let appId: Object = arr[1];
    pigeonResult.setAppId(appId as number);
    let fileId: Object = arr[2];
    pigeonResult.setFileId(fileId as string);
    let psign: Object = arr[3];
    pigeonResult.setPsign(psign as string);
    let url: Object = arr[4];
    pigeonResult.setUrl(url as string);
    return pigeonResult;
  }
}

/* Generated class from Pigeon that represents data sent in messages.*/
export class TXPlayerDrmMsg {
  private licenseUrl?: string;

  public setLicenseUrl(licenseUrl:string):void {
    this.licenseUrl = licenseUrl;
  }

  getLicenseUrl(): string | undefined{
    return this.licenseUrl;
  }

  private playUrl?: string;

  public setPlayUrl(playUrl:string):void {
    this.playUrl = playUrl;
  }

  getPlayUrl(): string | undefined{
    return this.playUrl;
  }

  private playerId?: number;

  public setPlayerId(playerId:number):void {
    this.playerId = playerId;
  }

  getPlayerId(): number | undefined{
    return this.playerId;
  }

  private deviceCertificateUrl?: string;

  public setDeviceCertificateUrl(deviceCertificateUrl:string):void {
    this.deviceCertificateUrl = deviceCertificateUrl;
  }

  getDeviceCertificateUrl(): string | undefined{
    return this.deviceCertificateUrl;
  }

  constructor(licenseUrl?: string, playUrl?: string, playerId?: number, deviceCertificateUrl?: string) {
    this.licenseUrl = licenseUrl;
    this.playUrl = playUrl;
    this.playerId = playerId;
    this.deviceCertificateUrl = deviceCertificateUrl;
  }

  toList(): Object[] {
    let arr: Object[] = new Array();
    if(this.licenseUrl !==undefined){
      arr.push(this.licenseUrl);
    }
    if(this.playUrl !==undefined){
      arr.push(this.playUrl);
    }
    if(this.playerId !==undefined){
      arr.push(this.playerId);
    }
    if(this.deviceCertificateUrl !==undefined){
      arr.push(this.deviceCertificateUrl);
    }
    return arr;
  }

  static fromList(arr: Object[]): TXPlayerDrmMsg {
    let pigeonResult: TXPlayerDrmMsg = new TXPlayerDrmMsg();
    let licenseUrl: Object = arr[0];
    pigeonResult.setLicenseUrl(licenseUrl as string);
    let playUrl: Object = arr[1];
    pigeonResult.setPlayUrl(playUrl as string);
    let playerId: Object = arr[2];
    pigeonResult.setPlayerId(playerId as number);
    let deviceCertificateUrl: Object = arr[3];
    pigeonResult.setDeviceCertificateUrl(deviceCertificateUrl as string);
    return pigeonResult;
  }
}

/* Generated class from Pigeon that represents data sent in messages.*/
export class PipParamsPlayerMsg {
  private playerId?: number;

  public setPlayerId(playerId:number):void {
    this.playerId = playerId;
  }

  getPlayerId(): number | undefined{
    return this.playerId;
  }

  private backIconForAndroid?: string;

  public setBackIconForAndroid(backIconForAndroid:string):void {
    this.backIconForAndroid = backIconForAndroid;
  }

  getBackIconForAndroid(): string | undefined{
    return this.backIconForAndroid;
  }

  private playIconForAndroid?: string;

  public setPlayIconForAndroid(playIconForAndroid:string):void {
    this.playIconForAndroid = playIconForAndroid;
  }

  getPlayIconForAndroid(): string | undefined{
    return this.playIconForAndroid;
  }

  private pauseIconForAndroid?: string;

  public setPauseIconForAndroid(pauseIconForAndroid:string):void {
    this.pauseIconForAndroid = pauseIconForAndroid;
  }

  getPauseIconForAndroid(): string | undefined{
    return this.pauseIconForAndroid;
  }

  private forwardIconForAndroid?: string;

  public setForwardIconForAndroid(forwardIconForAndroid:string):void {
    this.forwardIconForAndroid = forwardIconForAndroid;
  }

  getForwardIconForAndroid(): string | undefined{
    return this.forwardIconForAndroid;
  }

  constructor(playerId?: number, backIconForAndroid?: string, playIconForAndroid?: string, pauseIconForAndroid?: string, forwardIconForAndroid?: string) {
    this.playerId = playerId;
    this.backIconForAndroid = backIconForAndroid;
    this.playIconForAndroid = playIconForAndroid;
    this.pauseIconForAndroid = pauseIconForAndroid;
    this.forwardIconForAndroid = forwardIconForAndroid;
  }

  toList(): Object[] {
    let arr: Object[] = new Array();
    if(this.playerId !==undefined){
      arr.push(this.playerId);
    }
    if(this.backIconForAndroid !==undefined){
      arr.push(this.backIconForAndroid);
    }
    if(this.playIconForAndroid !==undefined){
      arr.push(this.playIconForAndroid);
    }
    if(this.pauseIconForAndroid !==undefined){
      arr.push(this.pauseIconForAndroid);
    }
    if(this.forwardIconForAndroid !==undefined){
      arr.push(this.forwardIconForAndroid);
    }
    return arr;
  }

  static fromList(arr: Object[]): PipParamsPlayerMsg {
    let pigeonResult: PipParamsPlayerMsg = new PipParamsPlayerMsg();
    let playerId: Object = arr[0];
    pigeonResult.setPlayerId(playerId as number);
    let backIconForAndroid: Object = arr[1];
    pigeonResult.setBackIconForAndroid(backIconForAndroid as string);
    let playIconForAndroid: Object = arr[2];
    pigeonResult.setPlayIconForAndroid(playIconForAndroid as string);
    let pauseIconForAndroid: Object = arr[3];
    pigeonResult.setPauseIconForAndroid(pauseIconForAndroid as string);
    let forwardIconForAndroid: Object = arr[4];
    pigeonResult.setForwardIconForAndroid(forwardIconForAndroid as string);
    return pigeonResult;
  }
}

/* Generated class from Pigeon that represents data sent in messages.*/
export class StringListPlayerMsg {
  private playerId?: number;

  public setPlayerId(playerId:number):void {
    this.playerId = playerId;
  }

  getPlayerId(): number | undefined{
    return this.playerId;
  }

  private vvtUrl?: string;

  public setVvtUrl(vvtUrl:string):void {
    this.vvtUrl = vvtUrl;
  }

  getVvtUrl(): string | undefined{
    return this.vvtUrl;
  }

  private imageUrls?: Array<string>;

  public setImageUrls(imageUrls:Array<string>):void {
    this.imageUrls = imageUrls;
  }

  getImageUrls(): Array<string> | undefined{
    return this.imageUrls;
  }

  constructor(playerId?: number, vvtUrl?: string, imageUrls?: Array<string>) {
    this.playerId = playerId;
    this.vvtUrl = vvtUrl;
    this.imageUrls = imageUrls;
  }

  toList(): Object[] {
    let arr: Object[] = new Array();
    if(this.playerId !==undefined){
      arr.push(this.playerId);
    }
    if(this.vvtUrl !==undefined){
      arr.push(this.vvtUrl);
    }
    if(this.imageUrls !==undefined){
      arr.push(this.imageUrls);
    }
    return arr;
  }

  static fromList(arr: Object[]): StringListPlayerMsg {
    let pigeonResult: StringListPlayerMsg = new StringListPlayerMsg();
    let playerId: Object = arr[0];
    pigeonResult.setPlayerId(playerId as number);
    let vvtUrl: Object = arr[1];
    pigeonResult.setVvtUrl(vvtUrl as string);
    let imageUrls: Object = arr[2];
    pigeonResult.setImageUrls(imageUrls as Array<string>);
    return pigeonResult;
  }
}

/* Generated class from Pigeon that represents data sent in messages.*/
export class BoolPlayerMsg {
  private playerId?: number;

  public setPlayerId(playerId:number):void {
    this.playerId = playerId;
  }

  getPlayerId(): number | undefined{
    return this.playerId;
  }

  private value?: boolean;

  public setValue(value:boolean):void {
    this.value = value;
  }

  getValue(): boolean | undefined{
    return this.value;
  }

  constructor(playerId?: number, value?: boolean) {
    this.playerId = playerId;
    this.value = value;
  }

  toList(): Object[] {
    let arr: Object[] = new Array();
    if(this.playerId !==undefined){
      arr.push(this.playerId);
    }
    if(this.value !==undefined){
      arr.push(this.value);
    }
    return arr;
  }

  static fromList(arr: Object[]): BoolPlayerMsg {
    let pigeonResult: BoolPlayerMsg = new BoolPlayerMsg();
    let playerId: Object = arr[0];
    pigeonResult.setPlayerId(playerId as number);
    let value: Object = arr[1];
    pigeonResult.setValue(value as boolean);
    return pigeonResult;
  }
}

/* Generated class from Pigeon that represents data sent in messages.*/
export class StringPlayerMsg {
  private playerId?: number;

  public setPlayerId(playerId:number):void {
    this.playerId = playerId;
  }

  getPlayerId(): number | undefined{
    return this.playerId;
  }

  private value?: string;

  public setValue(value:string):void {
    this.value = value;
  }

  getValue(): string | undefined{
    return this.value;
  }

  constructor(playerId?: number, value?: string) {
    this.playerId = playerId;
    this.value = value;
  }

  toList(): Object[] {
    let arr: Object[] = new Array();
    if(this.playerId !==undefined){
      arr.push(this.playerId);
    }
    if(this.value !==undefined){
      arr.push(this.value);
    }
    return arr;
  }

  static fromList(arr: Object[]): StringPlayerMsg {
    let pigeonResult: StringPlayerMsg = new StringPlayerMsg();
    let playerId: Object = arr[0];
    pigeonResult.setPlayerId(playerId as number);
    let value: Object = arr[1];
    pigeonResult.setValue(value as string);
    return pigeonResult;
  }
}

/* Generated class from Pigeon that represents data sent in messages.*/
export class DoublePlayerMsg {
  private playerId?: number;

  public setPlayerId(playerId:number):void {
    this.playerId = playerId;
  }

  getPlayerId(): number | undefined{
    return this.playerId;
  }

  private value?: number;

  public setValue(value:number):void {
    this.value = value;
  }

  getValue(): number | undefined{
    return this.value;
  }

  constructor(playerId?: number, value?: number) {
    this.playerId = playerId;
    this.value = value;
  }

  toList(): Object[] {
    let arr: Object[] = new Array();
    if(this.playerId !==undefined){
      arr.push(this.playerId);
    }
    if(this.value !==undefined){
      arr.push(this.value);
    }
    return arr;
  }

  static fromList(arr: Object[]): DoublePlayerMsg {
    let pigeonResult: DoublePlayerMsg = new DoublePlayerMsg();
    let playerId: Object = arr[0];
    pigeonResult.setPlayerId(playerId as number);
    let value: Object = arr[1];
    pigeonResult.setValue(value as number);
    return pigeonResult;
  }
}

/* Generated class from Pigeon that represents data sent in messages.*/
export class IntPlayerMsg {
  private playerId?: number;

  public setPlayerId(playerId:number):void {
    this.playerId = playerId;
  }

  getPlayerId(): number | undefined{
    return this.playerId;
  }

  private value?: number;

  public setValue(value:number):void {
    this.value = value;
  }

  getValue(): number | undefined{
    return this.value;
  }

  constructor(playerId?: number, value?: number) {
    this.playerId = playerId;
    this.value = value;
  }

  toList(): Object[] {
    let arr: Object[] = new Array();
    if(this.playerId !==undefined){
      arr.push(this.playerId);
    }
    if(this.value !==undefined){
      arr.push(this.value);
    }
    return arr;
  }

  static fromList(arr: Object[]): IntPlayerMsg {
    let pigeonResult: IntPlayerMsg = new IntPlayerMsg();
    let playerId: Object = arr[0];
    pigeonResult.setPlayerId(playerId as number);
    let value: Object = arr[1];
    pigeonResult.setValue(value as number);
    return pigeonResult;
  }
}

/* Generated class from Pigeon that represents data sent in messages.*/
export class FTXVodPlayConfigPlayerMsg {
  private playerId?: number;

  public setPlayerId(playerId:number):void {
    this.playerId = playerId;
  }

  getPlayerId(): number | undefined{
    return this.playerId;
  }

  private connectRetryCount?: number;

  public setConnectRetryCount(connectRetryCount:number):void {
    this.connectRetryCount = connectRetryCount;
  }

  getConnectRetryCount(): number | undefined{
    return this.connectRetryCount;
  }

  private connectRetryInterval?: number;

  public setConnectRetryInterval(connectRetryInterval:number):void {
    this.connectRetryInterval = connectRetryInterval;
  }

  getConnectRetryInterval(): number | undefined{
    return this.connectRetryInterval;
  }

  private timeout?: number;

  public setTimeout(timeout:number):void {
    this.timeout = timeout;
  }

  getTimeout(): number | undefined{
    return this.timeout;
  }

  private playerType?: number;

  public setPlayerType(playerType:number):void {
    this.playerType = playerType;
  }

  getPlayerType(): number | undefined{
    return this.playerType;
  }

  private headers?: Map<string, string>;

  public setHeaders(headers:Map<string, string>):void {
    this.headers = headers;
  }

  getHeaders(): Map<string, string> | undefined{
    return this.headers;
  }

  private enableAccurateSeek?: boolean;

  public setEnableAccurateSeek(enableAccurateSeek:boolean):void {
    this.enableAccurateSeek = enableAccurateSeek;
  }

  getEnableAccurateSeek(): boolean | undefined{
    return this.enableAccurateSeek;
  }

  private autoRotate?: boolean;

  public setAutoRotate(autoRotate:boolean):void {
    this.autoRotate = autoRotate;
  }

  getAutoRotate(): boolean | undefined{
    return this.autoRotate;
  }

  private smoothSwitchBitrate?: boolean;

  public setSmoothSwitchBitrate(smoothSwitchBitrate:boolean):void {
    this.smoothSwitchBitrate = smoothSwitchBitrate;
  }

  getSmoothSwitchBitrate(): boolean | undefined{
    return this.smoothSwitchBitrate;
  }

  private cacheMp4ExtName?: string;

  public setCacheMp4ExtName(cacheMp4ExtName:string):void {
    this.cacheMp4ExtName = cacheMp4ExtName;
  }

  getCacheMp4ExtName(): string | undefined{
    return this.cacheMp4ExtName;
  }

  private progressInterval?: number;

  public setProgressInterval(progressInterval:number):void {
    this.progressInterval = progressInterval;
  }

  getProgressInterval(): number | undefined{
    return this.progressInterval;
  }

  private maxBufferSize?: number;

  public setMaxBufferSize(maxBufferSize:number):void {
    this.maxBufferSize = maxBufferSize;
  }

  getMaxBufferSize(): number | undefined{
    return this.maxBufferSize;
  }

  private maxPreloadSize?: number;

  public setMaxPreloadSize(maxPreloadSize:number):void {
    this.maxPreloadSize = maxPreloadSize;
  }

  getMaxPreloadSize(): number | undefined{
    return this.maxPreloadSize;
  }

  private firstStartPlayBufferTime?: number;

  public setFirstStartPlayBufferTime(firstStartPlayBufferTime:number):void {
    this.firstStartPlayBufferTime = firstStartPlayBufferTime;
  }

  getFirstStartPlayBufferTime(): number | undefined{
    return this.firstStartPlayBufferTime;
  }

  private nextStartPlayBufferTime?: number;

  public setNextStartPlayBufferTime(nextStartPlayBufferTime:number):void {
    this.nextStartPlayBufferTime = nextStartPlayBufferTime;
  }

  getNextStartPlayBufferTime(): number | undefined{
    return this.nextStartPlayBufferTime;
  }

  private overlayKey?: string;

  public setOverlayKey(overlayKey:string):void {
    this.overlayKey = overlayKey;
  }

  getOverlayKey(): string | undefined{
    return this.overlayKey;
  }

  private overlayIv?: string;

  public setOverlayIv(overlayIv:string):void {
    this.overlayIv = overlayIv;
  }

  getOverlayIv(): string | undefined{
    return this.overlayIv;
  }

  private extInfoMap?: Map<string, Object>;

  public setExtInfoMap(extInfoMap:Map<string, Object>):void {
    this.extInfoMap = extInfoMap;
  }

  getExtInfoMap(): Map<string, Object> | undefined{
    return this.extInfoMap;
  }

  private enableRenderProcess?: boolean;

  public setEnableRenderProcess(enableRenderProcess:boolean):void {
    this.enableRenderProcess = enableRenderProcess;
  }

  getEnableRenderProcess(): boolean | undefined{
    return this.enableRenderProcess;
  }

  private preferredResolution?: number;

  public setPreferredResolution(preferredResolution:number):void {
    this.preferredResolution = preferredResolution;
  }

  getPreferredResolution(): number | undefined{
    return this.preferredResolution;
  }

  private mediaType?: number;

  public setMediaType(mediaType:number):void {
    this.mediaType = mediaType;
  }

  getMediaType(): number | undefined{
    return this.mediaType;
  }

  private encryptedMp4Level?: number;

  public setEncryptedMp4Level(encryptedMp4Level:number):void {
    this.encryptedMp4Level = encryptedMp4Level;
  }

  getEncryptedMp4Level(): number | undefined{
    return this.encryptedMp4Level;
  }

  private preferAudioTrack?: string;

  public setPreferAudioTrack(preferAudioTrack:string):void {
    this.preferAudioTrack = preferAudioTrack;
  }

  getPreferAudioTrack(): string | undefined{
    return this.preferAudioTrack;
  }

  constructor(playerId?: number, connectRetryCount?: number, connectRetryInterval?: number, timeout?: number, playerType?: number, headers?: Map<string, string>, enableAccurateSeek?: boolean, autoRotate?: boolean, smoothSwitchBitrate?: boolean, cacheMp4ExtName?: string, progressInterval?: number, maxBufferSize?: number, maxPreloadSize?: number, firstStartPlayBufferTime?: number, nextStartPlayBufferTime?: number, overlayKey?: string, overlayIv?: string, extInfoMap?: Map<string, Object>, enableRenderProcess?: boolean, preferredResolution?: number, mediaType?: number, encryptedMp4Level?: number, preferAudioTrack?: string) {
    this.playerId = playerId;
    this.connectRetryCount = connectRetryCount;
    this.connectRetryInterval = connectRetryInterval;
    this.timeout = timeout;
    this.playerType = playerType;
    this.headers = headers;
    this.enableAccurateSeek = enableAccurateSeek;
    this.autoRotate = autoRotate;
    this.smoothSwitchBitrate = smoothSwitchBitrate;
    this.cacheMp4ExtName = cacheMp4ExtName;
    this.progressInterval = progressInterval;
    this.maxBufferSize = maxBufferSize;
    this.maxPreloadSize = maxPreloadSize;
    this.firstStartPlayBufferTime = firstStartPlayBufferTime;
    this.nextStartPlayBufferTime = nextStartPlayBufferTime;
    this.overlayKey = overlayKey;
    this.overlayIv = overlayIv;
    this.extInfoMap = extInfoMap;
    this.enableRenderProcess = enableRenderProcess;
    this.preferredResolution = preferredResolution;
    this.mediaType = mediaType;
    this.encryptedMp4Level = encryptedMp4Level;
    this.preferAudioTrack = preferAudioTrack;
  }

  toList(): Object[] {
    let arr: Object[] = new Array();
    if(this.playerId !==undefined){
      arr.push(this.playerId);
    }
    if(this.connectRetryCount !==undefined){
      arr.push(this.connectRetryCount);
    }
    if(this.connectRetryInterval !==undefined){
      arr.push(this.connectRetryInterval);
    }
    if(this.timeout !==undefined){
      arr.push(this.timeout);
    }
    if(this.playerType !==undefined){
      arr.push(this.playerType);
    }
    if(this.headers !==undefined){
      arr.push(this.headers);
    }
    if(this.enableAccurateSeek !==undefined){
      arr.push(this.enableAccurateSeek);
    }
    if(this.autoRotate !==undefined){
      arr.push(this.autoRotate);
    }
    if(this.smoothSwitchBitrate !==undefined){
      arr.push(this.smoothSwitchBitrate);
    }
    if(this.cacheMp4ExtName !==undefined){
      arr.push(this.cacheMp4ExtName);
    }
    if(this.progressInterval !==undefined){
      arr.push(this.progressInterval);
    }
    if(this.maxBufferSize !==undefined){
      arr.push(this.maxBufferSize);
    }
    if(this.maxPreloadSize !==undefined){
      arr.push(this.maxPreloadSize);
    }
    if(this.firstStartPlayBufferTime !==undefined){
      arr.push(this.firstStartPlayBufferTime);
    }
    if(this.nextStartPlayBufferTime !==undefined){
      arr.push(this.nextStartPlayBufferTime);
    }
    if(this.overlayKey !==undefined){
      arr.push(this.overlayKey);
    }
    if(this.overlayIv !==undefined){
      arr.push(this.overlayIv);
    }
    if(this.extInfoMap !==undefined){
      arr.push(this.extInfoMap);
    }
    if(this.enableRenderProcess !==undefined){
      arr.push(this.enableRenderProcess);
    }
    if(this.preferredResolution !==undefined){
      arr.push(this.preferredResolution);
    }
    if(this.mediaType !==undefined){
      arr.push(this.mediaType);
    }
    if(this.encryptedMp4Level !==undefined){
      arr.push(this.encryptedMp4Level);
    }
    if(this.preferAudioTrack !==undefined){
      arr.push(this.preferAudioTrack);
    }
    return arr;
  }

  static fromList(arr: Object[]): FTXVodPlayConfigPlayerMsg {
    let pigeonResult: FTXVodPlayConfigPlayerMsg = new FTXVodPlayConfigPlayerMsg();
    let playerId: Object = arr[0];
    pigeonResult.setPlayerId(playerId as number);
    let connectRetryCount: Object = arr[1];
    pigeonResult.setConnectRetryCount(connectRetryCount as number);
    let connectRetryInterval: Object = arr[2];
    pigeonResult.setConnectRetryInterval(connectRetryInterval as number);
    let timeout: Object = arr[3];
    pigeonResult.setTimeout(timeout as number);
    let playerType: Object = arr[4];
    pigeonResult.setPlayerType(playerType as number);
    let headers: Object = arr[5];
    pigeonResult.setHeaders(headers as Map<string, string>);
    let enableAccurateSeek: Object = arr[6];
    pigeonResult.setEnableAccurateSeek(enableAccurateSeek as boolean);
    let autoRotate: Object = arr[7];
    pigeonResult.setAutoRotate(autoRotate as boolean);
    let smoothSwitchBitrate: Object = arr[8];
    pigeonResult.setSmoothSwitchBitrate(smoothSwitchBitrate as boolean);
    let cacheMp4ExtName: Object = arr[9];
    pigeonResult.setCacheMp4ExtName(cacheMp4ExtName as string);
    let progressInterval: Object = arr[10];
    pigeonResult.setProgressInterval(progressInterval as number);
    let maxBufferSize: Object = arr[11];
    pigeonResult.setMaxBufferSize(maxBufferSize as number);
    let maxPreloadSize: Object = arr[12];
    pigeonResult.setMaxPreloadSize(maxPreloadSize as number);
    let firstStartPlayBufferTime: Object = arr[13];
    pigeonResult.setFirstStartPlayBufferTime(firstStartPlayBufferTime as number);
    let nextStartPlayBufferTime: Object = arr[14];
    pigeonResult.setNextStartPlayBufferTime(nextStartPlayBufferTime as number);
    let overlayKey: Object = arr[15];
    pigeonResult.setOverlayKey(overlayKey as string);
    let overlayIv: Object = arr[16];
    pigeonResult.setOverlayIv(overlayIv as string);
    let extInfoMap: Object = arr[17];
    pigeonResult.setExtInfoMap(extInfoMap as Map<string, Object>);
    let enableRenderProcess: Object = arr[18];
    pigeonResult.setEnableRenderProcess(enableRenderProcess as boolean);
    let preferredResolution: Object = arr[19];
    pigeonResult.setPreferredResolution(preferredResolution as number);
    let mediaType: Object = arr[20];
    pigeonResult.setMediaType(mediaType as number);
    let encryptedMp4Level: Object = arr[21];
    pigeonResult.setEncryptedMp4Level(encryptedMp4Level as number);
    let preferAudioTrack: Object = arr[22];
    pigeonResult.setPreferAudioTrack(preferAudioTrack as string);
    return pigeonResult;
  }
}

/* Generated class from Pigeon that represents data sent in messages.*/
export class FTXLivePlayConfigPlayerMsg {
  private playerId?: number;

  public setPlayerId(playerId:number):void {
    this.playerId = playerId;
  }

  getPlayerId(): number | undefined{
    return this.playerId;
  }

  private cacheTime?: number;

  public setCacheTime(cacheTime:number):void {
    this.cacheTime = cacheTime;
  }

  getCacheTime(): number | undefined{
    return this.cacheTime;
  }

  private maxAutoAdjustCacheTime?: number;

  public setMaxAutoAdjustCacheTime(maxAutoAdjustCacheTime:number):void {
    this.maxAutoAdjustCacheTime = maxAutoAdjustCacheTime;
  }

  getMaxAutoAdjustCacheTime(): number | undefined{
    return this.maxAutoAdjustCacheTime;
  }

  private minAutoAdjustCacheTime?: number;

  public setMinAutoAdjustCacheTime(minAutoAdjustCacheTime:number):void {
    this.minAutoAdjustCacheTime = minAutoAdjustCacheTime;
  }

  getMinAutoAdjustCacheTime(): number | undefined{
    return this.minAutoAdjustCacheTime;
  }

  private videoBlockThreshold?: number;

  public setVideoBlockThreshold(videoBlockThreshold:number):void {
    this.videoBlockThreshold = videoBlockThreshold;
  }

  getVideoBlockThreshold(): number | undefined{
    return this.videoBlockThreshold;
  }

  private connectRetryCount?: number;

  public setConnectRetryCount(connectRetryCount:number):void {
    this.connectRetryCount = connectRetryCount;
  }

  getConnectRetryCount(): number | undefined{
    return this.connectRetryCount;
  }

  private connectRetryInterval?: number;

  public setConnectRetryInterval(connectRetryInterval:number):void {
    this.connectRetryInterval = connectRetryInterval;
  }

  getConnectRetryInterval(): number | undefined{
    return this.connectRetryInterval;
  }

  private autoAdjustCacheTime?: boolean;

  public setAutoAdjustCacheTime(autoAdjustCacheTime:boolean):void {
    this.autoAdjustCacheTime = autoAdjustCacheTime;
  }

  getAutoAdjustCacheTime(): boolean | undefined{
    return this.autoAdjustCacheTime;
  }

  private enableAec?: boolean;

  public setEnableAec(enableAec:boolean):void {
    this.enableAec = enableAec;
  }

  getEnableAec(): boolean | undefined{
    return this.enableAec;
  }

  private enableMessage?: boolean;

  public setEnableMessage(enableMessage:boolean):void {
    this.enableMessage = enableMessage;
  }

  getEnableMessage(): boolean | undefined{
    return this.enableMessage;
  }

  private enableMetaData?: boolean;

  public setEnableMetaData(enableMetaData:boolean):void {
    this.enableMetaData = enableMetaData;
  }

  getEnableMetaData(): boolean | undefined{
    return this.enableMetaData;
  }

  private flvSessionKey?: string;

  public setFlvSessionKey(flvSessionKey:string):void {
    this.flvSessionKey = flvSessionKey;
  }

  getFlvSessionKey(): string | undefined{
    return this.flvSessionKey;
  }

  constructor(playerId?: number, cacheTime?: number, maxAutoAdjustCacheTime?: number, minAutoAdjustCacheTime?: number, videoBlockThreshold?: number, connectRetryCount?: number, connectRetryInterval?: number, autoAdjustCacheTime?: boolean, enableAec?: boolean, enableMessage?: boolean, enableMetaData?: boolean, flvSessionKey?: string) {
    this.playerId = playerId;
    this.cacheTime = cacheTime;
    this.maxAutoAdjustCacheTime = maxAutoAdjustCacheTime;
    this.minAutoAdjustCacheTime = minAutoAdjustCacheTime;
    this.videoBlockThreshold = videoBlockThreshold;
    this.connectRetryCount = connectRetryCount;
    this.connectRetryInterval = connectRetryInterval;
    this.autoAdjustCacheTime = autoAdjustCacheTime;
    this.enableAec = enableAec;
    this.enableMessage = enableMessage;
    this.enableMetaData = enableMetaData;
    this.flvSessionKey = flvSessionKey;
  }

  toList(): Object[] {
    let arr: Object[] = new Array();
    if(this.playerId !==undefined){
      arr.push(this.playerId);
    }
    if(this.cacheTime !==undefined){
      arr.push(this.cacheTime);
    }
    if(this.maxAutoAdjustCacheTime !==undefined){
      arr.push(this.maxAutoAdjustCacheTime);
    }
    if(this.minAutoAdjustCacheTime !==undefined){
      arr.push(this.minAutoAdjustCacheTime);
    }
    if(this.videoBlockThreshold !==undefined){
      arr.push(this.videoBlockThreshold);
    }
    if(this.connectRetryCount !==undefined){
      arr.push(this.connectRetryCount);
    }
    if(this.connectRetryInterval !==undefined){
      arr.push(this.connectRetryInterval);
    }
    if(this.autoAdjustCacheTime !==undefined){
      arr.push(this.autoAdjustCacheTime);
    }
    if(this.enableAec !==undefined){
      arr.push(this.enableAec);
    }
    if(this.enableMessage !==undefined){
      arr.push(this.enableMessage);
    }
    if(this.enableMetaData !==undefined){
      arr.push(this.enableMetaData);
    }
    if(this.flvSessionKey !==undefined){
      arr.push(this.flvSessionKey);
    }
    return arr;
  }

  static fromList(arr: Object[]): FTXLivePlayConfigPlayerMsg {
    let pigeonResult: FTXLivePlayConfigPlayerMsg = new FTXLivePlayConfigPlayerMsg();
    let playerId: Object = arr[0];
    pigeonResult.setPlayerId(playerId as number);
    let cacheTime: Object = arr[1];
    pigeonResult.setCacheTime(cacheTime as number);
    let maxAutoAdjustCacheTime: Object = arr[2];
    pigeonResult.setMaxAutoAdjustCacheTime(maxAutoAdjustCacheTime as number);
    let minAutoAdjustCacheTime: Object = arr[3];
    pigeonResult.setMinAutoAdjustCacheTime(minAutoAdjustCacheTime as number);
    let videoBlockThreshold: Object = arr[4];
    pigeonResult.setVideoBlockThreshold(videoBlockThreshold as number);
    let connectRetryCount: Object = arr[5];
    pigeonResult.setConnectRetryCount(connectRetryCount as number);
    let connectRetryInterval: Object = arr[6];
    pigeonResult.setConnectRetryInterval(connectRetryInterval as number);
    let autoAdjustCacheTime: Object = arr[7];
    pigeonResult.setAutoAdjustCacheTime(autoAdjustCacheTime as boolean);
    let enableAec: Object = arr[8];
    pigeonResult.setEnableAec(enableAec as boolean);
    let enableMessage: Object = arr[9];
    pigeonResult.setEnableMessage(enableMessage as boolean);
    let enableMetaData: Object = arr[10];
    pigeonResult.setEnableMetaData(enableMetaData as boolean);
    let flvSessionKey: Object = arr[11];
    pigeonResult.setFlvSessionKey(flvSessionKey as string);
    return pigeonResult;
  }
}

/* Generated class from Pigeon that represents data sent in messages.*/
export class TXVodDownloadMediaMsg {
  private playPath?: string;

  public setPlayPath(playPath:string):void {
    this.playPath = playPath;
  }

  getPlayPath(): string | undefined{
    return this.playPath;
  }

  private progress?: number;

  public setProgress(progress:number):void {
    this.progress = progress;
  }

  getProgress(): number | undefined{
    return this.progress;
  }

  private downloadState?: number;

  public setDownloadState(downloadState:number):void {
    this.downloadState = downloadState;
  }

  getDownloadState(): number | undefined{
    return this.downloadState;
  }

  private userName?: string;

  public setUserName(userName:string):void {
    this.userName = userName;
  }

  getUserName(): string | undefined{
    return this.userName;
  }

  private duration?: number;

  public setDuration(duration:number):void {
    this.duration = duration;
  }

  getDuration(): number | undefined{
    return this.duration;
  }

  private playableDuration?: number;

  public setPlayableDuration(playableDuration:number):void {
    this.playableDuration = playableDuration;
  }

  getPlayableDuration(): number | undefined{
    return this.playableDuration;
  }

  private size?: number;

  public setSize(size:number):void {
    this.size = size;
  }

  getSize(): number | undefined{
    return this.size;
  }

  private downloadSize?: number;

  public setDownloadSize(downloadSize:number):void {
    this.downloadSize = downloadSize;
  }

  getDownloadSize(): number | undefined{
    return this.downloadSize;
  }

  private url?: string;

  public setUrl(url:string):void {
    this.url = url;
  }

  getUrl(): string | undefined{
    return this.url;
  }

  private appId?: number;

  public setAppId(appId:number):void {
    this.appId = appId;
  }

  getAppId(): number | undefined{
    return this.appId;
  }

  private fileId?: string;

  public setFileId(fileId:string):void {
    this.fileId = fileId;
  }

  getFileId(): string | undefined{
    return this.fileId;
  }

  private pSign?: string;

  public setPSign(pSign:string):void {
    this.pSign = pSign;
  }

  getPSign(): string | undefined{
    return this.pSign;
  }

  private quality?: number;

  public setQuality(quality:number):void {
    this.quality = quality;
  }

  getQuality(): number | undefined{
    return this.quality;
  }

  private token?: string;

  public setToken(token:string):void {
    this.token = token;
  }

  getToken(): string | undefined{
    return this.token;
  }

  private speed?: number;

  public setSpeed(speed:number):void {
    this.speed = speed;
  }

  getSpeed(): number | undefined{
    return this.speed;
  }

  private isResourceBroken?: boolean;

  public setIsResourceBroken(isResourceBroken:boolean):void {
    this.isResourceBroken = isResourceBroken;
  }

  getIsResourceBroken(): boolean | undefined{
    return this.isResourceBroken;
  }

  constructor(playPath?: string, progress?: number, downloadState?: number, userName?: string, duration?: number, playableDuration?: number, size?: number, downloadSize?: number, url?: string, appId?: number, fileId?: string, pSign?: string, quality?: number, token?: string, speed?: number, isResourceBroken?: boolean) {
    this.playPath = playPath;
    this.progress = progress;
    this.downloadState = downloadState;
    this.userName = userName;
    this.duration = duration;
    this.playableDuration = playableDuration;
    this.size = size;
    this.downloadSize = downloadSize;
    this.url = url;
    this.appId = appId;
    this.fileId = fileId;
    this.pSign = pSign;
    this.quality = quality;
    this.token = token;
    this.speed = speed;
    this.isResourceBroken = isResourceBroken;
  }

  toList(): Object[] {
    let arr: Object[] = new Array();
    if(this.playPath !==undefined){
      arr.push(this.playPath);
    }
    if(this.progress !==undefined){
      arr.push(this.progress);
    }
    if(this.downloadState !==undefined){
      arr.push(this.downloadState);
    }
    if(this.userName !==undefined){
      arr.push(this.userName);
    }
    if(this.duration !==undefined){
      arr.push(this.duration);
    }
    if(this.playableDuration !==undefined){
      arr.push(this.playableDuration);
    }
    if(this.size !==undefined){
      arr.push(this.size);
    }
    if(this.downloadSize !==undefined){
      arr.push(this.downloadSize);
    }
    if(this.url !==undefined){
      arr.push(this.url);
    }
    if(this.appId !==undefined){
      arr.push(this.appId);
    }
    if(this.fileId !==undefined){
      arr.push(this.fileId);
    }
    if(this.pSign !==undefined){
      arr.push(this.pSign);
    }
    if(this.quality !==undefined){
      arr.push(this.quality);
    }
    if(this.token !==undefined){
      arr.push(this.token);
    }
    if(this.speed !==undefined){
      arr.push(this.speed);
    }
    if(this.isResourceBroken !==undefined){
      arr.push(this.isResourceBroken);
    }
    return arr;
  }

  static fromList(arr: Object[]): TXVodDownloadMediaMsg {
    let pigeonResult: TXVodDownloadMediaMsg = new TXVodDownloadMediaMsg();
    let playPath: Object = arr[0];
    pigeonResult.setPlayPath(playPath as string);
    let progress: Object = arr[1];
    pigeonResult.setProgress(progress as number);
    let downloadState: Object = arr[2];
    pigeonResult.setDownloadState(downloadState as number);
    let userName: Object = arr[3];
    pigeonResult.setUserName(userName as string);
    let duration: Object = arr[4];
    pigeonResult.setDuration(duration as number);
    let playableDuration: Object = arr[5];
    pigeonResult.setPlayableDuration(playableDuration as number);
    let size: Object = arr[6];
    pigeonResult.setSize(size as number);
    let downloadSize: Object = arr[7];
    pigeonResult.setDownloadSize(downloadSize as number);
    let url: Object = arr[8];
    pigeonResult.setUrl(url as string);
    let appId: Object = arr[9];
    pigeonResult.setAppId(appId as number);
    let fileId: Object = arr[10];
    pigeonResult.setFileId(fileId as string);
    let pSign: Object = arr[11];
    pigeonResult.setPSign(pSign as string);
    let quality: Object = arr[12];
    pigeonResult.setQuality(quality as number);
    let token: Object = arr[13];
    pigeonResult.setToken(token as string);
    let speed: Object = arr[14];
    pigeonResult.setSpeed(speed as number);
    let isResourceBroken: Object = arr[15];
    pigeonResult.setIsResourceBroken(isResourceBroken as boolean);
    return pigeonResult;
  }
}

/* Generated class from Pigeon that represents data sent in messages.*/
export class TXDownloadListMsg {
  private infoList?: Array<TXVodDownloadMediaMsg>;

  public setInfoList(infoList:Array<TXVodDownloadMediaMsg>):void {
    this.infoList = infoList;
  }

  getInfoList(): Array<TXVodDownloadMediaMsg> | undefined{
    return this.infoList;
  }

  constructor(infoList?: Array<TXVodDownloadMediaMsg>) {
    this.infoList = infoList;
  }

  toList(): Object[] {
    let arr: Object[] = new Array();
    if(this.infoList !==undefined){
      arr.push(this.infoList);
    }
    return arr;
  }

  static fromList(arr: Object[]): TXDownloadListMsg {
    let pigeonResult: TXDownloadListMsg = new TXDownloadListMsg();
    let infoList: Object = arr[0];
    pigeonResult.setInfoList(infoList as Array<TXVodDownloadMediaMsg>);
    return pigeonResult;
  }
}

/* Generated class from Pigeon that represents data sent in messages.*/
export class UInt8ListMsg {
  private value?: number[];

  public setValue(value:number[]):void {
    this.value = value;
  }

  getValue(): number[] | undefined{
    return this.value;
  }

  constructor(value?: number[]) {
    this.value = value;
  }

  toList(): Object[] {
    let arr: Object[] = new Array();
    if(this.value !==undefined){
      arr.push(this.value);
    }
    return arr;
  }

  static fromList(arr: Object[]): UInt8ListMsg {
    let pigeonResult: UInt8ListMsg = new UInt8ListMsg();
    let value: Object = arr[0];
    pigeonResult.setValue(value as number[]);
    return pigeonResult;
  }
}

/* Generated class from Pigeon that represents data sent in messages.*/
export class ListMsg {
  private value?: Array<Object>;

  public setValue(value:Array<Object>):void {
    this.value = value;
  }

  getValue(): Array<Object> | undefined{
    return this.value;
  }

  constructor(value?: Array<Object>) {
    this.value = value;
  }

  toList(): Object[] {
    let arr: Object[] = new Array();
    if(this.value !==undefined){
      arr.push(this.value);
    }
    return arr;
  }

  static fromList(arr: Object[]): ListMsg {
    let pigeonResult: ListMsg = new ListMsg();
    let value: Object = arr[0];
    pigeonResult.setValue(value as Array<Object>);
    return pigeonResult;
  }
}

/* Generated class from Pigeon that represents data sent in messages.*/
export class BoolMsg {
  private value?: boolean;

  public setValue(value:boolean):void {
    this.value = value;
  }

  getValue(): boolean | undefined{
    return this.value;
  }

  constructor(value?: boolean) {
    this.value = value;
  }

  toList(): Object[] {
    let arr: Object[] = new Array();
    if(this.value !==undefined){
      arr.push(this.value);
    }
    return arr;
  }

  static fromList(arr: Object[]): BoolMsg {
    let pigeonResult: BoolMsg = new BoolMsg();
    let value: Object = arr[0];
    pigeonResult.setValue(value as boolean);
    return pigeonResult;
  }
}

/* Generated class from Pigeon that represents data sent in messages.*/
export class IntMsg {
  private value?: number;

  public setValue(value:number):void {
    this.value = value;
  }

  getValue(): number | undefined{
    return this.value;
  }

  constructor(value?: number) {
    this.value = value;
  }

  toList(): Object[] {
    let arr: Object[] = new Array();
    if(this.value !==undefined){
      arr.push(this.value);
    }
    return arr;
  }

  static fromList(arr: Object[]): IntMsg {
    let pigeonResult: IntMsg = new IntMsg();
    let value: Object = arr[0];
    pigeonResult.setValue(value as number);
    return pigeonResult;
  }
}

/* Generated class from Pigeon that represents data sent in messages.*/
export class StringMsg {
  private value?: string;

  public setValue(value:string):void {
    this.value = value;
  }

  getValue(): string | undefined{
    return this.value;
  }

  constructor(value?: string) {
    this.value = value;
  }

  toList(): Object[] {
    let arr: Object[] = new Array();
    if(this.value !==undefined){
      arr.push(this.value);
    }
    return arr;
  }

  static fromList(arr: Object[]): StringMsg {
    let pigeonResult: StringMsg = new StringMsg();
    let value: Object = arr[0];
    pigeonResult.setValue(value as string);
    return pigeonResult;
  }
}

/* Generated class from Pigeon that represents data sent in messages.*/
export class CachePathMsg {
  private androidAbsolutePath?: string;

  public setAndroidAbsolutePath(androidAbsolutePath:string):void {
    this.androidAbsolutePath = androidAbsolutePath;
  }

  getAndroidAbsolutePath(): string | undefined{
    return this.androidAbsolutePath;
  }

  private iOSAbsolutePath?: string;

  public setIOSAbsolutePath(iOSAbsolutePath:string):void {
    this.iOSAbsolutePath = iOSAbsolutePath;
  }

  getIOSAbsolutePath(): string | undefined{
    return this.iOSAbsolutePath;
  }

  constructor(androidAbsolutePath?: string, iOSAbsolutePath?: string) {
    this.androidAbsolutePath = androidAbsolutePath;
    this.iOSAbsolutePath = iOSAbsolutePath;
  }

  toList(): Object[] {
    let arr: Object[] = new Array();
    if(this.androidAbsolutePath !==undefined){
      arr.push(this.androidAbsolutePath);
    }
    if(this.iOSAbsolutePath !==undefined){
      arr.push(this.iOSAbsolutePath);
    }
    return arr;
  }

  static fromList(arr: Object[]): CachePathMsg {
    let pigeonResult: CachePathMsg = new CachePathMsg();
    let androidAbsolutePath: Object = arr[0];
    pigeonResult.setAndroidAbsolutePath(androidAbsolutePath as string);
    let iOSAbsolutePath: Object = arr[1];
    pigeonResult.setIOSAbsolutePath(iOSAbsolutePath as string);
    return pigeonResult;
  }
}

/* Generated class from Pigeon that represents data sent in messages.*/
export class DoubleMsg {
  private value?: number;

  public setValue(value:number):void {
    this.value = value;
  }

  getValue(): number | undefined{
    return this.value;
  }

  constructor(value?: number) {
    this.value = value;
  }

  toList(): Object[] {
    let arr: Object[] = new Array();
    if(this.value !==undefined){
      arr.push(this.value);
    }
    return arr;
  }

  static fromList(arr: Object[]): DoubleMsg {
    let pigeonResult: DoubleMsg = new DoubleMsg();
    let value: Object = arr[0];
    pigeonResult.setValue(value as number);
    return pigeonResult;
  }
}

/* Generated class from Pigeon that represents data sent in messages.*/
export class PreLoadMsg {
  private playUrl?: string;

  public setPlayUrl(playUrl:string):void {
    this.playUrl = playUrl;
  }

  getPlayUrl(): string | undefined{
    return this.playUrl;
  }

  private preloadSizeMB?: number;

  public setPreloadSizeMB(preloadSizeMB:number):void {
    this.preloadSizeMB = preloadSizeMB;
  }

  getPreloadSizeMB(): number | undefined{
    return this.preloadSizeMB;
  }

  private preferredResolution?: number;

  public setPreferredResolution(preferredResolution:number):void {
    this.preferredResolution = preferredResolution;
  }

  getPreferredResolution(): number | undefined{
    return this.preferredResolution;
  }

  constructor(playUrl?: string, preloadSizeMB?: number, preferredResolution?: number) {
    this.playUrl = playUrl;
    this.preloadSizeMB = preloadSizeMB;
    this.preferredResolution = preferredResolution;
  }

  toList(): Object[] {
    let arr: Object[] = new Array();
    if(this.playUrl !==undefined){
      arr.push(this.playUrl);
    }
    if(this.preloadSizeMB !==undefined){
      arr.push(this.preloadSizeMB);
    }
    if(this.preferredResolution !==undefined){
      arr.push(this.preferredResolution);
    }
    return arr;
  }

  static fromList(arr: Object[]): PreLoadMsg {
    let pigeonResult: PreLoadMsg = new PreLoadMsg();
    let playUrl: Object = arr[0];
    pigeonResult.setPlayUrl(playUrl as string);
    let preloadSizeMB: Object = arr[1];
    pigeonResult.setPreloadSizeMB(preloadSizeMB as number);
    let preferredResolution: Object = arr[2];
    pigeonResult.setPreferredResolution(preferredResolution as number);
    return pigeonResult;
  }
}

/* Generated class from Pigeon that represents data sent in messages.*/
export class PreLoadInfoMsg {
  private appId?: number;

  public setAppId(appId:number):void {
    this.appId = appId;
  }

  getAppId(): number | undefined{
    return this.appId;
  }

  private fileId?: string;

  public setFileId(fileId:string):void {
    this.fileId = fileId;
  }

  getFileId(): string | undefined{
    return this.fileId;
  }

  private pSign?: string;

  public setPSign(pSign:string):void {
    this.pSign = pSign;
  }

  getPSign(): string | undefined{
    return this.pSign;
  }

  private playUrl?: string;

  public setPlayUrl(playUrl:string):void {
    this.playUrl = playUrl;
  }

  getPlayUrl(): string | undefined{
    return this.playUrl;
  }

  private preloadSizeMB?: number;

  public setPreloadSizeMB(preloadSizeMB:number):void {
    this.preloadSizeMB = preloadSizeMB;
  }

  getPreloadSizeMB(): number | undefined{
    return this.preloadSizeMB;
  }

  private preferredResolution?: number;

  public setPreferredResolution(preferredResolution:number):void {
    this.preferredResolution = preferredResolution;
  }

  getPreferredResolution(): number | undefined{
    return this.preferredResolution;
  }

  private tmpPreloadTaskId?: number;

  public setTmpPreloadTaskId(tmpPreloadTaskId:number):void {
    this.tmpPreloadTaskId = tmpPreloadTaskId;
  }

  getTmpPreloadTaskId(): number | undefined{
    return this.tmpPreloadTaskId;
  }

  private httpHeader?: Map<string, string>;

  public setHttpHeader(httpHeader:Map<string, string>):void {
    this.httpHeader = httpHeader;
  }

  getHttpHeader(): Map<string, string> | undefined{
    return this.httpHeader;
  }

  constructor(appId?: number, fileId?: string, pSign?: string, playUrl?: string, preloadSizeMB?: number, preferredResolution?: number, tmpPreloadTaskId?: number, httpHeader?: Map<string, string>) {
    this.appId = appId;
    this.fileId = fileId;
    this.pSign = pSign;
    this.playUrl = playUrl;
    this.preloadSizeMB = preloadSizeMB;
    this.preferredResolution = preferredResolution;
    this.tmpPreloadTaskId = tmpPreloadTaskId;
    this.httpHeader = httpHeader;
  }

  toList(): Object[] {
    let arr: Object[] = new Array();
    if(this.appId !==undefined){
      arr.push(this.appId);
    }
    if(this.fileId !==undefined){
      arr.push(this.fileId);
    }
    if(this.pSign !==undefined){
      arr.push(this.pSign);
    }
    if(this.playUrl !==undefined){
      arr.push(this.playUrl);
    }
    if(this.preloadSizeMB !==undefined){
      arr.push(this.preloadSizeMB);
    }
    if(this.preferredResolution !==undefined){
      arr.push(this.preferredResolution);
    }
    if(this.tmpPreloadTaskId !==undefined){
      arr.push(this.tmpPreloadTaskId);
    }
    if(this.httpHeader !==undefined){
      arr.push(this.httpHeader);
    }
    return arr;
  }

  static fromList(arr: Object[]): PreLoadInfoMsg {
    let pigeonResult: PreLoadInfoMsg = new PreLoadInfoMsg();
    let appId: Object = arr[0];
    pigeonResult.setAppId(appId as number);
    let fileId: Object = arr[1];
    pigeonResult.setFileId(fileId as string);
    let pSign: Object = arr[2];
    pigeonResult.setPSign(pSign as string);
    let playUrl: Object = arr[3];
    pigeonResult.setPlayUrl(playUrl as string);
    let preloadSizeMB: Object = arr[4];
    pigeonResult.setPreloadSizeMB(preloadSizeMB as number);
    let preferredResolution: Object = arr[5];
    pigeonResult.setPreferredResolution(preferredResolution as number);
    let tmpPreloadTaskId: Object = arr[6];
    pigeonResult.setTmpPreloadTaskId(tmpPreloadTaskId as number);
    let httpHeader: Object = arr[7];
    pigeonResult.setHttpHeader(httpHeader as Map<string, string>);
    return pigeonResult;
  }
}

/* Generated class from Pigeon that represents data sent in messages.*/
export class MapMsg {
  private map?: Map<string, string>;

  public setMap(map:Map<string, string>):void {
    this.map = map;
  }

  getMap(): Map<string, string> | undefined{
    return this.map;
  }

  constructor(map?: Map<string, string>) {
    this.map = map;
  }

  toList(): Object[] {
    let arr: Object[] = new Array();
    if(this.map !==undefined){
      arr.push(this.map);
    }
    return arr;
  }

  static fromList(arr: Object[]): MapMsg {
    let pigeonResult: MapMsg = new MapMsg();
    let map: Object = arr[0];
    pigeonResult.setMap(map as Map<string, string>);
    return pigeonResult;
  }
}

/* Generated class from Pigeon that represents data sent in messages.*/
export class SubTitlePlayerMsg {
  private url?: string;

  public setUrl(url:string):void {
    this.url = url;
  }

  getUrl(): string | undefined{
    return this.url;
  }

  private name?: string;

  public setName(name:string):void {
    this.name = name;
  }

  getName(): string | undefined{
    return this.name;
  }

  private mimeType?: string;

  public setMimeType(mimeType:string):void {
    this.mimeType = mimeType;
  }

  getMimeType(): string | undefined{
    return this.mimeType;
  }

  private playerId?: number;

  public setPlayerId(playerId:number):void {
    this.playerId = playerId;
  }

  getPlayerId(): number | undefined{
    return this.playerId;
  }

  constructor(url?: string, name?: string, mimeType?: string, playerId?: number) {
    this.url = url;
    this.name = name;
    this.mimeType = mimeType;
    this.playerId = playerId;
  }

  toList(): Object[] {
    let arr: Object[] = new Array();
    if(this.url !==undefined){
      arr.push(this.url);
    }
    if(this.name !==undefined){
      arr.push(this.name);
    }
    if(this.mimeType !==undefined){
      arr.push(this.mimeType);
    }
    if(this.playerId !==undefined){
      arr.push(this.playerId);
    }
    return arr;
  }

  static fromList(arr: Object[]): SubTitlePlayerMsg {
    let pigeonResult: SubTitlePlayerMsg = new SubTitlePlayerMsg();
    let url: Object = arr[0];
    pigeonResult.setUrl(url as string);
    let name: Object = arr[1];
    pigeonResult.setName(name as string);
    let mimeType: Object = arr[2];
    pigeonResult.setMimeType(mimeType as string);
    let playerId: Object = arr[3];
    pigeonResult.setPlayerId(playerId as number);
    return pigeonResult;
  }
}

/* Generated class from Pigeon that represents data sent in messages.*/
export class SubTitleRenderModelPlayerMsg {
  private canvasWidth?: number;

  public setCanvasWidth(canvasWidth:number):void {
    this.canvasWidth = canvasWidth;
  }

  getCanvasWidth(): number | undefined{
    return this.canvasWidth;
  }

  private canvasHeight?: number;

  public setCanvasHeight(canvasHeight:number):void {
    this.canvasHeight = canvasHeight;
  }

  getCanvasHeight(): number | undefined{
    return this.canvasHeight;
  }

  private familyName?: string;

  public setFamilyName(familyName:string):void {
    this.familyName = familyName;
  }

  getFamilyName(): string | undefined{
    return this.familyName;
  }

  private fontSize?: number;

  public setFontSize(fontSize:number):void {
    this.fontSize = fontSize;
  }

  getFontSize(): number | undefined{
    return this.fontSize;
  }

  private fontScale?: number;

  public setFontScale(fontScale:number):void {
    this.fontScale = fontScale;
  }

  getFontScale(): number | undefined{
    return this.fontScale;
  }

  private fontColor?: number;

  public setFontColor(fontColor:number):void {
    this.fontColor = fontColor;
  }

  getFontColor(): number | undefined{
    return this.fontColor;
  }

  private isBondFontStyle?: boolean;

  public setIsBondFontStyle(isBondFontStyle:boolean):void {
    this.isBondFontStyle = isBondFontStyle;
  }

  getIsBondFontStyle(): boolean | undefined{
    return this.isBondFontStyle;
  }

  private outlineWidth?: number;

  public setOutlineWidth(outlineWidth:number):void {
    this.outlineWidth = outlineWidth;
  }

  getOutlineWidth(): number | undefined{
    return this.outlineWidth;
  }

  private outlineColor?: number;

  public setOutlineColor(outlineColor:number):void {
    this.outlineColor = outlineColor;
  }

  getOutlineColor(): number | undefined{
    return this.outlineColor;
  }

  private lineSpace?: number;

  public setLineSpace(lineSpace:number):void {
    this.lineSpace = lineSpace;
  }

  getLineSpace(): number | undefined{
    return this.lineSpace;
  }

  private startMargin?: number;

  public setStartMargin(startMargin:number):void {
    this.startMargin = startMargin;
  }

  getStartMargin(): number | undefined{
    return this.startMargin;
  }

  private endMargin?: number;

  public setEndMargin(endMargin:number):void {
    this.endMargin = endMargin;
  }

  getEndMargin(): number | undefined{
    return this.endMargin;
  }

  private verticalMargin?: number;

  public setVerticalMargin(verticalMargin:number):void {
    this.verticalMargin = verticalMargin;
  }

  getVerticalMargin(): number | undefined{
    return this.verticalMargin;
  }

  private playerId?: number;

  public setPlayerId(playerId:number):void {
    this.playerId = playerId;
  }

  getPlayerId(): number | undefined{
    return this.playerId;
  }

  constructor(canvasWidth?: number, canvasHeight?: number, familyName?: string, fontSize?: number, fontScale?: number, fontColor?: number, isBondFontStyle?: boolean, outlineWidth?: number, outlineColor?: number, lineSpace?: number, startMargin?: number, endMargin?: number, verticalMargin?: number, playerId?: number) {
    this.canvasWidth = canvasWidth;
    this.canvasHeight = canvasHeight;
    this.familyName = familyName;
    this.fontSize = fontSize;
    this.fontScale = fontScale;
    this.fontColor = fontColor;
    this.isBondFontStyle = isBondFontStyle;
    this.outlineWidth = outlineWidth;
    this.outlineColor = outlineColor;
    this.lineSpace = lineSpace;
    this.startMargin = startMargin;
    this.endMargin = endMargin;
    this.verticalMargin = verticalMargin;
    this.playerId = playerId;
  }

  toList(): Object[] {
    let arr: Object[] = new Array();
    if(this.canvasWidth !==undefined){
      arr.push(this.canvasWidth);
    }
    if(this.canvasHeight !==undefined){
      arr.push(this.canvasHeight);
    }
    if(this.familyName !==undefined){
      arr.push(this.familyName);
    }
    if(this.fontSize !==undefined){
      arr.push(this.fontSize);
    }
    if(this.fontScale !==undefined){
      arr.push(this.fontScale);
    }
    if(this.fontColor !==undefined){
      arr.push(this.fontColor);
    }
    if(this.isBondFontStyle !==undefined){
      arr.push(this.isBondFontStyle);
    }
    if(this.outlineWidth !==undefined){
      arr.push(this.outlineWidth);
    }
    if(this.outlineColor !==undefined){
      arr.push(this.outlineColor);
    }
    if(this.lineSpace !==undefined){
      arr.push(this.lineSpace);
    }
    if(this.startMargin !==undefined){
      arr.push(this.startMargin);
    }
    if(this.endMargin !==undefined){
      arr.push(this.endMargin);
    }
    if(this.verticalMargin !==undefined){
      arr.push(this.verticalMargin);
    }
    if(this.playerId !==undefined){
      arr.push(this.playerId);
    }
    return arr;
  }

  static fromList(arr: Object[]): SubTitleRenderModelPlayerMsg {
    let pigeonResult: SubTitleRenderModelPlayerMsg = new SubTitleRenderModelPlayerMsg();
    let canvasWidth: Object = arr[0];
    pigeonResult.setCanvasWidth(canvasWidth as number);
    let canvasHeight: Object = arr[1];
    pigeonResult.setCanvasHeight(canvasHeight as number);
    let familyName: Object = arr[2];
    pigeonResult.setFamilyName(familyName as string);
    let fontSize: Object = arr[3];
    pigeonResult.setFontSize(fontSize as number);
    let fontScale: Object = arr[4];
    pigeonResult.setFontScale(fontScale as number);
    let fontColor: Object = arr[5];
    pigeonResult.setFontColor(fontColor as number);
    let isBondFontStyle: Object = arr[6];
    pigeonResult.setIsBondFontStyle(isBondFontStyle as boolean);
    let outlineWidth: Object = arr[7];
    pigeonResult.setOutlineWidth(outlineWidth as number);
    let outlineColor: Object = arr[8];
    pigeonResult.setOutlineColor(outlineColor as number);
    let lineSpace: Object = arr[9];
    pigeonResult.setLineSpace(lineSpace as number);
    let startMargin: Object = arr[10];
    pigeonResult.setStartMargin(startMargin as number);
    let endMargin: Object = arr[11];
    pigeonResult.setEndMargin(endMargin as number);
    let verticalMargin: Object = arr[12];
    pigeonResult.setVerticalMargin(verticalMargin as number);
    let playerId: Object = arr[13];
    pigeonResult.setPlayerId(playerId as number);
    return pigeonResult;
  }
}

/* Generated class from Pigeon that represents data sent in messages.*/
export class StringOptionPlayerMsg {
  private key?: string;

  public setKey(key:string):void {
    this.key = key;
  }

  getKey(): string | undefined{
    return this.key;
  }

  private value?: Array<Object>;

  public setValue(value:Array<Object>):void {
    this.value = value;
  }

  getValue(): Array<Object> | undefined{
    return this.value;
  }

  private playerId?: number;

  public setPlayerId(playerId:number):void {
    this.playerId = playerId;
  }

  getPlayerId(): number | undefined{
    return this.playerId;
  }

  constructor(key?: string, value?: Array<Object>, playerId?: number) {
    this.key = key;
    this.value = value;
    this.playerId = playerId;
  }

  toList(): Object[] {
    let arr: Object[] = new Array();
    if(this.key !==undefined){
      arr.push(this.key);
    }
    if(this.value !==undefined){
      arr.push(this.value);
    }
    if(this.playerId !==undefined){
      arr.push(this.playerId);
    }
    return arr;
  }

  static fromList(arr: Object[]): StringOptionPlayerMsg {
    let pigeonResult: StringOptionPlayerMsg = new StringOptionPlayerMsg();
    let key: Object = arr[0];
    pigeonResult.setKey(key as string);
    let value: Object = arr[1];
    pigeonResult.setValue(value as Array<Object>);
    let playerId: Object = arr[2];
    pigeonResult.setPlayerId(playerId as number);
    return pigeonResult;
  }
}

class PigeonCodec extends StandardMessageCodec {
  static readonly INSTANCE: PigeonCodec  = new PigeonCodec();

  getByte(n: number): number {
    let byteArray = new Uint8Array(1);
    byteArray[0] = n;
    return byteArray[0] as number;
  }
  private constructor() {
    super();
  }

  readValueOfType(type: number,  buffer: ByteBuffer): ESObject {
    switch (type) {
      case this.getByte(129):
        return PlayerMsg.fromList(super.readValue(buffer) as Object[]);
      case this.getByte(130):
        return LicenseMsg.fromList(super.readValue(buffer) as Object[]);
      case this.getByte(131):
        return TXPlayInfoParamsPlayerMsg.fromList(super.readValue(buffer) as Object[]);
      case this.getByte(132):
        return TXPlayerDrmMsg.fromList(super.readValue(buffer) as Object[]);
      case this.getByte(133):
        return PipParamsPlayerMsg.fromList(super.readValue(buffer) as Object[]);
      case this.getByte(134):
        return StringListPlayerMsg.fromList(super.readValue(buffer) as Object[]);
      case this.getByte(135):
        return BoolPlayerMsg.fromList(super.readValue(buffer) as Object[]);
      case this.getByte(136):
        return StringPlayerMsg.fromList(super.readValue(buffer) as Object[]);
      case this.getByte(137):
        return DoublePlayerMsg.fromList(super.readValue(buffer) as Object[]);
      case this.getByte(138):
        return IntPlayerMsg.fromList(super.readValue(buffer) as Object[]);
      case this.getByte(139):
        return FTXVodPlayConfigPlayerMsg.fromList(super.readValue(buffer) as Object[]);
      case this.getByte(140):
        return FTXLivePlayConfigPlayerMsg.fromList(super.readValue(buffer) as Object[]);
      case this.getByte(141):
        return TXVodDownloadMediaMsg.fromList(super.readValue(buffer) as Object[]);
      case this.getByte(142):
        return TXDownloadListMsg.fromList(super.readValue(buffer) as Object[]);
      case this.getByte(143):
        return UInt8ListMsg.fromList(super.readValue(buffer) as Object[]);
      case this.getByte(144):
        return ListMsg.fromList(super.readValue(buffer) as Object[]);
      case this.getByte(145):
        return BoolMsg.fromList(super.readValue(buffer) as Object[]);
      case this.getByte(146):
        return IntMsg.fromList(super.readValue(buffer) as Object[]);
      case this.getByte(147):
        return StringMsg.fromList(super.readValue(buffer) as Object[]);
      case this.getByte(148):
        return CachePathMsg.fromList(super.readValue(buffer) as Object[]);
      case this.getByte(149):
        return DoubleMsg.fromList(super.readValue(buffer) as Object[]);
      case this.getByte(150):
        return PreLoadMsg.fromList(super.readValue(buffer) as Object[]);
      case this.getByte(151):
        return PreLoadInfoMsg.fromList(super.readValue(buffer) as Object[]);
      case this.getByte(152):
        return MapMsg.fromList(super.readValue(buffer) as Object[]);
      case this.getByte(153):
        return SubTitlePlayerMsg.fromList(super.readValue(buffer) as Object[]);
      case this.getByte(154):
        return SubTitleRenderModelPlayerMsg.fromList(super.readValue(buffer) as Object[]);
      case this.getByte(155):
        return StringOptionPlayerMsg.fromList(super.readValue(buffer) as Object[]);
      default:
        return super.readValueOfType(type, buffer);
    }
  }

  writeValue(stream: ByteBuffer , value: ESObject): ESObject{
    if (value instanceof PlayerMsg) {
      stream.writeUint8(this.getByte(129));
      this.writeValue(stream, (value as PlayerMsg).toList());
    } else if (value instanceof LicenseMsg) {
      stream.writeUint8(this.getByte(130));
      this.writeValue(stream, (value as LicenseMsg).toList());
    } else if (value instanceof TXPlayInfoParamsPlayerMsg) {
      stream.writeUint8(this.getByte(131));
      this.writeValue(stream, (value as TXPlayInfoParamsPlayerMsg).toList());
    } else if (value instanceof TXPlayerDrmMsg) {
      stream.writeUint8(this.getByte(132));
      this.writeValue(stream, (value as TXPlayerDrmMsg).toList());
    } else if (value instanceof PipParamsPlayerMsg) {
      stream.writeUint8(this.getByte(133));
      this.writeValue(stream, (value as PipParamsPlayerMsg).toList());
    } else if (value instanceof StringListPlayerMsg) {
      stream.writeUint8(this.getByte(134));
      this.writeValue(stream, (value as StringListPlayerMsg).toList());
    } else if (value instanceof BoolPlayerMsg) {
      stream.writeUint8(this.getByte(135));
      this.writeValue(stream, (value as BoolPlayerMsg).toList());
    } else if (value instanceof StringPlayerMsg) {
      stream.writeUint8(this.getByte(136));
      this.writeValue(stream, (value as StringPlayerMsg).toList());
    } else if (value instanceof DoublePlayerMsg) {
      stream.writeUint8(this.getByte(137));
      this.writeValue(stream, (value as DoublePlayerMsg).toList());
    } else if (value instanceof IntPlayerMsg) {
      stream.writeUint8(this.getByte(138));
      this.writeValue(stream, (value as IntPlayerMsg).toList());
    } else if (value instanceof FTXVodPlayConfigPlayerMsg) {
      stream.writeUint8(this.getByte(139));
      this.writeValue(stream, (value as FTXVodPlayConfigPlayerMsg).toList());
    } else if (value instanceof FTXLivePlayConfigPlayerMsg) {
      stream.writeUint8(this.getByte(140));
      this.writeValue(stream, (value as FTXLivePlayConfigPlayerMsg).toList());
    } else if (value instanceof TXVodDownloadMediaMsg) {
      stream.writeUint8(this.getByte(141));
      this.writeValue(stream, (value as TXVodDownloadMediaMsg).toList());
    } else if (value instanceof TXDownloadListMsg) {
      stream.writeUint8(this.getByte(142));
      this.writeValue(stream, (value as TXDownloadListMsg).toList());
    } else if (value instanceof UInt8ListMsg) {
      stream.writeUint8(this.getByte(143));
      this.writeValue(stream, (value as UInt8ListMsg).toList());
    } else if (value instanceof ListMsg) {
      stream.writeUint8(this.getByte(144));
      this.writeValue(stream, (value as ListMsg).toList());
    } else if (value instanceof BoolMsg) {
      stream.writeUint8(this.getByte(145));
      this.writeValue(stream, (value as BoolMsg).toList());
    } else if (value instanceof IntMsg) {
      stream.writeUint8(this.getByte(146));
      this.writeValue(stream, (value as IntMsg).toList());
    } else if (value instanceof StringMsg) {
      stream.writeUint8(this.getByte(147));
      this.writeValue(stream, (value as StringMsg).toList());
    } else if (value instanceof CachePathMsg) {
      stream.writeUint8(this.getByte(148));
      this.writeValue(stream, (value as CachePathMsg).toList());
    } else if (value instanceof DoubleMsg) {
      stream.writeUint8(this.getByte(149));
      this.writeValue(stream, (value as DoubleMsg).toList());
    } else if (value instanceof PreLoadMsg) {
      stream.writeUint8(this.getByte(150));
      this.writeValue(stream, (value as PreLoadMsg).toList());
    } else if (value instanceof PreLoadInfoMsg) {
      stream.writeUint8(this.getByte(151));
      this.writeValue(stream, (value as PreLoadInfoMsg).toList());
    } else if (value instanceof MapMsg) {
      stream.writeUint8(this.getByte(152));
      this.writeValue(stream, (value as MapMsg).toList());
    } else if (value instanceof SubTitlePlayerMsg) {
      stream.writeUint8(this.getByte(153));
      this.writeValue(stream, (value as SubTitlePlayerMsg).toList());
    } else if (value instanceof SubTitleRenderModelPlayerMsg) {
      stream.writeUint8(this.getByte(154));
      this.writeValue(stream, (value as SubTitleRenderModelPlayerMsg).toList());
    } else if (value instanceof StringOptionPlayerMsg) {
      stream.writeUint8(this.getByte(155));
      this.writeValue(stream, (value as StringOptionPlayerMsg).toList());
    } else {
      super.writeValue(stream, value);
    }
  }
}


export interface Result<T> {
  success( result: T ): void;

  error( error: Error): void;
}
/* Generated abstract class from Pigeon that represents a handler of messages from Flutter.*/
export abstract class TXFlutterSuperPlayerPluginAPI {

  abstract getPlatformVersion(): StringMsg;
  /* 创建点播播放器*/
  abstract createVodPlayer(onlyAudio: boolean ): PlayerMsg;
  /* 创建直播播放器*/
  abstract createLivePlayer(onlyAudio: boolean ): PlayerMsg;
  /* 开关log输出*/
  abstract setConsoleEnabled(enabled: BoolMsg ): void;
  /* 释放播放器资源*/
  abstract releasePlayer(playerId: PlayerMsg ): void;
  /*
  *  设置播放引擎的最大缓存大小。设置后会根据设定值自动清理Cache目录的文件
  *  @param size 最大缓存大小（单位：MB)
  */
  abstract setGlobalMaxCacheSize(size: IntMsg ): void;
  /*
  *  在短视频播放场景中，视频文件的本地缓存是很刚需的一个特性，对于普通用户而言，一个已经看过的视频再次观看时，不应该再消耗一次流量。
  *   @格式支持：SDK 支持 HLS(m3u8) 和 MP4 两种常见点播格式的缓存功能。
  *   @开启时机：SDK 并不默认开启缓存功能，对于用户回看率不高的场景，也并不推荐您开启此功能。
  *   @开启方式：全局生效，在使用播放器开启。开启此功能需要配置两个参数：本地缓存目录及缓存大小。
  * 
  *  该缓存路径默认设置到app沙盒目录下，postfixPath只需要传递相对缓存目录即可，不需要传递整个绝对路径。
  *  e.g. postfixPath = 'testCache'
  *  Android 平台：视频将会缓存到sdcard的Android/data/your-pkg-name/files/testCache 目录。
  *  iOS 平台：视频将会缓存到沙盒的Documents/testCache 目录。
  *  @param postfixPath 缓存目录
  *  @return true 设置成功 false 设置失败
  */
  abstract setGlobalCacheFolderPath(postfixPath: StringMsg ): BoolMsg;
  /* 设置播放器资源缓存目录绝对路径，该方法会与 setGlobalCacheFolderPath(String postfixPath) 相互覆盖，调用其中一个即可*/
  abstract setGlobalCacheFolderCustomPath(cacheMsg: CachePathMsg ): BoolMsg;
  /* 设置全局license*/
  abstract setGlobalLicense(licenseMsg: LicenseMsg ): void;
  /* 设置log输出级别 [TXLogLevel]*/
  abstract setLogLevel(logLevel: IntMsg ): void;
  /* 获取依赖Native端的 LiteAVSDK 的版本*/
  abstract getLiteAVSDKVersion(): StringMsg;
  /*
  * 
  *  设置 liteav SDK 接入的环境。
  *  腾讯云在全球各地区部署的环境，按照各地区政策法规要求，需要接入不同地区接入点。
  * 
  *  @param envConfig 需要接入的环境，SDK 默认接入的环境是：默认正式环境。
  *  @return 0：成功；其他：错误
  *  @note 目标市场为中国大陆的客户请不要调用此接口，如果目标市场为海外用户，请通过技术支持联系我们，了解 env_config 的配置方法，以确保 App 遵守 GDPR 标准。
  * 
  */
  abstract setGlobalEnv(envConfig: StringMsg ): IntMsg;
  /*
  * 
  *  开始监听设备旋转方向，开启之后，如果设备自动旋转打开，播放器会自动根据当前设备方向来旋转视频方向。
  *  <h1>该接口目前只适用安卓端，IOS端会自动开启该能力</h1>
  *  在调用该接口前，请务必向用户告知隐私风险。
  *  如有需要，请确认是否有获取旋转sensor的权限。
  *  @return true : 开启成功
  *          false : 开启失败，如开启过早，还未等到上下文初始化、获取sensor失败等原因
  */
  abstract startVideoOrientationService(): BoolMsg;

  abstract setUserId(msg: StringMsg ): void;

  abstract setLicenseFlexibleValid(msg: BoolMsg ): void;

  abstract setDrmProvisionEnv(env: number ): void;
  /** The codec used by TXFlutterSuperPlayerPluginAPI. */
  static getCodec(): MessageCodec<Object>{
    return PigeonCodec.INSTANCE;
  }
  /*Sets up an instance of `TXFlutterSuperPlayerPluginAPI` to handle messages through the `binaryMessenger`.*/
  static setup(binaryMessenger: BinaryMessenger, api: TXFlutterSuperPlayerPluginAPI | null): void {
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterSuperPlayerPluginAPI.getPlatformVersion", TXFlutterSuperPlayerPluginAPI.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let res: Array<Object> = [];
              try {
                let output: StringMsg = api!.getPlatformVersion();
                res.push(output);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterSuperPlayerPluginAPI.createVodPlayer", TXFlutterSuperPlayerPluginAPI.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              let res: Array<Object> = [];
              try {
                let output: PlayerMsg = api!.createVodPlayer(args[0] as boolean);
                res.push(output);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterSuperPlayerPluginAPI.createLivePlayer", TXFlutterSuperPlayerPluginAPI.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              let res: Array<Object> = [];
              try {
                let output: PlayerMsg = api!.createLivePlayer(args[0] as boolean);
                res.push(output);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterSuperPlayerPluginAPI.setConsoleEnabled", TXFlutterSuperPlayerPluginAPI.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              let res: Array<Object> = [];
              try {
                api!.setConsoleEnabled(args[0] as BoolMsg);
                res.push(null);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterSuperPlayerPluginAPI.releasePlayer", TXFlutterSuperPlayerPluginAPI.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              let res: Array<Object> = [];
              try {
                api!.releasePlayer(args[0] as PlayerMsg);
                res.push(null);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterSuperPlayerPluginAPI.setGlobalMaxCacheSize", TXFlutterSuperPlayerPluginAPI.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              let res: Array<Object> = [];
              try {
                api!.setGlobalMaxCacheSize(args[0] as IntMsg);
                res.push(null);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterSuperPlayerPluginAPI.setGlobalCacheFolderPath", TXFlutterSuperPlayerPluginAPI.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              let res: Array<Object> = [];
              try {
                let output: BoolMsg = api!.setGlobalCacheFolderPath(args[0] as StringMsg);
                res.push(output);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterSuperPlayerPluginAPI.setGlobalCacheFolderCustomPath", TXFlutterSuperPlayerPluginAPI.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              let res: Array<Object> = [];
              try {
                let output: BoolMsg = api!.setGlobalCacheFolderCustomPath(args[0] as CachePathMsg);
                res.push(output);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterSuperPlayerPluginAPI.setGlobalLicense", TXFlutterSuperPlayerPluginAPI.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              let res: Array<Object> = [];
              try {
                api!.setGlobalLicense(args[0] as LicenseMsg);
                res.push(null);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterSuperPlayerPluginAPI.setLogLevel", TXFlutterSuperPlayerPluginAPI.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              let res: Array<Object> = [];
              try {
                api!.setLogLevel(args[0] as IntMsg);
                res.push(null);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterSuperPlayerPluginAPI.getLiteAVSDKVersion", TXFlutterSuperPlayerPluginAPI.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let res: Array<Object> = [];
              try {
                let output: StringMsg = api!.getLiteAVSDKVersion();
                res.push(output);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterSuperPlayerPluginAPI.setGlobalEnv", TXFlutterSuperPlayerPluginAPI.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              let res: Array<Object> = [];
              try {
                let output: IntMsg = api!.setGlobalEnv(args[0] as StringMsg);
                res.push(output);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterSuperPlayerPluginAPI.startVideoOrientationService", TXFlutterSuperPlayerPluginAPI.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let res: Array<Object> = [];
              try {
                let output: BoolMsg = api!.startVideoOrientationService();
                res.push(output);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterSuperPlayerPluginAPI.setUserId", TXFlutterSuperPlayerPluginAPI.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              let res: Array<Object> = [];
              try {
                api!.setUserId(args[0] as StringMsg);
                res.push(null);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterSuperPlayerPluginAPI.setLicenseFlexibleValid", TXFlutterSuperPlayerPluginAPI.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              let res: Array<Object> = [];
              try {
                api!.setLicenseFlexibleValid(args[0] as BoolMsg);
                res.push(null);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterSuperPlayerPluginAPI.setDrmProvisionEnv", TXFlutterSuperPlayerPluginAPI.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              let res: Array<Object> = [];
              try {
                api!.setDrmProvisionEnv(args[0] as number);
                res.push(null);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
  }
}
/* Generated abstract class from Pigeon that represents a handler of messages from Flutter.*/
export abstract class TXFlutterNativeAPI {
  /* 修改当前界面亮度*/
  abstract setBrightness(brightness: DoubleMsg ): void;
  /* 恢复当前界面亮度*/
  abstract restorePageBrightness(): void;
  /* 获得当前界面亮度 0.0 ~ 1.0*/
  abstract getBrightness(): DoubleMsg;
  /* 获取系统界面亮度，IOS系统与界面亮度一致，安卓可能会有差异*/
  abstract getSysBrightness(): DoubleMsg;
  /* 设置当前系统音量，0.0 ~ 1.0*/
  abstract setSystemVolume(volume: DoubleMsg ): void;
  /* 获得当前系统音量，范围：0.0 ~ 1.0*/
  abstract getSystemVolume(): DoubleMsg;
  /* 释放音频焦点，只用于安卓端*/
  abstract abandonAudioFocus(): void;
  /* 请求获得音频焦点，只用于安卓端*/
  abstract requestAudioFocus(): void;
  /*
  *  当前设备是否支持画中画模式
  *  @return [TXVodPlayEvent]
  *   0 可开启画中画模式
  *   -101  android版本过低
  *   -102  画中画权限关闭/设备不支持画中画
  *   -103  当前界面已销毁
  */
  abstract isDeviceSupportPip(): IntMsg;
  /*
  * 
  *  register or unregister system brightness
  * 
  */
  abstract registerSysBrightness(isRegister: BoolMsg ): void;
  /** The codec used by TXFlutterNativeAPI. */
  static getCodec(): MessageCodec<Object>{
    return PigeonCodec.INSTANCE;
  }
  /*Sets up an instance of `TXFlutterNativeAPI` to handle messages through the `binaryMessenger`.*/
  static setup(binaryMessenger: BinaryMessenger, api: TXFlutterNativeAPI | null): void {
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterNativeAPI.setBrightness", TXFlutterNativeAPI.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              let res: Array<Object> = [];
              try {
                api!.setBrightness(args[0] as DoubleMsg);
                res.push(null);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterNativeAPI.restorePageBrightness", TXFlutterNativeAPI.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let res: Array<Object> = [];
              try {
                api!.restorePageBrightness();
                res.push(null);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterNativeAPI.getBrightness", TXFlutterNativeAPI.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let res: Array<Object> = [];
              try {
                let output: DoubleMsg = api!.getBrightness();
                res.push(output);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterNativeAPI.getSysBrightness", TXFlutterNativeAPI.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let res: Array<Object> = [];
              try {
                let output: DoubleMsg = api!.getSysBrightness();
                res.push(output);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterNativeAPI.setSystemVolume", TXFlutterNativeAPI.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              let res: Array<Object> = [];
              try {
                api!.setSystemVolume(args[0] as DoubleMsg);
                res.push(null);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterNativeAPI.getSystemVolume", TXFlutterNativeAPI.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let res: Array<Object> = [];
              try {
                let output: DoubleMsg = api!.getSystemVolume();
                res.push(output);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterNativeAPI.abandonAudioFocus", TXFlutterNativeAPI.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let res: Array<Object> = [];
              try {
                api!.abandonAudioFocus();
                res.push(null);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterNativeAPI.requestAudioFocus", TXFlutterNativeAPI.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let res: Array<Object> = [];
              try {
                api!.requestAudioFocus();
                res.push(null);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterNativeAPI.isDeviceSupportPip", TXFlutterNativeAPI.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let res: Array<Object> = [];
              try {
                let output: IntMsg = api!.isDeviceSupportPip();
                res.push(output);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterNativeAPI.registerSysBrightness", TXFlutterNativeAPI.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              let res: Array<Object> = [];
              try {
                api!.registerSysBrightness(args[0] as BoolMsg);
                res.push(null);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
  }
}
/* Generated abstract class from Pigeon that represents a handler of messages from Flutter.*/
export abstract class TXFlutterVodPlayerApi {
  /*
  *  播放器初始化，创建共享纹理、初始化播放器
  * 
  *  To initialize the player, you would need to create a shared texture and initialize the player.
  *  @param onlyAudio 是否是纯音频模式 if pure audio mode
  */
  abstract initialize(onlyAudio: BoolPlayerMsg ): IntMsg;
  /*
  *  通过url开始播放视频
  *  10.7版本开始，startPlay变更为startVodPlay，需要通过 {@link SuperPlayerPlugin#setGlobalLicense} 设置 Licence 后方可成功播放，
  *  否则将播放失败（黑屏），全局仅设置一次即可。直播 Licence、短视频 Licence 和视频播放 Licence 均可使用，若您暂未获取上述 Licence ，
  *  可[快速免费申请测试版 Licence](https://cloud.tencent.com/act/event/License) 以正常播放，正式版 License 需[购买]
  *  (https://cloud.tencent.com/document/product/881/74588#.E8.B4.AD.E4.B9.B0.E5.B9.B6.E6.96.B0.E5.BB.BA.E6.AD.A3.E5.BC.8F.E7.89.88-license)。
  * 
  *  Starting from version 10.7, the method `startPlay` has been changed to `startVodPlay` for playing videos via a URL.
  *  To play videos successfully, it is necessary to set the license by using the method `SuperPlayerPlugin#setGlobalLicense`.
  *  Failure to set the license will result in video playback failure (a black screen).
  *  Live streaming, short video, and video playback licenses can all be used. If you do not have any of the above licenses,
  *  you can apply for a free trial license to play videos normally[Quickly apply for a free trial version Licence]
  *  (https://cloud.tencent.com/act/event/License).Official licenses can be purchased
  *  (https://cloud.tencent.com/document/product/881/74588#.E8.B4.AD.E4.B9.B0.E5.B9.B6.E6.96.B0.E5.BB.BA.E6.AD.A3.E5.BC.8F.E7.89.88-license).
  *  @param url : 视频播放地址 video playback address
  *  return 是否播放成功 if play successfully
  */
  abstract startVodPlay(url: StringPlayerMsg ): BoolMsg;
  /*
  *  通过fileId播放视频
  *  10.7版本开始，startPlayWithParams变更为startVodPlayWithParams，需要通过 {@link SuperPlayerPlugin#setGlobalLicense} 设置 Licence 后方可成功播放，
  *  否则将播放失败（黑屏），全局仅设置一次即可。直播 Licence、短视频 Licence 和视频播放 Licence 均可使用，若您暂未获取上述 Licence ，
  *  可[快速免费申请测试版 Licence](https://cloud.tencent.com/act/event/License) 以正常播放，正式版 License 需[购买]
  *  (https://cloud.tencent.com/document/product/881/74588#.E8.B4.AD.E4.B9.B0.E5.B9.B6.E6.96.B0.E5.BB.BA.E6.AD.A3.E5.BC.8F.E7.89.88-license)。
  * 
  *  Starting from version 10.7, the method "startPlayWithParams" has been changed to "startVodPlayWithParams" for playing videos using fileId.
  *  To play the video successfully, you need to set the Licence using "SuperPlayerPlugin#setGlobalLicense" method before playing the video.
  *  If you do not set the Licence, the video will not play (black screen). The Licence for live streaming,
  *  short video, and video playback can all be used. If you have not obtained the Licence, you can apply for a free trial version [here]
  *  (https://cloud.tencent.com/act/event/License) for normal playback. To use the official version, you need to [purchase]
  *  (https://cloud.tencent.com/document/product/881/74588#.E8.B4.AD.E4.B9.B0.E5.B9.B6.E6.96.B0.E5.BB.BA.E6.AD.A3.E5.BC.8F.E7.89.88-license).
  *  @params : see[TXPlayInfoParams]
  *  return 是否播放成功  if play successful
  */
  abstract startVodPlayWithParams(params: TXPlayInfoParamsPlayerMsg ): void;
  /*
  *  播放 DRM 加密视频
  * 
  *  Playing DRM-encrypted video.
  */
  abstract startPlayDrm(params: TXPlayerDrmMsg ): IntMsg;
  /*
  *  设置是否自动播放
  * 
  *  set autoplay
  */
  abstract setAutoPlay(isAutoPlay: BoolPlayerMsg ): void;
  /*
  *  停止播放
  * 
  *  Stop playback
  *  return 是否停止成功 if stop successful
  */
  abstract stop(isNeedClear: BoolPlayerMsg ): BoolMsg;
  /*
  *  视频是否处于正在播放中
  * 
  *  Is the video currently playing
  */
  abstract isPlaying(playerMsg: PlayerMsg ): BoolMsg;
  /*
  *  视频暂停，必须在播放器开始播放的时候调用
  * 
  *  pause video, it must be called when the player starts playing
  */
  abstract pause(playerMsg: PlayerMsg ): void;
  /*
  *  继续播放，在暂停的时候调用
  * 
  *  resume playback, it should be called when the video is paused
  */
  abstract resume(playerMsg: PlayerMsg ): void;
  /*
  *  设置是否静音
  * 
  *  Set whether to mute or not
  */
  abstract setMute(mute: BoolPlayerMsg ): void;
  /*
  *  设置是否循环播放
  * 
  *  Set whether to loop playback or not
  */
  abstract setLoop(loop: BoolPlayerMsg ): void;
  /*
  *  将视频播放进度定位到指定的进度进行播放
  * 
  *  Set the video playback progress to a specific time and start playing.
  *  progress 要定位的视频时间，单位 秒 The video playback time to be located, in seconds
  */
  abstract seek(progress: DoublePlayerMsg ): void;
  /*
  *  跳转到视频流指定PDT时间点, 可实现视频快进,快退,进度条跳转等功能
  *  单位毫秒(ms)
  *  播放器高级版 11.6 版本开始支持
  * 
  *  Jump to the specified PDT time point of the video stream, which can realize video fast forward, fast rewind, progress bar jump and other functions.
  *  Unit millisecond (ms)
  *  Player Premium version 11.6 starts to support
  */
  abstract seekToPdtTime(pdtTimeMs: IntPlayerMsg ): void;
  /*
  *  设置播放速率，默认速率 1
  * 
  *  Set the playback speed, with a default speed of 1.
  */
  abstract setRate(rate: DoublePlayerMsg ): void;
  /*
  *  获得播放视频解析出来的码率信息
  * 
  *  get the bitrate information extracted from playing a video
  *  return List<Map>
  *  Bitrate：index 码率序号，
  *          width 码率对应视频宽度，
  *          height 码率对应视频高度,
  *          bitrate 码率值
  * 
  *  Bitrate：index:bitrate index，
  *          width:the video with of this bitrate，
  *          height:the video height of this bitrate,
  *          bitrate:bitrate value
  */
  abstract getSupportedBitrate(playerMsg: PlayerMsg ): ListMsg;
  /*
  *  获得当前设置的码率序号
  * 
  *  Get the index of the current bitrate setting
  */
  abstract getBitrateIndex(playerMsg: PlayerMsg ): IntMsg;
  /*
  *  设置码率序号
  * 
  *  Set the index of the bitrate setting.
  */
  abstract setBitrateIndex(index: IntPlayerMsg ): void;
  /*
  *  设置视频播放开始时间，单位 秒
  * 
  *  Set the start time of the video playback, in seconds.
  */
  abstract setStartTime(startTime: DoublePlayerMsg ): void;
  /*
  *  设置视频声音 0~100
  * 
  *  Set the volume of the video, ranging from 0 to 100.
  */
  abstract setAudioPlayOutVolume(volume: IntPlayerMsg ): void;
  /*
  *  请求获得音频焦点
  * 
  *  Request audio focus.
  */
  abstract setRequestAudioFocus(focus: BoolPlayerMsg ): BoolMsg;
  /*
  *  设置播放器配置
  * 
  *  Set player configuration
  *  config @see [FTXVodPlayConfig]
  */
  abstract setConfig(config: FTXVodPlayConfigPlayerMsg ): void;
  /*
  *  获得当前已经播放的时间，单位 秒
  * 
  *  Get the current playback time, in seconds.
  */
  abstract getCurrentPlaybackTime(playerMsg: PlayerMsg ): DoubleMsg;
  /*
  *  获得当前视频已缓存的时间
  * 
  *  Get the current amount of video that has been buffered.
  */
  abstract getBufferDuration(playerMsg: PlayerMsg ): DoubleMsg;
  /*
  *  获得当前视频的可播放时间
  * 
  *  Get the current playable duration of the video.
  */
  abstract getPlayableDuration(playerMsg: PlayerMsg ): DoubleMsg;
  /*
  *  获得当前播放视频的宽度
  * 
  *  Get the width of the currently playing video.
  */
  abstract getWidth(playerMsg: PlayerMsg ): IntMsg;
  /*
  *  获得当前播放视频的高度
  * 
  *  Get the height of the currently playing video.
  */
  abstract getHeight(playerMsg: PlayerMsg ): IntMsg;
  /*
  *  设置播放视频的token
  * 
  *  Set the token for playing the video.
  */
  abstract setToken(token: StringPlayerMsg ): void;
  /*
  *  当前播放的视频是否循环播放
  * 
  *  Is the currently playing video set to loop
  */
  abstract isLoop(playerMsg: PlayerMsg ): BoolMsg;
  /*
  *  开启/关闭硬件编码
  * 
  *  Enable/Disable hardware encoding.
  */
  abstract enableHardwareDecode(enable: BoolPlayerMsg ): BoolMsg;
  /*
  *  进入画中画模式，进入画中画模式，需要适配画中画模式的界面，安卓只支持7.0以上机型
  *  <h1>
  *  由于android系统限制，传递的图标大小不得超过1M，否则无法显示
  *  </h1>
  *  @param backIcon playIcon pauseIcon forwardIcon 为播放后退、播放、暂停、前进的图标，如果赋值的话，将会使用传递的图标，否则
  *  使用系统默认图标，只支持flutter本地资源图片，传递的时候，与flutter使用图片资源一致，例如： images/back_icon.png
  */
  abstract enterPictureInPictureMode(pipParamsMsg: PipParamsPlayerMsg ): IntMsg;
  /*
  *  退出画中画，如果该播放器处于画中画模式
  * 
  *  Exit picture-in-picture mode if the video player is in picture-in-picture mode.
  */
  abstract exitPictureInPictureMode(playerMsg: PlayerMsg ): void;

  abstract initImageSprite(spriteInfo: StringListPlayerMsg ): void;

  abstract getImageSprite(time: DoublePlayerMsg ): UInt8ListMsg;
  /*
  *  获取总时长
  * 
  *  To get the total duration
  */
  abstract getDuration(playerMsg: PlayerMsg ): DoubleMsg;

  abstract addSubtitleSource(playerMsg: SubTitlePlayerMsg ): void;

  abstract getSubtitleTrackInfo(playerMsg: PlayerMsg ): ListMsg;

  abstract getAudioTrackInfo(playerMsg: PlayerMsg ): ListMsg;

  abstract selectTrack(playerMsg: IntPlayerMsg ): void;

  abstract deselectTrack(playerMsg: IntPlayerMsg ): void;

  abstract setSubtitleStyle(playerMsg: SubTitleRenderModelPlayerMsg ): void;

  abstract setStringOption(playerMsg: StringOptionPlayerMsg ): void;

  abstract setPlayerView(renderViewId: number ): void;

  abstract setRenderMode(renderMode: number ): void;

  abstract reDraw(): void;

  abstract enableTRTC(isEnabled: boolean ): void;

  abstract publishVideo(): void;

  abstract unpublishVideo(): void;

  abstract publishAudio(): void;

  abstract unpublishAudio(): void;
  /** The codec used by TXFlutterVodPlayerApi. */
  static getCodec(): MessageCodec<Object>{
    return PigeonCodec.INSTANCE;
  }
  /*Sets up an instance of `TXFlutterVodPlayerApi` to handle messages through the `binaryMessenger`.*/
  static setup(binaryMessenger: BinaryMessenger, api: TXFlutterVodPlayerApi | null): void {
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterVodPlayerApi.initialize", TXFlutterVodPlayerApi.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              let res: Array<Object> = [];
              try {
                let output: IntMsg = api!.initialize(args[0] as BoolPlayerMsg);
                res.push(output);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterVodPlayerApi.startVodPlay", TXFlutterVodPlayerApi.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              let res: Array<Object> = [];
              try {
                let output: BoolMsg = api!.startVodPlay(args[0] as StringPlayerMsg);
                res.push(output);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterVodPlayerApi.startVodPlayWithParams", TXFlutterVodPlayerApi.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              let res: Array<Object> = [];
              try {
                api!.startVodPlayWithParams(args[0] as TXPlayInfoParamsPlayerMsg);
                res.push(null);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterVodPlayerApi.startPlayDrm", TXFlutterVodPlayerApi.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              let res: Array<Object> = [];
              try {
                let output: IntMsg = api!.startPlayDrm(args[0] as TXPlayerDrmMsg);
                res.push(output);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterVodPlayerApi.setAutoPlay", TXFlutterVodPlayerApi.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              let res: Array<Object> = [];
              try {
                api!.setAutoPlay(args[0] as BoolPlayerMsg);
                res.push(null);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterVodPlayerApi.stop", TXFlutterVodPlayerApi.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              let res: Array<Object> = [];
              try {
                let output: BoolMsg = api!.stop(args[0] as BoolPlayerMsg);
                res.push(output);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterVodPlayerApi.isPlaying", TXFlutterVodPlayerApi.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              let res: Array<Object> = [];
              try {
                let output: BoolMsg = api!.isPlaying(args[0] as PlayerMsg);
                res.push(output);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterVodPlayerApi.pause", TXFlutterVodPlayerApi.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              let res: Array<Object> = [];
              try {
                api!.pause(args[0] as PlayerMsg);
                res.push(null);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterVodPlayerApi.resume", TXFlutterVodPlayerApi.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              let res: Array<Object> = [];
              try {
                api!.resume(args[0] as PlayerMsg);
                res.push(null);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterVodPlayerApi.setMute", TXFlutterVodPlayerApi.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              let res: Array<Object> = [];
              try {
                api!.setMute(args[0] as BoolPlayerMsg);
                res.push(null);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterVodPlayerApi.setLoop", TXFlutterVodPlayerApi.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              let res: Array<Object> = [];
              try {
                api!.setLoop(args[0] as BoolPlayerMsg);
                res.push(null);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterVodPlayerApi.seek", TXFlutterVodPlayerApi.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              let res: Array<Object> = [];
              try {
                api!.seek(args[0] as DoublePlayerMsg);
                res.push(null);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterVodPlayerApi.seekToPdtTime", TXFlutterVodPlayerApi.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              let res: Array<Object> = [];
              try {
                api!.seekToPdtTime(args[0] as IntPlayerMsg);
                res.push(null);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterVodPlayerApi.setRate", TXFlutterVodPlayerApi.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              let res: Array<Object> = [];
              try {
                api!.setRate(args[0] as DoublePlayerMsg);
                res.push(null);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterVodPlayerApi.getSupportedBitrate", TXFlutterVodPlayerApi.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              let res: Array<Object> = [];
              try {
                let output: ListMsg = api!.getSupportedBitrate(args[0] as PlayerMsg);
                res.push(output);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterVodPlayerApi.getBitrateIndex", TXFlutterVodPlayerApi.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              let res: Array<Object> = [];
              try {
                let output: IntMsg = api!.getBitrateIndex(args[0] as PlayerMsg);
                res.push(output);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterVodPlayerApi.setBitrateIndex", TXFlutterVodPlayerApi.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              let res: Array<Object> = [];
              try {
                api!.setBitrateIndex(args[0] as IntPlayerMsg);
                res.push(null);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterVodPlayerApi.setStartTime", TXFlutterVodPlayerApi.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              let res: Array<Object> = [];
              try {
                api!.setStartTime(args[0] as DoublePlayerMsg);
                res.push(null);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterVodPlayerApi.setAudioPlayOutVolume", TXFlutterVodPlayerApi.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              let res: Array<Object> = [];
              try {
                api!.setAudioPlayOutVolume(args[0] as IntPlayerMsg);
                res.push(null);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterVodPlayerApi.setRequestAudioFocus", TXFlutterVodPlayerApi.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              let res: Array<Object> = [];
              try {
                let output: BoolMsg = api!.setRequestAudioFocus(args[0] as BoolPlayerMsg);
                res.push(output);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterVodPlayerApi.setConfig", TXFlutterVodPlayerApi.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              let res: Array<Object> = [];
              try {
                api!.setConfig(args[0] as FTXVodPlayConfigPlayerMsg);
                res.push(null);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterVodPlayerApi.getCurrentPlaybackTime", TXFlutterVodPlayerApi.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              let res: Array<Object> = [];
              try {
                let output: DoubleMsg = api!.getCurrentPlaybackTime(args[0] as PlayerMsg);
                res.push(output);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterVodPlayerApi.getBufferDuration", TXFlutterVodPlayerApi.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              let res: Array<Object> = [];
              try {
                let output: DoubleMsg = api!.getBufferDuration(args[0] as PlayerMsg);
                res.push(output);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterVodPlayerApi.getPlayableDuration", TXFlutterVodPlayerApi.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              let res: Array<Object> = [];
              try {
                let output: DoubleMsg = api!.getPlayableDuration(args[0] as PlayerMsg);
                res.push(output);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterVodPlayerApi.getWidth", TXFlutterVodPlayerApi.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              let res: Array<Object> = [];
              try {
                let output: IntMsg = api!.getWidth(args[0] as PlayerMsg);
                res.push(output);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterVodPlayerApi.getHeight", TXFlutterVodPlayerApi.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              let res: Array<Object> = [];
              try {
                let output: IntMsg = api!.getHeight(args[0] as PlayerMsg);
                res.push(output);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterVodPlayerApi.setToken", TXFlutterVodPlayerApi.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              let res: Array<Object> = [];
              try {
                api!.setToken(args[0] as StringPlayerMsg);
                res.push(null);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterVodPlayerApi.isLoop", TXFlutterVodPlayerApi.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              let res: Array<Object> = [];
              try {
                let output: BoolMsg = api!.isLoop(args[0] as PlayerMsg);
                res.push(output);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterVodPlayerApi.enableHardwareDecode", TXFlutterVodPlayerApi.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              let res: Array<Object> = [];
              try {
                let output: BoolMsg = api!.enableHardwareDecode(args[0] as BoolPlayerMsg);
                res.push(output);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterVodPlayerApi.enterPictureInPictureMode", TXFlutterVodPlayerApi.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              let res: Array<Object> = [];
              try {
                let output: IntMsg = api!.enterPictureInPictureMode(args[0] as PipParamsPlayerMsg);
                res.push(output);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterVodPlayerApi.exitPictureInPictureMode", TXFlutterVodPlayerApi.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              let res: Array<Object> = [];
              try {
                api!.exitPictureInPictureMode(args[0] as PlayerMsg);
                res.push(null);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterVodPlayerApi.initImageSprite", TXFlutterVodPlayerApi.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              let res: Array<Object> = [];
              try {
                api!.initImageSprite(args[0] as StringListPlayerMsg);
                res.push(null);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterVodPlayerApi.getImageSprite", TXFlutterVodPlayerApi.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              let res: Array<Object> = [];
              try {
                let output: UInt8ListMsg = api!.getImageSprite(args[0] as DoublePlayerMsg);
                res.push(output);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterVodPlayerApi.getDuration", TXFlutterVodPlayerApi.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              let res: Array<Object> = [];
              try {
                let output: DoubleMsg = api!.getDuration(args[0] as PlayerMsg);
                res.push(output);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterVodPlayerApi.addSubtitleSource", TXFlutterVodPlayerApi.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              let res: Array<Object> = [];
              try {
                api!.addSubtitleSource(args[0] as SubTitlePlayerMsg);
                res.push(null);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterVodPlayerApi.getSubtitleTrackInfo", TXFlutterVodPlayerApi.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              let res: Array<Object> = [];
              try {
                let output: ListMsg = api!.getSubtitleTrackInfo(args[0] as PlayerMsg);
                res.push(output);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterVodPlayerApi.getAudioTrackInfo", TXFlutterVodPlayerApi.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              let res: Array<Object> = [];
              try {
                let output: ListMsg = api!.getAudioTrackInfo(args[0] as PlayerMsg);
                res.push(output);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterVodPlayerApi.selectTrack", TXFlutterVodPlayerApi.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              let res: Array<Object> = [];
              try {
                api!.selectTrack(args[0] as IntPlayerMsg);
                res.push(null);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterVodPlayerApi.deselectTrack", TXFlutterVodPlayerApi.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              let res: Array<Object> = [];
              try {
                api!.deselectTrack(args[0] as IntPlayerMsg);
                res.push(null);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterVodPlayerApi.setSubtitleStyle", TXFlutterVodPlayerApi.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              let res: Array<Object> = [];
              try {
                api!.setSubtitleStyle(args[0] as SubTitleRenderModelPlayerMsg);
                res.push(null);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterVodPlayerApi.setStringOption", TXFlutterVodPlayerApi.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              let res: Array<Object> = [];
              try {
                api!.setStringOption(args[0] as StringOptionPlayerMsg);
                res.push(null);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterVodPlayerApi.setPlayerView", TXFlutterVodPlayerApi.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              let res: Array<Object> = [];
              try {
                api!.setPlayerView(args[0] as number);
                res.push(null);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterVodPlayerApi.setRenderMode", TXFlutterVodPlayerApi.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              let res: Array<Object> = [];
              try {
                api!.setRenderMode(args[0] as number);
                res.push(null);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterVodPlayerApi.reDraw", TXFlutterVodPlayerApi.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let res: Array<Object> = [];
              try {
                api!.reDraw();
                res.push(null);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterVodPlayerApi.enableTRTC", TXFlutterVodPlayerApi.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              let res: Array<Object> = [];
              try {
                api!.enableTRTC(args[0] as boolean);
                res.push(null);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterVodPlayerApi.publishVideo", TXFlutterVodPlayerApi.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let res: Array<Object> = [];
              try {
                api!.publishVideo();
                res.push(null);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterVodPlayerApi.unpublishVideo", TXFlutterVodPlayerApi.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let res: Array<Object> = [];
              try {
                api!.unpublishVideo();
                res.push(null);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterVodPlayerApi.publishAudio", TXFlutterVodPlayerApi.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let res: Array<Object> = [];
              try {
                api!.publishAudio();
                res.push(null);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterVodPlayerApi.unpublishAudio", TXFlutterVodPlayerApi.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let res: Array<Object> = [];
              try {
                api!.unpublishAudio();
                res.push(null);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
  }
}
/* Generated abstract class from Pigeon that represents a handler of messages from Flutter.*/
export abstract class TXFlutterLivePlayerApi {
  /*
  *  播放器初始化，创建共享纹理、初始化播放器
  *  @param onlyAudio 是否是纯音频模式
  */
  abstract initialize(onlyAudio: BoolPlayerMsg ): IntMsg;
  /*
  * 
  *  当设置[LivePlayer] 类型播放器时
  *  10.7版本开始，startPlay变更为startLivePlay，需要通过 {@link SuperPlayerPlugin#setGlobalLicense} 设置 Licence 后方可成功播放，
  *  否则将播放失败（黑屏），全局仅设置一次即可。直播 Licence、短视频 Licence 和视频播放 Licence 均可使用，若您暂未获取上述 Licence ，
  *  可[快速免费申请测试版 Licence](https://cloud.tencent.com/act/event/License) 以正常播放，正式版 License 需[购买]
  *  (https://cloud.tencent.com/document/product/881/74588#.E8.B4.AD.E4.B9.B0.E5.B9.B6.E6.96.B0.E5.BB.BA.E6.AD.A3.E5.BC.8F.E7.89.88-license)。
  */
  abstract startLivePlay(playerMsg: StringPlayerMsg ): BoolMsg;
  /*
  *  停止播放
  *  return 是否停止成功
  */
  abstract stop(isNeedClear: BoolPlayerMsg ): BoolMsg;
  /* 视频是否处于正在播放中*/
  abstract isPlaying(playerMsg: PlayerMsg ): BoolMsg;
  /* 视频暂停，必须在播放器开始播放的时候调用*/
  abstract pause(playerMsg: PlayerMsg ): void;
  /* 继续播放，在暂停的时候调用*/
  abstract resume(playerMsg: PlayerMsg ): void;
  /* 设置直播模式，see TXPlayerLiveMode*/
  abstract setLiveMode(mode: IntPlayerMsg ): void;
  /* 设置视频声音 0~100*/
  abstract setVolume(volume: IntPlayerMsg ): void;
  /* 设置是否静音*/
  abstract setMute(mute: BoolPlayerMsg ): void;
  /* 切换播放流*/
  abstract switchStream(url: StringPlayerMsg ): IntMsg;
  /* 设置appId*/
  abstract setAppID(appId: StringPlayerMsg ): void;
  /*
  *  设置播放器配置
  *  config @see [FTXLivePlayConfig]
  */
  abstract setConfig(config: FTXLivePlayConfigPlayerMsg ): void;
  /* 开启/关闭硬件编码*/
  abstract enableHardwareDecode(enable: BoolPlayerMsg ): BoolMsg;
  /*
  *  进入画中画模式，进入画中画模式，需要适配画中画模式的界面，安卓只支持7.0以上机型
  *  <h1>
  *  由于android系统限制，传递的图标大小不得超过1M，否则无法显示
  *  </h1>
  *  @param backIcon playIcon pauseIcon forwardIcon 为播放后退、播放、暂停、前进的图标，仅适用于android，如果赋值的话，将会使用传递的图标，否则
  *  使用系统默认图标，只支持flutter本地资源图片，传递的时候，与flutter使用图片资源一致，例如： images/back_icon.png
  */
  abstract enterPictureInPictureMode(pipParamsMsg: PipParamsPlayerMsg ): IntMsg;
  /* 退出画中画，如果该播放器处于画中画模式*/
  abstract exitPictureInPictureMode(playerMsg: PlayerMsg ): void;

  abstract enableReceiveSeiMessage(playerMsg: PlayerMsg , isEnabled: boolean , payloadType: number ): number;

  abstract showDebugView(playerMsg: PlayerMsg , isShow: boolean ): void;

  abstract setProperty(playerMsg: PlayerMsg , key: string , value: Object ): number;

  abstract getSupportedBitrate(playerMsg: PlayerMsg ): ListMsg;

  abstract setCacheParams(playerMsg: PlayerMsg , minTime: number , maxTime: number ): number;

  abstract enablePictureInPicture(msg: BoolPlayerMsg ): number;

  abstract setPlayerView(renderViewId: number ): void;

  abstract setRenderMode(renderMode: number ): void;

  abstract startLocalRecording(localRecordingParams: Map<string, Object> ): void;

  abstract stopLocalRecording(): void;

  abstract snapshot(): void;
  /** The codec used by TXFlutterLivePlayerApi. */
  static getCodec(): MessageCodec<Object>{
    return PigeonCodec.INSTANCE;
  }
  /*Sets up an instance of `TXFlutterLivePlayerApi` to handle messages through the `binaryMessenger`.*/
  static setup(binaryMessenger: BinaryMessenger, api: TXFlutterLivePlayerApi | null): void {
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterLivePlayerApi.initialize", TXFlutterLivePlayerApi.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              let res: Array<Object> = [];
              try {
                let output: IntMsg = api!.initialize(args[0] as BoolPlayerMsg);
                res.push(output);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterLivePlayerApi.startLivePlay", TXFlutterLivePlayerApi.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              let res: Array<Object> = [];
              try {
                let output: BoolMsg = api!.startLivePlay(args[0] as StringPlayerMsg);
                res.push(output);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterLivePlayerApi.stop", TXFlutterLivePlayerApi.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              let res: Array<Object> = [];
              try {
                let output: BoolMsg = api!.stop(args[0] as BoolPlayerMsg);
                res.push(output);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterLivePlayerApi.isPlaying", TXFlutterLivePlayerApi.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              let res: Array<Object> = [];
              try {
                let output: BoolMsg = api!.isPlaying(args[0] as PlayerMsg);
                res.push(output);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterLivePlayerApi.pause", TXFlutterLivePlayerApi.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              let res: Array<Object> = [];
              try {
                api!.pause(args[0] as PlayerMsg);
                res.push(null);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterLivePlayerApi.resume", TXFlutterLivePlayerApi.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              let res: Array<Object> = [];
              try {
                api!.resume(args[0] as PlayerMsg);
                res.push(null);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterLivePlayerApi.setLiveMode", TXFlutterLivePlayerApi.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              let res: Array<Object> = [];
              try {
                api!.setLiveMode(args[0] as IntPlayerMsg);
                res.push(null);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterLivePlayerApi.setVolume", TXFlutterLivePlayerApi.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              let res: Array<Object> = [];
              try {
                api!.setVolume(args[0] as IntPlayerMsg);
                res.push(null);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterLivePlayerApi.setMute", TXFlutterLivePlayerApi.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              let res: Array<Object> = [];
              try {
                api!.setMute(args[0] as BoolPlayerMsg);
                res.push(null);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterLivePlayerApi.switchStream", TXFlutterLivePlayerApi.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              let res: Array<Object> = [];
              try {
                let output: IntMsg = api!.switchStream(args[0] as StringPlayerMsg);
                res.push(output);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterLivePlayerApi.setAppID", TXFlutterLivePlayerApi.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              let res: Array<Object> = [];
              try {
                api!.setAppID(args[0] as StringPlayerMsg);
                res.push(null);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterLivePlayerApi.setConfig", TXFlutterLivePlayerApi.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              let res: Array<Object> = [];
              try {
                api!.setConfig(args[0] as FTXLivePlayConfigPlayerMsg);
                res.push(null);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterLivePlayerApi.enableHardwareDecode", TXFlutterLivePlayerApi.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              let res: Array<Object> = [];
              try {
                let output: BoolMsg = api!.enableHardwareDecode(args[0] as BoolPlayerMsg);
                res.push(output);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterLivePlayerApi.enterPictureInPictureMode", TXFlutterLivePlayerApi.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              let res: Array<Object> = [];
              try {
                let output: IntMsg = api!.enterPictureInPictureMode(args[0] as PipParamsPlayerMsg);
                res.push(output);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterLivePlayerApi.exitPictureInPictureMode", TXFlutterLivePlayerApi.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              let res: Array<Object> = [];
              try {
                api!.exitPictureInPictureMode(args[0] as PlayerMsg);
                res.push(null);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterLivePlayerApi.enableReceiveSeiMessage", TXFlutterLivePlayerApi.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              let res: Array<Object> = [];
              try {
                let output: number = api!.enableReceiveSeiMessage(args[0] as PlayerMsg, args[1] as boolean, args[2] as number);
                res.push(output);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterLivePlayerApi.showDebugView", TXFlutterLivePlayerApi.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              let res: Array<Object> = [];
              try {
                api!.showDebugView(args[0] as PlayerMsg, args[1] as boolean);
                res.push(null);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterLivePlayerApi.setProperty", TXFlutterLivePlayerApi.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              let res: Array<Object> = [];
              try {
                let output: number = api!.setProperty(args[0] as PlayerMsg, args[1] as string, args[2] as Object);
                res.push(output);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterLivePlayerApi.getSupportedBitrate", TXFlutterLivePlayerApi.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              let res: Array<Object> = [];
              try {
                let output: ListMsg = api!.getSupportedBitrate(args[0] as PlayerMsg);
                res.push(output);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterLivePlayerApi.setCacheParams", TXFlutterLivePlayerApi.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              let res: Array<Object> = [];
              try {
                let output: number = api!.setCacheParams(args[0] as PlayerMsg, args[1] as number, args[2] as number);
                res.push(output);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterLivePlayerApi.enablePictureInPicture", TXFlutterLivePlayerApi.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              let res: Array<Object> = [];
              try {
                let output: number = api!.enablePictureInPicture(args[0] as BoolPlayerMsg);
                res.push(output);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterLivePlayerApi.setPlayerView", TXFlutterLivePlayerApi.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              let res: Array<Object> = [];
              try {
                api!.setPlayerView(args[0] as number);
                res.push(null);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterLivePlayerApi.setRenderMode", TXFlutterLivePlayerApi.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              let res: Array<Object> = [];
              try {
                api!.setRenderMode(args[0] as number);
                res.push(null);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterLivePlayerApi.startLocalRecording", TXFlutterLivePlayerApi.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              let res: Array<Object> = [];
              try {
                api!.startLocalRecording(args[0] as Map<string, Object>);
                res.push(null);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterLivePlayerApi.stopLocalRecording", TXFlutterLivePlayerApi.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let res: Array<Object> = [];
              try {
                api!.stopLocalRecording();
                res.push(null);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterLivePlayerApi.snapshot", TXFlutterLivePlayerApi.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let res: Array<Object> = [];
              try {
                api!.snapshot();
                res.push(null);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
  }
}
/* Generated abstract class from Pigeon that represents a handler of messages from Flutter.*/
export abstract class TXFlutterDownloadApi {
  /*
  *  启动预下载。
  *  playUrl: 要预下载的url
  *  preloadSizeMB: 预下载的大小（单位：MB）
  *  preferredResolution 期望分辨率，long类型，值为高x宽。可参考如720*1080。不支持多分辨率或不需指定时，传-1。
  *  返回值：任务ID，可用这个任务ID停止预下载 [stopPreload]
  */
  abstract startPreLoad(msg: PreLoadMsg ): IntMsg;

  abstract startPreLoadByParams(msg: PreLoadInfoMsg ): void;
  /*
  *  停止预下载。
  *  taskId： 任务id
  */
  abstract stopPreLoad(msg: IntMsg ): void;
  /*
  *  开始下载
  *  videoDownloadModel: 下载构造体
  */
  abstract startDownload(msg: TXVodDownloadMediaMsg ): void;
  /*
  *  继续下载，与开始下载接口有区别，该接口会寻找对应的缓存，复用之前的缓存来续点下载，
  *  而开始下载接口会启动一个全新的下载
  *  videoDownloadModel: 下载构造体
  */
  abstract resumeDownload(msg: TXVodDownloadMediaMsg ): void;
  /*
  *  停止下载
  *  videoDownloadModel: 下载构造体
  */
  abstract stopDownload(msg: TXVodDownloadMediaMsg ): void;
  /* 设置下载请求头*/
  abstract setDownloadHeaders(headers: MapMsg ): void;
  /* 获取所有视频下载列表*/
  abstract getDownloadList(): TXDownloadListMsg;
  /* 获得指定视频的下载信息*/
  abstract getDownloadInfo(msg: TXVodDownloadMediaMsg ): TXVodDownloadMediaMsg;
  /* 删除下载任务*/
  abstract deleteDownloadMediaInfo(msg: TXVodDownloadMediaMsg ): BoolMsg;
  /** The codec used by TXFlutterDownloadApi. */
  static getCodec(): MessageCodec<Object>{
    return PigeonCodec.INSTANCE;
  }
  /*Sets up an instance of `TXFlutterDownloadApi` to handle messages through the `binaryMessenger`.*/
  static setup(binaryMessenger: BinaryMessenger, api: TXFlutterDownloadApi | null): void {
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterDownloadApi.startPreLoad", TXFlutterDownloadApi.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              let res: Array<Object> = [];
              try {
                let output: IntMsg = api!.startPreLoad(args[0] as PreLoadMsg);
                res.push(output);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterDownloadApi.startPreLoadByParams", TXFlutterDownloadApi.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              let res: Array<Object> = [];
              try {
                api!.startPreLoadByParams(args[0] as PreLoadInfoMsg);
                res.push(null);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterDownloadApi.stopPreLoad", TXFlutterDownloadApi.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              let res: Array<Object> = [];
              try {
                api!.stopPreLoad(args[0] as IntMsg);
                res.push(null);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterDownloadApi.startDownload", TXFlutterDownloadApi.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              let res: Array<Object> = [];
              try {
                api!.startDownload(args[0] as TXVodDownloadMediaMsg);
                res.push(null);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterDownloadApi.resumeDownload", TXFlutterDownloadApi.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              let res: Array<Object> = [];
              try {
                api!.resumeDownload(args[0] as TXVodDownloadMediaMsg);
                res.push(null);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterDownloadApi.stopDownload", TXFlutterDownloadApi.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              let res: Array<Object> = [];
              try {
                api!.stopDownload(args[0] as TXVodDownloadMediaMsg);
                res.push(null);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterDownloadApi.setDownloadHeaders", TXFlutterDownloadApi.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              let res: Array<Object> = [];
              try {
                api!.setDownloadHeaders(args[0] as MapMsg);
                res.push(null);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterDownloadApi.getDownloadList", TXFlutterDownloadApi.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let res: Array<Object> = [];
              try {
                let output: TXDownloadListMsg = api!.getDownloadList();
                res.push(output);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterDownloadApi.getDownloadInfo", TXFlutterDownloadApi.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              let res: Array<Object> = [];
              try {
                let output: TXVodDownloadMediaMsg = api!.getDownloadInfo(args[0] as TXVodDownloadMediaMsg);
                res.push(output);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.super_player.TXFlutterDownloadApi.deleteDownloadMediaInfo", TXFlutterDownloadApi.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              let res: Array<Object> = [];
              try {
                let output: BoolMsg = api!.deleteDownloadMediaInfo(args[0] as TXVodDownloadMediaMsg);
                res.push(output);
              }
 catch (error) {
                let wrappedError: Array<Object> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
  }
}
/* Generated class from Pigeon that represents Flutter messages that can be called from ArkTS.*/
export class TXDownloadFlutterAPI {
  binaryMessenger: BinaryMessenger;

  constructor(binaryMessenger: BinaryMessenger) {
    this.binaryMessenger = binaryMessenger;
  }

  /** The codec used by TXDownloadFlutterAPI. */
  static getCodec(): MessageCodec<Object> {
    return PigeonCodec.INSTANCE;
  }

  onDownloadEvent(eventArg: Map<string, Object>, callback: Reply<void>) {
    const channelName: string = 'dev.flutter.pigeon.super_player.TXDownloadFlutterAPI.onDownloadEvent';
    let channel: BasicMessageChannel<Object> = 
        new BasicMessageChannel<Object>(
            this.binaryMessenger, channelName, TXDownloadFlutterAPI.getCodec());
    channel.send(
        [eventArg],
        channelReply => {
          if (Array.isArray(channelReply)) {
            let listReply: ESObject[] = channelReply as ESObject[] ;
            if (listReply.length > 1) {
              let arrFirst:string = listReply[0] as string;
              let arrSecond:string = listReply[1] as string;
              let arrThird:string = listReply[2] as string;
              let replyArr:ESObject = new FlutterError(arrFirst, arrSecond, arrThird)
              callback.reply(replyArr);
            } else {
              callback.reply();
            }
          }  else {
            let connErr:ESObject = new FlutterError('channel-error', "Unable to establish connection on channel: " + channelName + ".", "")
            callback.reply(connErr);
          } 
        });
  }
  onPreDownloadEvent(eventArg: Map<string, Object>, callback: Reply<void>) {
    const channelName: string = 'dev.flutter.pigeon.super_player.TXDownloadFlutterAPI.onPreDownloadEvent';
    let channel: BasicMessageChannel<Object> = 
        new BasicMessageChannel<Object>(
            this.binaryMessenger, channelName, TXDownloadFlutterAPI.getCodec());
    channel.send(
        [eventArg],
        channelReply => {
          if (Array.isArray(channelReply)) {
            let listReply: ESObject[] = channelReply as ESObject[] ;
            if (listReply.length > 1) {
              let arrFirst:string = listReply[0] as string;
              let arrSecond:string = listReply[1] as string;
              let arrThird:string = listReply[2] as string;
              let replyArr:ESObject = new FlutterError(arrFirst, arrSecond, arrThird)
              callback.reply(replyArr);
            } else {
              callback.reply();
            }
          }  else {
            let connErr:ESObject = new FlutterError('channel-error', "Unable to establish connection on channel: " + channelName + ".", "")
            callback.reply(connErr);
          } 
        });
  }
}
/* Generated class from Pigeon that represents Flutter messages that can be called from ArkTS.*/
export class TXPluginFlutterAPI {
  binaryMessenger: BinaryMessenger;

  constructor(binaryMessenger: BinaryMessenger) {
    this.binaryMessenger = binaryMessenger;
  }

  /** The codec used by TXPluginFlutterAPI. */
  static getCodec(): MessageCodec<Object> {
    return PigeonCodec.INSTANCE;
  }

  onSDKListener(eventArg: Map<string, Object>, callback: Reply<void>) {
    const channelName: string = 'dev.flutter.pigeon.super_player.TXPluginFlutterAPI.onSDKListener';
    let channel: BasicMessageChannel<Object> = 
        new BasicMessageChannel<Object>(
            this.binaryMessenger, channelName, TXPluginFlutterAPI.getCodec());
    channel.send(
        [eventArg],
        channelReply => {
          if (Array.isArray(channelReply)) {
            let listReply: ESObject[] = channelReply as ESObject[] ;
            if (listReply.length > 1) {
              let arrFirst:string = listReply[0] as string;
              let arrSecond:string = listReply[1] as string;
              let arrThird:string = listReply[2] as string;
              let replyArr:ESObject = new FlutterError(arrFirst, arrSecond, arrThird)
              callback.reply(replyArr);
            } else {
              callback.reply();
            }
          }  else {
            let connErr:ESObject = new FlutterError('channel-error', "Unable to establish connection on channel: " + channelName + ".", "")
            callback.reply(connErr);
          } 
        });
  }
  onNativeEvent(eventArg: Map<string, Object>, callback: Reply<void>) {
    const channelName: string = 'dev.flutter.pigeon.super_player.TXPluginFlutterAPI.onNativeEvent';
    let channel: BasicMessageChannel<Object> = 
        new BasicMessageChannel<Object>(
            this.binaryMessenger, channelName, TXPluginFlutterAPI.getCodec());
    channel.send(
        [eventArg],
        channelReply => {
          if (Array.isArray(channelReply)) {
            let listReply: ESObject[] = channelReply as ESObject[] ;
            if (listReply.length > 1) {
              let arrFirst:string = listReply[0] as string;
              let arrSecond:string = listReply[1] as string;
              let arrThird:string = listReply[2] as string;
              let replyArr:ESObject = new FlutterError(arrFirst, arrSecond, arrThird)
              callback.reply(replyArr);
            } else {
              callback.reply();
            }
          }  else {
            let connErr:ESObject = new FlutterError('channel-error', "Unable to establish connection on channel: " + channelName + ".", "")
            callback.reply(connErr);
          } 
        });
  }
}
/* Generated class from Pigeon that represents Flutter messages that can be called from ArkTS.*/
export class TXPipFlutterAPI {
  binaryMessenger: BinaryMessenger;

  constructor(binaryMessenger: BinaryMessenger) {
    this.binaryMessenger = binaryMessenger;
  }

  /** The codec used by TXPipFlutterAPI. */
  static getCodec(): MessageCodec<Object> {
    return PigeonCodec.INSTANCE;
  }

  onPipEvent(eventArg: Map<string, Object>, callback: Reply<void>) {
    const channelName: string = 'dev.flutter.pigeon.super_player.TXPipFlutterAPI.onPipEvent';
    let channel: BasicMessageChannel<Object> = 
        new BasicMessageChannel<Object>(
            this.binaryMessenger, channelName, TXPipFlutterAPI.getCodec());
    channel.send(
        [eventArg],
        channelReply => {
          if (Array.isArray(channelReply)) {
            let listReply: ESObject[] = channelReply as ESObject[] ;
            if (listReply.length > 1) {
              let arrFirst:string = listReply[0] as string;
              let arrSecond:string = listReply[1] as string;
              let arrThird:string = listReply[2] as string;
              let replyArr:ESObject = new FlutterError(arrFirst, arrSecond, arrThird)
              callback.reply(replyArr);
            } else {
              callback.reply();
            }
          }  else {
            let connErr:ESObject = new FlutterError('channel-error', "Unable to establish connection on channel: " + channelName + ".", "")
            callback.reply(connErr);
          } 
        });
  }
}
/* Generated class from Pigeon that represents Flutter messages that can be called from ArkTS.*/
export class TXVodPlayerFlutterAPI {
  binaryMessenger: BinaryMessenger;

  constructor(binaryMessenger: BinaryMessenger) {
    this.binaryMessenger = binaryMessenger;
  }

  /** The codec used by TXVodPlayerFlutterAPI. */
  static getCodec(): MessageCodec<Object> {
    return PigeonCodec.INSTANCE;
  }

  onPlayerEvent(eventArg: Map<string, Object>, callback: Reply<void>) {
    const channelName: string = 'dev.flutter.pigeon.super_player.TXVodPlayerFlutterAPI.onPlayerEvent';
    let channel: BasicMessageChannel<Object> = 
        new BasicMessageChannel<Object>(
            this.binaryMessenger, channelName, TXVodPlayerFlutterAPI.getCodec());
    channel.send(
        [eventArg],
        channelReply => {
          if (Array.isArray(channelReply)) {
            let listReply: ESObject[] = channelReply as ESObject[] ;
            if (listReply.length > 1) {
              let arrFirst:string = listReply[0] as string;
              let arrSecond:string = listReply[1] as string;
              let arrThird:string = listReply[2] as string;
              let replyArr:ESObject = new FlutterError(arrFirst, arrSecond, arrThird)
              callback.reply(replyArr);
            } else {
              callback.reply();
            }
          }  else {
            let connErr:ESObject = new FlutterError('channel-error', "Unable to establish connection on channel: " + channelName + ".", "")
            callback.reply(connErr);
          } 
        });
  }
  onNetEvent(eventArg: Map<string, Object>, callback: Reply<void>) {
    const channelName: string = 'dev.flutter.pigeon.super_player.TXVodPlayerFlutterAPI.onNetEvent';
    let channel: BasicMessageChannel<Object> = 
        new BasicMessageChannel<Object>(
            this.binaryMessenger, channelName, TXVodPlayerFlutterAPI.getCodec());
    channel.send(
        [eventArg],
        channelReply => {
          if (Array.isArray(channelReply)) {
            let listReply: ESObject[] = channelReply as ESObject[] ;
            if (listReply.length > 1) {
              let arrFirst:string = listReply[0] as string;
              let arrSecond:string = listReply[1] as string;
              let arrThird:string = listReply[2] as string;
              let replyArr:ESObject = new FlutterError(arrFirst, arrSecond, arrThird)
              callback.reply(replyArr);
            } else {
              callback.reply();
            }
          }  else {
            let connErr:ESObject = new FlutterError('channel-error', "Unable to establish connection on channel: " + channelName + ".", "")
            callback.reply(connErr);
          } 
        });
  }
}
/* Generated class from Pigeon that represents Flutter messages that can be called from ArkTS.*/
export class TXLivePlayerFlutterAPI {
  binaryMessenger: BinaryMessenger;

  constructor(binaryMessenger: BinaryMessenger) {
    this.binaryMessenger = binaryMessenger;
  }

  /** The codec used by TXLivePlayerFlutterAPI. */
  static getCodec(): MessageCodec<Object> {
    return PigeonCodec.INSTANCE;
  }

  onPlayerEvent(eventArg: Map<string, Object>, callback: Reply<void>) {
    const channelName: string = 'dev.flutter.pigeon.super_player.TXLivePlayerFlutterAPI.onPlayerEvent';
    let channel: BasicMessageChannel<Object> = 
        new BasicMessageChannel<Object>(
            this.binaryMessenger, channelName, TXLivePlayerFlutterAPI.getCodec());
    channel.send(
        [eventArg],
        channelReply => {
          if (Array.isArray(channelReply)) {
            let listReply: ESObject[] = channelReply as ESObject[] ;
            if (listReply.length > 1) {
              let arrFirst:string = listReply[0] as string;
              let arrSecond:string = listReply[1] as string;
              let arrThird:string = listReply[2] as string;
              let replyArr:ESObject = new FlutterError(arrFirst, arrSecond, arrThird)
              callback.reply(replyArr);
            } else {
              callback.reply();
            }
          }  else {
            let connErr:ESObject = new FlutterError('channel-error', "Unable to establish connection on channel: " + channelName + ".", "")
            callback.reply(connErr);
          } 
        });
  }
  onNetEvent(eventArg: Map<string, Object>, callback: Reply<void>) {
    const channelName: string = 'dev.flutter.pigeon.super_player.TXLivePlayerFlutterAPI.onNetEvent';
    let channel: BasicMessageChannel<Object> = 
        new BasicMessageChannel<Object>(
            this.binaryMessenger, channelName, TXLivePlayerFlutterAPI.getCodec());
    channel.send(
        [eventArg],
        channelReply => {
          if (Array.isArray(channelReply)) {
            let listReply: ESObject[] = channelReply as ESObject[] ;
            if (listReply.length > 1) {
              let arrFirst:string = listReply[0] as string;
              let arrSecond:string = listReply[1] as string;
              let arrThird:string = listReply[2] as string;
              let replyArr:ESObject = new FlutterError(arrFirst, arrSecond, arrThird)
              callback.reply(replyArr);
            } else {
              callback.reply();
            }
          }  else {
            let connErr:ESObject = new FlutterError('channel-error', "Unable to establish connection on channel: " + channelName + ".", "")
            callback.reply(connErr);
          } 
        });
  }
  onLocalRecordBegin(codeArg: number,storagePathArg: string, callback: Reply<void>) {
    const channelName: string = 'dev.flutter.pigeon.super_player.TXLivePlayerFlutterAPI.onLocalRecordBegin';
    let channel: BasicMessageChannel<Object> = 
        new BasicMessageChannel<Object>(
            this.binaryMessenger, channelName, TXLivePlayerFlutterAPI.getCodec());
    channel.send(
        [codeArg, storagePathArg],
        channelReply => {
          if (Array.isArray(channelReply)) {
            let listReply: ESObject[] = channelReply as ESObject[] ;
            if (listReply.length > 1) {
              let arrFirst:string = listReply[0] as string;
              let arrSecond:string = listReply[1] as string;
              let arrThird:string = listReply[2] as string;
              let replyArr:ESObject = new FlutterError(arrFirst, arrSecond, arrThird)
              callback.reply(replyArr);
            } else {
              callback.reply();
            }
          }  else {
            let connErr:ESObject = new FlutterError('channel-error', "Unable to establish connection on channel: " + channelName + ".", "")
            callback.reply(connErr);
          } 
        });
  }
  onLocalRecording(durationMsArg: number,storagePathArg: string, callback: Reply<void>) {
    const channelName: string = 'dev.flutter.pigeon.super_player.TXLivePlayerFlutterAPI.onLocalRecording';
    let channel: BasicMessageChannel<Object> = 
        new BasicMessageChannel<Object>(
            this.binaryMessenger, channelName, TXLivePlayerFlutterAPI.getCodec());
    channel.send(
        [durationMsArg, storagePathArg],
        channelReply => {
          if (Array.isArray(channelReply)) {
            let listReply: ESObject[] = channelReply as ESObject[] ;
            if (listReply.length > 1) {
              let arrFirst:string = listReply[0] as string;
              let arrSecond:string = listReply[1] as string;
              let arrThird:string = listReply[2] as string;
              let replyArr:ESObject = new FlutterError(arrFirst, arrSecond, arrThird)
              callback.reply(replyArr);
            } else {
              callback.reply();
            }
          }  else {
            let connErr:ESObject = new FlutterError('channel-error', "Unable to establish connection on channel: " + channelName + ".", "")
            callback.reply(connErr);
          } 
        });
  }
  onLocalRecordComplete(codeArg: number,storagePathArg: string, callback: Reply<void>) {
    const channelName: string = 'dev.flutter.pigeon.super_player.TXLivePlayerFlutterAPI.onLocalRecordComplete';
    let channel: BasicMessageChannel<Object> = 
        new BasicMessageChannel<Object>(
            this.binaryMessenger, channelName, TXLivePlayerFlutterAPI.getCodec());
    channel.send(
        [codeArg, storagePathArg],
        channelReply => {
          if (Array.isArray(channelReply)) {
            let listReply: ESObject[] = channelReply as ESObject[] ;
            if (listReply.length > 1) {
              let arrFirst:string = listReply[0] as string;
              let arrSecond:string = listReply[1] as string;
              let arrThird:string = listReply[2] as string;
              let replyArr:ESObject = new FlutterError(arrFirst, arrSecond, arrThird)
              callback.reply(replyArr);
            } else {
              callback.reply();
            }
          }  else {
            let connErr:ESObject = new FlutterError('channel-error', "Unable to establish connection on channel: " + channelName + ".", "")
            callback.reply(connErr);
          } 
        });
  }
  onSnapshotComplete(imageBytesArg: number[], callback: Reply<void>) {
    const channelName: string = 'dev.flutter.pigeon.super_player.TXLivePlayerFlutterAPI.onSnapshotComplete';
    let channel: BasicMessageChannel<Object> = 
        new BasicMessageChannel<Object>(
            this.binaryMessenger, channelName, TXLivePlayerFlutterAPI.getCodec());
    channel.send(
        [imageBytesArg],
        channelReply => {
          if (Array.isArray(channelReply)) {
            let listReply: ESObject[] = channelReply as ESObject[] ;
            if (listReply.length > 1) {
              let arrFirst:string = listReply[0] as string;
              let arrSecond:string = listReply[1] as string;
              let arrThird:string = listReply[2] as string;
              let replyArr:ESObject = new FlutterError(arrFirst, arrSecond, arrThird)
              callback.reply(replyArr);
            } else {
              callback.reply();
            }
          }  else {
            let connErr:ESObject = new FlutterError('channel-error', "Unable to establish connection on channel: " + channelName + ".", "")
            callback.reply(connErr);
          } 
        });
  }
}
