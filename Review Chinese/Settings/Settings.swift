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
    // Load les réglages déjà enregistés, en lisant Userdefaults juste avant l'affichage des cells
    // Sauvegarder directement quand un réglage est modifié
    // Userdefaults utilise un string pour indexer chaque réglage. Le nom du réglage sur l'interface est utilisé comme string dans userdefault
    
    let settings = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       }
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Les réglages vont s'afficher
        if settings.bool(forKey: cell.textLabel?.text ?? "nil"){
            // si le réglage était activé dans la mémoire persistente, on le représente comme activé sur l'interface
            cell.accessoryType = .checkmark
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
        
    }
    
    
    // Un réglage a été selectionné
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // quelle section a été selectionnée ?
        
        
        if let cell = tableView.cellForRow(at: indexPath) {
            // afficher un checkmark pour faire visualiser que le réglage est validé
            cell.accessoryType = .checkmark
            // sauvegarder l'activation du réglage
            settings.set(true, forKey: cell.textLabel!.text ?? "nil")
            
        }
    }
    
   // Un réglage a été deselectionné
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .none
            // sauvegarder la desactivation du réglage
            settings.set(false, forKey: cell.textLabel!.text ?? "nil")
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
