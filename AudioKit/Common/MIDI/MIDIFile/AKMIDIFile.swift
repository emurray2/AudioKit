//
//  AKMIDIFile.swift
//  AudioKit
//
//  Created by Jeff Cooper on 11/5/18.
//  Copyright © 2018 AudioKit. All rights reserved.
//

import Foundation

public struct AKMIDIFile {
    public var chunks: [AKMIDIFileChunk] = []

    public var tracks: [AKMIDITrack] {
        return trackChunks.compactMap({ AKMIDITrack(chunk: $0) })
    }

    public var format: Int {
        return header?.format ?? 0
    }

    public var numberOfTracks: Int {
        return header?.numTracks ?? 0
    }

    public var timeFormat: MIDITimeFormat? {
        return header?.timeFormat ?? nil
    }

    public var ticksPerBeat: Int? {
        return header?.ticksPerBeat
    }

    public var framesPerSecond: Int? {
        return header?.framesPerSecond
    }

    public var ticksPerFrame: Int? {
        return header?.ticksPerFrame
    }

    public var timeDivision: UInt16 {
        return header?.timeDivision ?? 0
    }

    var header: MIDIFileHeaderChunk? {
        return chunks.first(where: { $0.isHeader }) as? MIDIFileHeaderChunk
    }
    var trackChunks: [MIDIFileTrackChunk] {
        return Array(chunks.drop(while: { $0.isHeader && $0.isValid })) as? [MIDIFileTrackChunk] ?? []
    }

    public init(url: URL) {
        if let midiData = try? Data(contentsOf: url) {
            let dataSize = midiData.count
            let typeLength = 4
            var typeIndex = 0
            let sizeLength = 4
            var sizeIndex = 0
            var dataLength = 0
            var chunks = [AKMIDIFileChunk]()
            var currentTypeChunk: [UInt8] = Array(repeating: 0, count: 4)
            var currentLengthChunk: [UInt8] = Array(repeating: 0, count: 4)
            var currentDataChunk: [UInt8] = []
            var newChunk = true
            var isParsingType = false
            var isParsingLength = false
            var isParsingHeader = true
            for i in 0..<dataSize {
                if newChunk {
                    isParsingType = true
                    isParsingLength = false
                    newChunk = false
                    currentTypeChunk = Array(repeating: 0, count: 4)
                    currentLengthChunk = Array(repeating: 0, count: 4)
                    currentDataChunk = []
                }
                if isParsingType { //get chunk type
                    currentTypeChunk[typeIndex] = midiData[i]
                    typeIndex += 1
                    if typeIndex == typeLength {
                        isParsingType = false
                        isParsingLength = true
                        typeIndex = 0
                    }
                } else if isParsingLength { //get chunk length
                    currentLengthChunk[sizeIndex] = midiData[i]
                    sizeIndex += 1
                    if sizeIndex == sizeLength {
                        isParsingLength = false
                        sizeIndex = 0
                        dataLength = Int(currentLengthChunk.map(String.init).joined()) ?? 0
                    }
                } else { //get chunk data
                    var tempChunk: AKMIDIFileChunk
                    currentDataChunk.append(midiData[i])
                    if UInt8(currentDataChunk.count) == dataLength {
                        if isParsingHeader {
                            tempChunk = MIDIFileHeaderChunk(typeData: currentTypeChunk,
                                                            lengthData: currentLengthChunk, data: currentDataChunk)
                        } else {
                            tempChunk = MIDIFileTrackChunk(typeData: currentTypeChunk,
                                                           lengthData: currentLengthChunk, data: currentDataChunk)
                        }
                        newChunk = true
                        isParsingHeader = false
                        chunks.append(tempChunk)
                    }
                }
            }
            self.chunks = chunks
        }
    }

    public init(path: String) {
        self.init(url: URL(fileURLWithPath: path))
    }
}
