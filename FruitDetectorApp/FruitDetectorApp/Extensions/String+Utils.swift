//
//  NSMutableAttributedString+Utils.swift
//  FruitDetectorApp
//
//  Created by Khan Sharmin on 15/03/20.
//  Copyright © 2020 Khan Sharmin. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    func formattedString(_ confidence: Float) -> NSMutableAttributedString {
        let formattedString = NSMutableAttributedString(string: String(format: "\(self)\nConfidence:  %.2f", confidence))
        let largeFont = UIFont(name: Constants.fontName, size: Constants.fontSize)!
        formattedString.addAttributes([NSAttributedString.Key.font: largeFont], range: NSRange(location: 0, length: self.count))
        return formattedString
    }
}
