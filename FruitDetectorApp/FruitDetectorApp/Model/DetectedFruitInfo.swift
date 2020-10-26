//
//  DetectedFruitInfo.swift
//  FruitDetectorApp
//
//  Created by Khan Sharmin on 16/03/20.
//  Copyright © 2020 Khan Sharmin. All rights reserved.
//

import Foundation
import UIKit
struct DetectedFruitInfo {
    
    let name: String
    let boxSize: CGSize
    
    init(name: String, boxSize: CGSize) {
        self.name = name
        self.boxSize = boxSize
    }
}
