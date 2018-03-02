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


class Flashcard: UIViewController,UITextFieldDelegate {
    
    // critère de selection Core Data qui se base sur les niveaux selectionnés dans les réglages
    var levelPredicate: NSCompoundPredicate!
    
    // réglage pour savoir si version(traduction du chinois) ou thème (trouver le chinois)
    var themeFlashcard = true
    var versionFlashcard = false

    
    let context=(UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var currentMot:Mot!
    var correctText:String!
    var scoreTotalActuel:Int=0
    var stringToEnter=""
    let defaultGreenColor=UIColor(red: 65/255, green: 199/255, blue: 34/255, alpha: 0.75)
    var incrementUp = Int32(3)

  let speechSynthesizer = AVSpeechSynthesizer()
  let voice=AVSpeechSynthesisVoice.init(language: "zh-CN")
    var utterance=AVSpeechUtterance(string: "我")
    

    
    @IBOutlet weak var characterLabel:UILabel!
    @IBOutlet weak var definitionTV:UITextView!
    @IBOutlet weak var answerTF: UITextField!
    @IBOutlet weak var correctOrFalseSymbolLabel:UILabel!
    @IBOutlet weak var scoreBar:UIProgressView!
    @IBOutlet weak var infoButton: UIButton!
     @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var wrongButton: UIButton!
    
    
    override func viewWillAppear(_ animated: Bool) {
        // La scène Flashcard va s'afficher à l'écran
        
        // Load les réglages, qui resteront fixes tant que la Flashcard est à l'écran
        // Creer un critère de selection en fonction des règlages
        // Stocker ce critère pour pouvoir l'utiser à chaque nouvelle question
        
            let settings = UserDefaults.standard
        
        // quelles sont les listes sélectionnées dans les réglages
        
        var levelPredicates=[NSPredicate]()
        if settings.bool(forKey: "HSK 1"){
            levelPredicates.append(NSPredicate(format: "%K == %@", #keyPath(Mot.level), "1"))
            }
        if settings.bool(forKey: "HSK 2"){
            levelPredicates.append(NSPredicate(format: "%K == %@", #keyPath(Mot.level), "2"))
        }
        if settings.bool(forKey: "HSK 3"){
            levelPredicates.append(NSPredicate(format: "%K == %@", #keyPath(Mot.level), "3"))
        }
        if settings.bool(forKey: "HSK 4"){
            levelPredicates.append(NSPredicate(format: "%K == %@", #keyPath(Mot.level), "4"))
        }
        if settings.bool(forKey: "HSK 5"){
            levelPredicates.append(NSPredicate(format: "%K == %@", #keyPath(Mot.level), "5"))
        }
        if settings.bool(forKey: "HSK 6"){
            levelPredicates.append(NSPredicate(format: "%K == %@", #keyPath(Mot.level), "6"))
        }
        if settings.bool(forKey: "Custom List"){
            levelPredicates.append(NSPredicate(format: "%K == %@", #keyPath(Mot.level), "7"))
        }
        
        levelPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: levelPredicates)
       
        // quel est le mode d'apprentissage: version/thème (CN->EN/ EN->CN) ou les deux
        versionFlashcard = settings.bool(forKey: "Chinese To English")
        themeFlashcard = settings.bool(forKey: "English To Chinese")
        print("themeFlashcard: ")
        print(themeFlashcard)
        versionFlashcard = !themeFlashcard
        
        createNewQuestion()
        
    }
    
    @IBAction func backFromDefinitionScene(segue:UIStoryboardSegue){
        
        createNewQuestion()
    }

    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // on va dans la scene de definition
        guard let _ = sender as? UIButton else{return}
        
        // si c'est via le bouton faux, on réduit le score
        
        decreaseScoreAndSave()
        
        // passer le mot actuel à la dictionaryScene
        (segue.destination as! DetailViewController).mot=currentMot
        (segue.destination as! DetailViewController).haveBackItem = false
}
    
    @IBAction func skip(_ sender: UIButton){
        if correctOrFalseSymbolLabel.text! != "✗"{
            
            
          increaseScoreAndSave()
            
        }
        
        // gestion de l'interface
        correctOrFalseSymbolLabel.textColor=defaultGreenColor
        correctOrFalseSymbolLabel.text="✓"
        characterLabel.text=currentMot.character
        answerTF.text=currentMot.pinyin
        // afficher la définition
        skipButton.isEnabled=false
        wrongButton.isEnabled=false
        definitionTV.text=currentMot.definition
        // VOICE
        if voiceEnabled{
            self.speechSynthesizer.speak(utterance)}
        
        
        
        
        // schedule la new question dans 1 seconde
        
        _=Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: {_ in self.createNewQuestion()})
        
        
    }
    
    func increaseScoreAndSave(){
        if themeFlashcard{
        
        if currentMot.themeScore < 6 {incrementUp = 3}
        if currentMot.themeScore >= 6 {incrementUp = 2}
        if currentMot.themeScore >= 8 {incrementUp = 1}
        if currentMot.themeScore == 10 {incrementUp = 0}
        if currentMot.themeScore == 11 {incrementUp = -1}
        currentMot.themeScore += Int16(incrementUp)
        updateExpirationDateAndSave()
            scoreTotalActuel += Int(incrementUp)
            
        }
        else if versionFlashcard{
            
            if currentMot.versionScore < 6 {incrementUp = 3}
            if currentMot.versionScore >= 6 {incrementUp = 2}
            if currentMot.versionScore >= 8 {incrementUp = 1}
            if currentMot.versionScore == 10 {incrementUp = 0}
            if currentMot.versionScore == 11 {incrementUp = -1}
            currentMot.versionScore += Int16(incrementUp)
            updateExpirationDateAndSave()
            scoreTotalActuel += Int(incrementUp)
            
        }
        
    }
    
    func decreaseScoreAndSave(){
        
        if themeFlashcard{
        if currentMot.themeScore>3{currentMot.themeScore=3}
        else {
            if currentMot.themeScore>1{currentMot.themeScore-=2}
            else{ if currentMot.themeScore==1{currentMot.themeScore=0}}}
        updateExpirationDateAndSave()
        scoreTotalActuel-=1
        }
        else if versionFlashcard{
            
            if currentMot.versionScore>3{currentMot.versionScore=3}
            else {
                if currentMot.versionScore>1{currentMot.versionScore-=2}
                else{ if currentMot.versionScore==1{currentMot.versionScore=0}}}
            updateExpirationDateAndSave()
            scoreTotalActuel-=1
        }
            
        }
    
    
  

    
    func updateExpirationDateAndSave(){
        // définition d'une nouvelle date de révision et sauvegarde
        if themeFlashcard{
        let tempsÀajouter=100*pow(3, Double(currentMot.themeScore))
        currentMot.themeExpiration=Int64(Date(timeIntervalSinceNow: tempsÀajouter).timeIntervalSinceReferenceDate)
        try! context.save()
        }
        else if versionFlashcard{
            let tempsÀajouter=100*pow(3, Double(currentMot.versionScore))
            currentMot.versionExpiration=Int64(Date(timeIntervalSinceNow: tempsÀajouter).timeIntervalSinceReferenceDate)
            try! context.save()
            
        }
        
        
    }
    
    
    
    func createNewQuestion(){
        // Nettoyer et préparer l'interface

        skipButton.isEnabled=true
        wrongButton.isEnabled=true
        correctOrFalseSymbolLabel.text=""
        answerTF.text=""
        definitionTV.text=""
        answerTF.isEnabled=false
        
        /*
        scoreBar.progress=Float(scoreTotalActuel)/Float(wordsNumberForCurrentLevel*10)
        print(Float(scoreTotalActuel)/Float(wordsNumberForCurrentLevel*10))
 */
        
        // Choix d'une flashcard
        // Thème ou Version
        
      
        

        // Vérifier si il y a des mot à réviser
        
        
        let currentDateAsNumber:Double=Date().timeIntervalSinceReferenceDate
        let expiredWordsRequest=NSFetchRequest<Mot>(entityName: "Mot")
        
        // PREDICATES
      
          if themeFlashcard{
            let reviewPredicate=NSPredicate(format: "%K < %@", #keyPath(Mot.themeExpiration), String(currentDateAsNumber))
            expiredWordsRequest.predicate=NSCompoundPredicate(andPredicateWithSubpredicates: [levelPredicate,reviewPredicate])
            
            let sorting=NSSortDescriptor(key: "themeExpiration", ascending: true)
            expiredWordsRequest.sortDescriptors=[sorting]
        
            guard  let expiredWords=try? context.fetch(expiredWordsRequest) else {return}
        
            if expiredWords.count != 0{
                // si il y a un mot à réviser, on prend le plus ancien
            currentMot=expiredWords.first
            }
            
            else{
            // Il n'y a plus de mot à réviser
            // 1) il reste des mots jamais apparus
                
            let fetchNeverSeenWordRequest=NSFetchRequest<Mot>(entityName: "Mot")
              
            
                    let newPredicate=NSPredicate(format: "%K == %@", #keyPath(Mot.themeExpiration), "1000000000")
                    fetchNeverSeenWordRequest.predicate=NSCompoundPredicate(andPredicateWithSubpredicates: [levelPredicate,newPredicate])
                
                guard let neverSeenWords=try? context.fetch(fetchNeverSeenWordRequest)else{return}
              
                if neverSeenWords.count != 0{
                    currentMot=neverSeenWords[Int(arc4random_uniform(UInt32(neverSeenWords.count)))]
                
                }
            
                // il ne reste plus du tout de mots à réviser

            else {
                    skipButton.isHidden=true
            answerTF.text="Come back later!"
                    answerTF.isEnabled=false
            characterLabel.text=""
            infoButton.isHidden=true
                 return
                }
           
        
        }
        
        
        // mise à jour de l'interface
      
        characterLabel.text=""
        definitionTV.text=currentMot.definition
        correctText=currentMot.pinyin!
            
        }
        
        if versionFlashcard{
            
            // PREDICATES
            
   
            let reviewPredicate=NSPredicate(format: "%K < %@", #keyPath(Mot.versionExpiration), String(currentDateAsNumber))
            expiredWordsRequest.predicate=NSCompoundPredicate(andPredicateWithSubpredicates: [levelPredicate,reviewPredicate])
            
            
            let sorting=NSSortDescriptor(key: "versionExpiration", ascending: true)
            expiredWordsRequest.sortDescriptors=[sorting]
            
            guard  let expiredWords=try? context.fetch(expiredWordsRequest) else {return}
            
            if expiredWords.count != 0{
                // si il y a un mot à réviser, on prend le plus ancien
                currentMot=expiredWords.first
            }
                
            else{
                
                // Il n'y a plus de mot à réviser
                // 1) il reste des mots jamais apparus
                
                let fetchNeverSeenWordRequest=NSFetchRequest<Mot>(entityName: "Mot")
                
                
                let newPredicate=NSPredicate(format: "%K == %@", #keyPath(Mot.versionExpiration), "1000000000")
                fetchNeverSeenWordRequest.predicate=NSCompoundPredicate(andPredicateWithSubpredicates: [levelPredicate,newPredicate])
                
                guard let neverSeenWords=try? context.fetch(fetchNeverSeenWordRequest)else{return}
                
                if neverSeenWords.count != 0{
                    currentMot=neverSeenWords[Int(arc4random_uniform(UInt32(neverSeenWords.count)))]
                    
                }
                    
                    // il ne reste plus du tout de mots à réviser
                    
                else {
                    skipButton.isHidden=true
                    answerTF.text="Come back later!"
                    answerTF.isEnabled=false
                    characterLabel.text=""
                    infoButton.isHidden=true
                    return
                }
                
                
            }
            
            // mise à jour de l'interface
            

            characterLabel.text = currentMot.character
            correctText=currentMot.pinyin!
            

            
            
        }
        
        
        if voiceEnabled{
            utterance=AVSpeechUtterance(string: currentMot.character!)
            utterance.voice=self.voice
            
        }
        
        
        print("coredata level:\(currentMot.level)")
        print("theme \(themeFlashcard)")
    }
    
    override func viewDidLoad() {
        let textFieldAppearance = UITextField.appearance()
        textFieldAppearance.keyboardAppearance = .dark
        super.viewDidLoad()
        
       // answerTF.becomeFirstResponder()
        
        
        
        // Do any additional setup after loading the view.
    }
}
