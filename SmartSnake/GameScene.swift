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

    var onFailure: (() -> Void)? = nil
    
    func collision() {
        if let callback = onFailure {
            callback()
            onFailure = nil
        }
//        let retryScene = RetryScene(size: size, won: false)
//        self.view?.presentScene(retryScene)
    }
    
    init(size: CGSize, onFailure: @escaping () -> Void) {
        self.onFailure = onFailure
        super.init(size: size)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func start() {
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        backgroundColor = UIColor.white
        
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        snake.start(scene: self)
        
        addRedzone(size: CGSize(width: size.width, height: 10),
                   position: CGPoint(x: 0, y: size.height / 2 - 10)
        )
        
        addRedzone(size: CGSize(width: size.width, height: 10),
                   position: CGPoint(x: 0, y: -(size.height / 2 - 10))
        )
        
        addRedzone(size: CGSize(width: 10, height: size.height),
                   position: CGPoint(x: size.width / 2 - 10, y: 0)
        )
        
        addRedzone(size: CGSize(width: 10, height: size.height),
                   position: CGPoint(x: -(size.width / 2 - 10), y: 0)
        )
        
    }
    
    func addRedzone(size: CGSize, position: CGPoint) {
        let node = SKSpriteNode(color: .red, size: size)
        node.physicsBody = SKPhysicsBody(rectangleOf: size)
        node.physicsBody?.isDynamic = true
        node.physicsBody?.categoryBitMask = PhysicsCategory.walls
        node.physicsBody?.contactTestBitMask = PhysicsCategory.snake
        node.physicsBody?.collisionBitMask = PhysicsCategory.none
        node.physicsBody?.usesPreciseCollisionDetection = true
        node.position = position
        addChild(node)
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


