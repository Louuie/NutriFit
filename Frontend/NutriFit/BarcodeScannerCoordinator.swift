//
//  BarcodeScannerCoordinator.swift
//  NutriFit
//
//  Created by Elias Dandouch on 5/20/24.
//
import SwiftUI
import AVFoundation


class BarcodeScannerCoordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {
    var parent: BarcodeScannerView

    init(parent: BarcodeScannerView) {
        self.parent = parent
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            parent.didFindCode(stringValue)
        }
    }
}


