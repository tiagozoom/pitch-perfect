//
//  PlaySoundsViewController.swift
//  PitchPerfect
//
//  Created by tiago turibio on 05/04/18.
//  Copyright © 2018 tiago turibio. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController{
    
    @IBOutlet weak var fastButton: UIButton!
    @IBOutlet weak var slowButton: UIButton!
    
    @IBOutlet weak var highPitchButton: UIButton!
    @IBOutlet weak var lowPitchButton: UIButton!
    
    @IBOutlet weak var echoButton: UIButton!
    @IBOutlet weak var reverbButton: UIButton!
    
    @IBOutlet weak var stopButton: UIButton!
    
    var recordedAudioURL:URL!
    var audioFile:AVAudioFile!
    var audioEngine:AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: Timer!
    
    enum ButtonType: Int {
        case slow = 0, fast, highPitch, lowPitch, echo, reverb
    }
    
    @IBAction func startSoundForButton(_ sender: UIButton){
        switch (ButtonType(rawValue: sender.tag))! {
        case ButtonType.slow:
            playSound(rate: 0.5)
        case ButtonType.fast:
            playSound(rate: 1.5)
        case ButtonType.highPitch:
            playSound(pitch: 1000)
        case ButtonType.lowPitch:
            playSound(pitch: -1000)
        case ButtonType.echo:
            playSound(echo: true)
        case ButtonType.reverb:
            playSound(reverb: true)
        }
        configureUI(.playing)
    }
    
    @IBAction func stopSoundForButton(_ sender: UIButton){
        stopAudio()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAudio()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI(.notPlaying)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopAudio()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
}
