//
//  SkateVideoPlayerViewController.swift
//  SK8NAYSH
//
//  Created by River McCaine on 3/7/21.
//

import UIKit
import AVKit
import AVFoundation

class SkateVideoPlayerViewController: AVPlayerViewController {
    // MARK: - Properties
    var trick: Trick? {
        didSet {
            print("Trick has been accessed")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.loadView()
        playSkateVideo()
    }
    
    // MARK: - Helper Methods
    func playSkateVideo() {
        guard let trick = trick,
              let asset = trick.avAsset,
              let fileURL = asset.fileURL else { return }
        
        let videoPlayer = AVPlayer(url: fileURL)
        self.player = videoPlayer
        self.player?.play()
    }

} // END OF CLASS
