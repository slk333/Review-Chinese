import UIKit
import CoreData

// variables globales


var hskLevel=1
var wordsNumberForCurrentLevel:Int{
    switch hskLevel{
    case 1:
        return 153
    case 2:
        return 303
    case 3:
        return 603
    case 4:
        return 1203
    case 5:
        return 2403
    default:
    return 0
    }
    
    
}
 
var voiceEnabled=false




// MENU VIEW CONTROLLER

class Menu: UIViewController {
    
    
    @IBOutlet weak var startTrainingButton: UIButton!
    @IBOutlet weak var dashboardButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    
    
    
    
    
    
    
    
    
    
    var scoreTotalActuel:Int=0
     let context=(UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewWillAppear(_ animated: Bool) {
        print(hskLevel)
        
        // Calculer le score total à partir de la base de donnée
        // les autres view ne font que mettre à jour à ce chiffre, sans calculer à chaque fois le score à partir de la base de donnée.
        
        let motsRequest=NSFetchRequest<Mot>(entityName: "Mot")
        let restrictionPredicate=NSPredicate(format: "%K < %@", #keyPath(Mot.index), String(wordsNumberForCurrentLevel))
         motsRequest.predicate=NSCompoundPredicate(andPredicateWithSubpredicates: [restrictionPredicate])
        
        let mots=try! context.fetch(motsRequest)
        
        scoreTotalActuel=0
        for mot in mots{
            scoreTotalActuel+=Int(mot.themeScore)
        }
   

    }
    
    override func viewDidLoad() {
        let kern = 1
     startTrainingButton.titleLabel?.attributedText = NSAttributedString(string: "START TRAINING", attributes: [.kern: kern])
      dashboardButton.titleLabel?.attributedText = NSAttributedString(string: "DASHBOARD", attributes: [.kern: kern])
        settingsButton.titleLabel?.attributedText = NSAttributedString(string: "SETTINGS", attributes: [.kern: kern])
        
        
        
        
        
        
        
          super.viewDidLoad()
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                // passer scoreTotalActuel à enterWord Scene pour qu'elle affiche et update le score
        if segue.identifier=="toFlashcard"{
            (segue.destination as! Flashcard).currentScore=scoreTotalActuel
        }
    }
  }
