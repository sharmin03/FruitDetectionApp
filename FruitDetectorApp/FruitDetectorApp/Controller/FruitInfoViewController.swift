//
//  CroppedImageViewController.swift
//  FruitDetectorApp
//
//  Created by Khan Sharmin on 16/03/20.
//  Copyright © 2020 Khan Sharmin. All rights reserved.
//

import UIKit
import AVFoundation
enum TableViewRows {
    case text
    case funfact
}

class FruitInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AVSpeechSynthesizerDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    var tableViewRows: [TableViewRows] = [.text, .funfact]
    var detectedFruitInfo: DetectedFruitInfo? = nil
    let textTableViewCell = "TextTableViewCell"
    let funfactTableViewCell = "FunfactTableViewCell"
    let synthesizer = AVSpeechSynthesizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: funfactTableViewCell, bundle: nil), forCellReuseIdentifier: funfactTableViewCell)
        tableView.register(UINib(nibName: textTableViewCell, bundle: nil), forCellReuseIdentifier: textTableViewCell)
        synthesizer.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.textToSpeech(audioButtonState: .speaker)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        synthesizer.stopSpeaking(at: .immediate)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewRows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let dFruitInfo = detectedFruitInfo else { return UITableViewCell() }
        
        let rowName = tableViewRows[indexPath.row]
        
        switch rowName {
        case .funfact:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: funfactTableViewCell, for: indexPath) as? FunfactTableViewCell else { return UITableViewCell() }
            cell.setImage(with: UIImage(named: "funfact_\(dFruitInfo.name)")!)
            return cell
        case .text:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: textTableViewCell, for: indexPath) as? TextTableViewCell else { return UITableViewCell() }
            cell.nameLabel.text = dFruitInfo.name
            cell.celldelegate = self
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let rowName = tableViewRows[indexPath.row]
        switch rowName {
        case .text:
            return 100
        case .funfact:
            return 300
        }
    }
}

extension FruitInfoViewController: TextTableViewCellDelegate {
    func textToSpeech(audioButtonState: AudioButtonState) {
        guard let dFruitInfo = detectedFruitInfo else { return }
        let utterance = AVSpeechUtterance(string: "Detected Object is \(dFruitInfo.name)")
        utterance.voice = AVSpeechSynthesisVoice(identifier: "com.apple.ttsbundle.Karen-compact")
        utterance.volume = 1.0
        synthesizer.speak(utterance)
        switch audioButtonState {
        case .speaker:
            synthesizer.continueSpeaking()
        case .mute:
            synthesizer.pauseSpeaking(at: .immediate)
            
        }
    }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        print("start")
        Toast.show(message: "Speaker On", controller: self)
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didPause utterance: AVSpeechUtterance) {
        print("pause")
        Toast.show(message: "Speaker Mute", controller: self)
    }
    
}
