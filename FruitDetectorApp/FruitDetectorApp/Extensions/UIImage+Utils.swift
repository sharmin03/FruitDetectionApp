//
//  UIImage+Utils.swift
//  FruitDetectorApp
//
//  Created by Khan Sharmin on 17/03/20.
//  Copyright © 2020 Khan Sharmin. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    func rotate(degree: Float) -> UIImage? {
        
        let radians: Float = degree * (3.14/180)
        var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)

        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!

        
        context.translateBy(x: newSize.width/2, y: newSize.height/2)
        
        context.rotate(by: CGFloat(radians))
        
        self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }
    
    
    
}
