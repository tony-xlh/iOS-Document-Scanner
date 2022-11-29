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
    var xPercent = 1.0
    var yPercent = 1.0
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
            let newPoint = CGPoint(x: point.x * xPercent, y: point.y * yPercent)
            newPoints.append(newPoint)
        }
        return newPoints
    }
    
}
