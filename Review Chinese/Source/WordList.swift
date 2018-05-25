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
        wordList = listManager.getAllWordsFromListNamed(listName)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterCell", for: indexPath)
        let characterLabel=cell.viewWithTag(1) as! UILabel
        let scoreLabel=cell.viewWithTag(2) as! UILabel
        characterLabel.text=mot.character
        
        
        
        let dateLabel=cell.viewWithTag(3) as! UILabel
        if mot.versionExpiration != 1000000000{
            scoreLabel.text=String(mot.versionScore)
            let date = Date(timeIntervalSinceReferenceDate: TimeInterval(mot.versionExpiration))
            dateLabel.text=dateFormatter.string(from: date)}
        else{
            
            dateLabel.text=""
            scoreLabel.text=""
        }
        return cell
        
        
    }
}
