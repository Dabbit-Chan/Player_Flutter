import { PlatformView } from '@ohos/flutter_ohos';
import FTXRenderTarget from './FTXRenderTarget';

const FTX_XCOMPONENT_PREFIX = 'FTXRenderView_';

interface FTXRenderBuilderParams {
  platformView: PlatformView;
}

@Builder
function FTXRenderBuilder(params: FTXRenderBuilderParams) {
  FTXRenderSurface({ renderView: params.platformView as FTXRenderView });
}

@Component
struct FTXRenderSurface {
  renderView?: FTXRenderView;
  private xComponentId: string = FTX_XCOMPONENT_PREFIX;

  aboutToAppear(): void {
    this.xComponentId = `${FTX_XCOMPONENT_PREFIX}${this.renderView?.getViewId() ?? 0}`;
  }

  build() {
    XComponent({
      id: this.xComponentId,
      type: XComponentType.SURFACE,
      libraryname: ''
    })
      .width('100%')
      .height('100%')
      .onLoad((context?: object) => {
        let surfaceId = this.xComponentId;
        let candidate: ESObject = context as ESObject;
        if (candidate !== undefined && candidate !== null) {
          if (candidate.getXComponentSurfaceId !== undefined) {
            surfaceId = candidate.getXComponentSurfaceId() as string;
          } else if (candidate.surfaceId !== undefined) {
            surfaceId = candidate.surfaceId as string;
          }
          if (candidate.setXComponentSurfaceRect !== undefined) {
            candidate.setXComponentSurfaceRect({
              offsetX: 0,
              offsetY: 0,
              surfaceWidth: 1,
              surfaceHeight: 1
            });
          }
        }
        this.renderView?.onSurfaceReady(surfaceId);
      })
      .onDestroy(() => {
        this.renderView?.onSurfaceDestroyed();
      });
  }
}

export default class FTXRenderView extends PlatformView {
  private readonly viewId: number;
  private readonly onDispose: (viewId: number) => void;
  private surfaceId?: string;
  private target?: FTXRenderTarget;

  constructor(viewId: number, onDispose: (viewId: number) => void) {
    super();
    this.viewId = viewId;
    this.onDispose = onDispose;
  }

  getType(): string {
    return 'FTXRenderViewType';
  }

  getView(): WrappedBuilder<[FTXRenderBuilderParams]> {
    return wrapBuilder(FTXRenderBuilder);
  }

  getViewId(): number {
    return this.viewId;
  }

  getSurfaceId(): string | undefined {
    return this.surfaceId;
  }

  bindTarget(target?: FTXRenderTarget): void {
    if (this.target !== undefined && this.target !== target) {
      this.target.detachSurface(this.surfaceId);
    }
    this.target = target;
    this.attachIfReady();
  }

  onSurfaceReady(surfaceId: string): void {
    this.surfaceId = surfaceId;
    this.attachIfReady();
  }

  onSurfaceDestroyed(): void {
    let oldSurface = this.surfaceId;
    this.surfaceId = undefined;
    if (this.target !== undefined) {
      this.target.detachSurface(oldSurface);
    }
  }

  dispose(): void {
    this.onSurfaceDestroyed();
    this.target = undefined;
    this.onDispose(this.viewId);
  }

  private attachIfReady(): void {
    if (this.surfaceId !== undefined && this.target !== undefined) {
      this.target.attachSurface(this.surfaceId);
    }
  }
}
