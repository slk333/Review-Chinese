  
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
