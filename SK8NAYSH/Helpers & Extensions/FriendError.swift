//
//  FriendError.swift
//  SK8NAYSH
//
//  Created by River McCaine on 3/5/21.
//

import Foundation

enum FriendError: LocalizedError {
    case ckError(Error)
    case noCurrentPlayer
    case failedSavingRequest
    case nilRecord
    case noSiblingFound
    
    var errorDescription: String {
        switch self {
        case .ckError(let error):
            return "Found error while accessing CloudKit: \(error.localizedDescription)"
        case .noCurrentPlayer:
            return "No current player is found"
        case .failedSavingRequest:
            return "Failed saving friend request, try again."
        case .nilRecord:
            return "No record was found associated with this friend. Check creation of friend/player."
        case .noSiblingFound:
            return "No sibling associated with player."
        }
    }
} // end of enum
