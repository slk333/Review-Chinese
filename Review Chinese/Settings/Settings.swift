import UIKit

enum WordsList:Int{
    case HSK1
    case HSK2
    case HSK3
    case HSK4
    case HSK5
    case HSK6
    case CustomList
}
var activeLists:Set<WordsList> = [WordsList.HSK1] // initialisé avec la liste HSK1 selectionnée


class SettingsTableViewController: UITableViewController {
    
    // BUT: enregistrer les différents réglages dans userdefaults

    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // garder la selection
        self.clearsSelectionOnViewWillAppear = false
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    
    // mettre checkmark au select
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // enregistre le choix dans le set activeLists
        activeLists.insert(WordsList(rawValue: indexPath.row)!)
     
        
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
        }
    }
    
    // enlever checkmmark au deselect
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        // enregistre le choix dans le set activeLists
        activeLists.remove(WordsList(rawValue: indexPath.row)!)
        print(activeLists)
        
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .none
        }
    }

   



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
