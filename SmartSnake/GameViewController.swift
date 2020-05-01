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
    
    let snake = Snake()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            let scene = SKScene(size: view.bounds.size)
            scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            scene.backgroundColor = UIColor.white
            view.ignoresSiblingOrder = true
            view.presentScene(scene)
            
            snake.start(scene: scene)
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let location = touch.location(in: self.view)
            
            if(location.x < self.view.frame.size.width / 2){
                snake.changeSnakeDirection(direction: .left)
            }
            else {
                snake.changeSnakeDirection(direction: .right)
            }
        }
    }
    

    
//
//
//    func addApple(scene: SKScene) {
//        let size  = CGSize(width: 20, height: 20)
//        let apple = SKSpriteNode(color: UIColor.red, size: size)
//        apple.position = CGPoint(x: 200, y: 1)
//        scene.addChild(apple)
//    }
//

    override var shouldAutorotate: Bool {
        return true
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
