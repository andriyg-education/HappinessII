//
//  FaceView.swift
//  HapinessII
//
//  Created by Andriy Gushuley on 18/08/15.
//  Copyright © 2015 andriyg. All rights reserved.
//

import UIKit

let DEFAULT_FACE_SCALE: CGFloat = 0.95
let EYE_Y_DISP: CGFloat = 0.35
let EYE_X_DISP: CGFloat = 0.35
let EYE_RADIUS: CGFloat = 0.10
let MOUTH_Y_DISP: CGFloat = 0.35
let MOUTH_HALF_WITH: CGFloat = 0.50
let MOUNT_MAX_DOWN: CGFloat = 0.20
let CONFUSION_MAX_DISP: CGFloat = 0.50

let TWO_PI = CGFloat(2 * M_PI)

class FaceView: UIView {
    var lineWith:CGFloat = 3 { didSet { setNeedsDisplay() } }
    var color: UIColor = UIColor.blueColor() { didSet { setNeedsDisplay() } }
    var scale: CGFloat = DEFAULT_FACE_SCALE { didSet { setNeedsDisplay() } }
    
    private var faceCenter: CGPoint {
        return convertPoint(center, fromView: superview)
    }
    
    private var faceRadius: CGFloat {
        return min(bounds.size.width, bounds.size.height) * scale / 2
    }
    
    private enum Eye {
        case Left
        case Right
    }
    
    private func eyePath(eye: Eye) -> UIBezierPath {
        let eyeRadius = faceRadius * EYE_RADIUS
        let eyeVerticalOffset = faceRadius * EYE_Y_DISP
        let eyeHorizontalOffset = faceRadius * EYE_X_DISP
        
        var eyeCenter = faceCenter
        eyeCenter.y -= eyeVerticalOffset
        switch eye {
        case .Left: eyeCenter.x -= eyeHorizontalOffset
        case .Right: eyeCenter.x += eyeHorizontalOffset
        }
        
        let path = UIBezierPath(arcCenter: eyeCenter, radius: eyeRadius, startAngle: 0, endAngle: TWO_PI, clockwise: true)
        path.lineWidth = lineWith
        return path
    }
    
    private func mouthPath(var hapiness: CGFloat, var confusion: CGFloat) -> UIBezierPath {
        if hapiness > 1 {
            hapiness = 1
        } else if hapiness < -1 {
            hapiness = -1
        }
        
        if confusion > 1 {
            confusion = 1
        } else if confusion < -1 {
            confusion = -1
        }
        
        let moutWith = faceRadius * MOUTH_HALF_WITH * 2
        let mouthHeigh = faceRadius * MOUNT_MAX_DOWN * hapiness
        let mouthVertialOffset = faceRadius * MOUTH_Y_DISP
        
        let start = CGPoint(x: faceCenter.x - moutWith / 2, y: faceCenter.y + mouthVertialOffset)
        let end = CGPoint(x: start.x + moutWith, y: start.y)
        
        let confusionDisp = confusion * moutWith * CONFUSION_MAX_DISP
        
        let cp1 = CGPoint(x: start.x + moutWith / 3 - confusionDisp / 2, y: start.y + mouthHeigh)
        let cp2 = CGPoint(x: start.x + moutWith * 2 / 3 - confusionDisp / 2, y: start.y + mouthHeigh)

        let path = UIBezierPath()
        path.moveToPoint(start)
        path.addCurveToPoint(end, controlPoint1: cp1, controlPoint2: cp2)
        path.lineWidth = lineWith
        
        return path
    }
    
    override func drawRect(rect: CGRect) {
        let oval = UIBezierPath(arcCenter: faceCenter, radius: faceRadius,
            startAngle: 0, endAngle: CGFloat(2 * M_PI), clockwise: true)
        
        oval.lineWidth = lineWith
        color.set()
        oval.stroke()
        
        eyePath(.Left).stroke()
        eyePath(.Right).stroke()
        
        mouthPath(1, confusion: 0).stroke()
    }
    

}
