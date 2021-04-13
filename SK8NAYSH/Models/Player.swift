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
    fileprivate static let friendReferencesKey = "friendReferences"
    fileprivate static let photoAssetKey = "photoAsset"
} // END OF STRUCT

class Player {
    var username: String
    var friendsList: [Friend]?
    var friendReferences: [CKRecord.Reference]?
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
    
    init(username: String, friendsList: [Friend]?, friendReferences: [CKRecord.Reference]?,  recordID: CKRecord.ID = CKRecord.ID.init(recordName:UUID().uuidString), applePlayerReference: CKRecord.Reference, profilePhoto: UIImage? = nil) {
        self.username = username
        self.friendsList = friendsList
        self.friendReferences = friendReferences
        self.recordID = recordID
        self.applePlayerReference = applePlayerReference
        self.profilePhoto = profilePhoto
    }
    
} // END OF STRUCT

// MARK: - Extensions
extension Player {
    convenience init?(ckRecord: CKRecord) {
        guard let username = ckRecord[PlayerStrings.usernameKey] as? String,
              let applePlayerReference = ckRecord[PlayerStrings.applePlayerReferenceKey] as? CKRecord.Reference  else { return nil }
             
        var foundPhoto: UIImage?
        
        if let photoAsset = ckRecord[PlayerStrings.photoAssetKey] as? CKAsset {
            do {
                let data = try Data(contentsOf: photoAsset.fileURL!)
                foundPhoto = UIImage(data: data)
            } catch {
                print("Could not convert photo asset into CloudKit data")
            }
        }
        
        let friendReferences = ckRecord[PlayerStrings.friendReferencesKey] as? [CKRecord.Reference]
        
        self.init(username: username, friendsList: nil, friendReferences: friendReferences,recordID: ckRecord.recordID, applePlayerReference: applePlayerReference, profilePhoto: foundPhoto)
    }
} // END OF STRUCT

extension Player: Equatable {
    static func == (lhs: Player, rhs: Player) -> Bool {
        lhs.recordID == rhs.recordID
    }
} // END OF STRUCT

extension CKRecord {
    convenience init(player: Player) {
        self.init(recordType: PlayerStrings.recordTypeKey, recordID: player.recordID)
        
        setValuesForKeys([
            PlayerStrings.usernameKey : player.username,
            PlayerStrings.applePlayerReferenceKey : player.applePlayerReference
//            PlayerStrings.photoAssetKey : player.photoAsset
        ])
        
        if let friendReferences = player.friendReferences {
            self.setValue(friendReferences, forKey: PlayerStrings.friendReferencesKey)
        }
    }
} // END OF STRUCT
