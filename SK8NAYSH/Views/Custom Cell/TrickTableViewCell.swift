//
//  GameTableViewCell.swift
//  SK8NAYSH
//
//  Created by River McCaine on 3/1/21.
//

import UIKit

class TrickTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var playerTwoImageView: UIImageView!
    @IBOutlet weak var playerTwoTrickLabel: UILabel!
    @IBOutlet weak var playerOneImageView: UIImageView!
    @IBOutlet weak var playerOneTrickLabel: UILabel!
    
    // MARK: - Properties
    var trick: Trick? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - Lifecycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Helper Methods
    func updateViews() {
        guard let trick = trick else { return }
        
    }

}
