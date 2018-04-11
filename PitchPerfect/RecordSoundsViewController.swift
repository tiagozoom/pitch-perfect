//
//  ViewController.swift
//  PitchPerfect
//
//  Created by tiago turibio on 04/04/18.
//  Copyright © 2018 tiago turibio. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController {

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    var audioRecorder: AVAudioRecorder?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func recordAudio(_ sender: Any) {
        recordingLabel.text = "Recording in progress"
        self.toggleButtons(buttons: recordButton, stopRecordingButton)
        
        let directory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let recordingName = "pitchPerfectAudio.wav"
        let pathArray = [directory,recordingName]
        if let fileURL = URL(string: pathArray.joined(separator: "/")){
            let session = AVAudioSession.sharedInstance()
            try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
            try! audioRecorder = AVAudioRecorder(url: fileURL, settings: [:])
            audioRecorder?.isMeteringEnabled = true
            audioRecorder?.prepareToRecord()
            audioRecorder?.record()
        }
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        recordingLabel.text = "Recording has stopped"
        self.toggleButtons(buttons: recordButton, stopRecordingButton)
        audioRecorder?.stop()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func toggleButtons(buttons: UIButton...){
        buttons.forEach { (button) in
            button.isEnabled = !button.isEnabled
        }
    }
}

