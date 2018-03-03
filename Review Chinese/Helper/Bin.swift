  
  /*
   
   import UIKit
   import CoreData
   import AVFoundation
   class AutoEvalViewController: UIViewController {
   
   // Variables et constantes
   let context=(UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   var currentMot:Mot!
   var confirmationMode=false
   
   var showTimer=Timer()
   
   // let speechSynthesizer = AVSpeechSynthesizer()
   
   // Outlets
   
   @IBOutlet weak var b1: UIButton!
   @IBOutlet weak var b2: UIButton!
   @IBOutlet weak var b3: UIButton!
   @IBOutlet weak var definitionLabel:UITextView!
   @IBOutlet weak var pinyinLabel: UILabel!
   @IBOutlet weak var characterLabel: UILabel!
   //  @IBOutlet weak var scoreLabel: UILabel!
   
   
   // IBActions
   
   
   
   @IBAction func confusedAction(_ sender: UIButton){
   guard !confirmationMode else {confirm()
   return}
   confirmationMode=true
   currentMot.themeExpiration=Int64(Date(timeIntervalSinceNow: 0).timeIntervalSinceReferenceDate)
   try! context.save()
   
   
   changeAnswerButtonToVoidAndDisabled(true)
   b2.setTitle("→", for: .normal)
   b2.isEnabled=true
   
   }
   
   
   @IBAction func correctAction(_ sender: UIButton) {
   guard !confirmationMode else {confirm()
   return}
   confirmationMode=true
   
   
   // Mise à jour du score
   if currentMot.themeScore<10{currentMot.themeScore+=1}
   //   scoreLabel.text=String(currentMot.score)
   scoreButtonsAction()
   
   // passe en mode "confirmer pour question suivante"
   changeAnswerButtonToVoidAndDisabled(true)
   b3.setTitle("→", for: .normal)
   b3.isEnabled=true
   
   
   
   
   
   
   
   }
   
   
   
   @IBAction func wrongAction(_ sender: UIButton) {
   guard !confirmationMode else {confirm()
   return}
   confirmationMode=true
   
   
   // Mise à jour du score
   if currentMot.themeScore>3{currentMot.themeScore=3}
   else {
   if currentMot.themeScore>1{currentMot.themeScore-=2}
   else{ if currentMot.themeScore==1{currentMot.themeScore=0}}}
   scoreButtonsAction()
   
   changeAnswerButtonToVoidAndDisabled(true)
   b1.setTitle("→", for: .normal)
   b1.isEnabled=true
   
   
   
   
   
   }
   
   // Fonctions
   
   
   
   func confirm(){
   toggleOff()
   createNewQuestion()
   confirmationMode=false
   }
   
   // Fin du click d'un bouton (enregistrement du score et effacement des boutons de score)
   func scoreButtonsAction(){
   //   scoreLabel.text=String(currentMot.score)
   //  scoreLabel.isHidden=false
   updateExpirationDateAndSave()
   
   
   }
   
   
   // Mettre à jour la date d'expiration
   
   func updateExpirationDateAndSave(){
   let tempsÀajouter=100*pow(3, Double(currentMot.themeScore))
   currentMot.themeExpiration=Int64(Date(timeIntervalSinceNow: tempsÀajouter).timeIntervalSinceReferenceDate)
   try! context.save()
   }
   
   
   // Enlever l'interface de réponse
   func toggleOff(){
   
   b1.setTitle("", for: .normal)
   b2.setTitle("", for: .normal)
   b3.setTitle("", for: .normal)
   definitionLabel.text=""
   pinyinLabel.text=""
   }
   
   
   // Afficher l'interface de réponse
   func toggleOn(){
   // affiche l'interface de réponse
   definitionLabel.text=currentMot.definition
   pinyinLabel.text=currentMot.pinyin
   changeAnswerButtonToVoidAndDisabled(false)
   
   /* let utterance=AVSpeechUtterance(string: currentMot.character)
   utterance.voice=AVSpeechSynthesisVoice.init(language: "zh-CN")
   speechSynthesizer.speak(utterance) */
   // prévoit  la nouvelle question
   
   
   }
   
   // Déclenche une nouvelle question si tous les boutons  sont relâchés
   func prepareForNewQuestion(){
   guard (!b1.isTouchInside && !b2.isTouchInside && !b3.isTouchInside) else{
   
   return}
   createNewQuestion()
   
   }
   
   override func viewWillAppear(_ animated: Bool) {
   
   
   }
   
   func changeAnswerButtonToVoidAndDisabled(_ yes:Bool){
   if yes{
   b1.setTitle("", for: .normal)
   b2.setTitle("", for: .normal)
   b3.setTitle("", for: .normal)
   b1.isEnabled=false
   b2.isEnabled=false
   b3.isEnabled=false
   }
   else{
   b1.setTitle("✗", for: .normal)
   b2.setTitle("≋", for: .normal)
   b3.setTitle("✓", for: .normal)
   b1.isEnabled=true
   b2.isEnabled=true
   b3.isEnabled=true
   
   }
   }
   
   // NOUVELLE QUESTION
   func createNewQuestion(){
   
   // cacher definition et pinyin et les boutons de réponses
   toggleOff()
   
   // scoreLabel.isHidden=true
   
   // choix d'un nouveau mot
   
   // trouver les mots expirés
   
   let dateOfNow:Double=Date(timeIntervalSinceNow: 0).timeIntervalSinceReferenceDate
   
   let expiredWordsRequest=NSFetchRequest<Mot>(entityName: "Mot")
   expiredWordsRequest.predicate=NSPredicate(format: "%K < %@", #keyPath(Mot.themeExpiration), String(dateOfNow))
   
   guard  let expiredWords=try? context.fetch(expiredWordsRequest) else{return}
   showTimer=Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: {_ in self.toggleOn()})
   
   
   
   
   
   let rand=Int(arc4random_uniform(UInt32(expiredWords.count)))
   //  print(expiredWords.count)
   currentMot=expiredWords[rand]
   
   // mise à jour de l'interface
   // scoreLabel.text=String(currentMot.score)
   characterLabel.text=currentMot.character
   
   // préparation du dévoilement du pinyin et de la définition dans 3 secondes
   
   }
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   if segue.identifier=="infoAboutWord"{
   showTimer.invalidate()
   let destination=segue.destination as! DetailViewController
   destination.mot=currentMot}
   
   }
   
   
   
   // Configuration initiale
   
   override func viewDidLoad() {
   super.viewDidLoad()
   
   
   
   createNewQuestion()
   
   
   }
   override func viewDidAppear(_ animated: Bool) {
   UIView.setAnimationsEnabled(false)
   }
   
   override func viewWillDisappear(_ animated: Bool) {
   UIView.setAnimationsEnabled(true)
   }
   
   
   
   
   
   
   }
   
   */

  
  
  
  
  
  
  
  /*
   @IBAction func textChanged(_ sender: UITextField) {
   // User a écrit quelque chose
   // Vérifier si c'est juste
   
   if sender.text==currentMot.pinyin{
   
   // c'est la bonne réponse
   
   // augmentation du score si il n'y a pas eu de mauvaise réponse
   if correctOrFalseSymbolLabel.text! != "✗"{
   
   increaseScoreAndSave()
   
   }
   
   // gestion de l'interface
   correctOrFalseSymbolLabel.textColor=defaultGreenColor
   correctOrFalseSymbolLabel.text="✓"
   characterLabel.text=currentMot.character
   answerTF.text=currentMot.pinyin
   // afficher la définition
   skipButton.isHidden=true
   definitionTV.text=currentMot.definition
   // VOICE
   if voiceEnabled{
   self.speechSynthesizer.speak(utterance)}
   
   
   
   
   // schedule la new question dans 1 seconde
   _=Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: {_ in self.createNewQuestion()})
   
   
   
   
   }
   // c'est faux (ou incomplet)
   else if sender.text?.count==currentMot.pinyin.count {
   // si c'est la mauvaise réponse, baisser le score une fois, et ignorer les prochaines mauvaises réponses, jusqu'à ce que l'utilisateur ait la bonne réponse
   guard correctOrFalseSymbolLabel.text != "✗" else {return}
   
   // première mauvaise réponse
   // gestion de l'interface
   correctOrFalseSymbolLabel.text="✗"
   correctOrFalseSymbolLabel.textColor=UIColor(red: 1, green: 0, blue: 0, alpha: 0.75)
   characterLabel.text=currentMot.character
   answerTF.text=currentMot.pinyin
   // mise à jour du score
   
   decreaseScoreAndSave()
   
   return}
   
   // insertion automatique d'un espace si c'est le prochain caractère à entrer
   else if correctText[correctText.index(correctText.startIndex, offsetBy: sender.text!.count)] == " "  && !stringToEnter.isEmpty{
   
   sender.text?.append(" ")
   
   }
   
   
   }
   */
  
  
  
  /*
   // l'utilisateur est en train d'écrire un caractère ou de supprimer un caractère
   // vérifier si on le laisse écrire et si on change de clavier
   func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
   stringToEnter=string
   
   
   // on ne peut pas écrire plus de caractères qu'il y en a dans la bonne réponse.
   if textField.text?.count==correctText.count && !string.isEmpty{
   return false
   }
   
   // l'utilisateur est en train de supprimer un caractère : on change le clavier pour que l'utilisateur puisse entrer le chiffre si il se trouve désormais dans la position où il faut entrer un ton.
   if string.isEmpty{
   guard let characterToDeleteIndex=correctText.index(correctText.startIndex, offsetBy: range.location,limitedBy:correctText.index(before: correctText.endIndex)) else{return true}
   
   if Int(String(correctText[characterToDeleteIndex])) != nil{
   textField.keyboardType = .numbersAndPunctuation
   textField.reloadInputViews()
   return true
   }
   else if textField.keyboardType == .numbersAndPunctuation{
   textField.keyboardType = .default
   textField.reloadInputViews()
   return true
   }
   return true
   }
   
   // l'utilisateur n'est pas en train de supprimer, il est en train d'écrire.
   
   /* Il faut étudier le caractère qui suit celui qui est entré pour voir si il s'agit d'un chiffre ou d'un espace. L'index du caractère entré correspond au lowerbound du range modifié, et l'index du caractère suivant correspond au upperBound du range modifié*/
   
   guard let existingFollowingCharacterIndex=correctText.index(correctText.startIndex, offsetBy: range.location+1,limitedBy:correctText.index(before: correctText.endIndex))
   
   else{
   textField.keyboardType = .default
   textField.reloadInputViews()
   // on est dans la situation où l'utilisateur est en train d'écrire le dernier caractère du mot à étudier, donc le dernier ton
   
   // il ne faut pas étudier le prochain caractère car il n'y en a pas.
   
   
   return true
   }
   
   // cas où l'utilisateur doit encore écrire au moins un caractère après celui qu'il est en train d'écrire
   
   // si le prochain caractère qu'il devra écrire est un entier, switch le clavier
   
   if Int(String(correctText[existingFollowingCharacterIndex])) != nil{
   textField.keyboardType = .numbersAndPunctuation
   textField.reloadInputViews()
   }
   
   // si le prochain caractère est une lettre et que le clavier est numérique, le mettre en mode lettres
   
   else if textField.keyboardType == .numbersAndPunctuation {textField.keyboardType = .default
   textField.reloadInputViews() }
   
   // à défaut de régles particulières, autoriser l'écriture
   return true
   } */
  
  
  /*
   import UIKit
   class DetailViewController: UIViewController {
   
   @IBOutlet weak var characterLabel:UILabel!
   @IBOutlet weak var pinyinLabel:UILabel!
   @IBOutlet weak var exempleTextView:UITextView!
   @IBOutlet weak var definitionTextView:UITextView!
   @IBOutlet weak var scoreLabel:UILabel!
   
   
   var haveBackItem = true
   
   var mot:Mot!
   
   
   @IBAction func dissmissA(){
   dismiss(animated: true, completion: nil)
   }
   
   
   
   override func viewDidLoad() {
   super.viewDidLoad()
   scoreLabel.text=String(mot.themeExpiration)
   characterLabel.text=mot.character
   pinyinLabel.text=mot.pinyin
   exempleTextView.text=mot.exemple
   
   definitionTextView.text=mot.definition
   
   if !haveBackItem {
   navigationItem.hidesBackButton = true
   }
   }
   
   override func didReceiveMemoryWarning() {
   super.didReceiveMemoryWarning()
   // Dispose of any resources that can be recreated.
   }
   }
   */

  
  
  
