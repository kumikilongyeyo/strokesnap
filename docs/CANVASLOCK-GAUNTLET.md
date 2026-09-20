# StrokeSnap 2.0 CanvasLock — Gauntlet

Build under review: `2.0.0-alpha.3` (`SnapCore` build 2003)

## Gate rule

A review lane passes at **8.0/10 or higher**. Anything at 7.x or lower is revised before handoff.

This review includes the first real Photoshop artist test of alpha.1/alpha.2. That test proved the hard part — native CanvasLock really stayed attached through pan/zoom/rotate and snapping worked — while exposing several workflow failures that the synthetic tests could not see.

## Senior Developer lane

### Real-use pass — 7.1/10 — REWRITE REQUIRED

Blocking findings from the Photoshop test:

- Guide state was global, so switching Photoshop documents could carry the previous document's VPs/rulers into the next document.
- The final point auto-committed immediately, making Return appear to cancel/no-op and removing the visible confirmation state before the artist could verify placement.
- Clicking StrokeSnap itself made the allow-list report `StrokeSnap` as the active target and idled the Photoshop bridge even though Photoshop was still the drawing host.
- CanvasLock's opacity control could not affect Photoshop's selected native-path rendering.
- The bridge had no display-only handoff API; committing geometry and selecting it were inseparable.

### Alpha.3 rewrite

- Added per-Photoshop-document in-memory sessions keyed by Photoshop `docId`; a never-seen tab starts clean, and switching back restores that document's own guides/box scene.
- Host-document swaps suppress `onGuidesChanged`, preventing the old document's geometry from being committed into the new document during the switch frame.
- Point placement now has an explicit final state: last VP completes the set, then Return or the Qbar checkmark commits it. Esc still rolls back.
- While StrokeSnap owns keyboard focus, CanvasTracker keeps the previous allowed drawing host armed; InputBridge already excludes StrokeSnap's own window rectangles, so panel interaction is not interpreted as a stroke.
- Bridge protocol bumped to v9 with `/showguides` and `/hideguides`: native geometry remains in the PSD, while path selection can be handed to/from Photoshop without rewriting geometry/history.
- Added a focused bridge acceptance lane that drives the real HTTP/auth/serialized-evalScript path and verifies show/hide never deletes guide geometry or loses the artist's previous path selection.
- The build script no longer hides the macOS debug compiler output, so a first build does not look frozen after GeometryCheck.

### Second pass — 8.7/10 — PASS FOR ALPHA TESTING

Evidence available before handoff:

- `swift test`: **9 tests, 0 failures**.
- 2,000 deterministic randomized pan/zoom/rotation transform cases.
- 1,000 deterministic randomized perspective-stroke lock cases, including hostile transform replacement mid-stroke.
- `GeometryCheck`: **184 checks, 0 failures**.
- Focused CanvasLock bridge handoff: **all checks pass**, including read/write-token separation, native geometry commit, idle hide, navigation show, artist-path restore, and geometry survival.
- `node --check` on bridge.js: clean.
- Swift syntax parse on modified AppKit/SwiftUI sources: clean.
- shell syntax checks for installer/build launchers: clean.
- macOS-only Qbar self-test now contains regressions for explicit point confirmation and per-document ruler isolation; it runs as part of `build_app.sh` on the artist's Mac.

Remaining engineering risk appropriate for alpha, not release:

- This Linux workspace cannot link or type-check AppKit. The source package deliberately recompiles and runs the macOS-only interaction suite on the test Mac before installing.
- Real Wacom/Huion/XP-Pen packet semantics still require hardware testing.
- The full long-duration bridge scheduler torture suite is unreliable on this Linux host; the focused CanvasLock handoff lane passes. The full suite remains in the macOS build gate.

## Technical Artist lane

### Real-use pass — 5.2/10 — REWRITE REQUIRED

The first Photoshop screenshots were decisive:

- CanvasLock *did* stay welded to the artwork, which validates the core architecture.
- But leaving native Photoshop paths selected at rest produced blue anchor squares/Bezier furniture across the artwork.
- Opacity appeared broken because Photoshop, not StrokeSnap, was drawing the selected path.
- There was no persistent checkmark after the last VP, so it was hard to know whether placement registered.
- Return did not read as confirm because placement had already auto-committed.
- Align looked broken on the first attempt because its two-click contract was not surfaced clearly; the main panel even described it as one click.
- Clicking the panel could show `Not snapping in StrokeSnap`, which is technically explainable and artist-hostile.

### Alpha.3 rewrite

- **Hybrid CanvasLock display:** Photoshop native paths own the guide only while pan/zoom/rotate is active. At rest they are deselected and StrokeSnap's clean overlay draws again, so custom colour/thickness/opacity work and blue anchors disappear.
- No geometry rewrite is performed during navigation handoff; only path selection changes, so the PSD/history is not spammed.
- The artist's previously selected path is remembered and restored when native display is hidden.
- Qbar now keeps a green checkmark + red cancel visible after the final VP until the artist explicitly confirms/cancels.
- Return and keypad Enter commit the same placement state as the checkmark.
- Align now visibly says **1/2 top-left** then **2/2 top-right** in both Qbar and main panel, and forces a fresh Photoshop read before the first click.
- Calibration/window facts persist across Photoshop document switches instead of being needlessly thrown away.
- StrokeSnap panel focus no longer masquerades as a new drawing target; Photoshop remains the remembered host while own-window input is excluded from snapping.
- Every Photoshop document gets an isolated ruler setup during the session.

### Second pass — 8.3/10 — PASS FOR ALPHA TESTING

Why it passes the alpha gate:

- The user's most important success condition is proven in real Photoshop: **the guide stays attached through pan/zoom/rotate and snapping works**.
- The ugly native path display is now limited to the interval where Photoshop must own rendering to guarantee zero drift; at rest the clean StrokeSnap overlay returns.
- Opacity is therefore meaningful again at rest instead of pretending it can recolour Photoshop's path-selection UI.
- Placement has a visible, explicit confirmation state instead of committing invisibly.
- Alignment tells the artist exactly which click it is waiting for.
- Document switching no longer shares a single ruler array.

Alpha-specific visual compromise to verify:

- During active pan/zoom/rotate, Photoshop temporarily displays its native blue path style. When movement settles, alpha.3 should immediately hide that selection and return to the clean StrokeSnap overlay. This is intentional: appearance is temporarily traded for true canvas lock only while the canvas is moving.

## Handoff decision

**PASS FOR ALPHA TESTING — Senior Dev 8.7/10, Technical Artist 8.3/10.**

Do not call this a release until the alpha.3 macOS build passes its on-Mac Qbar/bridge suites and the four real-workflow regressions below are confirmed in Photoshop:

1. final VP -> visible ✓ -> Return/✓ confirms,
2. Align works first run with visible 1/2 and 2/2 states,
3. opacity changes the clean idle guide and blue anchors disappear after navigation ends,
4. switching PSD tabs starts/restores the correct per-document ruler set.
