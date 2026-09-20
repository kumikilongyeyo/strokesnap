# CanvasLock alpha test matrix

Use Photoshop with CanvasLock mode enabled.

## Visual lock

1. Place a 1-point guide on a recognizable artwork corner.
2. Pan aggressively with Hand tool.
3. Zoom 25% → 800% → Fit Screen.
4. Rotate View to non-round values such as 17.5°, 37°, -23°.
5. Pan while rotated, then zoom while rotated.
6. Return to 0° and verify the VP/rays return to the same artwork features.

Expected: once the native path has landed, there is no visible guide catch-up. Photoshop moves guide and artwork together.

## Immediate edit → navigation

Drag a VP, release, and immediately pan or zoom.

Expected: direct manipulation commits on mouse-up; there is no generic ~300 ms external-overlay handoff window after a direct edit.

## Snap stability

Start a stroke between two candidate rays, move enough to cross the lock threshold, then wiggle toward another ray while continuing the same stroke.

Expected: one constraint is chosen and remains locked until pen-up. A new stroke may choose another constraint.

## Rotate + snap

Repeat snap tests at 17.5°, 45°, and -30° canvas rotation.

Expected: brush remains on the chosen perspective constraint; no jump when the view is rotated.

## Tablet

Test Wacom/Huion/XP-Pen if available: light→heavy pressure ramp, tilt while snapped, fast diagonal stroke, slow precision stroke, and pen-up immediately after a fast stroke.

Expected: position is constrained but pressure/tilt/timing remain natural. Report any case where the cursor is on the guide but Photoshop paints elsewhere.

## Path ownership

Select an existing artist path, commit CanvasLock guides, then use Release Guides.

Expected: StrokeSnap paths disappear and the previously captured path can be restored without deleting artist paths.

## Clean document behavior

Open an unchanged document, enable CanvasLock and place a guide.

Expected: the guide may mark the document modified because it is a real Photoshop path. This is intentional in CanvasLock; use Off/Shadow if document mutation is unacceptable.
