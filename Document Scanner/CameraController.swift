//
//  CameraController.swift
//  Document Scanner
//
//  Created by xulihang on 2022/11/27.
//

import UIKit
import AVFoundation

class CameraController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    var previewView: PreviewView!
    var captureSession: AVCaptureSession!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.previewView = PreviewView()
        self.view.addSubview(self.previewView)
        startCamera();
    }
    
    func startCamera(){
        // Create the capture session.
        self.captureSession = AVCaptureSession()

        // Find the default audio device.
        guard let videoDevice = AVCaptureDevice.default(for: .video) else { return }

        do {
            // Wrap the video device in a capture device input.
            let videoInput = try AVCaptureDeviceInput(device: videoDevice)
            // If the input can be added, add it to the session.
            if self.captureSession.canAddInput(videoInput) {
                self.captureSession.addInput(videoInput)
                self.previewView.videoPreviewLayer.session = self.captureSession
                let output = AVCaptureVideoDataOutput.init()
                self.captureSession.addOutput(output)
                var queue:DispatchQueue
                queue = DispatchQueue(label: "queue")
                output.setSampleBufferDelegate(self as AVCaptureVideoDataOutputSampleBufferDelegate, queue: queue)
                output.videoSettings = [kCVPixelBufferPixelFormatTypeKey : kCVPixelFormatType_32BGRA] as [String : Any]
                self.captureSession.startRunning()
            }
            
        } catch {
            // Configuration failed. Handle error.
        }
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection)
       {
           print("output")
           
       }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let previewView = self.previewView {
            let width: CGFloat = view.frame.width
            let height: CGFloat = view.frame.height
            let x: CGFloat = 0.0
            let y: CGFloat = 0.0
            previewView.frame = CGRect.init(x: x, y: y, width: width, height: height)
        }
    }
}

