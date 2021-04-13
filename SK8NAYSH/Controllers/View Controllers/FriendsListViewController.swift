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
    
    
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.friendsListTableView.delegate = self
        self.friendsListTableView.delegate = self
        
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
