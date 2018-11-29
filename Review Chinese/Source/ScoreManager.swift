import UIKit
import CoreData

class ScoreManager{
    // variables globales
    
    private let HSK1_WORD_COUNT = 153
    private let HSK2_WORD_COUNT = 150
    private let HSK3_WORD_COUNT = 300
    private let HSK4_WORD_COUNT = 600
    private let HSK5_WORD_COUNT = 1200
    // let HSK6_WORD_COUNT = 0
    
    var scoreTotalActuel = 0
    private let context=(UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    private var hskLevel = 1
    private var currentTotalWordCount:Int{
        switch hskLevel{
        case 1:
            return HSK1_WORD_COUNT
        case 2:
            return HSK1_WORD_COUNT + HSK2_WORD_COUNT
        case 3:
            return HSK1_WORD_COUNT + HSK2_WORD_COUNT + HSK3_WORD_COUNT
        case 4:
            return HSK1_WORD_COUNT + HSK2_WORD_COUNT + HSK3_WORD_COUNT + HSK4_WORD_COUNT
        case 5:
            return HSK1_WORD_COUNT + HSK2_WORD_COUNT + HSK3_WORD_COUNT + HSK4_WORD_COUNT + HSK5_WORD_COUNT
        default:
            return 0
        }
        
        
    }
    
    
    
    init(hskLevel:Int) {
        
        print(hskLevel)
        
        // Calculer le score total à partir de la base de donnée
        // les autres view ne font que mettre à jour à ce chiffre, sans calculer à chaque fois le score à partir de la base de donnée.
        
        let motsRequest=NSFetchRequest<Mot>(entityName: "Mot")
        let restrictionPredicate=NSPredicate(format: "%K < %@", #keyPath(Mot.index), String(currentTotalWordCount))
        motsRequest.predicate=NSCompoundPredicate(andPredicateWithSubpredicates: [restrictionPredicate])
        
        let mots = try! context.fetch(motsRequest)
        
        
        for mot in mots{
            scoreTotalActuel+=Int(mot.themeScore)
        }
    
    }
    
}
