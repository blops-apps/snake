import Foundation
import SpriteKit

class Snake {
    
    static let partSize = 12
    static let partSpace = 5
    
    var speed: Int = 180
    static let speedIncrement: Int = 15

    enum DirectionName {
        case left
        case right
        case up
        case down
    }
    
    typealias Direction = (x: Int, y: Int)
    
    var body: [SnakePart] = []
    
    let directions: [Direction] = [
        (x: 1, y: 0),
        (x: 0, y: -1),
        (x: -1, y: 0),
        (x: 0, y: 1)
    ]

    var currentDirectionIndex = 0

    var head: SnakePart {
        return body.first!
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
            newNode.physicsBody = GamePhysicsFactory.circle(radius: CGFloat(Snake.partSize), category: .snake, testContact: .walls)

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
            let timeRefresh = 1.0 / Double(snake.speed)
            let vector = CGVector(dx: d.x, dy: d.y)
            let move = SKAction.move(by: vector, duration: timeRefresh)
            node.removeAllActions()
            node.run(SKAction.repeatForever(move))
        }
        
        func pullNext() {
            if let next = nextPart() {
                let targetPosition = node.position
                let nodeMove = SKAction.move(to: targetPosition, duration: Double(Snake.partSize + Snake.partSpace) / Double(snake.speed))
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
    
    func freeze() {
        for part in body {
            part.node.removeAllActions()
        }
    }
    
    private func moveSnake(direction: Direction) {
        head.moveIn(direction: direction)
        head.pullNext()
    }
    
    func increaseSpeed() {
        speed += Snake.speedIncrement
    }
    
    func increaseLength(scene: SKScene, color: UIColor) {
        let penultimate = body.last!
        addPart(scene: scene, color: color)
        penultimate.pullNext()
    }
    
    private func addPart(scene: SKScene, color: UIColor) {
        let newPart = SnakePart(color: color, index: body.count, snake: self)
        body.append(newPart)
        scene.addChild(newPart.node)
    }

    func start(scene: SKScene, colorFactory: ColorFactory) {
        for _ in 0...3 {
            addPart(scene: scene, color: colorFactory.pop())
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
