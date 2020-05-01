//
//  Snake.swift
//  SmartSnake
//
//  Created by theo on 30/04/2020.
//  Copyright © 2020 blopz. All rights reserved.
//

import Foundation
import SpriteKit

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
    
    func next(part: SnakePart) -> SnakePart? {
        let nextIndex = part.index + 1
        return body[safe: nextIndex]
    }
    
    struct SnakePart {
        var node: SKSpriteNode
        var index: Int
        
        func moveSnake(direction: Direction) {
            let vector = CGVector(dx: direction.x * snakeSpeed, dy: direction.y * snakeSpeed)
            let move = SKAction.move(by: vector, duration: 1)
            node.removeAction(forKey: "movingSnake")
            node.run(SKAction.repeatForever(move), withKey: "movingSnake")
        }
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
        SnakePart(node: headNode(), index: 0)
//        SnakePart(node: bodyNode(), index: 1)
    ]
    
    func start(scene: SKScene) {
        body.forEach { sp in
            scene.addChild(sp.node)
        }
        body.forEach{ sp in
            sp.moveSnake(direction: directions.first!)
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
        print(newDirection.name)
        head.moveSnake(direction: newDirection)
    }
}
