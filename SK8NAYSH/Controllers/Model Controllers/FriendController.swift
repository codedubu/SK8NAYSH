//
//  FriendController.swift
//  SK8NAYSH
//
//  Created by River McCaine on 3/5/21.
//

import Foundation
import CloudKit

class FriendController {
    // MARK: - Properties
    static let shared = FriendController()
    let publicDB = CKContainer.default().publicCloudDatabase
    
    // MARK: - CRUD Methods
    func createFriendRequest(friendPlayer: Player, completion: @escaping (Result<[Friend]?, FriendError>) -> Void) {
        
        guard let currentPlayer = PlayerController.shared.currentPlayer else { return completion(.failure(.noCurrentPlayer)) }
        let ownerReference = CKRecord.Reference(recordID: currentPlayer.recordID, action: .deleteSelf)
        let friendReference = CKRecord.Reference(recordID: friendPlayer.recordID, action: .deleteSelf)
        let ownerRequest = Friend(ownerPlayerReference: ownerReference, friendPlayerReference: friendReference, friendUsername: friendPlayer.username, ownerDidSend: true, accepted: false, siblingReference: nil)
        let ownerRequestReference = CKRecord.Reference(recordID: ownerRequest.recordID, action: .deleteSelf)
        
        let friendRequest = Friend(ownerPlayerReference: friendReference, friendPlayerReference: ownerReference, friendUsername: currentPlayer.username, ownerDidSend: false, accepted: false, siblingReference: ownerRequestReference)
        let friendRequestReference = CKRecord.Reference(recordID: friendRequest.recordID, action: .deleteSelf)
        
        ownerRequest.siblingReference = friendRequestReference
        
        let ownerRecord = CKRecord(friend: ownerRequest)
        let friendRecord = CKRecord(friend: friendRequest)
        var requests: [Friend] = []
        
        publicDB.save(ownerRecord) { (record, error) in
            if let error = error {
                return completion(.failure(.ckError(error)))
            }
            guard let record = record,
                  let friend = Friend(ckRecord: record) else { return completion (.failure(.nilRecord)) }
            requests.append(friend)
        }
        
        publicDB.save(friendRecord) { (record, error) in
            if let error = error {
                return completion(.failure(.ckError(error)))
            }
            guard let record = record,
                  let friend = Friend(ckRecord: record) else { return completion(.failure(.nilRecord)) }
            requests.append(friend)
        }
        completion(.success(requests))
    }
    
    func fetchRequestsForPlayer(predicate: NSPredicate, completion: @escaping (Result<[Friend]?, FriendError>) -> Void) {
        
        let friendQuery = CKQuery(recordType: FriendStrings.recordType, predicate: predicate)
        
        publicDB.perform(friendQuery, inZoneWith: nil) { (records, error) in
            if let error = error {
                return completion(.failure(.ckError(error)))
            }
            
            guard let records = records else { return completion(.failure(.nilRecord)) }
            let friends = records.compactMap({ Friend(ckRecord:  $0) })
            completion(.success(friends))
        }
    }
    
    func toggledFriendAcceptance(response: Bool, request: Friend, completion: @escaping (Result<[Friend]?, FriendError>) -> Void) {
        
        switch response {
        case true:
            guard !request.ownerDidSend else { return }
            request.accepted = response
            guard let siblingReference = request.siblingReference else { return completion(.failure(.nilRecord)) }
            let siblingPredicate = NSPredicate(format: "%K==%@", argumentArray: ["recordID", siblingReference])
            fetchRequestsForPlayer(predicate: siblingPredicate) { (result) in
                switch result {
                case .success(let friends):
                    guard let friend = friends?.first else { return completion(.failure(.nilRecord)) }
                    friend.accepted = response
                    let ownerRequest = CKRecord(friend: request)
                    let friendRequest = CKRecord(friend: friend)
                    
                    let ownerOperation = CKModifyRecordsOperation(recordsToSave: [ownerRequest], recordIDsToDelete: nil)
                    ownerOperation.savePolicy = .changedKeys
                    ownerOperation.qualityOfService = .userInitiated
                    ownerOperation.modifyRecordsCompletionBlock = { records, _, error in
                        if let error = error {
                            return completion(.failure(.ckError(error)))
                        }
                        guard let records = records else { return completion(.failure(.failedSavingRequest)) }
                        let friendRequests = records.compactMap({ Friend(ckRecord: $0) })
                        completion(.success(friendRequests))
                    }
                    
                    let friendOperation = CKModifyRecordsOperation(recordsToSave: [friendRequest], recordIDsToDelete: nil)
                    friendOperation.savePolicy = .changedKeys
                    friendOperation.qualityOfService = .userInitiated
                    friendOperation.modifyRecordsCompletionBlock = { records, _, error in
                        if let error = error {
                            return completion(.failure(.ckError(error)))
                        }
                        guard let records = records else { return completion(.failure(.failedSavingRequest)) }
                        let friendRequests = records.compactMap({ Friend(ckRecord: $0) })
                        completion(.success(friendRequests))
                        
                    }
                    
                    self.publicDB.add(ownerOperation)
                    self.publicDB.add(friendOperation)
                    
                case .failure(let error):
                    return completion(.failure(.ckError(error)))
                }
            }
            
        case false:
            request.accepted = response
            let operation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: [request.recordID])
            operation.savePolicy = .changedKeys
            operation.qualityOfService = .userInitiated
            operation.modifyRecordsCompletionBlock = { records, _, error in
                if let error = error {
                    return completion(.failure(.ckError(error)))
                }
                guard let records = records else { return completion(.failure(.failedSavingRequest)) }
                let friendRequests = records.compactMap({ Friend(ckRecord: $0) })
                completion(.success(friendRequests))
            }
            self.publicDB.add(operation)
            
        }
    }
} // END OF CLASS
