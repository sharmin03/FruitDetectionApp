//
//  FunfactTableViewCell.swift
//  FruitDetectorApp
//
//  Created by Khan Sharmin on 19/03/20.
//  Copyright © 2020 Khan Sharmin. All rights reserved.
//

import UIKit

class FunfactTableViewCell: UITableViewCell {

    @IBOutlet weak var funfactImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }

    func setImage(with image: UIImage) {
        self.funfactImage.image = image
    }
    
    
}
