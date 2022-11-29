//
//  Utils.swift
//  Document Scanner
//
//  Created by xulihang on 2022/11/28.
//

import Foundation
import UIKit


class Utils {
    static func updatePoints(_ points:[CGPoint], frameWidth:Double, frameHeight:Double,viewWidth:Double, viewHeight:Double) -> [CGPoint]{
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
            x = x * xPercent(frameWidth:frameWidth,frameHeight:frameHeight,viewWidth:viewWidth,viewHeight:viewHeight)
            y = y * yPercent(frameWidth:frameWidth,frameHeight:frameHeight,viewWidth:viewWidth,viewHeight:viewHeight)
            let newPoint = CGPoint(x: x, y: y)
            newPoints.append(newPoint)
        }
        return newPoints
    }
    
    static func xPercent(frameWidth:Double, frameHeight:Double,viewWidth:Double, viewHeight:Double) -> Double {
        if (frameWidth>frameHeight && viewWidth>viewHeight) {
            return viewWidth/frameWidth
        }else{
            return viewWidth/frameHeight
        }
    }
    
    static func yPercent(frameWidth:Double, frameHeight:Double,viewWidth:Double, viewHeight:Double) -> Double {
        if (frameWidth>frameHeight && viewWidth>viewHeight) {
            return viewWidth/frameWidth
        }else{
            return viewWidth/frameHeight
        }
    }
}
