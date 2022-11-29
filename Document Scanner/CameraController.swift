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
                self.captureSession.startRunning()
            }
            
        } catch {
            // Configuration failed. Handle error.
        }
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection)
       {
           print("output")
           let image = imageFromSampleBuffer(sampleBuffer: sampleBuffer)
           let results = try? ddn.detectQuadFromImage(image)
           let width = image.size.width
           let height = image.size.height
           if results != nil {
               print(results?.count ?? 0)
               if results?.count ?? 0>0 {
                   DispatchQueue.main.async {
                       self.overlay.xPercent = self.view.frame.width/Double(width)
                       self.overlay.yPercent = self.view.frame.height/Double(height)
                       self.overlay.result=results?[0]
                       self.overlay.setNeedsDisplay()
                   }
               }
           }
        }
    
    func imageFromSampleBuffer(sampleBuffer : CMSampleBuffer) -> UIImage
     {
       // Get a CMSampleBuffer's Core Video image buffer for the media data
       let  imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
       // Lock the base address of the pixel buffer
       CVPixelBufferLockBaseAddress(imageBuffer!, CVPixelBufferLockFlags.readOnly);


       // Get the number of bytes per row for the pixel buffer
       let baseAddress = CVPixelBufferGetBaseAddress(imageBuffer!);

       // Get the number of bytes per row for the pixel buffer
       let bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer!);
       // Get the pixel buffer width and height
       let width = CVPixelBufferGetWidth(imageBuffer!);
       let height = CVPixelBufferGetHeight(imageBuffer!);

       // Create a device-dependent RGB color space
       let colorSpace = CGColorSpaceCreateDeviceRGB();

       // Create a bitmap graphics context with the sample buffer data
       var bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Little.rawValue
       bitmapInfo |= CGImageAlphaInfo.premultipliedFirst.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
       //let bitmapInfo: UInt32 = CGBitmapInfo.alphaInfoMask.rawValue
       let context = CGContext.init(data: baseAddress, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo)
       // Create a Quartz image from the pixel data in the bitmap graphics context
       let quartzImage = context?.makeImage();
       // Unlock the pixel buffer
       CVPixelBufferUnlockBaseAddress(imageBuffer!, CVPixelBufferLockFlags.readOnly);

       // Create an image object from the Quartz image
       let image = UIImage.init(cgImage: quartzImage!);

       return (image);
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

