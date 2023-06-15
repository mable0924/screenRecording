//
//  ContentView.swift
//  screenRecording
//
//  Created by Po hin Ma on 16/6/2023.
//

import SwiftUI


struct ContentView: View {
    @ObservedObject var screenRecorder = ScreenRecorder.shared

    var body: some View {
        VStack {
            Button("Start Recording") {
                screenRecorder.startRecording()
            }
            
            
        }
    }
}
