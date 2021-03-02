//
//  PlayerController.swift
//  SK8NAYSH
//
//  Created by River McCaine on 2/23/21.
//

import CloudKit


class PlayerController {
    // MARK: - Properties
    static let shared = PlayerController()
    var currentPlayer: Player?
    let publicDB = CKContainer.default().publicCloudDatabase
    
    // MARK: - CRUD Methods
    func createPlayerWith(_ username: String, completion: @escaping(Result<Player?, PlayerError>) -> Void) {
        fetchApplePlayerReference { (result) in
            
            print("hello world")
            
            switch result {
            case .success(let reference):
                guard let reference = reference else { return completion(.failure(.noPlayerLoggedIn)) }
                
                let newPlayer = Player(username: username, applePlayerReference: reference)
                
                let record = CKRecord(player: newPlayer)
                
                self.publicDB.save(record) { (record, error) in
                    
                    if let error = error {
                        print("Error: \(error.localizedDescription) : \(error)")
                        return completion(.failure(.ckError(error)))
                    }
                    
                    print("got it")
                    
                    guard let record = record else { return completion(.failure(.unexpectedRecordsFound)) }
                    guard let savedPlayer = Player(ckRecord: record) else { return completion(.failure(.unableToUnwrap)) }
                    
                    completion(.success(savedPlayer))
                    print("Sucessfully created Player: \(record.recordID.recordName)")
                }
                
            case .failure(let error):
                print("There was an error while creating a Player: \(error.errorDescription)")
            }

        }
    } // END OF FUNC
    
    func fetchPlayer(completion: @escaping(Result<Player?, PlayerError>) -> Void) {
        
        fetchApplePlayerReference { (result) in
            switch result {
            case .success(let reference):
                guard let reference = reference else { return completion(.failure(.noPlayerLoggedIn)) }
                
                let predicate = NSPredicate(format: "%K == %@", argumentArray: [PlayerStrings.applePlayerReferenceKey, reference])
                
                let query = CKQuery(recordType: PlayerStrings.recordTypeKey, predicate: predicate)
                
                self.publicDB.perform(query, inZoneWith: nil) { (records, error) in
                    if let error = error {
                        return completion(.failure(.ckError(error)))
                    }
                    
                    guard let record = records?.first else { return completion(.failure(.unexpectedRecordsFound)) }
                    guard let foundPlayer = Player(ckRecord: record) else { return completion(.failure(.unableToUnwrap)) }
                    
                    print("Fetched player: \(record.recordID.recordName)")
                    completion(.success(foundPlayer))
                }
                
            case .failure(let error):
                print("There was an error while fetching the player: \(error.errorDescription)")
            }
        }
    } // END OF FUNC
    
     private func fetchApplePlayerReference(completion: @escaping(Result<CKRecord.Reference?, PlayerError>) -> Void) {
        CKContainer.default().fetchUserRecordID { (recordID, error) in
            if let error = error {
                completion(.failure(.ckError(error)))
            }
            
            if let recordID = recordID {
                let reference = CKRecord.Reference(recordID: recordID, action: .deleteSelf)
                
                completion(.success(reference))
            }
        }
    }
} // END OF CLASS
