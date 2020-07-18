
import Foundation
import UIKit

class ColorFactory {

    var lastColorIndex = 0

    let colors: [UIColor] = [
         .yellow,
         .orange,
         .red,
         .purple,
         .blue,
         .green
     ]
    
    func pop() -> UIColor {
        let color = colors[lastColorIndex % colors.count]
        lastColorIndex += 1
        return color
    }
    
}
