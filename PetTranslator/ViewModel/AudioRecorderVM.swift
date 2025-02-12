//
//  AudioRecorderVM.swift
//  PetTranslator
//
//  Created by Kateryna Livinska on 09/02/2025.
//

import SwiftUI
import AVFoundation

@MainActor
class AudioRecorderVM: NSObject, ObservableObject, AVAudioPlayerDelegate {
    private var audioRecorder: AVAudioRecorder?
    private var audioPlayer: AVAudioPlayer?
    @Published var isRecording = false
    @Published var isPlaying = false
    @Published var audioURL: URL?
    @Published var needToEnableMicrophoneAccess = true
    
    override init() {
        super.init()
        requestMicrophonePermission()
    }
    
    private func configureAudioSession() {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
            try session.setActive(true)
            
            NotificationCenter.default.addObserver(self, selector: #selector(handleAudioSessionInterruption), name: AVAudioSession.interruptionNotification, object: nil)
            print("Audio session configured successfully.")
        } catch {
            print("Failed to configure audio session: \(error)")
        }
    }
    
    private func requestMicrophonePermission() {
        AVAudioApplication.requestRecordPermission { response in
            if response {
                print("Microphone access granted.")
                DispatchQueue.main.async{
                    self.needToEnableMicrophoneAccess = false
                }
            } else {
                print("Microphone access denied.")
                DispatchQueue.main.async {
                    self.needToEnableMicrophoneAccess = true
                }
            }
        }
    }
    
    @objc private func handleAudioSessionInterruption(notification: Notification) {
        if let userInfo = notification.userInfo,
           let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
           let type = AVAudioSession.InterruptionType(rawValue: typeValue) {
            switch type {
            case .began:
                print("Audio session interrupted.")
                stopRecording()
            case .ended:
                print("Audio session interruption ended.")
                if !isRecording {
                    startRecording() // If desired, restart the recording
                }
            @unknown default:
                break
            }
        }
    }
    
    @MainActor
    func startRecording() {
        if !needToEnableMicrophoneAccess {
            configureAudioSession()
            let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileName = path.appendingPathComponent("audioMessage.m4a")
            
            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 12000,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            
            do {
                audioRecorder = try AVAudioRecorder(url: fileName, settings: settings)
                audioRecorder?.prepareToRecord()
                audioRecorder?.record()
                isRecording = true
                audioURL = fileName
                isRecording = true
            } catch {
                print("Failed to start recording: \(error)")
            }
        } else {
            print("Need microphone access to start recording")
        }
        
    }
    
    @MainActor
    func stopRecording() {
        audioRecorder?.stop()
        isRecording = false
    }
    
    func deleteRecording() {
        guard let url = audioURL else { return }
        do {
            try FileManager.default.removeItem(at: url)
            print("Recording deleted.")
        } catch {
            print("Failed to delete recording: \(error)")
        }
    }
    
    @MainActor
    func playAudio(filename: String, fileExtension: String) {
        if let filePath = Bundle.main.path(forResource: filename, ofType: fileExtension) {
                    let url = URL(fileURLWithPath: filePath)
                    do {
                        audioPlayer = try AVAudioPlayer(contentsOf: url)
                        audioPlayer?.play()
                        audioPlayer?.delegate = self
                        isPlaying = true
                    } catch {
                        print("Error playing audio from resources: \(error)")
                    }
                } else {
                    print("Audio file not found in resources.")
                }
    }
    
    @MainActor
    func stopPlayback() {
        audioPlayer?.stop()
        isPlaying = false
    }
    
    nonisolated func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        DispatchQueue.main.async {
            self.isPlaying = false
            print("Audio playback finished.")
        }
    }
}
