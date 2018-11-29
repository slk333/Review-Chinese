import UIKit
import CoreData

class WordListVC: UITableViewController {
    
    
    // but de la scène: afficher tous les mots de la liste selectionnée
    // si il s'agit d'une liste de révision, n'afficher que les mots à réviser ainsi que leur date de révision
    
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
        
        
        print("nombre de mots à affiche dans la liste : \(wordList.count)")
       
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
       
        
      
        
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
