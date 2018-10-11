//
//  ViewController.swift
//  Pitch Perfect
//
//  Created by macbook-rhla on 28/09/18.
//  Copyright © 2018 ORIONSCODE. All rights reserved.
//

import UIKit
import AVFoundation

class RecordingViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordButton.isEnabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - Start Recording Function
    @IBAction func recordingClicked(_ sender: Any) {
        configuringButtonUI(isRecording: true)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record() 
        
    }
    
    // MARK: - Stop recording method
    @IBAction func stopRecording(_ sender: AnyObject) {
        configuringButtonUI(isRecording: false)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    // MARK: - Audio Recorder Delegate
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if ( flag ) {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("Recording not successful")
        }
    }
    
    // MARK: - Prepare for sending audio file to other controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if ( segue.identifier == "stopRecording" ) {
            let playSoundVC = segue.destination as! PlaySoundController
            let recordedAudioURL = sender as! URL
            playSoundVC.recordedAudioURL = recordedAudioURL
        }
    }
    
    // MARK: - Configuring UI for button enable state change
    private func configuringButtonUI(isRecording: Bool) {
        if ( isRecording ) {
            self.stopRecordButton.isEnabled = true
            self.recordButton.isEnabled = false
            self.recordLabel.text = "Recording"
        } else {
            self.stopRecordButton.isEnabled = false
            self.recordButton.isEnabled = true
            self.recordLabel.text = "Tap to record"
        }
    }
    
}

