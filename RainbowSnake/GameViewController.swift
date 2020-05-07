import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    var scene: GameScene? = nil
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reset()
    }
    
    func reset() {
        if let view = self.view as! SKView? {
            let newScene = GameScene(size: view.bounds.size, onFailure: { [weak self] score in
                self?.gameDidFail(score: score)
            })
            newScene.start()
            view.presentScene(newScene)
            scene = newScene
            view.ignoresSiblingOrder = true
            view.presentScene(scene)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func gameDidFail(score: Int) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let retryViewController = storyBoard.instantiateViewController(withIdentifier: "retryVC") as! RetryViewController
        retryViewController.gameViewController = self
        retryViewController.score = score
        retryViewController.modalPresentationStyle = .overCurrentContext
        self.present(retryViewController, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let location = touch.location(in: self.view)
            
            if(location.x < self.view.frame.size.width / 2){
                scene?.touchedLeft()
            }
            else {
                scene?.touchedRight()
            }
        }
    }
    
    override var shouldAutorotate: Bool {
        return false
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
