//
//  GameViewController.swift
//  SK8NAYSH
//
//  Created by River McCaine on 2/24/21.
//

import UIKit
import AVKit
import MobileCoreServices
import Photos

class TrickViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK: - Outlets
    @IBOutlet weak var trickListTableView: UITableView!
    @IBOutlet weak var trickThumbnailImageView: UIImageView!
    
    // MARK: - Properties
    var avAsset: AVAsset? {
        didSet {
            print("avAsset hit")
        }
    }
    
    var dataURL: URL? {
        didSet {
            print("dataURL hit")
        }
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        trickListTableView.delegate = self
        trickListTableView.dataSource = self
        
        fetchTricks()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        trickListTableView.reloadData()
    }
    
    // MARK: - Actions
    @IBAction func recordButtonTapped(_ sender: Any) {
        VideoHelper.startMediaBrowser(delegate: self, sourceType: .photoLibrary)
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
        
        guard let avAsset = avAsset,
              let url = dataURL else { return }
        let urlString = url.absoluteString
        
        TrickController.shared.createTrick(with: "Gnarly Shuvvy", video: avAsset, dataURL: urlString) { (result) in
            switch result {
            case .success(let response):
                print(response)
                self.trickListTableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: - Helper Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let gThang = info[.mediaURL] as? AVAsset {
            print("Got the URL path for the AVAsset: \(gThang)")
        }
        
        if let videoURL = info[.mediaURL] as? NSURL {
            print(videoURL)
            do {
                guard let url = videoURL as URL? else {return}
                let asset = AVURLAsset(url: url, options: nil)
                self.dataURL = url
                self.avAsset = asset
                
                let imgGenerator = AVAssetImageGenerator(asset: asset)
                imgGenerator.appliesPreferredTrackTransform = true
                let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
                let thumbnail = UIImage(cgImage: cgImage)
                trickThumbnailImageView.image = thumbnail
            } catch let error {
                print("Error generating thumbnail: \(error.localizedDescription)")
            }
        } else {
            print("Unable to generate thumbnail.")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Helper Methods
    func fetchTricks() {
        TrickController.shared.fetchAllTricks { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    print("Successfully fetched all tricks")
                    self.trickListTableView.reloadData()
                case .failure(let error):
                    print("Error while fetching tricks: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAVPlayerVC" {
            guard let indexPath = trickListTableView.indexPathForSelectedRow,
                  let destination = segue.destination as? SkateVideoPlayerViewController else {return}
            let trick = TrickController.shared.tricks[indexPath.row]
            destination.trick = trick
        }
    }
    
} // END OF CLASS

// MARK: - Extensions
extension TrickViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        TrickController.shared.tricks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "trickCell", for: indexPath)
        let trick = TrickController.shared.tricks[indexPath.row]
        
        cell.textLabel?.text = trick.trickName
        
        return cell
    }
    
} // END OF EXTENSION

