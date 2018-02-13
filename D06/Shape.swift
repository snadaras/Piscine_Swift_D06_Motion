//
//  Shape.swift
//  D06
//
//  Created by Siva NADARASSIN on 1/17/18.
//  Copyright © 2018 Siva NADARASSIN. All rights reserved.
//

import Foundation
import UIKit

// --- cette classe represente aleatoirement un carre ou un cercle, de couleur aleatoire
class Shape: UIView {
    
    /*
     // --- Only override draw() if you perform custom drawing.
     // --- An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    var size : CGFloat = 100
    var isCircle = false

    override var collisionBoundsType: UIDynamicItemCollisionBoundsType {
        if (isCircle) {
            return .ellipse
        } else {
            return .rectangle
        }
    }
    
    init(point: CGPoint, maxwidth: CGFloat, maxheight: CGFloat ) {
        var x = point.x
        var y = point.y
        // --- eviter que les formes sortent du cadre : definition des bornes
        if x+size/2 > maxwidth {
            x -= size/2
        }
        if y+size/2 > maxheight {
            y -= size/2
        }
        
        // --- generation aleatoire de carre ou cercle
        let random = Int(arc4random_uniform(2))
        // --- mettre a 2 pour avoir des cercles
        switch random {
        case 0 :
            super.init(frame: CGRect(x: x, y: y, width: size, height: size))
            self.layer.cornerRadius = size/10
                        self.layer.borderWidth = 1
        default:
            super.init(frame: CGRect(x: x, y: y, width: size, height: size))
            self.layer.cornerRadius = size/2
            self.layer.borderWidth = 1
            self.isCircle = true
        }
        // --- set de couleur aleatoire
        self.backgroundColor = getRandomColor()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getRandomColor() -> UIColor {
        let randomRed:CGFloat = CGFloat(arc4random()) / CGFloat(UInt32.max)
        let randomGreen:CGFloat = CGFloat(arc4random()) / CGFloat(UInt32.max)
        let randomBlue:CGFloat = CGFloat(arc4random()) / CGFloat(UInt32.max)
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 4)
    }
    
}
