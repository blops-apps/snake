import Foundation
import SpriteKit

class Apple {

    static let appleSize = CGSize(width: 20, height: 20)

    static func spawn(scene: SKScene) {
        let node = SKSpriteNode(color: UIColor.red, size: appleSize)

        let x = CGFloat.random(in: 0...scene.size.width) / 2.5
        let y = CGFloat.random(in: 0...scene.size.height) / 2.5

        node.physicsBody = GamePhysicsFactory.rectangle(size: appleSize, category: .apple, testContact: .snake)

        node.position = CGPoint(x: x, y: y)
        scene.addChild(node)
    }

}
