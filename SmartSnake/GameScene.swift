//
//  GameScene.swift
//  SmartSnake
//
//  Created by theo on 26/04/2020.
//  Copyright © 2020 blopz. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    let snake = Snake()
    
    func start() {
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        backgroundColor = UIColor.white
        
        physicsWorld.gravity = .zero
        
        snake.start(scene: self)
        
        let redzoneSize = CGSize(width: 10, height: size.height)
        let redzone = SKSpriteNode(color: .red, size: redzoneSize)
        redzone.position = CGPoint(x: size.width / 2 - 10, y: 0)
        addChild(redzone)
        
    }
    
    func touchedLeft() {
        snake.changeSnakeDirection(direction: .left)
    }
    
    func touchedRight() {
        snake.changeSnakeDirection(direction: .right)
    }
    
    
}
