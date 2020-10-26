//
//  DetectionViewController.swift
//  FruitDetectorApp
//
//  Created by Khan Sharmin on 15/03/20.
//  Copyright © 2020 Khan Sharmin. All rights reserved.
//

import UIKit
import Vision
import CoreML

class DetectionViewController: UIViewController {
    
    let model = FruitDetector()
    var bufferSize: CGSize = .zero
    var detectionOverlay: CALayer! = nil
    var rootLayer: CALayer! = nil
    var searchText: String = ""
    var confidence: Float = 0.0
    var boundingBox: CGRect = .zero
    var ciImageToBeCropped: CIImage?
    var imageBuffer: CVImageBuffer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func detect(cVImageBuffer: CVImageBuffer) {
        
        guard let model = try? VNCoreMLModel(for: model.model) else {
            fatalError("can't load model")
        }
        
        let width = CVPixelBufferGetWidth(cVImageBuffer)
        let height = CVPixelBufferGetHeight(cVImageBuffer)
        
        let imageSize = CGSize(width: width, height: height)
        
        let request = VNCoreMLRequest(model: model) { [unowned self] request, error in
            DispatchQueue.main.async(execute: {
                
                if let results = request.results {
                    self.drawBoundingBox(results, imageSize: imageSize)
                    
                }
            })
        }
        
        let handler = VNImageRequestHandler(cvPixelBuffer: cVImageBuffer, orientation: .left, options: [:])
        DispatchQueue.global(qos: .userInteractive).async {
            do {
                try handler.perform([request])
            } catch {
                print(error)
            }
        }
    }
    
    
    func drawBoundingBox(_ results: [Any], imageSize: CGSize) {
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        detectionOverlay.sublayers = nil
        for observation in results where observation is VNRecognizedObjectObservation {
            guard let objectObservation = observation as? VNRecognizedObjectObservation else {
                continue
            }
            let topLabelObservation = objectObservation.labels[0]
            let objectBounds = VNImageRectForNormalizedRect(objectObservation.boundingBox, Int(bufferSize.width), Int(bufferSize.height))
            let shapeLayer = self.layerWithBounds(objectBounds, identifier: topLabelObservation.identifier, confidence: topLabelObservation.confidence)
            if topLabelObservation.confidence > 0.9 {
                confidence = topLabelObservation.confidence
                searchText = topLabelObservation.identifier
                self.boundingBox = objectBounds
                self.ciImageToBeCropped = CIImage(cvImageBuffer: self.imageBuffer!)
            }
            detectionOverlay.addSublayer(shapeLayer)
        }
        CATransaction.commit()
        self.updateLayerGeometry()
    }
    
    func layerWithBounds(_ rect: CGRect, identifier: String, confidence: VNConfidence) -> CALayer {
        let layer = CAShapeLayer()
        layer.bounds = rect
        layer.path = UIBezierPath(roundedRect: rect, cornerRadius: 8).cgPath
        layer.lineWidth = 8
        layer.strokeColor = UIColor.red.cgColor
        layer.shadowOpacity = 0.7
        layer.shadowOffset = CGSize.zero
        layer.fillColor = UIColor.clear.cgColor
        layer.position = CGPoint(x: rect.midX, y: rect.midY)
        
        let textLayer = CATextLayer()
        textLayer.string = identifier.formattedString(confidence)
        textLayer.shadowOffset = CGSize(width: 2, height: 2)
        textLayer.bounds = CGRect(x: 0, y: 0, width: rect.size.height - 10, height: rect.size.width - 10)
        textLayer.position = CGPoint(x: rect.midX, y: rect.midY)
        textLayer.contentsScale = 2.0
        textLayer.setAffineTransform(CGAffineTransform(rotationAngle: CGFloat(.pi / 2.0)).scaledBy(x: 1.0, y: -1.0))
        
        layer.addSublayer(textLayer)
        return layer
        
    }
    
    func updateLayerGeometry() {
        let bounds = rootLayer.bounds
        var scale: CGFloat
        
        let xScale: CGFloat = bounds.size.width / bufferSize.height
        let yScale: CGFloat = bounds.size.height / bufferSize.width
        
        scale = fmax(xScale, yScale)
        if scale.isInfinite {
            scale = 1.0
        }
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        
        detectionOverlay.setAffineTransform(CGAffineTransform(rotationAngle: CGFloat(.pi / 2.0)).scaledBy(x: scale, y: -scale))
        detectionOverlay.position = CGPoint (x: bounds.midX, y: bounds.midY)
        
        CATransaction.commit()
        
    }
    
}
