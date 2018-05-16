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
    
    
    
    @IBOutlet weak var characterLabel:UILabel!
   
    @IBOutlet weak var definitionLabel: UILabel!
    @IBOutlet weak var pronunciationTF: UITextField!
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
    
    
    /*
     
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // on va dans la scene de definition
     guard let _ = sender as? UIButton else{return}
     
     // si c'est via le bouton faux, on réduit le score
     
     decreaseScoreAndSave()
     
     // passer le mot actuel à la dictionaryScene
     (segue.destination as! DetailViewController).mot=currentWord
     (segue.destination as! DetailViewController).haveBackItem = false
     }
     */
    
    @IBAction func skip(_ sender: UIButton){
        if correctOrFalseSymbolLabel.text! != "✗"{
            
            
            increaseScoreAndSave()
            
        }
        
        // gestion de l'interface
        correctOrFalseSymbolLabel.textColor=defaultGreenColor
        correctOrFalseSymbolLabel.text="✓"
        characterLabel.text=currentWord.character
        pronunciationTF.text=currentWord.pinyin
        // afficher la définition
        skipButton.isEnabled=false
        wrongButton.isEnabled=false
        definitionLabel.text=currentWord.definition
        // VOICE
        if voiceEnabled{
            self.speechSynthesizer.speak(utterance)}
        
        
        
        
        // schedule la new question dans 1 seconde
        
        _=Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: {_ in self.createNewQuestion()})
        
        
    }
    
    func increaseScoreAndSave(){
        if themeFlashcard{
            
            if currentWord.themeScore < 6 {incrementUp = 3}
            if currentWord.themeScore >= 6 {incrementUp = 2}
            if currentWord.themeScore >= 8 {incrementUp = 1}
            if currentWord.themeScore == 10 {incrementUp = 0}
            if currentWord.themeScore == 11 {incrementUp = -1}
            currentWord.themeScore += Int16(incrementUp)
            updateExpirationDateAndSave()
            currentScore += Int(incrementUp)
            
        }
        else if versionFlashcard{
            
            if currentWord.versionScore < 6 {incrementUp = 3}
            if currentWord.versionScore >= 6 {incrementUp = 2}
            if currentWord.versionScore >= 8 {incrementUp = 1}
            if currentWord.versionScore == 10 {incrementUp = 0}
            if currentWord.versionScore == 11 {incrementUp = -1}
            currentWord.versionScore += Int16(incrementUp)
            updateExpirationDateAndSave()
            currentScore += Int(incrementUp)
            
        }
        
    }
    
    func decreaseScoreAndSave(){
        
        if themeFlashcard{
            if currentWord.themeScore>3{currentWord.themeScore=3}
            else {
                if currentWord.themeScore>1{currentWord.themeScore-=2}
                else{ if currentWord.themeScore==1{currentWord.themeScore=0}}}
            updateExpirationDateAndSave()
            currentScore-=1
        }
        else if versionFlashcard{
            
            if currentWord.versionScore>3{currentWord.versionScore=3}
            else {
                if currentWord.versionScore>1{currentWord.versionScore-=2}
                else{ if currentWord.versionScore==1{currentWord.versionScore=0}}}
            updateExpirationDateAndSave()
            currentScore-=1
        }
        
    }
    
    
    
    
    
    func updateExpirationDateAndSave(){
        // définition d'une nouvelle date de révision et sauvegarde
        if themeFlashcard{
            let tempsÀajouter=100*pow(3, Double(currentWord.themeScore))
            currentWord.themeExpiration=Int64(Date(timeIntervalSinceNow: tempsÀajouter).timeIntervalSinceReferenceDate)
            try! context.save()
        }
        else if versionFlashcard{
            let tempsÀajouter=100*pow(3, Double(currentWord.versionScore))
            currentWord.versionExpiration=Int64(Date(timeIntervalSinceNow: tempsÀajouter).timeIntervalSinceReferenceDate)
            try! context.save()
            
        }
        
        
    }
    
    
    
    func createNewQuestion(){
        // Nettoyer et préparer l'interface
        
        skipButton.isEnabled=true
        wrongButton.isEnabled=true
        correctOrFalseSymbolLabel.text=""
        pronunciationTF.text=""
        definitionLabel.text=""
       
        
        /*
         scoreBar.progress=Float(currentScore)/Float(wordsNumberForCurrentLevel*10)
         print(Float(currentScore)/Float(wordsNumberForCurrentLevel*10))
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
                currentWord=expiredWords.first
            }
                
            else{
                // Il n'y a plus de mot à réviser
                // 1) il reste des mots jamais apparus
                
                let fetchNeverSeenWordRequest=NSFetchRequest<Mot>(entityName: "Mot")
                
                
                let newPredicate=NSPredicate(format: "%K == %@", #keyPath(Mot.themeExpiration), "1000000000")
                fetchNeverSeenWordRequest.predicate=NSCompoundPredicate(andPredicateWithSubpredicates: [levelPredicate,newPredicate])
                
                guard let neverSeenWords=try? context.fetch(fetchNeverSeenWordRequest)else{return}
                
                if neverSeenWords.count != 0{
                    currentWord=neverSeenWords[Int(arc4random_uniform(UInt32(neverSeenWords.count)))]
                    
                }
                    
                    // il ne reste plus du tout de mots à réviser
                    
                else {
                    skipButton.isHidden=true
                    pronunciationTF.text="Come back later!"
                    pronunciationTF.isEnabled=false
                    characterLabel.text=""
                    infoButton.isHidden=true
                    return
                }
                
                
            }
            
            
            // mise à jour de l'interface
            
            characterLabel.text=""
            definitionLabel.text=currentWord.definition
            
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
                currentWord=expiredWords.first
            }
                
            else{
                
                // Il n'y a plus de mot à réviser
                // 1) il reste des mots jamais apparus
                
                let fetchNeverSeenWordRequest=NSFetchRequest<Mot>(entityName: "Mot")
                
                
                let newPredicate=NSPredicate(format: "%K == %@", #keyPath(Mot.versionExpiration), "1000000000")
                fetchNeverSeenWordRequest.predicate=NSCompoundPredicate(andPredicateWithSubpredicates: [levelPredicate,newPredicate])
                
                guard let neverSeenWords=try? context.fetch(fetchNeverSeenWordRequest)else{return}
                
                if neverSeenWords.count != 0{
                    currentWord=neverSeenWords[Int(arc4random_uniform(UInt32(neverSeenWords.count)))]
                    
                }
                    
                    // il ne reste plus du tout de mots à réviser
                    
                else {
                    skipButton.isHidden=true
                    pronunciationTF.text="Come back later!"
                    pronunciationTF.isEnabled=false
                    characterLabel.text=""
                    infoButton.isHidden=true
                    return
                }
                
                
            }
            
            // mise à jour de l'interface
            
            
            characterLabel.text = currentWord.character
           
            
            
            
            
        }
        
        
        if voiceEnabled{
            utterance=AVSpeechUtterance(string: currentWord.character!)
            utterance.voice=self.voice
            
        }
        
        
        print("coredata level:\(currentWord.level)")
        print("theme \(themeFlashcard)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
