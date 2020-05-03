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
    var body: [SnakePart] = []
    
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

    class SnakePart {
        var node: SKSpriteNode
        var snake: Snake
        var index: Int
        var direction: Direction? = nil
        
        init(color: UIColor, index: Int, snake: Snake) {
            self.index = index
            self.snake = snake
            let newNode = SKSpriteNode(color: color, size: CGSize(width: 20, height: 20))
            let nodePhysic = SKPhysicsBody(rectangleOf: newNode.size)
            nodePhysic.isDynamic = true
            nodePhysic.usesPreciseCollisionDetection = false
            nodePhysic.categoryBitMask = PhysicsCategory.snake
            nodePhysic.contactTestBitMask = PhysicsCategory.walls
            nodePhysic.collisionBitMask = PhysicsCategory.none
            newNode.physicsBody = nodePhysic
            self.node = newNode
        }
        
        func nextPart() -> SnakePart? {
            if let part = snake.body[safe: index + 1] {
                return part
            } else {
                return nil
            }
        }
        
        func previousPart() -> SnakePart? {
            if let part = snake.body[safe: index - 1] {
                return part
            } else {
                return nil
            }
        }
        
        func moveIn(direction d: Direction) {
            self.direction = d
            let timeRefresh = 1.0 / Double(Snake.snakeSpeed)
            let vector = CGVector(dx: d.x, dy: d.y)
            let move = SKAction.move(by: vector, duration: timeRefresh)
            node.removeAllActions()
            node.run(SKAction.repeatForever(move))
        }
        
        func pullNext() {
            if let next = nextPart() {
                let targetPosition = node.position
                let nodeMove = SKAction.move(to: targetPosition, duration: 25 / Double(Snake.snakeSpeed))
                next.node.removeAllActions()
                next.direction = nil
                next.node.run(nodeMove, completion: {
//                    TODO: Check reference leaks of self!
                    if let d = self.direction {
                        next.direction = d
                        next.moveIn(direction: d)
                    }
                    next.pullNext()
                })
            }
        }
        
    }
    
    enum RotationDirection: Int {
        case left = -1
        case right = 1
    }
    
    
    func distanceBetween(a: CGPoint, b: CGPoint) -> Double {
        let distX = Double(a.x - b.x)
        let distY = Double(a.y - b.y)
        
        return sqrt(distX*distX + distY*distY)
    }
    
    func moveSnake(direction: Direction) {
        head.moveIn(direction: direction)
        head.pullNext()
    }
    
    func addPart(color: UIColor) {
        let newPart = SnakePart(color: color, index: body.count, snake: self)
        body.append(newPart)
    }
    
    func start(scene: SKScene) {
        addPart(color: .green)
        addPart(color: .blue)
        addPart(color: .red)
        addPart(color: .green)
        addPart(color: .blue)
        addPart(color: .red)
        
        body.forEach { sp in
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
