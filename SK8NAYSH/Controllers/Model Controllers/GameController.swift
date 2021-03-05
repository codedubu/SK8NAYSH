//
//  GameController.swift
//  SK8NAYSH
//
//  Created by River McCaine on 2/24/21.
//

import CloudKit
import AVKit
import MobileCoreServices


class GameController {
    // MARK: - Properties
    static let shared = GameController()
    
    var games: [Game] = []
    let publicDB = CKContainer.default().publicCloudDatabase
    
    // MARK: - Crud Methods
    func createGame(with trickTitle: String, url: URL, completion: @escaping (Result<String, CloudKitError>) -> Void ) {
        
        guard let currentPlayer = PlayerController.shared.currentPlayer else { return completion(.failure(.noUserLoggedIn)) }
        
        let reference = CKRecord.Reference.init(recordID: currentPlayer.recordID, action: .deleteSelf)
        
        let newGame = Game(trickName: trickTitle, timestamp: Date(), playerReference: reference, url: url)
        
        self.games.append(newGame)
        
        let gameRecord = CKRecord()
        
        self.publicDB.save(gameRecord) { (record, error) in
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
                      let savedGame = Game(ckRecord: record) else { return completion(.failure(.unableToUnwrap)) }
                
                self.games.append(savedGame)
                completion(.success("Succesfully saved a Game"))
           
            }
        }
    }
    
    func fetchAllGames(completion: @escaping (Result<String, CloudKitError>) -> Void) {
        
        let fetchallPredicate = NSPredicate(value: true)
        let query = CKQuery(recordType: GameStrings.recordTypeKey, predicate: fetchallPredicate)
        
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
                
                let fetchedGames = records.compactMap { Game(ckRecord:  $0) }
                self.games = fetchedGames
                
                completion(.success("Sucessfull fetched all games."))
                
            }
        }
    }
    
    func fetchGame() {
        
    }
    
    func updateGame() {
        
    }
    
} // END OF CLASS
