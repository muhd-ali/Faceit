//
//  ViewController.swift
//  Faceit
//
//  Created by Muhammadali on 27/02/2017.
//  Copyright © 2017 Muhammadali. All rights reserved.
//

import UIKit

class FaceViewController: UIViewController {
    
    var expression: FacialExpression = FacialExpression(eyes: .Open, eyeBrows: .Normal, mouth: .Smile) {
        didSet {
            updateUI()
        }
    }
    
    private func setEyes() {
        switch expression.eyes {
        case .Open:
            faceView.eyesOpen = true
        case .Closed:
            faceView.eyesOpen = false
        default:
            break
        }
    }
    
    private let mouthCurvatures = [
        FacialExpression.Mouth.Frown : -1.0,
        .Grin : 0.5,
        .Smile : 1.0,
        .Smirk : -0.5,
        .Neutral: 0.0,
        ]
    
    private let eyeBrowTilts = [
        FacialExpression.EyeBrows.Normal : 0.0,
        .Relaxed : 0.5,
        .Furrowed : -0.5,
        ]
    
    func increaseHappiness() {
        expression.mouth = expression.mouth.happierMouth()
    }

    func decreaseHappiness() {
        expression.mouth = expression.mouth.sadderMouth()
    }
    
    @IBOutlet weak var faceView: FaceView!{
        didSet {
            faceView.addGestureRecognizer(
                UIPinchGestureRecognizer(
                    target: faceView,
                    action: #selector(FaceView.changeScale(recognizer:))
                )
            )
            
            let happierSwipe = UISwipeGestureRecognizer(
                target: self,
                action: #selector(increaseHappiness)
            )
            happierSwipe.direction = .up
            faceView.addGestureRecognizer(happierSwipe)
            
            let sadderSwipe = UISwipeGestureRecognizer(
                target: self,
                action: #selector(decreaseHappiness)
            )
            sadderSwipe.direction = .down
            faceView.addGestureRecognizer(sadderSwipe)
            
            updateUI()
        }
    }
    
    @IBAction func toggleEyes(_ recognizer: UITapGestureRecognizer) {
        if (recognizer.state == .ended) {
            switch expression.eyes {
            case .Open:
                expression.eyes = .Closed
            case .Closed:
                expression.eyes = .Open
            case .Squinting:
                break
            }
        }
    }
    
    
    private func updateUI() {
        if faceView != nil {
            setEyes()
            faceView.mouthCurvature = mouthCurvatures[expression.mouth] ?? 0.0
            faceView.eyeBrowTilt = eyeBrowTilts[expression.eyeBrows] ?? 0.0
        }
    }
    
}

