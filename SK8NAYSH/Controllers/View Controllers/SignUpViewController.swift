//
//  SignUpViewController.swift
//  SK8NAYSH
//
//  Created by River McCaine on 2/22/21.
//

import UIKit

class SignUpViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var signMeUpButton: UIButton!
    
    // MARK: - Properties
    var isNewPlayer = true
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPlayer()
    }
    
    // MARK: - Actions
    @IBAction func loginButtonTapped(_ sender: Any) {
        isNewPlayer = false
        self.confirmPasswordTextField.isHidden = true
        
    }
    
    @IBAction func signupButtonTapped(_ sender: Any) {
        isNewPlayer = true
        self.confirmPasswordTextField.isHidden = false
        
    }
    
    @IBAction func signMeUpButtonTapped(_ sender: Any) {
        
        guard let username = usernameTextField.text, !username.isEmpty else { return }
        
        PlayerController.shared.createPlayerWith(username) { (result) in
            switch result {
            case .success(let player):
                guard let player = player else { return }
                PlayerController.shared.currentPlayer = player
                self.presentSkateGameVC()
            case .failure(let error):
                print(error.errorDescription)
            }
        }
        
    }
    
    // MARK: - Helper Methods
    func fetchPlayer() {
        PlayerController.shared.fetchPlayer { (result) in
            switch result {
            case .success(let player):
                PlayerController.shared.currentPlayer = player
                print("Succesfully fetched player")
                self.presentSkateGameVC()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func presentSkateGameVC() {
        DispatchQueue.main.async {
        let gameStoryboard = UIStoryboard(name: "SkateGame", bundle: nil)
        
            guard let gameViewController = gameStoryboard.instantiateInitialViewController() else { return }
            
            gameViewController.modalPresentationStyle = .fullScreen
            self.present(gameViewController, animated: true)
        }
    }
} // END OF CLASS
