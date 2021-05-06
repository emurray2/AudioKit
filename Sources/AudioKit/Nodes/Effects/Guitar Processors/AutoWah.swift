// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/AudioKit/
// This file was auto-autogenerated by scripts and templates at http://github.com/AudioKit/AudioKitDevTools/

import AVFoundation
import CAudioKit

/// An automatic wah effect, ported from Guitarix via Faust.
public class AutoWah: Node, AudioUnitContainer, Toggleable {

    /// Unique four-letter identifier "awah"
    public static let ComponentDescription = AudioComponentDescription(effect: "awah")

    /// Internal type of audio unit for this node
    public typealias AudioUnitType = AudioUnitBase

    /// Internal audio unit 
    public private(set) var internalAU: AudioUnitType?

    // MARK: - Parameters

    /// Specification details for wah
    public static let wahDef = NodeParameterDef(
        identifier: "wah",
        name: "Wah Amount",
        address: akGetParameterAddress("AutoWahParameterWah"),
        range: 0.0 ... 1.0,
        unit: .percent,
        flags: .default)

    /// Wah Amount
    @Parameter2(wahDef) public var wah: AUValue

    /// Specification details for mix
    public static let mixDef = NodeParameterDef(
        identifier: "mix",
        name: "Dry/Wet Mix",
        address: akGetParameterAddress("AutoWahParameterMix"),
        range: 0.0 ... 1.0,
        unit: .percent,
        flags: .default)

    /// Dry/Wet Mix
    @Parameter2(mixDef) public var mix: AUValue

    /// Specification details for amplitude
    public static let amplitudeDef = NodeParameterDef(
        identifier: "amplitude",
        name: "Overall level",
        address: akGetParameterAddress("AutoWahParameterAmplitude"),
        range: 0.0 ... 1.0,
        unit: .percent,
        flags: .default)

    /// Overall level
    @Parameter2(amplitudeDef) public var amplitude: AUValue

    // MARK: - Initialization

    /// Initialize this autoWah node
    ///
    /// - Parameters:
    ///   - input: Input node to process
    ///   - wah: Wah Amount
    ///   - mix: Dry/Wet Mix
    ///   - amplitude: Overall level
    ///
    public init(
        _ input: Node,
        wah: AUValue = 0.0,
        mix: AUValue = 1.0,
        amplitude: AUValue = 0.1
        ) {
        super.init(avAudioNode: AVAudioNode())

        instantiateAudioUnit { avAudioUnit in
            self.avAudioUnit = avAudioUnit
            self.avAudioNode = avAudioUnit

            guard let audioUnit = avAudioUnit.auAudioUnit as? AudioUnitType else {
                fatalError("Couldn't create audio unit")
            }
            self.internalAU = audioUnit

            self.wah = wah
            self.mix = mix
            self.amplitude = amplitude
        }
        connections.append(input)
    }
}
