//
//  UIViewController+Utils.swift
//  FruitDetectorApp
//
//  Created by Khan Sharmin on 17/03/20.
//  Copyright © 2020 Khan Sharmin. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func openFruitInfoImageVC(with detectedFruitInfo: DetectedFruitInfo) {
      let croppedImageViewController =  self.storyboard?.instantiateViewController(withIdentifier: "FruitInfoImageViewController") as! FruitInfoViewController
        croppedImageViewController.detectedFruitInfo = detectedFruitInfo
        self.navigationController?.show(croppedImageViewController, sender: nil)
    }
    
}
