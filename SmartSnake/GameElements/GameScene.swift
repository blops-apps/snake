import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    let snake = Snake()

    var onFailure: (() -> Void)? = nil
    
    init(size: CGSize, onFailure: @escaping () -> Void) {
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
        if let callback = onFailure {
            callback()
            onFailure = nil
        }
    }
    
    func appleCollision(node: SKNode) {
        node.removeFromParent()
        Apple.spawn(scene: self)
        snake.increaseLength(scene: self)
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


