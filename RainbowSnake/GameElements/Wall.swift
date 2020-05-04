import Foundation
import SpriteKit

class Wall {
    
    static func addLeft(scene: SKScene) {
        add(
            size: CGSize(width: 10, height: scene.size.height),
            position: CGPoint(x: -(scene.size.width / 2 - 10), y: 0),
            scene: scene
        )
    }
    
    static func addRight(scene: SKScene) {
        add(
            size: CGSize(width: 10, height: scene.size.height),
            position: CGPoint(x: scene.size.width / 2 - 10, y: 0),
            scene: scene
        )
    }
    
    static func addTop(scene: SKScene) {
        add(
            size: CGSize(width: scene.size.width, height: 10),
            position: CGPoint(x: 0, y: scene.size.height / 2 - 10),
            scene: scene
        )
    }
    
    static func addBottom(scene: SKScene) {
        add(
            size: CGSize(width: scene.size.width, height: 10),
            position: CGPoint(x: 0, y: -(scene.size.height / 2 - 10)),
            scene: scene
        )
    }
    
    static func add(size: CGSize, position: CGPoint, scene: SKScene) {
        let node = SKSpriteNode(color: UIColor.clear, size: size)
        node.physicsBody = GamePhysicsFactory.rectangle(size: size, category: .walls, testContact: .snake)
        node.position = position
        scene.addChild(node)
    }
}
