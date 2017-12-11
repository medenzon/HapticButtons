//
//  InteractiveView.swift
//  HapticButtons
//
//  Created by Michael Edenzon on 12/10/17.
//  Copyright © 2017 Michael Edenzon. All rights reserved.
//

import Foundation
import UIKit

class InteractiveView: UIView {
    
    var light: LightView!
    var button: HapticButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = Color.black
        let point1 = CGPoint(x: center.x, y: frame.height * (1/3))
        let point2 = CGPoint(x: center.x, y: frame.height * (2/3))
        light = LightView(center: point1, width: 100, height: 100)
        button = HapticButton(in: self, center: point2, radius: 75)
        addSubview(light)
        addSubview(button)
    }
    
    func activate() {
        light.flip()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
