//
//  Friend.swift
//  SK8NAYSH
//
//  Created by River McCaine on 3/5/21.
//

import Foundation
import CloudKit

struct FriendStrings {
    static let recordType = "Friend"
    static let ownerPlayerReferenceKey = "ownerPlayerReference"
    fileprivate static let friendPlayerReferenceKey = "friendPlayerReference"
    fileprivate static let friendUsernameKey = "friendUsername"
    fileprivate static let ownerDidSendKey = "ownerDidSend"
    fileprivate static let acceptedKey = "accepted"
    static let siblingReferenceKey = "siblingReference"
} // END OF STRUCT

class Friend {
    var ownerPlayerReference: CKRecord.Reference
    var friendPlayerReference: CKRecord.Reference
    var friendUsername: String
    var ownerDidSend: Bool
    var accepted: Bool
    var siblingReference: CKRecord.Reference?
    var recordID: CKRecord.ID
    
    init(ownerPlayerReference: CKRecord.Reference, friendPlayerReference: CKRecord.Reference, friendUsername: String, ownerDidSend: Bool, accepted: Bool, siblingReference: CKRecord.Reference? = nil, recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        
        self.ownerPlayerReference = ownerPlayerReference
        self.friendPlayerReference = friendPlayerReference
        self.friendUsername = friendUsername
        self.ownerDidSend = ownerDidSend
        self.accepted = accepted
        self.siblingReference = siblingReference
        self.recordID = recordID
    }
} // END OF CLASS

// MARK: - Extensions
extension Friend {
    convenience init?(ckRecord: CKRecord) {
        guard let ownerPlayerReference = ckRecord[FriendStrings.ownerPlayerReferenceKey] as? CKRecord.Reference,
              let friendPlayerReference = ckRecord[FriendStrings.friendPlayerReferenceKey] as? CKRecord.Reference,
              let friendUsername = ckRecord[FriendStrings.friendUsernameKey] as? String,
              let ownerDidSend = ckRecord[FriendStrings.ownerDidSendKey] as? Bool,
              let accepted = ckRecord[FriendStrings.acceptedKey] as? Bool else { return nil }
        
        let siblingReference = ckRecord[FriendStrings.siblingReferenceKey] as? CKRecord.Reference
        
        self.init(ownerPlayerReference: ownerPlayerReference, friendPlayerReference: friendPlayerReference, friendUsername: friendUsername, ownerDidSend: ownerDidSend, accepted: accepted, siblingReference: siblingReference, recordID: ckRecord.recordID)
    }
} // END OF EXTENSION

extension CKRecord {
    convenience init(friend: Friend) {
        
        self.init(recordType: FriendStrings.recordType, recordID: friend.recordID)
        
        setValuesForKeys([
            FriendStrings.ownerPlayerReferenceKey : friend.ownerPlayerReference,
            FriendStrings.friendPlayerReferenceKey : friend.friendPlayerReference,
            FriendStrings.friendUsernameKey : friend.friendUsername,
            FriendStrings.acceptedKey : friend.accepted
        ])
        
        if let siblingReference = friend.siblingReference {
            self.setValue(siblingReference, forKey: FriendStrings.siblingReferenceKey)
        }
    }
} // END OF EXTENSION

