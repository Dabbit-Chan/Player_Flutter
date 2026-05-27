import { Reply } from '@ohos/flutter_ohos/src/main/ets/plugin/common/BasicMessageChannel';

class NoopVoidReply implements Reply<void> {
  reply(_reply: void): void {}
}

export default class FTXEventUtils {
  static readonly PLAY_EVT_CONNECT_SUCC = 2001;
  static readonly PLAY_EVT_RCV_FIRST_I_FRAME = 2003;
  static readonly PLAY_EVT_PLAY_BEGIN = 2004;
  static readonly PLAY_EVT_PLAY_LOADING = 2007;
  static readonly PLAY_EVT_CHANGE_RESOLUTION = 2009;
  static readonly PLAY_EVT_GET_MESSAGE = 2012;
  static readonly PLAY_EVT_VOD_LOADING_END = 2014;
  static readonly PLAY_EVT_STREAM_SWITCH_SUCC = 2015;
  static readonly PLAY_EVT_RCV_FIRST_AUDIO_FRAME = 2026;
  static readonly PLAY_ERR_STREAM_SWITCH_FAIL = -2307;

  static readonly EVENT_PREDOWNLOAD_ON_COMPLETE = 200;
  static readonly EVENT_PREDOWNLOAD_ON_ERROR = 201;
  static readonly EVENT_PREDOWNLOAD_ON_START = 202;
  static readonly EVENT_DOWNLOAD_START = 301;
  static readonly EVENT_DOWNLOAD_PROGRESS = 302;
  static readonly EVENT_DOWNLOAD_STOP = 303;
  static readonly EVENT_DOWNLOAD_FINISH = 304;
  static readonly EVENT_DOWNLOAD_ERROR = 305;
  static readonly EVENT_ON_LICENCE_LOADED = 503;

  static noopReply(): Reply<void> {
    return new NoopVoidReply();
  }

  static eventMap(event: number, params?: Map<string, Object>): Map<string, Object> {
    const result = new Map<string, Object>();
    if (event !== 0) {
      result.set('event', event);
    }
    if (params !== undefined) {
      params.forEach((value: Object, key: string): void => {
        if (value !== undefined && value !== null) {
          result.set(key, value);
        }
      });
    }
    return result;
  }

  static withMessage(message: string): Map<string, Object> {
    return new Map<string, Object>([['EVT_MSG', message]]);
  }

  static bytesFromArrayBuffer(buffer: ArrayBuffer): number[] {
    return Array.from(new Uint8Array(buffer));
  }

  static downloadStateToEvent(state: number): number {
    switch (state) {
      case 0:
        return FTXEventUtils.EVENT_DOWNLOAD_START;
      case 1:
        return FTXEventUtils.EVENT_DOWNLOAD_PROGRESS;
      case 2:
        return FTXEventUtils.EVENT_DOWNLOAD_STOP;
      case 3:
        return FTXEventUtils.EVENT_DOWNLOAD_ERROR;
      case 4:
        return FTXEventUtils.EVENT_DOWNLOAD_FINISH;
      default:
        return FTXEventUtils.EVENT_DOWNLOAD_ERROR;
    }
  }
}
