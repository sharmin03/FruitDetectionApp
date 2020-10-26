//
//  ViewController.swift
//  FruitDetectorApp
//
//  Created by Khan Sharmin on 14/03/20.
//  Copyright © 2020 Khan Sharmin. All rights reserved.
//

import UIKit
import AVFoundation
import CoreGraphics
import Vision


class CameraViewController: DetectionViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    
    @IBOutlet weak var cropClickButton: UIButton!
    @IBOutlet weak var searchWebButton: UIButton!
    @IBOutlet weak var previewView: UIView!
    
    private var cameraLayer: AVCaptureVideoPreviewLayer!
    private let session = AVCaptureSession()
    private let videoOutput = AVCaptureVideoDataOutput()
    private let videoDataOutputQueue = DispatchQueue(label: "VideoDataOutput", qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)
    var cornerViewCode : CornerView?
    var bounds = CGRect.zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cropClickButton.isEnabled = false
        searchWebButton.isEnabled = false
        
        setupCaptureSession()
        setupDetectionLayers()
        addMaskLayer()
        session.startRunning()
    }
    
    private func setupCaptureSession() {
        session.sessionPreset = AVCaptureSession.Preset.photo
        let backCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
        let deviceInput: AVCaptureDeviceInput
        do {
            deviceInput = try AVCaptureDeviceInput(device: backCamera!)
        } catch {
            print("Could not create video device input: \(error)")
            return
        }
        session.beginConfiguration()
        session.sessionPreset = .vga640x480
        guard session.canAddInput(deviceInput) else {
            print("Could not add video device input to the session")
            session.commitConfiguration()
            return
        }
        
        if session.canAddOutput(videoOutput) {
            videoOutput.alwaysDiscardsLateVideoFrames = true
            videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)]
            videoOutput.setSampleBufferDelegate(self , queue: videoDataOutputQueue)
        }
        self.session.addOutput(videoOutput)
        let captureConnection = videoOutput.connection(with: .video)
        
        captureConnection?.isEnabled = true
        do {
            try backCamera!.lockForConfiguration()
            let dimensions = CMVideoFormatDescriptionGetDimensions((backCamera?.activeFormat.formatDescription)!)
            bufferSize.width = CGFloat(dimensions.width)
            bufferSize.height = CGFloat(dimensions.height)
            backCamera!.unlockForConfiguration()
        } catch {
            print(error)
        }
        session.addInput(deviceInput)
        session.commitConfiguration()
    }
    
    func setupDetectionLayers() {
        cameraLayer = AVCaptureVideoPreviewLayer(session: session)
        cameraLayer.videoGravity = .resizeAspectFill
        rootLayer = previewView.layer
        cameraLayer.frame = rootLayer.bounds
        rootLayer.addSublayer(cameraLayer)
        
        detectionOverlay = CALayer()
        detectionOverlay.bounds = CGRect(x: 0.0,y: 0.0,width: bufferSize.width, height: bufferSize.height)
        detectionOverlay.position = CGPoint(x: rootLayer.bounds.midX, y: rootLayer.bounds.midY)
        
        rootLayer.addSublayer(detectionOverlay)
    }
    
    func addMaskLayer() {
        self.cornerViewCode = CornerView(frame: CGRect(x: (self.previewView.bounds.width - self.previewView.bounds.width*0.8)/2, y: (self.previewView.bounds.height - self.previewView.bounds.height*0.8)/2, width: self.previewView.bounds.width*0.8, height: self.previewView.bounds.height*0.8))
        self.previewView.addSubview(self.cornerViewCode!)
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        connection.videoOrientation = AVCaptureVideoOrientation.portrait
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        self.imageBuffer = pixelBuffer
        
        detect(cVImageBuffer: pixelBuffer)
        DispatchQueue.main.async {
            if self.confidence > 0.9 {
                self.searchWebButton.isEnabled = true
                self.cropClickButton.isEnabled = true
            } else {
                self.searchWebButton.isEnabled = false
                self.cropClickButton.isEnabled = false
            }
        }
        
    }
    
    
    @IBAction func searchWeb(_ sender: Any) {
        guard let url = URL(string: "http://www.google.com/search?q=Benefits+of+\(searchText)") else { return }
        UIApplication.shared.open(url)
    }
    
    @IBAction func cropClick(_ sender: Any) {
        let detectedFruitInfo = DetectedFruitInfo(name: self.searchText, boxSize: boundingBox.size)
        self.openFruitInfoImageVC(with: detectedFruitInfo)
    }
    
    
    
}
