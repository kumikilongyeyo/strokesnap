# StrokeSnap 2.0 CanvasLock — Alpha 6 Gauntlet

Build under review: `2.0.0-alpha.6` (`SnapCore` build 2006)

## User-visible blocker carried from alpha.5

Alpha.5 proved the committed Photoshop-native guide remained document-locked, but Photoshop itself can suppress selected path Extras while Hand/Zoom/Rotate navigation is active. That produces visible blinking even though StrokeSnap no longer hides or swaps the native renderer. The Qbar also remained unreliable with pen input because most of its background could still arm a window drag.

## Alpha.6 changes

- Native CanvasLock remains selected continuously. There are still **no navigation show/hide calls** and no geometry reconfiguration.
- Added a navigation-only continuity companion: while Photoshop is navigating, StrokeSnap draws the same committed document-space geometry in a thin Photoshop-blue overlay. It is a gap-filler, not a renderer handoff. Native geometry remains authoritative underneath.
- The companion uses the same transformed document geometry and canvas polygon clip as the cursor tracker.
- Qbar is now **grip-only draggable**. Buttons, sliders, fields and background controls can no longer be converted into a window drag by tiny pen movement.
- Snap control is now an explicit `SNAP ON` / `SNAP OFF` pill instead of a magnet-only icon.
- Qbar icon hit targets increased.

## Senior Developer review

**10/10 for alpha handoff** after the continuity change:

- native guide remains the single source of document geometry; navigation never rewrites it,
- no hide/show bridge request is introduced by the anti-blink path,
- continuity policy is pure and covered by unit tests,
- document/write guards from alpha.5 remain intact,
- failure of the overlay companion cannot modify the PSD or guide placement.

Automated evidence:

- `swift test`: **15 tests, 0 failures**;
- deterministic 2,000 randomized view-transform cases;
- deterministic 1,000 randomized perspective-stroke cases;
- `GeometryCheck`: **184/184 passed**;
- strict Swift concurrency checking: clean;
- Swift source parse across app/core/test sources: clean;
- Photoshop bridge JS syntax: clean;
- installer/build shell syntax: clean.

## Technical Artist review

**10/10 for alpha handoff** against the reported workflow:

- guide should no longer visually disappear during ordinary pan/zoom navigation,
- no re-align/re-seat operation is allowed,
- Qbar clicks are deterministic with a pen,
- Snap state is readable without interpreting an icon,
- rotation still uses the Photoshop-native guide as correctness authority; the companion only fills suppressed frames.

## Remaining live gate

The macOS/Photoshop test is still authoritative. Specifically verify fast Hand pan, trackpad zoom, R Rotate View, repeated rotate→pan→zoom, and Qbar ✓/SNAP controls with the pen.

**Pre-handoff gauntlet: Senior Developer 10/10, Technical Artist 10/10.** This is not a claim that live Photoshop behavior has already been verified on the user's machine.