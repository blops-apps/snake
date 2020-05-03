//
//  RetryViewController.swift
//  SmartSnake
//
//  Created by theo on 04/05/2020.
//  Copyright © 2020 blopz. All rights reserved.
//

import Foundation
import UIKit

class RetryViewController: UIViewController {
    
    override func viewDidLoad() {
        view.isOpaque = false
        view.backgroundColor = .clear 
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    @IBAction func retryTouched(_ sender: Any) {
        self.dismiss(animated: true) {
        }
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}
