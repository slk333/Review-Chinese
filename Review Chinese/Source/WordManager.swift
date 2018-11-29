import UIKit
import CoreData
class WordManager{
    
    let versionIsEnabled:Bool
    let themeIsEnabled:Bool
    let settings = UserDefaults.standard
    var activeLists: NSCompoundPredicate!
 
    
    // quelles sont les listes sélectionnées dans les réglages
    
    
    
    let context=(UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var reviewListIsEmpty:Bool!
    
    private func getRandomFreshWord()->Mot?{
        // Trouver un nouveau mot à étudier ou return nil si il n'y a plus de nouveaux mots
        
        let freshWordRequest=NSFetchRequest<Mot>(entityName: "Mot") // la requête qu'on paramètre
        
        
        var wordIsFresh=NSPredicate(format: "%K == %@", #keyPath(Mot.themeExpiration), "1000000000")
        if versionIsEnabled{
            wordIsFresh=NSPredicate(format: "%K == %@", #keyPath(Mot.versionExpiration), "1000000000")
        }
        // le mot est new (quand son expiration est égale à l'expiration par défaut que chaque mot dispose lorsqu'il n'a jamais fait l'objet d'une réponse)
        
        freshWordRequest.predicate=NSCompoundPredicate(andPredicateWithSubpredicates: [activeLists,wordIsFresh]) // le mot fait partie d'une liste active
        
        guard let freshWords=try? context.fetch(freshWordRequest)else{
            fatalError("fxdfhfgyhdfdfgsdfg") // la requête n'a pas fonctionné
            
        }
        
        if !freshWords.isEmpty{
            // il reste des mots fresh et on en retourne un au hasard
            
            return freshWords.randomElement()
        }
            
        else { // il ne reste plus de fresh word
            return nil}
        
        
        
    }
    
    
    
    
    private func getWordFromReviewList()->Mot?{
        // Trouver un mot à réviser ou return nil
        
        
        let currentDateAsNumber:Double=Date().timeIntervalSinceReferenceDate
        let expiredWordsRequest=NSFetchRequest<Mot>(entityName: "Mot") // la requête qu'on paramètre
        
        // le mot est expiré
        var wordIsExpired=NSPredicate(format: "%K < %@", #keyPath(Mot.versionExpiration), String(currentDateAsNumber))
        if themeIsEnabled {wordIsExpired=NSPredicate(format: "%K < %@", #keyPath(Mot.themeExpiration), String(currentDateAsNumber))}
        
        // ET le mot fait parti d'un niveau actif
        expiredWordsRequest.predicate=NSCompoundPredicate(andPredicateWithSubpredicates: [activeLists,wordIsExpired])
        
        // La liste est triée pour qu'on puisse facilement obtenir le plus ancien
        var sorting=NSSortDescriptor(key: "versionExpiration", ascending: true)
        if themeIsEnabled {sorting=NSSortDescriptor(key: "themeExpiration", ascending: true)}
        expiredWordsRequest.sortDescriptors=[sorting]
        
        guard  let expiredWords=try? context.fetch(expiredWordsRequest) else {
            // Il n'a pas été possible d'effectuer une requête
            fatalError("azedfqsdf")}
        
        if !expiredWords.isEmpty{
            // La requête a retourné au moins un mot à réviser, on prend le plus ancien
            return expiredWords.first
        }
        else {
            // La requête n'a retourné aucun mot à réviser, on retourne nil
            return nil
        }
        
    }
    
    
    
    func createactiveListsPredicate()->NSCompoundPredicate{
        // lire les réglages pour ne choisir que les listes selectionnées par l'utilisateur
        
        // le word manager est créé avec une liste de niveaux selectionnés, qui ne pourra pas être changée en cours de route. Si les réglages sont changés, un nouveau wordmanager est de toute façon créé.
        // Predicates cumulatifs (or predicates) : plus de predicates, plus de listes, plus de words
        
        var levelPredicates=[NSPredicate]()
        if settings.bool(forKey: "HSK 1"){levelPredicates.append(NSPredicate(format: "%K == %@", #keyPath(Mot.listName), "HSK 1"))}
        if settings.bool(forKey: "HSK 2"){levelPredicates.append(NSPredicate(format: "%K == %@", #keyPath(Mot.listName), "HSK 2"))}
        if settings.bool(forKey: "HSK 3"){levelPredicates.append(NSPredicate(format: "%K == %@", #keyPath(Mot.listName), "HSK 3"))}
        if settings.bool(forKey: "HSK 4"){levelPredicates.append(NSPredicate(format: "%K == %@", #keyPath(Mot.listName), "HSK 4"))}
        if settings.bool(forKey: "HSK 5"){levelPredicates.append(NSPredicate(format: "%K == %@", #keyPath(Mot.listName), "HSK 5"))}
        if settings.bool(forKey: "HSK 6"){levelPredicates.append(NSPredicate(format: "%K == %@", #keyPath(Mot.listName), "HSK 6"))}
        if settings.bool(forKey: "Custom List"){levelPredicates.append(NSPredicate(format: "%K == %@", #keyPath(Mot.listName), "7"))}
        
        return NSCompoundPredicate(orPredicateWithSubpredicates: levelPredicates)
    }
    
    
    
    
    
    func getWord()->Mot?{
        if let expiredWord = getWordFromReviewList(){
            return expiredWord
        }
        else if let freshWord = getRandomFreshWord(){
            return freshWord
        }
        else {
            return nil
        }
        
    }
    
    
    func increaseScore(for word:Mot, toTen:Bool){
        
        if toTen{
            if themeIsEnabled{
                word.themeScore = 11
                
            }
            else{
                word.versionScore = 11
                
            }
            updateExpirationDate(for: word)
            return
        }
        
        
        let formerScore : Int16!
        if themeIsEnabled{
            formerScore = word.themeScore}
        else{
            formerScore = word.versionScore}
        
        var increment :Int16 = 0
        if formerScore < 6 {increment = 3}
        if formerScore >= 6 {increment = 2}
        if formerScore >= 8 {increment = 1}
        if formerScore == 11 {increment = 0}
        
        
        if themeIsEnabled{
            word.themeScore += increment}
        else {
            word.versionScore += increment}
        
        updateExpirationDate(for: word)
        
        
        
    }
    
    func decreaseScore(for word:Mot,toZero:Bool,byOne:Bool){
        if toZero{
            if themeIsEnabled{
                word.themeScore = 0
                
            }
            else{
                word.versionScore = 0
                
            }
            updateExpirationDate(for: word)
            return
        }
        if byOne{
            if themeIsEnabled{
                word.themeScore -= 1
                if word.themeScore < 0 {word.themeScore = 0}
                
            }
            else{
                word.versionScore -= 1
                if word.versionScore < 0 {word.versionScore = 0}
                
            }
            updateExpirationDate(for: word)
            return
        }
        
        
        var newScore : Int16!
        let formerScore : Int16!
        if themeIsEnabled{
            formerScore = word.themeScore}
        else{
            formerScore = word.versionScore}
        
        
        if formerScore > 3 {newScore = 3}
        if formerScore == 3 {newScore = 2}
        if formerScore < 3 {newScore = 1}
        
        
        if themeIsEnabled{
            word.themeScore = newScore}
        else {
            word.versionScore = newScore}
        
        updateExpirationDate(for: word)
        
    }
    
    
    
    
    
    func updateExpirationDate(for word:Mot){
        print("updateExpirationDate")
        
        let score : Int16!
        if themeIsEnabled{
            score = word.themeScore
        }
        else {
            score = word.versionScore
            
            
        }
        print("score")
        print(score)
        
        
        let spareTime = 100 * pow(3, Double(score))
        print("spareTime")
        print(spareTime)
        let expirationDate = Date(timeIntervalSinceNow: spareTime)
        let expirationInterval = Int64(expirationDate.timeIntervalSinceReferenceDate)
        print("expirationInterval")
        print(expirationInterval)
        if themeIsEnabled{
            word.themeExpiration = expirationInterval}
        else {
            word.versionExpiration = expirationInterval
        }
        print("versionScore")
        print(word.versionScore)
        print("themeScore")
        print(word.themeScore)
        
        save()
        
    }
    
    func save(){
        
        print("save")
        print("context.hasChanges")
        print(context.hasChanges)
        
        try! context.save()
        
        
      
        
        
        
        
    }
    
    
    init(versionIsEnabled:Bool,themeIsEnabled:Bool) {
        self.versionIsEnabled = versionIsEnabled
        self.themeIsEnabled = themeIsEnabled
        guard versionIsEnabled != themeIsEnabled else {
            fatalError("should not have both at same time")
        }
        activeLists = createactiveListsPredicate() // seules les listes selectionnées dans les réglages sont étudiées
        
    } // fin de l'init
    
    
} // fin de Mot Manager
