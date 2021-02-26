//
//  PlayerError.swift
//  SK8NAYSH
//
//  Created by River McCaine on 2/23/21.
//

import Foundation

enum PlayerError: Error {
    case ckError(Error)
    case unableToUnwrap
    case unexpectedRecordsFound
    case noPlayerLoggedIn
    case noPlayerForGame
    
    var errorDescription: String {
        switch self {
        case .ckError(let error):
            return "Found error while accessing CloudKit: \(error.localizedDescription)"
            
        case .unableToUnwrap:
            return "Could not unwrap data, check model for more information."
            
        case .unexpectedRecordsFound:
            return "Unexpected records found during search for Player. Did not match the expected record."
            
        case .noPlayerLoggedIn:
            return "Player is not currently logged in, check iCloud settings or if playerController methods are being ran."
            
        case .noPlayerForGame:
            return "No player data found to match current game."
        }
    }
} // END OF ENUM
