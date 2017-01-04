//
//  GameViewController.swift
//  ads demo ios
//
//  Created by Solomon Li on 04/01/2017.
//  Copyright © 2017 Unity Technologies. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    var displayLink:CADisplayLink!
    
    override func viewDidAppear(_ animated: Bool) {
        if self.displayLink == nil {
            displayLink = CADisplayLink(target: self, selector: #selector(update))
            displayLink.add(to: RunLoop.main, forMode: RunLoopMode.commonModes)
        } else {
            displayLink.isPaused = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let dl = self.displayLink {
            dl.isPaused = true
        }
    }
    
    func update() {
    }
}
