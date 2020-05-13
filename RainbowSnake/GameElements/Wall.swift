import Foundation
import SpriteKit

class Wall {
    
    private static let thickness: CGFloat = 10
    
    private static func borderPosition(_ size: CGFloat) -> CGFloat {
        return (size + thickness) / 2
    }
        
    static func addLeft(scene: SKScene) {
        add(
            size: CGSize(width: thickness, height: scene.size.height),
            position: CGPoint(x: -(borderPosition(scene.size.width)), y: 0),
            scene: scene
        )
    }
    
    static func addRight(scene: SKScene) {
        add(
            size: CGSize(width: 10, height: scene.size.height),
            position: CGPoint(x: borderPosition(scene.size.width), y: 0),
            scene: scene
        )
    }
    
    static func addTop(scene: SKScene) {
        add(
            size: CGSize(width: scene.size.width, height: 10),
            position: CGPoint(x: 0, y: borderPosition(scene.size.height)),
            scene: scene
        )
    }
    
    static func addBottom(scene: SKScene) {
        add(
            size: CGSize(width: scene.size.width, height: 10),
            position: CGPoint(x: 0, y: -borderPosition(scene.size.height)),
            scene: scene
        )
    }
    
    static func add(size: CGSize, position: CGPoint, scene: SKScene) {
        let node = SKSpriteNode(color: UIColor.red, size: size)
        node.physicsBody = GamePhysicsFactory.rectangle(size: size, category: .walls, testContact: .snake)
        node.position = position
        scene.addChild(node)
    }
}
