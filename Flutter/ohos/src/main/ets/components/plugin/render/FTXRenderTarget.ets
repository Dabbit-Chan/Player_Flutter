export default interface FTXRenderTarget {
  attachSurface(surfaceId: string): void;
  detachSurface(surfaceId?: string): void;
}
