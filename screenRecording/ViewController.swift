//
//  ViewController.swift
//  screenRecording
//
//  Created by Po hin Ma on 16/6/2023.
//
//
//import UIKit
//import ReplayKit
//import AVFoundation
//
//class ViewController: UIViewController {
//
//    let recorder = RPScreenRecorder.shared()
//    var assetWriter: AVAssetWriter!
//    var videoInput: AVAssetWriterInput!
//    var audioInput: AVAssetWriterInput!
//    var startSessionAtSourceTime: CMTime!
//
//    @IBAction func startRecording(_ sender: UIButton) {
//        setupWriter()
//        
//        recorder.startCapture(handler: { (sampleBuffer, bufferType, error) in
//            if self.startSessionAtSourceTime == nil {
//                self.startSessionAtSourceTime = CMSampleBufferGetPresentationTimeStamp(sampleBuffer)
//                self.assetWriter.startSession(atSourceTime: self.startSessionAtSourceTime)
//            }
//            
//            switch bufferType {
//            case .video:
//                if self.videoInput.isReadyForMoreMediaData {
//                    self.videoInput.append(sampleBuffer)
//                }
//            case .audioApp:
//                if self.audioInput.isReadyForMoreMediaData {
//                    self.audioInput.append(sampleBuffer)
//                }
//            case .audioMic:
//                if self.audioInput.isReadyForMoreMediaData {
//                    self.audioInput.append(sampleBuffer)
//                }
//            @unknown default:
//                break
//            }
//            
//        }) { (error) in
//            if let error = error {
//                print("Failed to start capture: \(error.localizedDescription)")
//            } else {
//                print("Started capture.")
//            }
//        }
//    }
//
//    @IBAction func stopRecording(_ sender: UIButton) {
//        recorder.stopCapture { (error) in
//            if let error = error {
//                print("Failed to stop capture: \(error.localizedDescription)")
//            } else {
//                print("Stopped capture.")
//                self.assetWriter.finishWriting {
//                    print("Finished writing video.")
//                }
//            }
//        }
//    }
//
//    
//    func setupWriter() {
//        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//        let videoOutputURL = documentsPath.appendingPathComponent("OutputVideo.mp4")
//        
//        if FileManager.default.fileExists(atPath: videoOutputURL.path) {
//            do {
//                try FileManager.default.removeItem(at: videoOutputURL)
//            } catch {
//                print("Failed to remove item at \(videoOutputURL)")
//            }
//        }
//        
//        do {
//            assetWriter = try AVAssetWriter(outputURL: videoOutputURL, fileType: .mp4)
//        } catch {
//            print("Error occurred when creating asset writer: \(error)")
//        }
//        
//        let videoOutputSettings: Dictionary<String, Any> = [
//            AVVideoCodecKey : AVVideoCodecType.h264,
//            AVVideoWidthKey : UIScreen.main.bounds.width * UIScreen.main.scale,
//            AVVideoHeightKey : UIScreen.main.bounds.height * UIScreen.main.scale
//        ]
//        
//        videoInput  = AVAssetWriterInput(mediaType: .video, outputSettings: videoOutputSettings)
//        videoInput.expectsMediaDataInRealTime = true
//        if assetWriter.canAdd(videoInput) {
//            assetWriter.add(videoInput)
//        }
//        
//        let audioOutputSettings: Dictionary<String, Any> = [
//            AVFormatIDKey : kAudioFormatMPEG4AAC,
//            AVNumberOfChannelsKey : 2,
//            AVSampleRateKey : 44100.0
//        ]
//        
//        audioInput  = AVAssetWriterInput(mediaType: .audio, outputSettings: audioOutputSettings)
//        audioInput.expectsMediaDataInRealTime = true
//        if assetWriter.canAdd(audioInput) {
//            assetWriter.add(audioInput)
//        }
//    }
//}
