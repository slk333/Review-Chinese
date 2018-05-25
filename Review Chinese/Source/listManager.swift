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
    
    
    
  
    
    
    
    
    
    
}

