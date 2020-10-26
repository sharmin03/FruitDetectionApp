//
//  TextTableViewCell.swift
//  FruitDetectorApp
//
//  Created by Khan Sharmin on 16/03/20.
//  Copyright © 2020 Khan Sharmin. All rights reserved.
//

import UIKit

protocol TextTableViewCellDelegate {
    func textToSpeech(audioButtonState: AudioButtonState)
}

class TextTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var audioButton: UIButton!
    var audioButtonState: AudioButtonState = .mute
    var celldelegate: TextTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }

    @IBAction func audioButtonTap(_ sender: Any) {
        let ab = AudioButton(currentState: audioButtonState)
        celldelegate?.textToSpeech(audioButtonState: audioButtonState)
        audioButton.setImage(ab.currentImage, for: .normal)
        switch audioButtonState {
        case .speaker:
            audioButtonState = .mute
        case .mute:
            audioButtonState = .speaker
        }
    }
    
}
