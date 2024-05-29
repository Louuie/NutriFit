import SwiftUI
import AVFoundation

class ViewController: UIViewController {
    
    // Capture Session
    var session: AVCaptureSession?
    
    // Video Preview
    let previewLayer = AVCaptureVideoPreviewLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.layer.addSublayer(previewLayer)
        checkCameraPermissions()
        
        // Add a Tap Gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapToFocus(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = view.bounds
    }
    
    private func checkCameraPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            // Request
            AVCaptureDevice.requestAccess(for: .video) { granted in
                guard granted else {
                    return
                }
                DispatchQueue.main.async {
                    self.setupCamera()
                }
            }
        case .restricted:
            break
        case .denied:
            break
        case .authorized:
            setupCamera()
        @unknown default:
            break
        }
    }
    
    private func setupCamera() {
        let session = AVCaptureSession()
        session.sessionPreset = .photo
        if let device = AVCaptureDevice.default(for: .video) {
            do {
                let input = try AVCaptureDeviceInput(device: device)
                if session.canAddInput(input) {
                    session.addInput(input)
                }
                
                let metadataOutput = AVCaptureMetadataOutput()
                if session.canAddOutput(metadataOutput) {
                    session.addOutput(metadataOutput)
                    metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                    metadataOutput.metadataObjectTypes = [.qr, .ean13, .ean8, .code128]
                }
                
                previewLayer.videoGravity = .resizeAspectFill
                previewLayer.session = session
                
                session.startRunning()
                self.session = session
            } catch {
                print(error)
            }
        }
    }
    
    // Tap Gesture
    @objc private func handleTapToFocus(_ gesture: UITapGestureRecognizer) {
        let point = gesture.location(in: view)
        print("Tap detected at point: \(point)") // Logging the tap location
        focus(at: point)
    }
    private func focus(at point: CGPoint) {
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        let focusPoint = previewLayer.captureDevicePointConverted(fromLayerPoint: point)
        print("Converted focus point: \(focusPoint)") // Logging the converted focus point
        
        do {
            try device.lockForConfiguration()
            
            if device.isFocusPointOfInterestSupported && device.isFocusModeSupported(.continuousAutoFocus) && device.isExposurePointOfInterestSupported {
                
                // Focus
                device.focusPointOfInterest = focusPoint
                device.focusMode = .continuousAutoFocus
                
                // Exposure
                device.exposurePointOfInterest = focusPoint
                device.exposureMode = .autoExpose
            }
            device.unlockForConfiguration()
        } catch {
            print(error)
        }
    }

}


extension ViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            print("Scanned barcode: \(stringValue)")
            NotificationCenter.default.post(name: .didFindBarcode, object: stringValue)
        }
    }
}

