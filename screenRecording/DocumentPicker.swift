//
//  DocumentPicker.swift
//  screenRecording
//
//  Created by Po hin Ma on 16/6/2023.
//

import UIKit
import MobileCoreServices
import SwiftUI

struct DocumentPicker: UIViewControllerRepresentable {
    var url: URL
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forExporting: [url])
        return picker
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
}
