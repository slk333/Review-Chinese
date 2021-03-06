import UIKit
// version => chinese to english

class ScoreManager{

    var currentScore = 0
    var perfectScore = 0
    
    init(wordManager:WordManager) {
        
        if let allWords = wordManager.getAllWords(){
            perfectScore = allWords.count * MAX_SCORE
            
            for word in allWords {
                currentScore += Int(word.versionScore)
                
            }
        }
       
    }
    
}
