//
//  Overlay.swift
//  Document Scanner
//
//  Created by xulihang on 2022/11/28.
//

import UIKit
import DynamsoftDocumentNormalizer

class Overlay: UIView {
    var result:iDetectedQuadResult? = nil
    var frameWidth = 1280.0
    var frameHeight = 720.0
    var viewWidth = 1280.0
    var viewHeight = 720.0
    override func draw(_ rect: CGRect) {
        if result != nil {
            let aPath = UIBezierPath()
            var CGPoints = result?.location.points as! [CGPoint]
            CGPoints = updatePoints(CGPoints)
            print(CGPoints[0].x)
            print(CGPoints[1].y)
            aPath.move(to: CGPoints[0])
            aPath.addLine(to: CGPoints[1])
            aPath.move(to: CGPoints[1])
            aPath.addLine(to: CGPoints[2])
            aPath.move(to: CGPoints[2])
            aPath.addLine(to: CGPoints[3])
            aPath.move(to: CGPoints[3])
            aPath.addLine(to: CGPoints[0])

            // Keep using the method addLine until you get to the one where about to close the path
            aPath.close()

            // If you want to stroke it with a red color
            UIColor.red.set()
            aPath.lineWidth = 3
            aPath.stroke()
        }
    }
    
    func updatePoints(_ points:[CGPoint]) -> [CGPoint]{
        var newPoints:[CGPoint] = []
        for point in points {
            var x = point.x
            var y = point.y
            let orientation = UIDevice.current.orientation
            if  orientation == .portrait || orientation == .unknown || orientation == .faceUp {
                x = frameHeight - point.y;
                y = point.x;
            } else if orientation == .landscapeRight {
                x = frameWidth - point.x;
                y = frameHeight - point.y;
            }
            x = x * xPercent()
            y = y * yPercent()
            let newPoint = CGPoint(x: x, y: y)
            newPoints.append(newPoint)
        }
        return newPoints
    }
    
    func xPercent() -> Double {
        if (frameWidth>frameHeight && viewWidth>viewHeight) {
            return viewWidth/frameWidth
        }else{
            return viewWidth/frameHeight
        }
    }
    
    func yPercent() -> Double {
        if (frameWidth>frameHeight && viewWidth>viewHeight) {
            return viewWidth/frameWidth
        }else{
            return viewWidth/frameHeight
        }
    }
    
}
