//
//  InteractiveView.swift
//  HapticButtons
//
//  Created by Michael Edenzon on 12/8/17.
//  Copyright © 2017 Michael Edenzon. All rights reserved.
//

import Foundation
import UIKit

enum Direction {
    case up, down
}

class HapticButton: UIView {
    
    var master: InteractiveView!
    private var lightGenerator: UIImpactFeedbackGenerator?
    private var heavyGenerator: UIImpactFeedbackGenerator?
    private var clicked = false
    private var color: UIColor!
    private var insetView: UIView!
    private var filterView: UIView!
    private var imageView: UIImageView!
    private var maxForce: CGFloat {
        get {
            return 2.0
        }
    }
    private var maxScale: CGFloat {
        get {
            return normalized(force: 5.5, maximum: true)
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
        addSubviews()
    }
    
    private func addSubviews() {
        addInsetView()
        addFilterView()
        addImageView()
    }
    
    private func addInsetView() {
        insetView = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        insetView.backgroundColor = Color.clear
        insetView.layer.borderColor = Color.clear.cgColor
        insetView.layer.borderWidth = 1.0
        insetView.layer.cornerRadius = layer.cornerRadius
        addSubview(insetView)
    }
    
    private func addFilterView() {
        filterView = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        filterView.backgroundColor = Color.clear
        filterView.layer.cornerRadius = layer.cornerRadius
        addSubview(filterView)
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
            filterView.backgroundColor = Color.clear
            imageView.image = imageUp
            master.activate()
            clicked = false
        case .down:
            heavyGenerator?.impactOccurred()
            filterView.backgroundColor = Color.clear.withAlphaComponent(0.25)
            imageView.image = imageDown
            setScale(to: maxScale)
            clicked = true
        }
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
    
    private func setScale(to x: CGFloat) {
        insetView.transform = CGAffineTransform(scaleX: x, y: x)
    }
    
    private func scale(to touch: UITouch) {
        setScale(to: normalized(force: touch.force))
    }
    
    private func reset() {
        insetView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        lightGenerator = UIImpactFeedbackGenerator(style: .medium)
        heavyGenerator = UIImpactFeedbackGenerator(style: .heavy)
        lightGenerator?.prepare()
        heavyGenerator?.prepare()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            
            if touch.force > 1.0 && !clicked {
                scale(to: touch)
                if touch.force >= maxForce && !clicked {
                    press(button: .down)
                }
            }
            
            if touch.force < maxForce && clicked {
                press(button: .up)
                reset()
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if clicked {
            press(button: .up)
            reset()
        }
        lightGenerator = nil
        heavyGenerator = nil
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if clicked {
            press(button: .up)
            reset()
        }
        lightGenerator = nil
        heavyGenerator = nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

