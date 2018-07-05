//
//  AnalogButton.swift
//  HapticButtons
//
//  Created by Michael Edenzon on 12/8/17.
//  Copyright © 2017 Michael Edenzon. All rights reserved.
//

import Foundation
import UIKit

class AnalogButton: UIView {
    
    var master: InteractiveView!
    private var lightGenerator: UIImpactFeedbackGenerator?
    private var heavyGenerator: UIImpactFeedbackGenerator?
    private var clicked = false
    private var imageView: UIImageView!
    
    private var maxForce: CGFloat {
        get {
            return 2.0
        }
    }
    
    private var imageUp: UIImage {
        get {
            return UIImage(named: "button_up.pdf")!
        }
    }
    
    private var imageDown: UIImage {
        get {
            return UIImage(named: "button_down.pdf")!
        }
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = self.frame.height / 4
    }
    
    convenience init(in master: InteractiveView, center: CGPoint, radius: CGFloat) {
        let origin = CGPoint(x:  center.x - radius, y: center.y - radius)
        let size = CGSize(width: radius * 2, height: radius * 2)
        self.init(frame: CGRect(origin: origin, size: size))
        self.layer.cornerRadius = self.frame.height / 2
        self.backgroundColor = Color.clear
        self.master = master
        addImageView()
    }
    
    private func addImageView() {
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        imageView.contentMode = .scaleAspectFit
        imageView.image = imageUp
        addSubview(imageView)
    }
    
    private func press(button direction: Direction) {
        switch direction {
        case .up:
            lightGenerator?.impactOccurred()
            imageView.image = imageUp
            master.activate()
            clicked = false
        case .down:
            heavyGenerator?.impactOccurred()
            imageView.image = imageDown
            clicked = true
        }
    }
    
    func prepareGenerators() {
        lightGenerator = UIImpactFeedbackGenerator(style: .medium)
        heavyGenerator = UIImpactFeedbackGenerator(style: .heavy)
        lightGenerator?.prepare()
        heavyGenerator?.prepare()
    }
    
    func disposeGenerators() {
        lightGenerator = nil
        heavyGenerator = nil
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
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if clicked {
            press(button: .up)
        }
        disposeGenerators()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if clicked {
            press(button: .up)
        }
        disposeGenerators()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

