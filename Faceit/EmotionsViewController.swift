//
//  EmotionsViewController.swift
//  Faceit
//
//  Created by muaz hamza on 2017-03-03.
//  Copyright © 2017 Muhammadali. All rights reserved.
//

import UIKit

class EmotionsViewController: UIViewController {
    
    let emotions = [
        "happy" : FacialExpression(eyes: .Open, eyeBrows: .Normal, mouth: .Smile),
        "angry" : FacialExpression(eyes: .Closed, eyeBrows: .Furrowed, mouth: .Frown),
        "worried" : FacialExpression(eyes: .Open, eyeBrows: .Relaxed, mouth: .Smirk),
        "mischievious" : FacialExpression(eyes: .Open, eyeBrows: .Furrowed, mouth: .Grin),
        ]
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination
        if let faceVC = destinationVC as? FaceViewController {
            if let identifier = segue.identifier {
                if let expression = emotions[identifier] {
                    faceVC.expression = expression
                }
            }
        }
        
    }

}
