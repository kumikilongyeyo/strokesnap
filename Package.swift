// swift-tools-version:5.9
import PackageDescription

var targets: [Target] = [
    .target(name: "SnapCore"),
    .testTarget(name: "SnapCoreTests", dependencies: ["SnapCore"]),
]

#if os(macOS)
targets.append(.executableTarget(name: "StrokeSnap", dependencies: ["SnapCore"]))
targets.append(.executableTarget(name: "GeometryCheck", dependencies: ["SnapCore"]))
#else
// Keep the geometry benchmark available on non-macOS builders without
// attempting to compile the AppKit application target.
targets.append(.executableTarget(name: "GeometryCheck", dependencies: ["SnapCore"]))
#endif

let package = Package(
    name: "StrokeSnap",
    platforms: [.macOS(.v14)],
    targets: targets
)
