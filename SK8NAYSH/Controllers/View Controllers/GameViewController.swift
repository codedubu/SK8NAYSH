//
//  GameViewController.swift
//  SK8NAYSH
//
//  Created by River McCaine on 2/24/21.
//

import UIKit

class GameViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var gameListTableView: UITableView!
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Actions
    

    @IBAction func recordButtonTapped(_ sender: Any) {
        
    let imagePickerController = UIImagePickerController()
        
        present(imagePickerController, animated:  true, completion:  nil)
        
    }
    
    
} // END OF CLASS

// MARK: - Extensions
extension GameViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        GameController.shared.games.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gameCell", for: indexPath)
        
        let game = GameController.shared.games[indexPath.row]
        
        cell.textLabel?.text = game.trickName
        
        
        
        // game/video goes in here
        
        return cell
    }
    
    
}
