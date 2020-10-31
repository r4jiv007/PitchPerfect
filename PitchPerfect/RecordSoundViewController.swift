//
//  ViewController.swift
//  PitchPerfect
//
//  Created by m4ntis on 21/10/20.
//

import UIKit
import AVFoundation

class RecordSoundViewController: UIViewController,AVAudioRecorderDelegate {

    @IBOutlet weak var recordingLabel: UILabel!
  
    @IBOutlet weak var recordButton: UIButton!
    
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.stopRecordingButton.isEnabled = false
    }
    
    
    @IBAction func startRecording(_ sender: Any) {
        
        configureUi(isRecording: true)
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
       let recordingName = "recordedVoice.wav"
       let pathArray = [dirPath, recordingName]
       let filePath = URL(string: pathArray.joined(separator: "/"))

       let session = AVAudioSession.sharedInstance()
       try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)

       try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
       audioRecorder.delegate=self
       audioRecorder.isMeteringEnabled = true
       audioRecorder.prepareToRecord()
       audioRecorder.record()
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        configureUi(isRecording: false)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }else{
            print("error saving recording")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundVC = segue.destination as! PlaySoundViewController
            let recordedAudioUrl = sender as! URL
            playSoundVC.recordedAudioURL = recordedAudioUrl
        }
    }
    
    // Mark :
    
    func configureUi(isRecording:Bool)  {
        if isRecording {
            self.recordButton.isEnabled=false
            self.stopRecordingButton.isEnabled=true
            self.recordingLabel.text="Recording in Progress"
        }else{
            self.recordButton.isEnabled=true
            self.stopRecordingButton.isEnabled=false
            self.recordingLabel.text="Tap to Record"
        }
    }
}
