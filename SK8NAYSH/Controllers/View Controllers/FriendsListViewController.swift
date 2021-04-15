//
//  FriendsListViewController.swift
//  SK8NAYSH
//
//  Created by River McCaine on 3/4/21.
//

import UIKit

class FriendsListViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var friendsListTableView: UITableView!
    
    // MARK: - Properties
    var friendArray: [[Friend]] = [[], []]
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.friendsListTableView.delegate = self
        self.friendsListTableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let currentPlayer = PlayerController.shared.currentPlayer else { return }
        
        let allRequestsPredicate = NSPredicate(format: "%K==%@", argumentArray: [FriendStrings.ownerPlayerReferenceKey, currentPlayer.recordID])
        FriendController.shared.fetchRequestsForPlayer(predicate: allRequestsPredicate) { (result) in
            switch result {
            case .success(let friends):
                currentPlayer.friends = friends
                guard let friendArray = currentPlayer.friends else { return }
                
                self.friendArray = [[], []]
                
                for friend in friendArray {
                    if !friend.accepted {
                        self.friendArray[0].append(friend)
                    } else {
                        self.friendArray[1].append(friend)
                    }
                    DispatchQueue.main.async {
                        self.friendsListTableView.reloadData()
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
} // end of class

// MARK: - Extensions
extension FriendsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 10 //PlayerController.shared.friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath)
                
            // cell.textLabel?.text = friends.name
        
        return cell
    }
    
} // END OF EXTENSION
