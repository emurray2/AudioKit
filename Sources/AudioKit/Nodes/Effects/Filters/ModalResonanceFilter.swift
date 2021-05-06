// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/AudioKit/
// This file was auto-autogenerated by scripts and templates at http://github.com/AudioKit/AudioKitDevTools/

import AVFoundation
import CAudioKit

/// A modal resonance filter used for modal synthesis. Plucked and bell sounds can be created
/// using  passing an impulse through a combination of modal filters.
/// 
public class ModalResonanceFilter: Node, AudioUnitContainer, Toggleable {

    /// Unique four-letter identifier "modf"
    public static let ComponentDescription = AudioComponentDescription(effect: "modf")

    /// Internal type of audio unit for this node
    public typealias AudioUnitType = AudioUnitBase

    /// Internal audio unit 
    public private(set) var internalAU: AudioUnitType?

    // MARK: - Parameters

    /// Specification details for frequency
    public static let frequencyDef = NodeParameterDef(
        identifier: "frequency",
        name: "Resonant Frequency (Hz)",
        address: akGetParameterAddress("ModalResonanceFilterParameterFrequency"),
        range: 12.0 ... 20_000.0,
        unit: .hertz,
        flags: .default)

    /// Resonant frequency of the filter.
    @Parameter2(frequencyDef) public var frequency: AUValue

    /// Specification details for qualityFactor
    public static let qualityFactorDef = NodeParameterDef(
        identifier: "qualityFactor",
        name: "Quality Factor",
        address: akGetParameterAddress("ModalResonanceFilterParameterQualityFactor"),
        range: 0.0 ... 100.0,
        unit: .generic,
        flags: .default)

    /// Quality factor of the filter. Roughly equal to Q/frequency.
    @Parameter2(qualityFactorDef) public var qualityFactor: AUValue

    // MARK: - Initialization

    /// Initialize this filter node
    ///
    /// - Parameters:
    ///   - input: Input node to process
    ///   - frequency: Resonant frequency of the filter.
    ///   - qualityFactor: Quality factor of the filter. Roughly equal to Q/frequency.
    ///
    public init(
        _ input: Node,
        frequency: AUValue = 500.0,
        qualityFactor: AUValue = 50.0
        ) {
        super.init(avAudioNode: AVAudioNode())

        instantiateAudioUnit { avAudioUnit in
            self.avAudioUnit = avAudioUnit
            self.avAudioNode = avAudioUnit

            guard let audioUnit = avAudioUnit.auAudioUnit as? AudioUnitType else {
                fatalError("Couldn't create audio unit")
            }
            self.internalAU = audioUnit

            self.frequency = frequency
            self.qualityFactor = qualityFactor
        }
        connections.append(input)
    }
}
