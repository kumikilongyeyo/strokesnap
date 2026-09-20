# CanvasLock alpha.3 test matrix

Install alpha.3, then **quit and reopen Photoshop once**. Bridge v9 adds the clean/native display handoff; an already-open Photoshop keeps the older CEP bridge in memory and will behave like alpha.1/alpha.2 until restarted.

## 1. Placement confirmation / Return

1. Add a two-point guide and enter Edit points.
2. Place VP1, then VP2.
3. Do not click anything else yet.

Expected after VP2:

- the Qbar still shows a **green checkmark** and **red X**,
- the guide is still in the placement/edit session,
- hint says `Ready • Return or ✓ keeps these points`,
- pressing **Return** or keypad Enter commits,
- pressing Esc cancels/rolls back.

## 2. Align first attempt

1. Press Align / scope.
2. Qbar/main panel must show **ALIGN 1/2**.
3. Click the document's **top-left artwork corner**.
4. It must change to **ALIGN 2/2**.
5. Click the document's **top-right artwork corner**.
6. Pan, zoom, rotate.

Expected: first run succeeds without having to restart Align. The second click solves scale/zoom; the first solves the starting location.

## 3. Clean CanvasLock + opacity

1. With CanvasLock enabled, let the canvas sit still.
2. Change guide opacity from low to high.

Expected at rest:

- StrokeSnap's clean guide changes opacity immediately,
- there are **no blue Photoshop anchor squares** left selected,
- artist path selection is restored if one existed before CanvasLock.

Then pan/zoom/rotate continuously.

Expected while moving:

- Photoshop may temporarily show its native blue path style; this is the zero-drift display surface,
- guide stays welded to the artwork.

Expected when movement stops:

- blue/native selection disappears again,
- clean StrokeSnap guide returns at the chosen opacity.

## 4. Photoshop document isolation

1. In PSD A, create a clearly recognizable two-point perspective setup.
2. Switch to PSD B that has not been seen during this StrokeSnap session.

Expected: PSD B starts with **no inherited VP/ruler setup**.

3. Create a different guide in PSD B.
4. Switch back to PSD A.

Expected: PSD A's original guide returns.

5. Switch to PSD B again.

Expected: PSD B's own guide returns; A's does not.

## 5. StrokeSnap panel focus

Click into a StrokeSnap field so StrokeSnap owns keyboard focus.

Expected:

- status should continue to treat Photoshop as the drawing host, not say `Not snapping in StrokeSnap`,
- dragging/clicking inside StrokeSnap's own panel/Qbar must never be snapped as a drawing stroke,
- returning the pen to Photoshop should require no allow-list repair.

## 6. Visual lock stress

1. Place a VP on a recognizable artwork feature.
2. Pan aggressively.
3. Zoom 25% -> 800% -> Fit Screen.
4. Rotate View to 17.5°, 37°, -23°.
5. Pan while rotated, then zoom while rotated.
6. Return to 0°.

Expected: guide geometry stays on the same artwork features; there is no external-overlay catch-up.

## 7. Snap stability

1. Start a stroke between two candidate rays.
2. Move enough to cross the lock threshold.
3. Deliberately wiggle toward another candidate while continuing the same stroke.

Expected: one constraint is chosen and held until pen-up. A new stroke may choose another constraint.

Repeat at rotated canvas angles.

## 8. Tablet

With Wacom/Huion/XP-Pen if available:

- light -> heavy pressure ramp,
- tilt while snapped,
- fast diagonal stroke,
- slow precision stroke,
- pen-up immediately after a fast stroke.

Expected: position is constrained while pressure/tilt/timing remain natural. Report any case where the cursor is on the guide but Photoshop paints elsewhere.
