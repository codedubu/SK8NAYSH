//
//  CloudKitError.swift
//  SK8NAYSH
//
//  Created by River McCaine on 2/23/21.
//

import Foundation

enum CloudKitError: LocalizedError {
    case ckError(Error)
    case unableToUnwrap
    case unexpectedRecordsFound
    case noUserLoggedIn
    
    var errorDescription: String {
        switch self {
        case .ckError(let error):
            return error.localizedDescription
        case .unableToUnwrap:
            return "Unable to retrieve game data."
        case .unexpectedRecordsFound:
            return "Unexpected records returned when trying to delete."
        case .noUserLoggedIn:
            return "User was not found for the current game session."
        }
    }
} // END OF ENUM
