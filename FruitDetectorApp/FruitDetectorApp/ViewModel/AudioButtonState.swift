//
//  AudioButtonState.swift
//  FruitDetectorApp
//
//  Created by Khan Sharmin on 17/03/20.
//  Copyright © 2020 Khan Sharmin. All rights reserved.
//

import Foundation
import UIKit

enum AudioButtonState {
    case speaker
    case mute
}

struct AudioButton {
    
    let currentState: AudioButtonState
    let currentImage: UIImage
    
    init(currentState: AudioButtonState) {
        self.currentState = currentState
        switch currentState {
        case .speaker:
            currentImage = UIImage(named: "speaker")!
        case .mute:
            currentImage = UIImage(named: "mute")!
        }
    }
}
