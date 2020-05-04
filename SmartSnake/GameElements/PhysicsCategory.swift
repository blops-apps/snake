import Foundation

enum PhysicsCategory: UInt32 {
    case none = 0
    case snake = 0b1
    case walls = 0b10
    case apple = 0b11
}
