//
//  GameController.swift
//  SK8NAYSH
//
//  Created by River McCaine on 2/24/21.
//

import CloudKit
import AVKit
import MobileCoreServices


class TrickController {
    // MARK: - Properties
    static let shared = TrickController()
    var tricks: [Trick] = []
    let publicDB = CKContainer.default().publicCloudDatabase
    
    // MARK: - CRUD Methods
    func createTrick(with trickTitle: String, video: AVAsset?, dataURL: String?, completion: @escaping (Result<String, CloudKitError>) -> Void ) {
        
        guard let currentPlayer = PlayerController.shared.currentPlayer else { return completion(.failure(.noUserLoggedIn)) }
        
        let reference = CKRecord.Reference.init(recordID: currentPlayer.recordID, action: .deleteSelf)
        
        let newTrick = Trick(trickName: trickTitle, timestamp: Date(), playerReference: reference, dataURL: dataURL, skateVideo: video)
        
        let trickRecord = CKRecord(trick: newTrick)
        
        self.publicDB.save(trickRecord) { (record, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print("""
                ========= ERROR =========
                Function: \(#function)
                Error: \(error)
                Description: \(error.localizedDescription)
                ========= ERROR =========
                """)
                    return completion(.failure(.ckError(error)))
                }
                
                guard let record = record,
                      let savedGame = Trick(ckRecord: record) else { return completion(.failure(.unableToUnwrap)) }
                
                self.tricks.append(savedGame)
                completion(.success("Succesfully saved a Game"))
                
            }
        }
    }
    
    func fetchAllTricks(completion: @escaping (Result<String, CloudKitError>) -> Void) {
        
        let fetchAllPredicate = NSPredicate(value: true)
        let query = CKQuery(recordType: TrickStrings.recordTypeKey, predicate: fetchAllPredicate)
        
        publicDB.perform(query, inZoneWith: nil) { (records, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print("""
                ========= ERROR =========
                Function: \(#function)
                Error: \(error)
                Description: \(error.localizedDescription)
                ========= ERROR =========
                """)
                    completion(.failure(.ckError(error)))
                }
                
                guard let records = records else { return completion(.failure(.unableToUnwrap)) }
                
                let fetchedTricks = records.compactMap { Trick(ckRecord:  $0) }
                self.tricks = fetchedTricks
                print(self.tricks.count)
                completion(.success("Sucessfull fetched all tricks."))
                
            }
        }
    }
    
    func fetchGame() {
        
    }
    
    func updateGame() {
        
    }
    
} // END OF CLASS
