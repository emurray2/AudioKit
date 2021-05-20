// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AudioKit",
    platforms: [
        .macOS(.v10_15), .iOS(.v13), .tvOS(.v13)
    ],
    products: [
        .library(
            name: "AudioKit",
            type: .static,
            targets: ["AudioKit"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/AudioKit/Soundpipe", .branch("main")),
    ],
    targets: [
        .target(
            name: "CAudioKit",
            dependencies: ["Soundpipe"],
            exclude: [
                "AudioKitCore/Modulated Delay/README.md",
                "AudioKitCore/Sampler/Wavpack/license.txt",
                "AudioKitCore/Common/README.md",
                "Nodes/Effects/Distortion/DiodeClipper.soul",
                "AudioKitCore/Common/Envelope.hpp",
                "AudioKitCore/Sampler/README.md",
                "AudioKitCore/README.md",
            ],
            publicHeadersPath: "include",
            cxxSettings: [
                .headerSearchPath("Internals"),
                .headerSearchPath("AudioKitCore/Common"),
                .headerSearchPath("Devoloop/include"),
                .headerSearchPath(".")
            ]
        ),
        .target(
            name: "AudioKit",
            dependencies: ["CAudioKit"],
            exclude: [
                "Nodes/Generators/Physical Models/README.md",
                "Internals/Table/README.md",
                "Nodes/Playback/Samplers/Sampler/Sampler.md",
                "Nodes/Playback/Samplers/Apple Sampler/AppleSamplerNotes.md",
                "Nodes/Playback/Samplers/Samplers.md",
                "Nodes/Playback/Samplers/Sampler/README.md",
                "Nodes/Effects/Guitar Processors/README.md",
                "Nodes/Playback/Samplers/PreparingSampleSets.md",
                "Internals/README.md",
                "Nodes/Effects/Modulation/ModDelay.svg",
                "MIDI/README.md",
                "Taps/README.md",
                "Nodes/Effects/Modulation/ModulatedDelayEffects.md",
                "Nodes/Effects/Modulation/README.md",
                "Nodes/Playback/Samplers/Apple Sampler/Skeleton.aupreset",
                "Nodes/Effects/README.md",
                "Operations/README.md",
                "Nodes/README.md",
            ]),
        .testTarget(
            name: "AudioKitTests",
            dependencies: ["AudioKit"],
            resources: [.copy("TestResources/")]),
        .testTarget(
            name: "CAudioKitTests",
            dependencies: ["CAudioKit"])
    ],
    cxxLanguageStandard: .cxx14
)
