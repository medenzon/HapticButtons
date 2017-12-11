//
//  LightView.swift
//  HapticButtons
//
//  Created by Michael Edenzon on 12/10/17.
//  Copyright © 2017 Michael Edenzon. All rights reserved.
//

import Foundation
import UIKit

enum State {
    case on, off
}

class LightView: UIImageView {
    
    var state: State = .off
    
    private var imageOn: UIImage {
        get {
            return UIImage(named: "light_on.pdf")!
        }
    }
    
    private var imageOff: UIImage {
        get {
            return UIImage(named: "light_off.pdf")!
        }
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(center: CGPoint, width: CGFloat, height: CGFloat) {
        let origin = CGPoint(x:  center.x - (width / 2), y: center.y - (height / 2))
        let size = CGSize(width: width, height: height)
        self.init(frame: CGRect(origin: origin, size: size))
        self.contentMode = .scaleAspectFit
        self.image = imageOff
    }
    
    func flip() {
        switch state {
        case .on:
            self.image = imageOff
            state = .off
        case .off:
            self.image = imageOn
            state = .on
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
