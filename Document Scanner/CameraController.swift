//
//  CameraController.swift
//  Document Scanner
//
//  Created by xulihang on 2022/11/27.
//

import UIKit
import AVFoundation
import DynamsoftDocumentNormalizer

class CameraController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    var previewView: PreviewView!
    var captureSession: AVCaptureSession!
    var overlay: Overlay!
    var ddn:DynamsoftDocumentNormalizer = DynamsoftDocumentNormalizer()
    var previousResults:[iDetectedQuadResult] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.overlay = Overlay()
        self.previewView = PreviewView()
        self.view.addSubview(self.previewView)
        self.view.addSubview(self.overlay)
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
                //output.automaticallyConfiguresOutputBufferDimensions = false
                //output.deliversPreviewSizedOutputBuffers = true
                
                self.captureSession.startRunning()
            }
            
        } catch {
            // Configuration failed. Handle error.
        }
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection)
    {
        print("output")
        let imageBuffer:CVImageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!
        CVPixelBufferLockBaseAddress(imageBuffer, .readOnly)
        let baseAddress = CVPixelBufferGetBaseAddress(imageBuffer)
        let bufferSize = CVPixelBufferGetDataSize(imageBuffer)
        let width = CVPixelBufferGetWidth(imageBuffer)
        let height = CVPixelBufferGetHeight(imageBuffer)
        let bpr = CVPixelBufferGetBytesPerRow(imageBuffer)
        CVPixelBufferUnlockBaseAddress(imageBuffer, .readOnly)
        let buffer = Data(bytes: baseAddress!, count: bufferSize)
     
        let imageData = iImageData.init()
        imageData.bytes = buffer
        imageData.width = width
        imageData.height = height
        imageData.stride = bpr
        imageData.format = .ARGB_8888
        let results = try? ddn.detectQuadFromBuffer(imageData)
        if results != nil {
            print(results?.count ?? 0)
            if results?.count ?? 0>0 {
                if self.previousResults.count == 2 {
                    self.previousResults.append(results![0])
                    if steady() {
                        self.captureSession.stopRunning()
                    }else{
                        self.previousResults.remove(at: 0)
                    }
                }else{
                    self.previousResults.append(results![0])
                }
                
                DispatchQueue.main.async {
                    self.overlay.frameWidth = Double(width)
                    self.overlay.frameHeight = Double(height)
                    self.overlay.viewWidth = self.view.frame.width
                    self.overlay.viewHeight = self.view.frame.height
                    self.overlay.result=results?[0]
                    self.overlay.setNeedsDisplay()
                }
            }
        }
    }
    
    func steady() -> Bool {
        let points1,points2,points3:[CGPoint]
        points1 = self.previousResults[0].location.points as! [CGPoint]
        points2 = self.previousResults[1].location.points as! [CGPoint]
        points3 = self.previousResults[2].location.points as! [CGPoint]
        let iou1 = Utils.intersectionOverUnion(pts1: points1,pts2: points2)
        let iou2 = Utils.intersectionOverUnion(pts1: points1,pts2: points3)
        let iou3 = Utils.intersectionOverUnion(pts1: points2,pts2: points3)
        if iou1>0.9 && iou2>0.9 && iou3>0.9 {
            return true
        }else{
            return false
        }
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
        if let overlay = self.overlay {
            let width: CGFloat = view.frame.width
            let height: CGFloat = view.frame.height
            let x: CGFloat = 0.0
            let y: CGFloat = 0.0
            overlay.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0)
            overlay.frame = CGRect.init(x: x, y: y, width: width, height: height)
        }
    }
}

