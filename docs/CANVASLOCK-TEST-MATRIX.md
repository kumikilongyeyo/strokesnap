# CanvasLock alpha.8 — live Photoshop test matrix

1. Run `BUILD & INSTALL STROKESNAP.command`. The real macOS AppKit target must compile with no Qbar error.
2. Drag Qbar using only the 38pt left grip. It must follow the pen/mouse continuously and remain where released.
3. Drag/click opacity, thickness and ray-count controls. None may move the Qbar.
4. Place a two-point guide with a VP behind/near Qbar; ✓ must remain reachable and Return must still confirm.
5. Pan continuously, zoom, rotate, then pan/zoom while rotated. Canvas-mode guide must remain one continuous StrokeSnap renderer with no visible Photoshop PathItem.
6. SNAP OFF must leave guides visible and stop constraining strokes; SNAP ON restores snapping.
7. Repeat setup twice in one document and A → B → A.

Any compile failure, blinking, path furniture, Qbar control theft, or second-run failure is a gauntlet FAIL.
