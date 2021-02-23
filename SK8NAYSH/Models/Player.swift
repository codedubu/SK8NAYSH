//
//  Player.swift
//  SK8NAYSH
//
//  Created by River McCaine on 2/22/21.
//

import CloudKit
import UIKit

struct PlayerStrings {
    static let recordTypeKey = "Player"
    static let applePlayerReferenceKey = "applePlayerReference"
    fileprivate static let usernameKey = "username"
    fileprivate static let photoAssetKey = "photoAsset"
} // END OF STRUCT

class Player {
    var username: String
    var recordID: CKRecord.ID
    var applePlayerReference: CKRecord.Reference
    var photoData: Data?
    
    var profilePhoto: UIImage? {
        get {
            guard let photoData = self.photoData else { return nil }
            return UIImage(data: photoData)
        } set {
            photoData = newValue?.jpegData(compressionQuality: 0.5)
        }
    }
    
    var photoAsset: CKAsset {
        get {
          
            let tempDirectory = NSTemporaryDirectory()
            let tempDirectoryURL = URL(fileURLWithPath: tempDirectory)
            let fileURL = tempDirectoryURL.appendingPathComponent(UUID().uuidString).appendingPathExtension("jpg")
            
            do {
                try photoData?.write(to: fileURL)
            } catch {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            }
            return CKAsset(fileURL: fileURL)
        }
    }
    
    init(username: String, recordID: CKRecord.ID = CKRecord.ID.init(recordName:UUID().uuidString), applePlayerReference: CKRecord.Reference, profilePhoto: UIImage? = nil) {
        self.username = username
        self.recordID = recordID
        self.applePlayerReference = applePlayerReference
        self.profilePhoto = profilePhoto
    }
} // END OF CLASS

// MARK: - Extensions

extension Player {
    convenience init?(ckRecord: CKRecord) {
        guard let username = ckRecord[PlayerStrings.usernameKey] as? String,
              let applePlayerReference = ckRecord[PlayerStrings.applePlayerReferenceKey] as? CKRecord.Reference else { return nil }
        
        var foundPhoto: UIImage?
        
        if let photoAsset = ckRecord[PlayerStrings.photoAssetKey] as? CKAsset {
            do {
                let data = try Data(contentsOf: photoAsset.fileURL!)
                foundPhoto = UIImage(data: data)
            } catch {
                print("Could not convert photo asset into CloudKit data")
            }
        }
        
        self.init(username: username, recordID: ckRecord.recordID, applePlayerReference: applePlayerReference, profilePhoto: foundPhoto)
    }
} // END OF EXTENSION

extension Player: Equatable {
    
    static func == (lhs: Player, rhs: Player) -> Bool {
        lhs.recordID == rhs.recordID
    }
    
} // END OF EXTENSION

extension CKRecord {
    convenience init(player: Player) {
        self.init(recordType: PlayerStrings.recordTypeKey, recordID: player.recordID)
        
        setValuesForKeys([
            PlayerStrings.usernameKey : player.username,
            PlayerStrings.applePlayerReferenceKey : player.applePlayerReference,
            PlayerStrings.photoAssetKey : player.photoAsset
        ])
    }
} // END OF EXTENSION
