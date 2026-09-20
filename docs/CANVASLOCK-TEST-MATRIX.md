# CanvasLock alpha.6 live test matrix

1. Confirm a two-point guide. Do not edit it again.
2. Hold Space and pan continuously for several seconds. Guide lines must remain continuously visible; no blank frame or re-seat is acceptable.
3. Pinch/scroll zoom repeatedly. Same rule: no disappearance.
4. Rotate with R and with trackpad rotate if available. Native path is correctness authority; report any ghost/separation between blue companion/native geometry.
5. Pan while rotated, then zoom while rotated, then return to 0°. The guide must never rewrite or change document placement.
6. Click Qbar ✓, SNAP ON/OFF, eye, lock and delete with the pen. Only the 28pt grip may move the Qbar.
7. SNAP OFF must leave guides visible and immediately stop stroke constraining; SNAP ON restores it.
8. Repeat guide setup twice in the same document, then A→B→A document switching.

## Core invariant

The anti-blink companion is visual-only. It may fill a frame while Photoshop suppresses its selected Path Extras, but it must never commit geometry, move a VP, change the Photoshop path, or trigger a later re-alignment/catch-up operation.