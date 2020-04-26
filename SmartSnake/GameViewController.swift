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
    
    var snakeSpeed: Int = 100
    
    typealias Direction = (x: Int, y: Int, name: String)
    
    let directions: [Direction] = [
        (x: 1, y: 0, name: "right"),
        (x: 0, y: -1, name: "down"),
        (x: -1, y: 0, name: "left"),
        (x: 0, y: 1, name: "up")
    ]
    var currentDirectionIndex = 0
    
    var snake: SKSpriteNode? = nil
    
    enum RotationDirection: Int {
        case left = -1
        case right = 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            let scene = SKScene(size: view.bounds.size)
            scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            scene.backgroundColor = UIColor.white
            view.ignoresSiblingOrder = true
            view.presentScene(scene)

            let size  = CGSize(width: 20, height: 20)
            snake = SKSpriteNode(color: UIColor.green, size: size)
            scene.addChild(snake!)
            
            addApple(scene: scene)
            moveSnake(direction: directions.first!)
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let location = touch.location(in: self.view)
            
            if(location.x < self.view.frame.size.width / 2){
                changeSnakeDirection(direction: .left)
            }
            else {
                changeSnakeDirection(direction: .right)
            }
        }
    }
    
    func changeSnakeDirection(direction: RotationDirection) {
        let newIndex = (currentDirectionIndex + direction.rawValue) % directions.count
        if newIndex < 0 {
            currentDirectionIndex = directions.count + newIndex
        } else {
            currentDirectionIndex = newIndex
        }
        let newDirection = directions[currentDirectionIndex]
        moveSnake(direction: newDirection)
    }
    
    func moveSnake(direction: Direction) {
        let vector = CGVector(dx: direction.x * snakeSpeed, dy: direction.y * snakeSpeed)
        let move = SKAction.move(by: vector, duration: 1)
        if let s = snake {
            s.removeAction(forKey: "movingSnake")
            s.run(SKAction.repeatForever(move), withKey: "movingSnake")
        } else {
            fatalError("no snake")
        }
    }
    
    func addApple(scene: SKScene) {
        let size  = CGSize(width: 20, height: 20)
        let apple = SKSpriteNode(color: UIColor.red, size: size)
        apple.position = CGPoint(x: 200, y: 1)
        scene.addChild(apple)
    }
    

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
