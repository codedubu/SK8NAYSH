//
//  Game.swift
//  SK8NAYSH
//
//  Created by River McCaine on 2/22/21.
//

import CloudKit
import UIKit
import AVKit

struct GameStrings {
    static let recordTypeKey = "Game"
    fileprivate static let playerReferenceKey = "playerReference"
    fileprivate static let trickNameKey = "trickName"
    fileprivate static let videoAssetKey = "videoAsset"
    fileprivate static let timestampKey = "timestamp"
    
    
    /// `Future Keys`
    
    // fileprivate static let SKATELettersReferenceKey = "SKATELettersReference"
    // fileprivate static let fromPlayer: String?
    // fileprivate static let toPlayer: String?
    // fileprivate static let currentTurn: Bool
} // END OF STRUCT

class Game {
    var player: Player?
    var trickName: String
    var timestamp: Date
    let recordID: CKRecord.ID
    var playerReference: CKRecord.Reference?
    
    var avData: Data?
    var skateVideo: AVAsset? {
        get {
            guard let avData = self.avData else { return nil }
            return avData.getAVAsset()
        } set {
            guard let session = AVAssetExportSession(asset: newValue!, presetName: AVAssetExportPresetHighestQuality),
                  let url = session.outputURL else { return }
            avData = try? Data(contentsOf: url)
        }
    }
    
    var avAsset: CKAsset {
        get {
            let tempDirectory = NSTemporaryDirectory()
            let tempDirectoryURL = URL(fileURLWithPath: tempDirectory)
            let fileURL = tempDirectoryURL.appendingPathComponent(UUID().uuidString).appendingPathExtension("mov")
            
            do {
                try avData?.write(to: fileURL)
            } catch {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            }
            return CKAsset(fileURL: fileURL)
        }
    }
    
    init(trickName: String, timestamp: Date = Date(),recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString), playerReference: CKRecord.Reference?, skateVideo: AVAsset? = nil) {
        self.trickName = trickName
        self.timestamp = timestamp
        self.recordID = recordID
        self.playerReference = playerReference
        self.skateVideo = skateVideo
    }
} // END OF CLASS

// MARK: - Extensions

extension Game {
    convenience init?(ckRecord: CKRecord) {
        guard let trickName = ckRecord[GameStrings.trickNameKey] as? String,
              let timestamp = ckRecord[GameStrings.timestampKey] as? Date else { return nil }
        
        let playerReference = ckRecord[GameStrings.playerReferenceKey] as? CKRecord.Reference
        
        var foundData: Data?
        
        if let videoAsset = ckRecord[GameStrings.videoAssetKey] as? CKAsset {
            do {
                let data = try Data(contentsOf: videoAsset.fileURL!)
                foundData = data
            } catch {
                print("Could not transform video into CloudKit data.")
            }
        }
        self.init(trickName: trickName, timestamp: timestamp, recordID: ckRecord.recordID, playerReference: playerReference, skateVideo: foundData?.getAVAsset())
    }
} // END OF EXTENSION

extension CKRecord {
    convenience init(game: Game) {
        self.init(recordType: GameStrings.recordTypeKey, recordID: game.recordID)
        self.setValuesForKeys([
            GameStrings.trickNameKey : game.trickName,
            GameStrings.timestampKey : game.timestamp,
        ])
        
        if let reference = game.playerReference {
            setValue(reference, forKey: GameStrings.playerReferenceKey)
        }
        
        if game.skateVideo != nil {
            setValue(game.skateVideo, forKey: GameStrings.videoAssetKey)
        }
    }
} // END OF EXTENSION

extension Game: Equatable {
    static func == (lhs: Game, rhs: Game) -> Bool {
        return lhs.recordID == rhs.recordID
    }
} // END OF EXTENSION

extension Data {
    func getAVAsset() -> AVAsset? {
        let directory = NSTemporaryDirectory()
        let fileName = "\(NSUUID().uuidString).mov"
        guard let fullURL = NSURL.fileURL(withPathComponents: [directory, fileName]) else { return nil }
        try? self.write(to: fullURL)
        let asset = AVAsset(url: fullURL)
        return asset
    }
} // END OF EXTENSION
