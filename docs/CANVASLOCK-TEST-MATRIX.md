# CanvasLock Alpha 4 — Mac / Photoshop Test Matrix

Run these after installing alpha.4 and restarting Photoshop once.

## 1. Final-point confirmation

1. Add a two-point guide and place VP1 + VP2.
2. After VP2, the artwork must no longer be covered by the placement dim veil.
3. Qbar's green check must remain visibly active.
4. Press Return or keypad Enter.

Expected: guide commits exactly once. Photoshop must not separately cancel/consume the same Return. Esc must roll back instead.

## 2. Qbar is screen-pinned

1. Drag Qbar to an obvious screen location.
2. Pan the Photoshop canvas aggressively.
3. Zoom from a small value to a large value.
4. Rotate and reset the view.

Expected: Qbar stays at the exact screen location where it was left. The artwork and guides move underneath it.

## 3. Cursor ray cannot cross Photoshop UI

1. Enable Cursor tracker.
2. Put VPs far off canvas.
3. Move the cursor around the document at 0°.
4. Rotate the document ~30–50° and repeat.

Expected: the live ray is clipped to the actual four-corner artwork polygon. It must not draw through pasteboard, Properties/Color panels, StrokeSnap panel, or other Photoshop chrome.

## 4. Rotate View ownership

1. At 0°, confirm the clean StrokeSnap guide lines match the artwork.
2. Hold/use Rotate View and rotate to a non-zero angle.
3. Pan and zoom while rotated.
4. Reset to 0°.

Expected: while rotated, Photoshop-native paths are allowed to become visible as the correctness renderer; geometry must stay welded. At 0°, the clean opacity-aware StrokeSnap renderer should return.

## 5. Calibration is not perspective alignment

1. If StrokeSnap asks for calibration, click document top-left then top-right once.
2. Add a perspective guide and choose the actual VP positions you want.
3. Quit/relaunch StrokeSnap with the same Photoshop window layout.

Expected: calibration is remembered and should not be requested again. Calibration only maps Photoshop document coordinates to the screen; it must never move/guess the perspective VPs.

If Photoshop's window/panel layout changes substantially, use **Recalibrate Photoshop canvas** intentionally.

## 6. Per-document isolation

1. In document A, create obviously asymmetric VPs.
2. Switch to document B.
3. B must not inherit A's VPs/rays.
4. Create a different setup in B.
5. Switch A → B → A.

Expected: each document restores its own guide session.

## 7. Opacity at square view

At 0° with CanvasLock idle, sweep guide opacity low → high.

Expected: clean guides visibly fade/strengthen. During navigation or Rotate View, Photoshop-native paths may temporarily take ownership and use Photoshop's appearance.

## 8. Snap stability / hardware

With a real pen if available:

- Start toward one VP, then wobble toward another mid-stroke.
- Pan/zoom, then immediately start another stroke.
- Repeat after Rotate View is reset to 0°.

Expected: one constraint is selected after the movement threshold and stays locked until pen-up; no VP hopping, cursor/brush disagreement, or pressure loss.
