//
//  FaceView.swift
//  Faceit
//
//  Created by Muhammadali on 27/02/2017.
//  Copyright © 2017 Muhammadali. All rights reserved.
//

import UIKit

@IBDesignable
class FaceView: UIView {
    
    @IBInspectable
    var scale: CGFloat = 0.9 { didSet { setNeedsDisplay() } }
    
    @IBInspectable
    var lineWidth: CGFloat = 5.0 { didSet { setNeedsDisplay() } }
    
    @IBInspectable
    var mouthCurvature: Double = 1  { didSet { setNeedsDisplay() } }
    
    @IBInspectable
    var eyesOpen: Bool = true { didSet { setNeedsDisplay() } }
    
    @IBInspectable
    var eyeBrowTilt: Double = 0.5  { didSet { setNeedsDisplay() } }
    
    @IBInspectable
    var color: UIColor = UIColor.red { didSet { setNeedsDisplay() } }
    
    func changeScale(recognizer: UIPinchGestureRecognizer) {
        switch recognizer.state {
        case .changed, .ended:
            scale *= recognizer.scale
            recognizer.scale = 1.0
        default:
            break
        }
    }
    
    private var faceRad: CGFloat {
        return min(bounds.size.height, bounds.size.width) / 2 * scale
    }
    
    private var faceCenter: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    private struct Ratios {
        static let FaceRadToEyeOffset: CGFloat = 3;
        static let FaceRadToEyeRad: CGFloat = 10;
        static let FaceRadToMouthWidth: CGFloat = 1;
        static let FaceRadToMouthHeight: CGFloat = 3;
        static let FaceRadToMouthOffset: CGFloat = 3;
        static let FaceRadToBrowOffset: CGFloat = 5;
    }
    
    private enum Eye {
        case Left
        case Right
    }
    
    private func pathForCircleCenteredAtPoint(midPoint: CGPoint, withRadius radius: CGFloat) -> UIBezierPath {
        let path = UIBezierPath(
            arcCenter: midPoint,
            radius: radius,
            startAngle: 0.0,
            endAngle: CGFloat(2 * M_PI),
            clockwise: true
        )
        path.lineWidth = lineWidth
        return path
    }
    
    private func getEyeCenter(eye: Eye) -> CGPoint {
        let eyeOffset = faceRad / Ratios.FaceRadToEyeOffset
        var eyeCenter = faceCenter
        eyeCenter.y -= eyeOffset
        switch eye {
        case .Left: eyeCenter.x -= eyeOffset
        case .Right: eyeCenter.x += eyeOffset
        }
        return eyeCenter
    }
    
    private func pathForEye(eye: Eye) -> UIBezierPath {
        let eyeRad = faceRad / Ratios.FaceRadToEyeRad
        let eyeCenter = getEyeCenter(eye: eye)
        if (eyesOpen) {
            return pathForCircleCenteredAtPoint(midPoint: eyeCenter, withRadius: eyeRad)
        } else {
            let path = UIBezierPath()
            path.move(to: CGPoint(x: eyeCenter.x - eyeRad, y: eyeCenter.y))
            path.addLine(to: CGPoint(x: eyeCenter.x + eyeRad, y: eyeCenter.y))
            path.lineWidth = lineWidth
            return path
        }
    }
    
    private func pathForMouth() -> UIBezierPath {
        let mouthWidth = faceRad / Ratios.FaceRadToMouthWidth
        let mouthHeight = faceRad / Ratios.FaceRadToMouthHeight
        let mouthOffset = faceRad / Ratios.FaceRadToMouthOffset
        
        let mouthRect = CGRect(
            x: faceCenter.x - mouthWidth/2,
            y: faceCenter.y + mouthOffset,
            width: mouthWidth,
            height: mouthHeight
        )
        
        let smileOffset = CGFloat(max(-1, min(mouthCurvature, 1))) * mouthRect.height
        let start = CGPoint(x: mouthRect.minX, y: mouthRect.minY)
        let end = CGPoint(x: mouthRect.maxX, y: mouthRect.minY)
        let cp1 = CGPoint(x: mouthRect.minX + mouthRect.width/3, y: mouthRect.minY + smileOffset)
        let cp2 = CGPoint(x: mouthRect.maxX - mouthRect.width/3, y: mouthRect.minY + smileOffset)
        
        let path = UIBezierPath()
        path.move(to: start)
        path.addCurve(to: end, controlPoint1: cp1, controlPoint2: cp2)
        path.lineWidth = lineWidth
        
        return path
    }
    
    private func pathForBrow(eye: Eye) -> UIBezierPath {
        var tilt = eyeBrowTilt;
        switch eye {
        case .Left:
            tilt *= -1.0
        case .Right:
            break
        }
        
        var browCenter = getEyeCenter(eye: eye)
        browCenter.y -= faceRad / Ratios.FaceRadToBrowOffset
        let eyeRad = faceRad / Ratios.FaceRadToEyeRad
        let tiltOffset = CGFloat(max(-1, min(tilt, 1))) * eyeRad / 2
        let browStart = CGPoint(x: browCenter.x - eyeRad, y: browCenter.y - tiltOffset)
        let browEnd = CGPoint(x: browCenter.x + eyeRad, y: browCenter.y + tiltOffset)
        let path = UIBezierPath()
        path.move(to: browStart)
        path.addLine(to: browEnd)
        path.lineWidth = lineWidth
        return path
    }
    
    override func draw(_ rect: CGRect) {
        color.setStroke()
        pathForCircleCenteredAtPoint(midPoint: faceCenter, withRadius: faceRad).stroke()
        pathForEye(eye: .Left).stroke()
        pathForEye(eye: .Right).stroke()
        pathForMouth().stroke()
        pathForBrow(eye: .Left).stroke()
        pathForBrow(eye: .Right).stroke()
    }
    
}
