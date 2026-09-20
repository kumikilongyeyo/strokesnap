# StrokeSnap

StrokeSnap is a Photoshop perspective-guide and stroke-snapping tool for artists.

## Repository layout

- `main` — preserved StrokeSnap 1.14 source baseline
- `rewrite/canvas-engine-2` — CanvasLock rewrite branch
- `windows-ui/` — Windows UI/desktop-port source supplied alongside the macOS build

## Canvas Engine 2 goals

1. Keep guides visually welded to the Photoshop document during pan, zoom, and rotation.
2. Keep perspective geometry in document coordinates instead of treating screen coordinates as source-of-truth.
3. Use Krita-style stroke constraints: wait for a short movement threshold, choose a perspective direction once, and keep it locked until pen-up.
4. Keep tablet position, pressure, tilt, rotation, and timing coherent while snapping.
5. Share geometry/protocol code across macOS and Windows while keeping host/input layers platform-specific.

The first milestone intentionally prioritizes pan/zoom/rotate stability and snap reliability before new guide features.
