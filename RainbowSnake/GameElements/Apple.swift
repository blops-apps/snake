import Foundation
import SpriteKit

class Apple {

    static let appleSize = CGSize(width: 20, height: 20)

    static func spawn(scene: SKScene, color: UIColor) {
        let node = SKSpriteNode(color: color, size: appleSize)

        let x = CGFloat.random(in: 0...scene.size.width) / 1.3 - scene.size.width / 2
        let y = CGFloat.random(in: 0...scene.size.height) / 1.3 - scene.size.height / 2

        node.physicsBody = GamePhysicsFactory.rectangle(size: appleSize, category: .apple, testContact: .snake)

        node.position = CGPoint(x: x, y: y)
        scene.addChild(node)
    }

}
