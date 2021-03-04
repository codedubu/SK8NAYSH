//
//  GameViewController.swift
//  SK8NAYSH
//
//  Created by River McCaine on 2/24/21.
//

import UIKit
import AVKit
import MobileCoreServices

class GameViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK: - Outlets
    @IBOutlet weak var gameListTableView: UITableView!
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Actions
    
    
    @IBAction func recordButtonTapped(_ sender: Any) {
        
        VideoHelper.startMediaBrowser(delegate: self, sourceType: .camera)
    }
    
    @objc func video(
      _ videoPath: String,
      didFinishSavingWithError error: Error?,
      contextInfo info: AnyObject
    ) {
      let title = (error == nil) ? "Success" : "Error"
      let message = (error == nil) ? "Video was saved" : "Video failed to save"

      let alert = UIAlertController(
        title: title,
        message: message,
        preferredStyle: .alert)
      alert.addAction(UIAlertAction(
        title: "OK",
        style: UIAlertAction.Style.cancel,
        handler: nil))
      present(alert, animated: true, completion: nil)
        
        print(" this is the \(videoPath)")
    }
    
    
    @IBAction func sendVideoButtonTapped(_ sender: Any) {
        
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.delegate = self
        imagePickerController.mediaTypes = [kUTTypeMovie as String]
        
        present(imagePickerController, animated:  true, completion:  nil)
        
        
    }
    
    // MARK: - Helper Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
//        dismiss(animated: true, completion: nil)
        
        
        // uhhhh...maybe?
//        if let pickedVideo = info[.mediaURL] as? AVAsset {
//        }
    
        
        guard let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String,
              mediaType == (kUTTypeMovie as String),
              // 1
              let url = info[UIImagePickerController.InfoKey.mediaURL] as? URL,
              // 2
              let movieData = try? Data(contentsOf: url)
        
        GameController.shared.createGame(with: <#T##String#>, video: <#T##AVAsset?#>, completion: <#T##(Result<String, CloudKitError>) -> Void#>)
        
        else { return }

        
//              UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(url.path)
        print("media was hit")
        
        // 3
//        UISaveVideoAtPathToSavedPhotosAlbum(
//          url.path,
//          self,
//          #selector(video(_:didFinishSavingWithError:contextInfo:)),
//          nil)
      }
        
//        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
//
//        if let videoURL = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.mediaURL)] as? URL {
//
//            print("selected video!")
//        }
//        dismiss(animated: true, completion: nil)
    
    
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



// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
    guard let input = input else { return nil }
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
    return input.rawValue
}

