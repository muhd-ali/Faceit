//
//  FaceView.swift
//  Faceit
//
//  Created by Muhammadali on 27/02/2017.
//  Copyright © 2017 Muhammadali. All rights reserved.
//

import UIKit

class FaceView: UIView {
    
    var scale: CGFloat = 0.9

    var faceRad: CGFloat {
        return min(bounds.size.height, bounds.size.width) / 2 * scale
    }
    
    var faceCenter: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    override func draw(_ rect: CGRect) {
        let face = UIBezierPath(arcCenter: faceCenter, radius: faceRad, startAngle: 0.0, endAngle: CGFloat(2 * M_PI), clockwise: true)

        UIColor.green.setFill()
        face.fill()

        UIColor.red.setStroke()
        face.lineWidth = 5.0
        face.stroke()
    }

}
