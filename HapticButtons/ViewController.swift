//
//  ViewController.swift
//  HapticButtons
//
//  Created by Michael Edenzon on 12/8/17.
//  Copyright © 2017 Michael Edenzon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(InteractiveView(frame: view.frame))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var shouldAutorotate: Bool {
        
        return false
    }
    
    override var prefersStatusBarHidden: Bool {
        
        return true
    }
}

