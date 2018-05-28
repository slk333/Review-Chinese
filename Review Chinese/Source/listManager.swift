import UIKit
import CoreData

// Retourne une listes de mots sous la forme d'Array de Mot.

class ListManager{
    
   
    let context=(UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    
    func getAllWordsFromListNamed(_ listName:String)->[Mot]{
    
    let listPredicate = NSPredicate(format: "%K == %@", #keyPath(Mot.listName),listName)
    let fetchRequest:NSFetchRequest<Mot>=Mot.fetchRequest()
    fetchRequest.predicate = listPredicate
    let words = try! context.fetch(fetchRequest)
    print("words.count")
    print(words.count)
    return words
    
        
    }
    
    
    func getWordsThatHaveAnExpirationDate(_ listName:String)->[Mot]{
        var hasExpirationDatePredicate:NSPredicate!
        if listName == "Chinese To English"{
            hasExpirationDatePredicate = NSPredicate(format: "%K != 1000000000", #keyPath(Mot.versionExpiration))
        }
        if listName == "English To Chinese"{
            hasExpirationDatePredicate = NSPredicate(format: "%K != 1000000000", #keyPath(Mot.themeExpiration))
        }
        
        let fetchRequest:NSFetchRequest<Mot>=Mot.fetchRequest()
        fetchRequest.predicate = hasExpirationDatePredicate
        let words = try! context.fetch(fetchRequest)
        print("words.count")
        print(words.count)
        return words
        
        
    }
    
    
    
    
  
    
    
    
    
    
    
}

