//
//  ScreenRecorder.swift
//  screenRecording
//
//  Created by Po hin Ma on 16/6/2023.
//

import SwiftUI
import ReplayKit
import AVFoundation

class ScreenRecorder: ObservableObject {
    static let shared = ScreenRecorder()
    
    private let recorder = RPScreenRecorder.shared()
    private var assetWriter: AVAssetWriter?
    private var videoInput: AVAssetWriterInput?
    private var audioInput: AVAssetWriterInput?
    @Published var isPresentingDocumentPicker = false
    var outputURL: URL?
    
    func startRecording() {
        guard recorder.isAvailable else {
            print("Recording is not available at this time.")
            return
        }
        
        outputURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension("mov")
        
        do {
            assetWriter = try AVAssetWriter(outputURL: outputURL!, fileType: .mov)
        } catch {
            print("Failed to create AVAssetWriter: \(error)")
            return
        }
        
        let screenBounds = UIScreen.main.bounds
        let scale = UIScreen.main.scale
        let videoSettings: [String: Any] = [
            AVVideoCodecKey: AVVideoCodecType.h264,
            AVVideoWidthKey: screenBounds.width * scale,
            AVVideoHeightKey: screenBounds.height * scale
        ]
        videoInput = AVAssetWriterInput(mediaType: .video, outputSettings: videoSettings)
        videoInput?.expectsMediaDataInRealTime = true
        if let videoInput = videoInput, assetWriter?.canAdd(videoInput) == true {
            assetWriter?.add(videoInput)
        }
        
        let audioOutputSettings: [String: Any] = [
            AVFormatIDKey: kAudioFormatMPEG4AAC,
            AVNumberOfChannelsKey: 2,
            AVSampleRateKey: 44100.0
        ]
        audioInput = AVAssetWriterInput(mediaType: .audio, outputSettings: audioOutputSettings)
        audioInput?.expectsMediaDataInRealTime = true
        if let audioInput = audioInput, assetWriter?.canAdd(audioInput) == true {
            assetWriter?.add(audioInput)
        }
        
        recorder.startCapture(handler: { [weak self] (sampleBuffer, bufferType, error) in
            if let error = error {
                print("Failed to capture sample buffer: \(error)")
                return
            }
            
            guard let strongSelf = self else { return }
            
            if bufferType == .video {
                if strongSelf.assetWriter?.status == .unknown {
                    strongSelf.assetWriter?.startWriting()
                    strongSelf.assetWriter?.startSession(atSourceTime: CMSampleBufferGetPresentationTimeStamp(sampleBuffer))
                }
                
                if strongSelf.videoInput?.isReadyForMoreMediaData == true {
                    strongSelf.videoInput?.append(sampleBuffer)
                }
            } else if bufferType == .audioApp || bufferType == .audioMic {
                if strongSelf.audioInput?.isReadyForMoreMediaData == true {
                    strongSelf.audioInput?.append(sampleBuffer)
                }
            }
        }) { [weak self] (error) in
            if let error = error {
                print("Failed to start capture: \(error)")
            } else {
                print("Started capture.")
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    self?.stopRecording()
                }
            }
        }
    }
    
    func stopRecording() {
        recorder.stopCapture { [weak self] (error) in
            if let error = error {
                print("Failed to stop capture: \(error)")
            } else {
                self?.assetWriter?.finishWriting {
                    guard let strongSelf = self else { return }
                    
                    let fileManager = FileManager.default
                    let documentsDirectory = try? fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                    let destinationURL = documentsDirectory?.appendingPathComponent(UUID().uuidString).appendingPathExtension("mov")
                    
                    do {
                        try fileManager.moveItem(at: strongSelf.outputURL!, to: destinationURL!)
                        print("Recording moved to \(destinationURL?.absoluteString ?? "unknown location")")
                    } catch {
                        print("Failed to move recording: \(error)")
                    }
                }
            }
        }
    }

}
