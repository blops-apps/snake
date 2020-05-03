//
//  GameViewController.swift
//  SmartSnake
//
//  Created by theo on 26/04/2020.
//  Copyright © 2020 blopz. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    var scene: GameScene? = nil
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let view = self.view as! SKView? {
            scene = GameScene(size: view.bounds.size, onFailure: { [weak self] in
                self?.gameDidFail()
            })
            scene?.start()
            
            view.ignoresSiblingOrder = true
            view.presentScene(scene)
            view.showsFPS = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func gameDidFail() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "retryVC") as! RetryViewController

        newViewController.modalPresentationStyle = .overCurrentContext
        self.present(newViewController, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let location = touch.location(in: self.view)
            
            if(location.x < self.view.frame.size.width / 2){
                scene?.touchedLeft()
            }
            else {
                scene?.touchedRight()
            }
        }
    }
    
    override var shouldAutorotate: Bool {
        return false
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
