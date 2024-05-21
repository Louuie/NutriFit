//
//  BarcodeScannerView.swift
//  NutriFit
//
//  Created by Elias Dandouch on 5/20/24.
//

import SwiftUI
import AVFoundation

struct BarcodeScannerView: UIViewRepresentable {
    var didFindCode: (String) -> Void
    
    func makeCoordinator() -> BarcodeScannerCoordinator {
        return BarcodeScannerCoordinator(parent: self)
    }

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        let session = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return view }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return view
        }

        if (session.canAddInput(videoInput)) {
            session.addInput(videoInput)
        } else {
            return view
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if (session.canAddOutput(metadataOutput)) {
            session.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(context.coordinator, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr, .ean13, .ean8, .code128]
        } else {
            return view
        }

        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)

        DispatchQueue.global(qos: .userInitiated).async {
            session.startRunning()
        }

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        if let previewLayer = uiView.layer.sublayers?.first as? AVCaptureVideoPreviewLayer {
            previewLayer.frame = uiView.layer.bounds
        }
    }
}


//#Preview {
//    BarcodeScannerView(false)
//}
