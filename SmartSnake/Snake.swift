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
   
    let colors: [UIColor] = [
        .green,
        .blue,
        .purple,
        .red,
        .orange,
        .yellow
    ]
    var lastColorIndex = 0
    
    static let partSize = 12
    static let partSpace = 5
    
    static var snakeSpeed: Int = 150

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
        
        var node: SKNode
        var snake: Snake
        var index: Int
        var direction: Direction? = nil
        
        init(color: UIColor, index: Int, snake: Snake) {
            self.index = index
            self.snake = snake

            let newNode = SKShapeNode(circleOfRadius: CGFloat(Snake.partSize))
            newNode.fillColor = color
            newNode.lineWidth = 0
            let nodePhysic = SKPhysicsBody(circleOfRadius:  CGFloat(Snake.partSize))
            nodePhysic.isDynamic = true
            nodePhysic.usesPreciseCollisionDetection = true
            nodePhysic.categoryBitMask = PhysicsCategory.snake
            nodePhysic.contactTestBitMask = PhysicsCategory.walls
            nodePhysic.collisionBitMask = PhysicsCategory.none
            newNode.physicsBody = nodePhysic
            self.node = newNode
            
            if let p = previousPart() {
                node.position = p.node.position
            }
        }
    
        func previousPart() -> SnakePart? {
            if let part = snake.body[safe: index - 1] {
                return part
            } else {
                return nil
            }
        }
        
        func nextPart() -> SnakePart? {
            if let part = snake.body[safe: index + 1] {
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
                let nodeMove = SKAction.move(to: targetPosition, duration: Double(Snake.partSize + Snake.partSpace) / Double(Snake.snakeSpeed))
                next.node.removeAllActions()
                next.direction = nil
                next.node.run(nodeMove, completion: { [weak self] in
                    if let d = self?.direction {
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
    
    func moveSnake(direction: Direction) {
        head.moveIn(direction: direction)
        head.pullNext()
    }
    
    func addPart(scene: SKScene) {
        let color = colors[lastColorIndex % colors.count]
        lastColorIndex += 1
        let newPart = SnakePart(color: color, index: body.count, snake: self)
        body.append(newPart)
        scene.addChild(newPart.node)
    }
    
    
    func start(scene: SKScene) {
        for _ in 0...40 {
            addPart(scene: scene)
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
        moveSnake(direction: newDirection)
    }
}
