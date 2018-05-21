import UIKit
import CoreData

class Word{}

class WordManager{
    let versionIsEnabled:Bool
    let themeIsEnabled:Bool
    
    let context=(UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var reviewListIsEmpty:Bool!
    
    
    
    
    
    
    
    private func getRandomWordFromFreshList()->Word{return Word()}
    private func getWordFromReviewList()->Word{return Word()}

    func getWord()->Word{return Word()}

    func changeScoreBy(_ n:Int,forWord:Word){}
    
    
    
    
    init(versionIsEnabled:Bool,themeIsEnabled:Bool) {
        self.versionIsEnabled = versionIsEnabled
        self.themeIsEnabled = themeIsEnabled
    }
    
    
}
