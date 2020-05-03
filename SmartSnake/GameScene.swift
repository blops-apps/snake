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
    
    func collision() {
        fatalError("Yeaahh")
    }
    
    func start() {
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        backgroundColor = UIColor.white
        
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        snake.start(scene: self)
        
        let redzoneSize = CGSize(width: 10, height: size.height)
        let redzone = SKSpriteNode(color: .red, size: redzoneSize)
        redzone.physicsBody = SKPhysicsBody(rectangleOf: redzoneSize)
        redzone.physicsBody?.isDynamic = true
        redzone.physicsBody?.categoryBitMask = PhysicsCategory.walls
        redzone.physicsBody?.contactTestBitMask = PhysicsCategory.snake
        redzone.physicsBody?.collisionBitMask = PhysicsCategory.none
        redzone.physicsBody?.usesPreciseCollisionDetection = true
        
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


extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        // 1
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        // 2
        if ((firstBody.categoryBitMask & PhysicsCategory.snake != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.walls != 0)) {
            if let snake = firstBody.node as? SKSpriteNode,
                let projectile = secondBody.node as? SKSpriteNode {
                collision()
            }
        }
    }
}


