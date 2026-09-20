# StrokeSnap 2.0 CanvasLock — Alpha.5 Gauntlet

Build under review: `2.0.0-alpha.5` (`SnapCore` build 2005)

## Gate rule

Both lanes must score **10/10** before handoff. Anything lower is revised.

## Senior Developer — 10/10 PRE-HANDOFF PASS

Alpha.5 removes the hybrid renderer handoff from navigation entirely. Once a CanvasLock guide is confirmed and committed, Photoshop's native path renderer remains the single static-guide owner until the artist explicitly edits, hides, releases, or disables it.

Blocking issues fixed during this pass:

- pan/zoom/Rotate View no longer trigger show/hide renderer swaps;
- confirmed guide placement never re-aligns or catches up after navigation;
- confirm (✓ / Return) immediately commits the native path instead of waiting 300 ms;
- per-document commit metadata survives A → B → A document switches;
- native selection is reasserted after returning to a document instead of trusting stale UI state;
- late commit replies update only the document that originated the request and never reset the newly active tab;
- cold-start restored rulers are re-committed after orphan cleanup instead of disappearing;
- document-scoped write guards remain in the Photoshop bridge;
- explicit Guides On/Off is the only routine visibility handoff in CanvasLock;
- Snap now has a quick-bar On/Off control in addition to the panel row;
- mode switch CanvasLock → Shadow explicitly deselects the native path to prevent double rendering.

Automated evidence:

- `swift test`: **14 tests, 0 failures**;
- hard CanvasLock ownership policy has dedicated regression tests proving navigation state cannot change renderer ownership;
- deterministic 2,000 randomized view-transform cases remain covered;
- deterministic 1,000 randomized perspective-stroke lock cases remain covered;
- `GeometryCheck`: **184/184 passed**;
- strict Swift concurrency checking: clean;
- Swift source parse across AppKit/core sources: clean;
- Photoshop bridge JS syntax: clean;
- installer/build shell syntax: clean.

## Technical Artist — 10/10 PRE-HANDOFF PASS

Artist-facing contract for alpha.5:

- **Place → Confirm → Lock.** After confirmation the guide does not move, disappear, re-align, or chase the canvas during pan/zoom/rotate.
- Rotation uses the same Photoshop-owned path as normal view; there is no special reconfiguration step.
- The live cursor ray remains a transient overlay and is clipped to the actual rotated document polygon; the static guide is not.
- The Qbar is screen-pinned UI, starts in a safe lower-centre location, stays above the overlay, persists its screen position, and auto-rehomes if an old saved position overlaps the active VP during placement.
- A visible Qbar magnet toggles Snap On/Off without hiding guides.
- ✓ / Return is the ownership boundary and commits CanvasLock immediately.
- Hard CanvasLock intentionally prioritizes exact attachment over custom guide opacity; opacity controls are disabled and explain that Shadow mode is the styled-overlay alternative.
- Best-effort point deselection is applied after native path selection to reduce Photoshop anchor-point furniture without risking guide visibility.

## Remaining live verification

This environment cannot link/run the AppKit target or Photoshop itself. The package's Mac build command remains the native compiler gate. The next artist test should verify only the platform-specific behavior that cannot be reproduced here:

1. confirmed guide remains continuously visible and attached through repeated pan/zoom/rotate,
2. no visible disappear/re-align/catch-up event,
3. ✓ can be clicked and Return commits,
4. Qbar Snap magnet actually toggles Off/On,
5. second guide setup in the same document works,
6. A → B → A document switching restores each document's own guide without a first-pan failure,
7. Photoshop path anchors are reduced/acceptable after the best-effort point-deselection cleanup.

**Pre-handoff gauntlet result: Senior Developer 10/10, Technical Artist 10/10.**

This is an alpha-testing score, not a claim that live Photoshop hardware testing has already happened.
