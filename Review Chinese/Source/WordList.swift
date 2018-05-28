import UIKit
import CoreData
class WordList: UITableViewController {
    
    
    // but : afficher tous les mots d'une listNamee
    
    // propriétés
    
    let listManager = ListManager()
    var listName:String!
    var wordList:[Mot]!=[Mot]()
    let fetchRequest:NSFetchRequest<Mot>=Mot.fetchRequest()
    var decalage=0
    var motsSortedByDate=[Mot]()
    let dateFormatter = DateFormatter()
    var isVersionSchedule:Bool{
        return (listName == "Chinese To English")
    }
    var isThemeSchedule:Bool{
        return (listName == "English To Chinese")
    }
    var isBrowsingPredifinedList:Bool{
        // à l'exception de english to chinese et chinese to english, il s'agit de naviguer dans une liste de mots qui n'affichera que les scores
        return !isThemeSchedule && !isVersionSchedule
    }

    
    // méthodes
    
    /*
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
     
     let destination=segue.destination as! DetailViewController
     
     fetchRequest.predicate=NSPredicate(format: "%K == %@", #keyPath(Mot.index), String(selectedRow+decalage))
     var mot=try! context.fetch(fetchRequest).first!
     if listName=="Review Schedule"{
     mot=motsSortedByDate[selectedRow]
     }
     
     destination.mot=mot
     
     
     }
     
     
     
     override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
     selectedRow=indexPath.row
     return indexPath
     }
     */
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // listName est fourni par le viewController qui présente ce viewController
        if isBrowsingPredifinedList{
        wordList = listManager.getAllWordsFromListNamed(listName)
        }
        if !isBrowsingPredifinedList{
            wordList = listManager.getWordsThatHaveAnExpirationDate(listName)
        }
        
        
        print("wordList.count")
        print(wordList.count)
       
        
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
       
        
        /*
        
        let triParDate:NSFetchRequest<Mot>=Mot.fetchRequest()
        if hskLevel==1{
            let restrictionPredicate=NSPredicate(format: "%K < %@", #keyPath(Mot.index), String(153))
            let notNew=NSPredicate(format: "%K != %@", #keyPath(Mot.themeExpiration),"1000000000")
            triParDate.predicate=NSCompoundPredicate(andPredicateWithSubpredicates: [restrictionPredicate,notNew])
            
        }
        else{ triParDate.predicate=NSPredicate(format: "%K != %@", #keyPath(Mot.themeExpiration),"1000000000")}
        
        
        
        triParDate.sortDescriptors=[NSSortDescriptor(key: "themeExpiration", ascending: true)]
        motsSortedByDate=try! context.fetch(triParDate)
        
        
       
 */
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wordList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        /* if listName=="Review Schedule"{
         mot=motsSortedByDate[indexPath.row]
         } */
        
        let mot=wordList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "wordCell", for: indexPath)
        let characterLabel=cell.viewWithTag(1) as! UILabel
        let versionScoreLabel=cell.viewWithTag(2) as! UILabel
        let themeScoreLabel=cell.viewWithTag(3) as! UILabel
        let dateLabel=cell.viewWithTag(4) as! UILabel
        
        characterLabel.text=mot.character
        
        // naviguer dans les listes prédéfinies, on affiche seulement le score, pas la date de révision
        if isBrowsingPredifinedList {
            versionScoreLabel.text = String(mot.versionScore)
            themeScoreLabel.text = String(mot.themeScore)
             dateLabel.text=""
            return cell
        }
        // sinon il s'agit des listes de schedules qui affichent la date et le score du mode choisi
        if isVersionSchedule{
            versionScoreLabel.text = String(mot.versionScore)
            themeScoreLabel.text = ""
            let date = Date(timeIntervalSinceReferenceDate: TimeInterval(mot.versionExpiration))
            dateLabel.text=dateFormatter.string(from: date)
            return cell
           
        }
        if isThemeSchedule{
            versionScoreLabel.text = ""
            themeScoreLabel.text = String(mot.themeScore)
            let date = Date(timeIntervalSinceReferenceDate: TimeInterval(mot.themeExpiration))
            dateLabel.text=dateFormatter.string(from: date)
            return cell
            
        }
      return cell
        
        
    }
}
