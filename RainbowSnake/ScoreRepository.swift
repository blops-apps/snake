import Foundation

class ScoreRepository {
    
    let userDefaults = UserDefaults.standard
    
    func save(score: Int) {
        if let previousScore = retrieve(), previousScore > score {
            return
        }
        userDefaults.set(score, forKey: "bestScore")
    }
    
    func retrieve() -> Int? {
        return userDefaults.value(forKey: "bestScore") as? Int
    }
    
}
