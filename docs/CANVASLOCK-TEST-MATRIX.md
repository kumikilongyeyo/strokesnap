# CanvasLock alpha.5 live test matrix

## Core invariant

After a guide is confirmed:

**it must not move, disappear, re-align, swap renderer, or catch up because of pan, zoom, or Rotate View.**

Only explicit Edit points / Guides Off / Release / mode changes are allowed to alter guide placement or visibility.

## 1. Confirm and lock

1. Add Two-point.
2. Place VP1 + VP2.
3. Click ✓ or press Return.
4. Immediately pan, zoom and rotate.

Expected: native guide is already committed at confirmation; no 300 ms transition window.

## 2. Navigation torture

Repeat rapidly:

- pan left/right,
- zoom 25% → 800%,
- rotate 17.5°, 45°, -30°,
- pan while rotated,
- zoom while rotated,
- return to 0°.

Expected: guide never disappears, re-aligns or catches up. It remains on the exact same document coordinates.

## 3. Second setup

Create and confirm another perspective setup in the same Photoshop document.

Expected: second placement works normally; no stale placement/commit session from the first setup.

## 4. Qbar

Expected:

- Qbar starts away from the active VP,
- Qbar can be dragged anywhere on screen,
- its position remains screen-fixed while the canvas moves,
- green ✓ remains clickable,
- magnet toggles Snap On/Off,
- Guides toggle remains separate from Snap.

## 5. Cursor ray

Move the cursor around a rotated document.

Expected: live cursor ray is clipped to the transformed document polygon and does not draw over Photoshop panels/chrome.

## 6. Documents

1. PSD A: create/confirm guide.
2. Switch to PSD B: create a different guide.
3. Return to A, pan immediately.
4. Return to B, pan immediately.

Expected: each document restores its own guide and the first navigation gesture is already native-locked.

## 7. Explicit visibility

- Guides Off: native path disappears intentionally.
- Guides On: same committed geometry returns; no reconfiguration.
- Snap Off: guide remains visible but strokes are unconstrained.

## 8. Styling tradeoff

In CanvasLock, opacity control is disabled because Photoshop owns the static guide. Switch to Shadow mode to test styled opacity-aware overlay guides.
