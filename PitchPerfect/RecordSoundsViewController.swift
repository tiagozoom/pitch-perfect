//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by tiago turibio on 04/04/18.
//  Copyright © 2018 tiago turibio. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate{
    
    static let identifier = "stopRecording"
    
    struct Alerts {
        static let DismissAlert = "Dismiss"
        static let RecordingFailedTitle = "Recording Failed"
        static let RecordingFailedMessage = "Something went wrong with your recording."
    }
    
    struct Labels{
       static let TapToRecord = "Tap to record"
       static let TapToStopRecording = "Tap to stop recording"
    }
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    enum ScreenState{
        case recording
        case notRecording
    }
    
    func configureUI(_ state: ScreenState){
        switch(state){
        case .recording:
            recordingLabel.text = Labels.TapToStopRecording
            toggleRecordingButtons()
        case .notRecording:
            recordingLabel.text = Labels.TapToRecord
            toggleRecordingButtons()
        }
    }
    
    var audioRecorder: AVAudioRecorder?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func recordAudio(_ sender: Any) {
        configureUI(.recording)
        let directory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let recordingName = "pitchPerfectAudio.wav"
        let pathArray = [directory,recordingName]
        
        if let fileURL = URL(string: pathArray.joined(separator: "/")){
            let session = AVAudioSession.sharedInstance()
            try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
            try! audioRecorder = AVAudioRecorder(url: fileURL, settings: [:])
            audioRecorder?.delegate = self
            audioRecorder?.isMeteringEnabled = true
            audioRecorder?.prepareToRecord()
            audioRecorder?.record()
        }
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        configureUI(.notRecording)
        audioRecorder?.stop()
        let session = AVAudioSession.sharedInstance()
        try! session.setActive(false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    fileprivate func toggleRecordingButtons(){
        recordButton.isEnabled = !recordButton.isEnabled
        stopRecordingButton.isEnabled = !stopRecordingButton.isEnabled
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag{
           self.performSegue(withIdentifier: RecordSoundsViewController.identifier, sender: audioRecorder?.url)
        }else{
            self.showAlert(Alerts.RecordingFailedTitle, message: Alerts.RecordingFailedMessage)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == RecordSoundsViewController.identifier, let playSoundsViewController = segue.destination as? PlaySoundsViewController{
            if let url = sender as? URL{
                playSoundsViewController.recordedAudioURL = url
            }
        }
    }
    
    func showAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Alerts.DismissAlert, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
}

