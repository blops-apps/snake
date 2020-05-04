import SpriteKit
import GameplayKit

class GameScene: SKScene {

    let snake = Snake()

    var score: Int = 0
    var onFailure: ((Int) -> Void)? = nil

    init(size: CGSize, onFailure: @escaping (Int) -> Void) {
        self.onFailure = onFailure
        super.init(size: size)
        backgroundColor = UIColor(named: "GameBackground")!
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func start() {
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        snake.start(scene: self)
        
        Wall.addTop(scene: self)
        Wall.addBottom(scene: self)
        Wall.addLeft(scene: self)
        Wall.addRight(scene: self)
        
        Apple.spawn(scene: self)
    }
    
    func touchedLeft() {
        snake.changeSnakeDirection(direction: .left)
    }
    
    func touchedRight() {
        snake.changeSnakeDirection(direction: .right)
    }
    
}

extension GameScene: SKPhysicsContactDelegate {

    func wallCollision() {
        snake.freeze()
        ScoreRepository().save(score: score)
        if let callback = onFailure {
            callback(score)
            onFailure = nil
        }
    }

    func appleCollision(node: SKNode) {
        score += 1
        node.removeFromParent()
        Apple.spawn(scene: self)
        snake.increaseLength(scene: self)
        snake.increaseSpeed()
    }

    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }

        if (firstBody.categoryBitMask == PhysicsCategory.snake.rawValue) {
            if secondBody.categoryBitMask == PhysicsCategory.walls.rawValue {
                wallCollision()
            } else if secondBody.categoryBitMask == PhysicsCategory.apple.rawValue {
                if let apple = secondBody.node {
                    appleCollision(node: apple)
                }
            }
        }
    }
}


