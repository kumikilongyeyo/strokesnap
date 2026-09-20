# StrokeSnap 2.0 CanvasLock — Alpha 4 Gauntlet

Build under review: `2.0.0-alpha.4` (`SnapCore` build 2004)

## Gate rule

A review lane passes at **8.0/10 or higher**. Anything at 7.x or lower is revised before handoff.

## Live-test findings carried in from alpha.3

The Mac/Photoshop test proved the important part: Photoshop-native CanvasLock geometry stays attached during ordinary pan/zoom and snapping works. It also exposed five artist-facing failures that the portable test suite could not see:

1. Clean overlay geometry was not trustworthy under Rotate View even though the underlying Photoshop path remained correct.
2. The live cursor ray used an axis-aligned canvas envelope, so a rotated document could let the ray cross Photoshop pasteboard/UI triangles.
3. The on-canvas Qbar was document-anchored and moved when the artist panned; it should behave like Photoshop chrome and stay where the artist left it.
4. Return/Escape were only observed through NSEvent monitors. Photoshop could receive the same Return and cancel/consume it after StrokeSnap saw it.
5. “Align” was misleading. Those two corner clicks calibrate Photoshop screen↔document coordinates; they do **not** choose the artwork's perspective vanishing points.

The ready-to-confirm placement veil also visually dimmed the confirmation affordance, making the green check look unavailable even when the scene was ready.

---

## Senior Developer lane

### Alpha.3 live-use pass — 7.2/10 — REWRITE REQUIRED

Blocking findings:

- Rotate View could hand visual ownership back to a transform whose angle was stale or temporarily unavailable.
- Two AppState projection paths reconstructed rotated rectangles from only two opposite corners.
- Modal Return was not owned at the CGEvent layer, so Photoshop and StrokeSnap could act on the same key.
- Calibration was discarded across relaunches even when the Photoshop viewport layout had not changed.

### Alpha.4 rewrite

- Rotate gestures are observed at the event-tap level. CanvasLock hands display ownership to Photoshop immediately and holds it until a post-gesture angle sample is trustworthy.
- Any non-zero trusted Rotate View angle keeps native Photoshop paths as the renderer; clean overlay ownership returns automatically at square view.
- All rotated document/crop bounds are projected from **all four corners**.
- The event tap now owns Esc / Return / keypad Enter while a modal StrokeSnap tool is active and swallows the event before Photoshop can also consume it.
- Qbar position is stored in Cocoa screen coordinates, not document coordinates.
- Calibration is stored relative to the Photoshop host window and restored across relaunch/window moves when the window dimensions are compatible.
- Existing per-document guide-session isolation is retained.

### Second pass — 8.8/10 — PASS FOR ALPHA TESTING

Why it passes the code-quality gate:

- SnapCore remains document-space and active strokes freeze one transform + one chosen constraint until pen-up.
- 2,000 deterministic randomized pan/zoom/rotation transform cases remain part of the portable gate.
- 1,000 deterministic randomized perspective strokes remain part of the portable gate.
- Rotated rectangle coverage uses four-corner projection in both SnapCore and host projection paths.
- Modal key ownership is explicit rather than relying on best-effort event observation.

Remaining engineering risk:

- Photoshop's public scripting surface still does not provide a Krita-style direct canvas decoration API or universally readable viewport angle during every Rotate View gesture. Native path ownership remains the exact correctness fallback while rotated.
- The AppKit executable must still be compiled and exercised on the Mac test machine; Linux can parse but cannot link AppKit.
- Real Wacom/Huion/XP-Pen packet behavior remains a hardware test gate.

---

## Technical Artist lane

### Alpha.3 live-use pass — 6.9/10 — REWRITE REQUIRED

Blocking artist-facing findings:

- Rotation visibly broke the clean helper overlay even though returning to 0° recovered it.
- Cursor rays could draw over Photoshop UI when the document was rotated.
- Qbar wandered with canvas navigation instead of staying where the artist placed it.
- Ready-to-confirm state still looked dim, and Return was not dependable enough to trust.
- “Align top-left/top-right” sounded like it was supposed to align the perspective setup, creating an unnecessary second-readjustment expectation.

### Alpha.4 rewrite

- **Rotation correctness first:** when Rotate View is non-zero, Photoshop-native path rendering owns the static guide. This can show Photoshop's blue native-path appearance while rotated, but it remains exactly welded to the artwork. Returning to 0° returns to the clean StrokeSnap renderer and its opacity styling.
- **True canvas clip:** guide and live-cursor drawing clip to the transformed four-corner document polygon, not its bounding rectangle, so rays stop at the artwork instead of crossing Photoshop chrome.
- **Screen-pinned Qbar:** pan/zoom/rotate never drags the Qbar. Drag it once and it stays at that screen location.
- **Visible confirmation:** after the final point is placed, the placement dim veil is removed. Return / keypad Enter and the green check mean the same commit action; Esc cancels.
- **Calibration terminology:** UI now says `Calibrate`, explains it is a one-time Photoshop coordinate calibration, and explicitly says the perspective VPs are still artist-chosen. The calibration is remembered while the Photoshop window layout remains compatible.

### Second pass — 8.5/10 — PASS FOR ALPHA TESTING

What should feel materially better:

- CanvasLock remains exact during Rotate View instead of preferring a prettier but wrong overlay.
- Live cursor rays cannot paint outside the actual rotated canvas polygon.
- The Qbar behaves like a tool palette rather than artwork geometry.
- Confirmation no longer sits under a modal dim layer and the keyboard event cannot fall through to Photoshop.
- The artist should normally calibrate the Photoshop viewport once, not once per guide or once per app launch.

Remaining compromise:

- While the canvas is rotated, exactness currently wins over custom styling: Photoshop may show its native blue path/anchor appearance. A future native canvas-decoration path can remove that compromise if a stable host hook is proven.

---

## Handoff status

**Code-quality gate: PASS for alpha testing.**

**Live release gate: NOT YET PASSED.** Alpha.4 must be exercised on the Mac against these exact regressions: Rotate View, Qbar pinning, clipped cursor ray, Return confirmation, remembered calibration, and real tablet snapping.
