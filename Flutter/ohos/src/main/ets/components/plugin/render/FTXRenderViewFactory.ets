import common from '@ohos.app.ability.common';
import { PlatformView, PlatformViewFactory, StandardMessageCodec } from '@ohos/flutter_ohos';
import Any from '@ohos/flutter_ohos/src/main/ets/plugin/common/Any';
import FTXRenderView from './FTXRenderView';

export default class FTXRenderViewFactory extends PlatformViewFactory {
  private readonly views: Map<number, FTXRenderView> = new Map<number, FTXRenderView>();

  constructor() {
    super(StandardMessageCodec.INSTANCE);
  }

  create(context: common.Context, viewId: number, args: Any): PlatformView {
    const renderView = new FTXRenderView(viewId, (id: number) => {
      this.views.delete(id);
    });
    this.views.set(viewId, renderView);
    return renderView;
  }

  getRenderView(viewId: number): FTXRenderView | undefined {
    return this.views.get(viewId);
  }

  clear(): void {
    this.views.forEach((view: FTXRenderView) => {
      view.dispose();
    });
    this.views.clear();
  }
}
