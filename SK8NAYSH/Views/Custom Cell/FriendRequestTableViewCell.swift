//
//  FriendRequestTableViewCell.swift
//  SK8NAYSH
//
//  Created by River McCaine on 4/14/21.
//

import UIKit

class FriendRequestTableViewCell: UITableViewCell {
    // MARK: - Outlets
    @IBOutlet weak var playerUsernameLabel: UILabel!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var declineButton: UIButton!
    @IBOutlet weak var actionStackView: UIStackView!
    
    
    // MARK: - Properties
    var friend: Friend?
    var isMenuHidden = true
    
    // MARK: - Helper Methods
    func updateViews() {
        guard let friend = friend else { return }
        playerUsernameLabel.text = friend.friendUsername
        acceptButton.isHidden = false
        if friend.accepted {
            acceptButton.isEnabled = false
            acceptButton.isHidden = true
            declineButton.setTitle("Remove Friend", for: .normal)
        }
        actionStackView.isHidden = isMenuHidden
    }
    
    // MARK: - Actions
    
    @IBAction func menuButtonTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.2) {
            self.actionStackView.isHidden =
                !self.isMenuHidden
        }
        self.isMenuHidden.toggle()
    }
    
    @IBAction func acceptButtonTapped(_ sender: Any) {
        guard let friend = friend else { return }
        
        FriendController.shared.toggledFriendAcceptance(response: true, request: friend) { (result) in
            switch result {
            case .success(_):
                print("Succesfully added \(friend.friendUsername) to friends list.")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    @IBAction func declinedButtonTapped(_ sender: Any) {
        guard let friend = friend else { return }
        
        FriendController.shared.toggledFriendAcceptance(response: false, request: friend) { (result) in
            print("Decline button tapped.")
        }
    }
    
    
} // END OF CLASS
