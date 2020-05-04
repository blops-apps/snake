import Foundation
import SpriteKit

class GamePhysicsFactory {

    static func rectangle(size: CGSize, category: PhysicsCategory, testContact: PhysicsCategory) -> SKPhysicsBody {
        let body = SKPhysicsBody(rectangleOf: size)
        assignProperties(body: body, category: category, testContact: testContact)
        return body
    }
    
    static func circle(radius: CGFloat, category: PhysicsCategory, testContact: PhysicsCategory) -> SKPhysicsBody {
        let body = SKPhysicsBody(circleOfRadius: radius)
        assignProperties(body: body, category: category, testContact: testContact)
        return body
    }
    
    private static func assignProperties(body: SKPhysicsBody, category: PhysicsCategory, testContact: PhysicsCategory) {
        body.categoryBitMask = category.rawValue
        body.contactTestBitMask = testContact.rawValue
        body.collisionBitMask = PhysicsCategory.none.rawValue
        body.usesPreciseCollisionDetection = true
        body.isDynamic = true
    }
    
}
