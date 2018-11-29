import UIKit
import CoreData

// MENU VIEW CONTROLLER

class MenuVC: UIViewController {
    
    
    @IBOutlet weak var startTrainingButton: UIButton!
    @IBOutlet weak var dashboardButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!

   
   //  let scoreManager = ScoreManager(hskLevel: 1)
    
    
    override func viewWillAppear(_ animated: Bool) {
        
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
            
           // (segue.destination as! FlashcardVC).currentScore = scoreManager.scoreTotalActuel
        
        }
    }
  }
