import Foundation
import UIKit

class RetryViewController: UIViewController {
    
    var gameViewController: GameViewController!
    var score: Int = 0
    
    @IBOutlet weak var scoreText: UITextField!
    @IBOutlet weak var bestScoreText: UITextField!
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor(named: "FailureBackgroundColor")
        scoreText.text = "\(score)"
        if let bestScore = ScoreRepository().retrieve() {
            bestScoreText.text = "\(bestScore)"
        }
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    @IBAction func retryTouched(_ sender: Any) {
        self.dismiss(animated: true) {
            self.gameViewController.reset()
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}
