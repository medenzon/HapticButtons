//
//  AbstractButton.swift
//  HapticButtons
//
//  Created by Michael Edenzon on 12/11/17.
//  Copyright © 2017 Michael Edenzon. All rights reserved.
//

import Foundation
import UIKit

class AbstractButton: HapticButton {
    
    var color: UIColor = Color.blue
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = self.frame.height / 4
    }
    
    convenience init(center: CGPoint, radius: CGFloat, color: UIColor) {
        let origin = CGPoint(x:  center.x - radius, y: center.y - radius)
        let size = CGSize(width: radius * 2, height: radius * 2)
        self.init(frame: CGRect(origin: origin, size: size))
        self.layer.cornerRadius = self.frame.height / 2
        self.color = color
        self.backgroundColor = color
    }
    
    private func normalized(force: CGFloat, maximum: Bool = false) -> CGFloat {
        var n: CGFloat = 0.0
        if maximum {
            n = pow(log(pow(force,2)),0.15)
        } else {
            n = pow(log(pow(min(force, maxForce),2)),0.125)
        }
        return n
    }
    
    override func press(button direction: Direction) {
        impact(direction)
        switch direction {
        case .up:
            master?.activate()
            clicked = false
        case .down:
            clicked = true
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        prepareGenerators()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            if touch.force >= maxForce && !clicked {
                press(button: .down)
            }
            if touch.force < maxForce && clicked {
                press(button: .up)
            }
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        disposeGenerators()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        disposeGenerators()
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
