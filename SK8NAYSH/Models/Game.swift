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
    
    
} // END OF STRUCT
class Game {
    var player: Player?
    var trickName: String
    var timestamp: Date
    let recordID: CKRecord.ID
    var playerReference: CKRecord.Reference?
    var url: URL?
    var videoAsset: CKAsset? {
        get {
            guard let videoURL = url else { return nil }
            return CKAsset(fileURL: videoURL)
         
        }
        set {
            url = newValue?.fileURL
        }
    }
    
    
    init(trickName: String, timestamp: Date = Date(),recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString), playerReference: CKRecord.Reference?, url: URL) {
        self.trickName = trickName
        self.timestamp = timestamp
        self.recordID = recordID
        self.playerReference = playerReference
        self.url = url
    }

    
    
    // MARK: - Extensions
 
    
    init?(ckRecord: CKRecord) {
        guard let trickName = ckRecord[GameStrings.trickNameKey] as? String,
              let timestamp = ckRecord[GameStrings.timestampKey] as? Date,
              let playerReference = ckRecord[GameStrings.playerReferenceKey] as? CKRecord.Reference,
              let videoAsset = ckRecord[GameStrings.videoAssetKey] as? CKAsset else { return nil }
        
        self.trickName = trickName
        self.timestamp = timestamp
        self.recordID = ckRecord.recordID
        self.playerReference = playerReference
        self.videoAsset = videoAsset
        
    }

}

/// `Future Keys`

// fileprivate static let SKATELettersReferenceKey = "SKATELettersReference"
// fileprivate static let waitingPlayer: String?
// fileprivate static let currentPlayer: String?
