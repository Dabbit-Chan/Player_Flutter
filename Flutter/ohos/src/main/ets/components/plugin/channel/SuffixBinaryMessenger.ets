import {
  BinaryMessageHandler,
  BinaryMessenger,
  BinaryReply,
  TaskQueue,
  TaskQueueOptions
} from '@ohos/flutter_ohos';
import SendableBinaryMessageHandler from '@ohos/flutter_ohos/src/main/ets/plugin/common/SendableBinaryMessageHandler';

export default class SuffixBinaryMessenger implements BinaryMessenger {
  private readonly delegate: BinaryMessenger;
  private readonly suffix: string;

  constructor(delegate: BinaryMessenger, suffix: string) {
    this.delegate = delegate;
    this.suffix = suffix.startsWith('.') ? suffix : `.${suffix}`;
  }

  makeBackgroundTaskQueue(options?: TaskQueueOptions): TaskQueue {
    return this.delegate.makeBackgroundTaskQueue(options);
  }

  send(channel: string, message: ArrayBuffer | null, callback?: BinaryReply | null): void {
    this.delegate.send(this.channelName(channel), message, callback);
  }

  setMessageHandler(
    channel: string,
    handler: BinaryMessageHandler | SendableBinaryMessageHandler | null,
    taskQueue?: TaskQueue,
    ...args: Object[]
  ): void {
    this.delegate.setMessageHandler(this.channelName(channel), handler, taskQueue, ...args);
  }

  private channelName(channel: string): string {
    return `${channel}${this.suffix}`;
  }
}
