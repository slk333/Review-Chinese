import UIKit
import CoreData
import AVFoundation


// Présenter une flashcard et réagir à la réponse


// 1) L'utilisateur veut une flashcard
// Creer un critère de selection en fonction des règlages et des données
// Aller chercher l'élément dans la base de donnée
// Modifier l'interface pour afficher l'élément
//

// 2) L'utilisateur répond
// Réagir en modifiant l'interface
// Réagir en modifiant les données
// Repartir sur le 1)

class Flashcard: UIViewController{
    
        // MARK: - Properties
    
    
    // critère de selection Core Data qui se base sur les niveaux selectionnés dans les réglages
    var levelPredicate: NSCompoundPredicate!
    
    // réglage pour savoir si version(traduction du chinois) ou thème (trouver le chinois)
    var themeFlashcard = true
    var versionFlashcard = false
    
    
    let context=(UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var currentWord:Mot!
    var correctText:String!
    var currentScore:Int=0
    let defaultGreenColor=UIColor(red: 65/255, green: 199/255, blue: 34/255, alpha: 0.75)
    var incrementUp = Int32(3)
    
    let speechSynthesizer = AVSpeechSynthesizer()
    let voice=AVSpeechSynthesisVoice.init(language: "zh-CN")
    var utterance=AVSpeechUtterance(string: "我")
    
    var wordManager: WordManager!
    
    // MARK: - Outlets
    
    
    @IBOutlet weak var characterLabel:UILabel!
    @IBOutlet weak var definitionLabel: UILabel!
    @IBOutlet weak var pronunciationTF: UITextField!
    @IBOutlet weak var correctOrFalseSymbolLabel:UILabel!
    @IBOutlet weak var scoreBar:UIProgressView!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var wrongButton: UIButton!
    @IBOutlet weak var toggleButtonsButton: UIButton!
    @IBOutlet weak var setScoreTo0Button: UIButton!
    @IBOutlet weak var setScoreTo10Button: UIButton!
    
    
   
    // MARK: - IBActions

    
    
    
    @IBAction func notSureAboutTheAnswer(_ sender: UIButton?){
        
        wordManager.updateExpirationDate(for: currentWord)
        displayAnswerInterface()
        createNewQuestionIn(seconds: 1)
        
    }
    
    
    @IBAction func noIdeaAboutTheAnswer(_ sender: UIButton?){
        
        wordManager.decreaseScore(for: currentWord, toZero: false)
        displayAnswerInterface()
        createNewQuestionIn(seconds: 2)
        
    }
    
    @IBAction func resetScore(_ sender: UIButton?){
        
        wordManager.decreaseScore(for: currentWord, toZero: true)
        displayAnswerInterface()
        createNewQuestionIn(seconds: 5)
        
    }
    
    @IBAction func skipWordForALongTime(_ sender: UIButton?){
        
        wordManager.increaseScore(for: currentWord, toTen: true)
        displayAnswerInterface()
        createNewQuestionIn(seconds: 0.5)
        
    }
    
    
    
    
    
    @IBAction func enable0and10Buttons(_ sender: UIButton?){
        
        setScoreTo0Button.isEnabled = true
        setScoreTo10Button.isEnabled = true
        setScoreTo0Button.setTitle("0", for: .normal)
        setScoreTo10Button.setTitle("10", for: .normal)
        sender?.removeTarget(self, action: #selector(enable0and10Buttons), for: .touchUpInside)
        sender?.addTarget(self, action: #selector(disable0and10Buttons), for: .touchUpInside)
        
      }
    
    @objc func disable0and10Buttons(){
        
        setScoreTo0Button.isEnabled = false
        setScoreTo10Button.isEnabled = false
        setScoreTo0Button.setTitle("", for: .normal)
        setScoreTo10Button.setTitle("", for: .normal)
        toggleButtonsButton.removeTarget(self, action: #selector(disable0and10Buttons), for: .touchUpInside)
        toggleButtonsButton.addTarget(self, action: #selector(enable0and10Buttons), for: .touchUpInside)
        
    }
    
    
    
   func displayAnswerInterface(){
    // gestion de l'interface
 
    correctOrFalseSymbolLabel.textColor=defaultGreenColor
    correctOrFalseSymbolLabel.text="✓"
    skipButton.isEnabled=false
    wrongButton.isEnabled=true
    infoButton.isEnabled=false
    toggleButtonsButton.isEnabled=false
    
    if voiceEnabled{self.speechSynthesizer.speak(utterance)}
    
    // afficher la réponse
    characterLabel.text=currentWord.character
    pronunciationTF.text=currentWord.pinyin
    definitionLabel.text=currentWord.definition
    }
    
    
    func createNewQuestionIn(seconds:Double){
    _=Timer.scheduledTimer(withTimeInterval: seconds, repeats: false, block: {_ in self.createNewQuestion()})
    }
    
    

    
    @IBAction func skip(_ sender: UIButton){
        // n'augmenter le score que si il n'y pas de croix
        
        wordManager.increaseScore(for: currentWord, toTen: false)
    
        displayAnswerInterface()
     
        
        // schedule la new question dans x temps
        createNewQuestionIn(seconds: 0.5)
        
        }
    
    
      // MARK: - Methodes
    
   
    
    func createNewQuestion(){
        
        // Nettoyer et préparer l'interface
        skipButton.isEnabled=true
        wrongButton.isEnabled=true
        infoButton.isEnabled=true
        toggleButtonsButton.isEnabled=true
        correctOrFalseSymbolLabel.text=""
        pronunciationTF.text=""
        definitionLabel.text=""
        
        
        
        /*
         scoreBar.progress=Float(currentScore)/Float(wordsNumberForCurrentLevel*10)
         print(Float(currentScore)/Float(wordsNumberForCurrentLevel*10))
         */
        
        
        if let obtainedWord = wordManager.getWord() {
                    currentWord = obtainedWord
                }
                    
                else { // il n'y a plus rien à réviser ou à apprendre
                    skipButton.isHidden=true
                    pronunciationTF.text="Come back later!"
                    pronunciationTF.isEnabled=false
                    characterLabel.text=""
                    infoButton.isHidden=true
                    return
                }
                
        if themeFlashcard{
            characterLabel.text=""
            definitionLabel.text=currentWord.definition}
            
        if versionFlashcard{
            characterLabel.text = currentWord.character
            
        }
        
        
      /*  if voiceEnabled{
            utterance=AVSpeechUtterance(string: currentWord.character!)
            utterance.voice=self.voice
            
        } */
        
        
        print("coredata level:\(currentWord.level)")
        print("theme \(themeFlashcard)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        // La scène Flashcard va s'afficher à l'écran
        
        // créer un wordManager qui gérera la logique relative à : fournir le mot à réviser et sauvegarder les progrès dans la mémoire persistente
        
        wordManager = WordManager(versionIsEnabled: versionFlashcard, themeIsEnabled: themeFlashcard)

        
        // Load les réglages, qui resteront fixes tant que la Flashcard est à l'écran
        // Creer un critère de selection en fonction des règlages
        // Stocker ce critère pour pouvoir l'utiser à chaque nouvelle question
        
        let settings = UserDefaults.standard
        
        // quelles sont les listes sélectionnées dans les réglages
    
        
        // quel est le mode d'apprentissage: version/thème (CN->EN/ EN->CN) ou les deux
        versionFlashcard = settings.bool(forKey: "Chinese To English")
        themeFlashcard = settings.bool(forKey: "English To Chinese")
        print("themeFlashcard: ")
        print(themeFlashcard)
        versionFlashcard = !themeFlashcard
        
        createNewQuestion()
        
    }
}
