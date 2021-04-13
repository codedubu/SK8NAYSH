//
//  Game.swift
//  SK8NAYSH
//
//  Created by River McCaine on 2/22/21.
//

import CloudKit
import UIKit
import AVKit

struct TrickStrings {
    static let recordTypeKey = "Trick"
    fileprivate static let playerReferenceKey = "playerReference"
    fileprivate static let trickNameKey = "trickName"
    fileprivate static let videoAssetKey = "videoAsset"
    fileprivate static let timestampKey = "timestamp"
    fileprivate static let dataURLKey = "dataURL"
    
    /// `Future Keys`
    // fileprivate static let SKATELettersReferenceKey = "SKATELettersReference"
    // fileprivate static let waitingPlayer: String?
    // fileprivate static let currentPlayer: String?
    
} // END OF STRUCT

class Trick {
    var player: Player?
    var trickName: String
    var timestamp: Date
    let recordID: CKRecord.ID
    var playerReference: CKRecord.Reference?
    var dataURL: String?
    // thumbnail
    
    var avData: Data?
    var skateVideo: AVAsset? {
        get {
            guard avData != nil else { return nil }
            guard let avData = self.avData else { return nil }
            return avData.getAVAsset()
        } set {
            guard let urlString = dataURL,
                  let url = URL(string: urlString) else { return }
            avData = try? Data(contentsOf: url)
        }
    }
    
    var avAsset: CKAsset? {
        get {
            guard avData != nil else { return nil }
            let tempDirectory = NSTemporaryDirectory()
            let tempDirectoryURL = URL(fileURLWithPath: tempDirectory)
            let fileURL =
                tempDirectoryURL.appendingPathComponent(UUID().uuidString).appendingPathExtension("mov")
            
            do {
                try avData?.write(to: fileURL)
            } catch {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            }
            return CKAsset(fileURL: fileURL)
        }
    }
    
    init(trickName: String, timestamp: Date = Date(),recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString), playerReference: CKRecord.Reference?, dataURL: String?, skateVideo: AVAsset? = nil) {
        self.trickName = trickName
        self.timestamp = timestamp
        self.recordID = recordID
        self.playerReference = playerReference
        self.dataURL = dataURL
        self.skateVideo = skateVideo
    }
} // END OF CLASS

// MARK: - Extensions
extension Trick {
    convenience init?(ckRecord: CKRecord) {
        guard let trickName = ckRecord[TrickStrings.trickNameKey] as? String,
              let timestamp = ckRecord[TrickStrings.timestampKey] as? Date,
              let _ = ckRecord[TrickStrings.dataURLKey] as? String else { return nil }
        
        let playerReference = ckRecord[TrickStrings.playerReferenceKey] as? CKRecord.Reference
        
        var foundData: Data?
        var assetURL: URL?
        
        if let videoAsset = ckRecord[TrickStrings.videoAssetKey] as? CKAsset {
            do {
                assetURL = videoAsset.fileURL
                let data = try Data(contentsOf: videoAsset.fileURL!)
                foundData = data
            } catch {
                print("Could not transform video into CloudKit data.")
            }
        }
        self.init(trickName: trickName, timestamp: timestamp, recordID: ckRecord.recordID, playerReference: playerReference, dataURL: assetURL?.absoluteString, skateVideo: foundData?.getAVAsset())
    }
} // END OF EXTENSION

extension CKRecord {
    convenience init(trick: Trick) {
        self.init(recordType: TrickStrings.recordTypeKey, recordID: trick.recordID)
        self.setValuesForKeys([
            TrickStrings.trickNameKey : trick.trickName,
            TrickStrings.timestampKey : trick.timestamp,
        ])
        
        if let url = trick.dataURL {
            setValue(url, forKey: TrickStrings.dataURLKey)
        }
        
        if let reference = trick.playerReference {
            setValue(reference, forKey: TrickStrings.playerReferenceKey)
        }
        
        if trick.avAsset != nil {
            setValue(trick.avAsset, forKey: TrickStrings.videoAssetKey)
        }
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
