import SpriteKit
import GameplayKit

class GameScene: SKScene {

    let snake = Snake()
    let background: SKSpriteNode
    
    var score: Int = 0
    var onFailure: ((Int) -> Void)? = nil

    init(size: CGSize, onFailure: @escaping (Int) -> Void) {
        self.onFailure = onFailure
        self.background = SKSpriteNode(color: UIColor(named: "GameBackground")!, size: size)
        super.init(size: size)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeBackgroundColor() {
        let randomHue = CGFloat.random(in: 0...1.0)
        let newColor = UIColor(hue: randomHue, saturation: 0.9, brightness: 0.3, alpha: 1.0)
        let colorize = SKAction.colorize(with: newColor, colorBlendFactor: 0.5, duration: 0.5)
        background.run(colorize)
    }

    func start() {
        addChild(background)
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
        changeBackgroundColor()
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


