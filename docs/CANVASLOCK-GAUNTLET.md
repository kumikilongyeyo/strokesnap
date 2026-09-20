# StrokeSnap 2.0 CanvasLock — Gauntlet

Build under review: `2.0.0-alpha.1` (`SnapCore` build 2001)

## Gate rule

A review lane passes at **8.0/10 or higher**. Anything at 7.x or lower is revised before handoff.

## Senior Developer lane

### First pass — 7.0/10 — REWRITE REQUIRED

Findings that blocked handoff:

- Active strokes could consume a Photoshop view transform that was replaced asynchronously mid-stroke.
- The event-tap thread read mutable `AppState` fields directly.
- Screen-rectangle → document bounds transformed only two opposite corners, which is wrong after Rotate View.
- The first 2.0 migration silently promoted old `Off` path preferences to CanvasLock.
- Keyboard ruler cycling could still surface the deprecated 3D box guide.

### Rewrite

- Added `StrokeSession` in `SnapCore`: movement threshold → freeze one sane transform → choose one constraint → hold both until pen-up.
- Published `SnapScene` and `InputPolicySnapshot` atomically for the event tap.
- Fixed rotated rectangle mapping to use all four corners.
- Preserved existing users' native-path preference; CanvasLock is only the fresh-install default.
- Removed `.box` from keyboard creation/cycling while retaining decode compatibility for old guide files.
- Hardened AX/CGWindow type checks and fail-open behavior.

### Second pass — 8.5/10 — PASS FOR ALPHA TESTING

Evidence:

- `swift test`: 9 tests, 0 failures.
- 2,000 deterministic randomized pan/zoom/rotate transform cases.
- 1,000 deterministic randomized perspective-stroke lock cases, including hostile transform replacement mid-stroke.
- `GeometryCheck`: 184 checks, 0 failures.
- Strict Swift concurrency warnings on the portable core: clean.
- Swift syntax parse across app/core/test sources: clean.
- Release benchmark: hot snap math is far below a 240 Hz sample budget; 400-guide resolution remains sub-millisecond on the test host.

Remaining alpha risks:

- The current build workspace is Linux and cannot link/type-check the AppKit executable. A real Apple-toolchain compile remains a release gate.
- Real Wacom/Huion/XP-Pen packet behavior cannot be hardware-validated in this workspace.
- CEP remains present for host state and path writes; it is no longer intended to own the idle guide display in CanvasLock.

## Technical Artist lane

### First pass — 6.8/10 — REWRITE REQUIRED

Findings that blocked handoff:

- A clean Photoshop document refused the native-path commit, so the common “set perspective before first brush mark” workflow could fall back to the drifting overlay.
- Native-path handoff waited for the generic 300 ms debounce after a direct VP/handle drag.
- Screen-space guide furniture could remain visible after Photoshop took over the actual guide, making a correctly locked guide still look like it drifted.
- The hidden 3D box mode was still reachable from keyboard cycling.

### Rewrite

- CanvasLock now treats the Photoshop path as the actual display surface even in a clean document. Selecting CanvasLock therefore explicitly opts into a document path/history change.
- Direct guide manipulation commits at mouse-up, so an immediate pan/zoom follows a Photoshop-owned path rather than a pending external overlay.
- Idle CanvasLock hides external guide handles/chips/furniture. They return for editing/placement.
- 3D box creation is absent from both picker and cycle path; old data can still load safely.
- Snap acquisition waits for real movement, picks once, and never hops between perspective candidates during a stroke.

### Second pass — 8.2/10 — PASS FOR ALPHA TESTING

Why it passes:

- The settled guide is rendered by Photoshop itself, so normal idle pan/zoom/Rotate View has no StrokeSnap overlay transform to chase.
- Direct VP edits hand off on the gesture boundary.
- Rotation-specific guide extents no longer clip due to the old two-corner conversion.
- The active stroke keeps one transform and one constraint, eliminating the most common visual snap twitch/jump path.
- CanvasLock deliberately suppresses the pre-stroke external cursor-ray while Photoshop owns the static guide; a stale cursor helper is worse than no helper.

Remaining artist-facing compromises:

- Photoshop controls the appearance of selected native paths; CanvasLock cannot retain StrokeSnap's full custom guide styling while Photoshop is the renderer.
- Visible native paths necessarily occupy Photoshop's path selection. StrokeSnap captures the artist's previous target path and exposes Release Guides to give it back.
- CanvasLock may mark a clean document modified because the guide is now a real Photoshop path. `Off` and `Shadow` remain available when that tradeoff is unwanted.
- Hardware feel, actual Photoshop pan/zoom/rotate behavior and tablet pressure/tilt must still be exercised on a Mac before promotion out of alpha.

## Handoff status

**Code-quality gate: PASS for alpha testing.**

**Release gate: NOT YET PASSED.** A macOS AppKit compile plus live Photoshop/tablet smoke test is required before a signed release candidate.
