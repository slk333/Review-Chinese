import UIKit

enum WordsList:String{
    case HSK1
    case HSK2
    case HSK3
    case HSK4
    case HSK5
    case HSK6
    case CustomList
}


class SettingsTableViewController: UITableViewController {
    
    // BUT: enregistrer les différents réglages dans userdefaults

    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        // garder la selection
        self.clearsSelectionOnViewWillAppear = false
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if UserDefaults.standard.bool(forKey: cell.textLabel?.text ?? "nil"){
            cell.accessoryType = .checkmark
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
        
    }
    
   
    

    
    // mettre checkmark au select
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section < 2 else{return}
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
            UserDefaults.standard.set(true, forKey: cell.textLabel!.text ?? "nil")
        }
    }
    
    // enlever checkmmark au deselect
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        // enregistre le choix dans le set activeLists
       
        
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .none
            UserDefaults.standard.set(false, forKey: cell.textLabel!.text ?? "nil")
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
