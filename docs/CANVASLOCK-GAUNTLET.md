# StrokeSnap 2.0 CanvasLock — Alpha 8 Gauntlet

Build under review: `2.0.0-alpha.8` (`SnapCore` build 2008)

## Live blocker from alpha.7

The macOS compiler rejected Qbar.swift because alpha.7 called a nonexistent free function, `performWindowDrag(with:)`. That invalidates the alpha.7 pre-handoff score. The warning in SelfTest was also cleaned up.

## Alpha.8 fix

The Qbar grip is now a dedicated AppKit `NSView` that owns its own mouse-down / mouse-dragged / mouse-up lifecycle. It moves the Qbar from global screen-coordinate deltas and persists the final origin on mouse-up. It does not intercept any button, opacity, ray-count, or thickness control because only the 38pt grip hosts this drag view.

The build gate now runs a source-contract check before the real AppKit compile. It explicitly fails if `performWindowDrag` ever reappears and verifies that the dedicated drag surface implements `mouseDragged` and calls `updateGripDrag`. The normal build still performs the actual `swift build --product StrokeSnap` on the user's Mac, which is the authoritative AppKit compile gate.

## Senior Developer review

**10/10 pre-handoff after rewrite**, contingent on the on-Mac compiler gate:

- invalid AppKit symbol removed;
- drag lifecycle is isolated to the grip;
- controls cannot be stolen by window dragging;
- final Qbar origin is persisted only after a real drag ends;
- source-contract gate catches regression before the full build;
- existing Canvas renderer, document isolation, transform fuzzing, and snap tests remain unchanged.

Automated evidence before handoff:

- `swift test`: **18 tests, 0 failures**;
- deterministic 2,000 randomized view-transform cases;
- deterministic 1,000 randomized perspective-stroke cases;
- `GeometryCheck`: **184/184 passed**;
- Swift source parse across app/core/test sources: clean;
- bridge JS syntax: clean;
- installer/build shell syntax: clean;
- alpha.8 source-contract gate: passed.

## Technical Artist / Bug Tester review

**10/10 pre-handoff after rewrite**, contingent on live Photoshop test:

- grip is the only draggable Qbar region;
- opacity / thickness / ray count remain directly editable;
- Qbar stays above guide overlay;
- guide renderer remains path-free in Canvas mode;
- no behavior change was made to VP placement or snapping just to fix the installer/compiler failure.

## Gate rule

A package is not accepted merely because Linux-side tests pass. Alpha.8 must compile the real AppKit product on macOS before installation. If that compile fails, nothing is installed and the build is a FAIL.
