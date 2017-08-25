//
//  RecordSoundViewControoler.swift
//  PitchPerfect
//
//  Created by Yi Zhou on 2017/7/3.
//  Copyright © 2017年 Yi Zhou. All rights reserved.
//

import UIKit
import AVFoundation
class RecordSoundViewControoler: UIViewController,AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!
    
    @IBOutlet weak var RecordingLabel: UILabel!
    @IBOutlet weak var RecordButton: UIButton!
    @IBOutlet weak var StopRecordingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        StopRecordingButton.isEnabled=false
        // Do any additional setup after loading the view, typically from a nib.
    }
   


    @IBAction func RecordAudio(_ sender: Any) {
        print("Button has been pressed!")
        RecordingLabel.text="Recording in Progress"
        StopRecordingButton.isEnabled=true;
        RecordButton.isEnabled=false;
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.isMeteringEnabled = true
        audioRecorder.delegate=self
        audioRecorder.prepareToRecord()
        audioRecorder.record()

    }
    
    @IBAction func StopRecording(_ sender: Any)
    {
        RecordButton.isEnabled=true
        StopRecordingButton.isEnabled=false
        RecordingLabel.text="Tap to Record"
        audioRecorder.stop()
        let audioSession=AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag
        {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }
        else
        {
            print("Fail to record")
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="stopRecording"
        {
            let playSoundsVC=segue.destination as! PlaySoundViewController
            let recordedAudioURL=sender as! URL
            playSoundsVC.recordedAudioURL=recordedAudioURL
            
        }
    }

}

