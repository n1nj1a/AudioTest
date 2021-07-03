import Foundation
import AVFoundation

class ContentViewModel: NSObject, ObservableObject, AVAudioPlayerDelegate, AVAudioRecorderDelegate {
    var audioPlayer: AVAudioPlayer?
    var audioRecorder : AVAudioRecorder?
    let audioFilePath = "sample"
    let recodedFilePath = "empty"

    func playAudio() {
        guard let url = Bundle.main.url(forResource: audioFilePath, withExtension: "mp3") else { return }
        audioPlayer = try! AVAudioPlayer(contentsOf: url)
        audioPlayer?.delegate = self
        audioPlayer?.play()
    }
    
    func stopAudio() {
        audioPlayer?.stop()
    }

    func handleRecord() {
        let session = AVAudioSession.sharedInstance()
        do{
            try session.setCategory(.playAndRecord)
            try session.setActive(true)
            session.requestRecordPermission({ [unowned self] (allowed : Bool) -> Void in
                DispatchQueue.main.async {
                    if allowed {
                        startRecording()
                    } else {
                        print("We don't have request permission for recording.")
                    }
                }
            })
        } catch {
            print("\(error)")
        }
    }
    
    func startRecording() {
        do{
            guard let url = Bundle.main.url(forResource: recodedFilePath, withExtension: "mp3") else { return }
            
            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 12000,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            
            //            let fileURL = NSURL(string: recodedFilePath)!
            audioRecorder = try AVAudioRecorder(url: url, settings: settings)
            
            if let recorder = self.audioRecorder{
                recorder.delegate = self
                
                if recorder.record() && recorder.prepareToRecord(){
                    print("Audio recording started successfully")
                }
            }
        } catch {
            print("\(error)")
        }
    }
    
    func stopRecording() {
        if let record = audioRecorder{
            record.stop()
            let session = AVAudioSession.sharedInstance()
            do {
                try session.setActive(false)
            }
            catch{
                print("\(error)")
            }
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("Did finish Playing")
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            stopRecording()
        }
    }
}
