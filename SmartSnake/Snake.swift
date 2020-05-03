//
//  Snake.swift
//  SmartSnake
//
//  Created by theo on 30/04/2020.
//  Copyright © 2020 blopz. All rights reserved.
//

import Foundation
import SpriteKit

struct PhysicsCategory {
    static let none      : UInt32 = 0
    static let all       : UInt32 = UInt32.max
    static let snake   : UInt32 = 0b1
    static let walls: UInt32 = 0b10
    static let apples: UInt32 = 0b11
}

class Snake {
   
    static var snakeSpeed: Int = 100

    typealias Direction = (x: Int, y: Int, name: String)

    let directions: [Direction] = [
        (x: 1, y: 0, name: "right"),
        (x: 0, y: -1, name: "down"),
        (x: -1, y: 0, name: "left"),
        (x: 0, y: 1, name: "up")
    ]
    var currentDirectionIndex = 0
    
    var head: SnakePart {
        get {
            return body.first!
        }
    }
    
    var tail: SnakePart {
        get {
            return body.last!
        }
    }

    func next(part: SnakePart) -> SnakePart? {
        let nextIndex = part.index + 1
        return body[safe: nextIndex]
    }

    struct SnakePart {
        var node: SKSpriteNode
        var index: Int
        var destination: CGPoint? = nil



    }
    
    enum RotationDirection: Int {
        case left = -1
        case right = 1
    }
    
    static func headNode() -> SKSpriteNode {
        return SKSpriteNode(color: .green, size: CGSize(width: 20, height: 20))
    }
    
    static func bodyNode() -> SKSpriteNode {
        return SKSpriteNode(color: .blue, size: CGSize(width: 20, height: 20))
    }
    
    var body: [SnakePart] = [
        SnakePart(node: headNode(), index: 0, destination: nil),
        SnakePart(node: bodyNode(), index: 1, destination: nil)
    ]
    
    func distanceBetween(a: CGPoint, b: CGPoint) -> Double {
        let distX = Double(a.x - b.x)
        let distY = Double(a.y - b.y)
        
        return sqrt(distX*distX + distY*distY)
    }
    
    func moveSnake(direction: Direction) {
        let timeRefresh = 1.0 / Double(Snake.snakeSpeed)
        let vector = CGVector(dx: direction.x, dy: direction.y)
        let move = SKAction.move(by: vector, duration: timeRefresh)
//        head.node.removeAction(forKey: "move")
        head.node.run(SKAction.repeatForever(move), withKey: "move")
        let p = head.node.position
        let moveTail = SKAction.move(to: p, duration: 25 / Double(Snake.snakeSpeed))
        tail.node.removeAllActions()
        tail.node.run(moveTail, completion: {
            self.tail.node.run(SKAction.repeatForever(move), withKey: "move")
        })
    }
    
    func start(scene: SKScene) {
        body.forEach { sp in
            let nodePhysic = SKPhysicsBody(rectangleOf: sp.node.size)
            nodePhysic.isDynamic = true
            nodePhysic.usesPreciseCollisionDetection = false
            nodePhysic.categoryBitMask = PhysicsCategory.snake
            nodePhysic.contactTestBitMask = PhysicsCategory.walls
            nodePhysic.collisionBitMask = PhysicsCategory.none
            
            sp.node.physicsBody = nodePhysic
            
            scene.addChild(sp.node)
        }

        moveSnake(direction: directions.first!)
    }
    
    func changeSnakeDirection(direction: RotationDirection) {
        let newIndex = (currentDirectionIndex + direction.rawValue) % directions.count
        if newIndex < 0 {
            currentDirectionIndex = directions.count + newIndex
        } else {
            currentDirectionIndex = newIndex
        }
        let newDirection = directions[currentDirectionIndex]
        print(newDirection.name)
        moveSnake(direction: newDirection)
    }
}
