import UIKit
class DashboardVC: UITableViewController {
    // Le Dashboard affiche les différentes listes, qu'on peut consulter en cliquant sur celles ci
    // Il y a deux catégories de liste
    // Les mots triés par ordre de révision, liste de révision
    // Les listes HSK, qui sont des liste de vocabulaire
    
    
    let reviewListsCount = 2
    let VocabListsCount = 6
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return reviewListsCount
        }
        else{
            return VocabListsCount
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // on va afficher une liste
        // travail normalement effectué par le coordinator
        // indiquer au VC de liste, quelle liste à affichée.
        let wordListVC = segue.destination as! WordListVC
        let cell = sender as! UITableViewCell
        let cellLabel = cell.textLabel!
        wordListVC.listName = cellLabel.text!
    }
    
}
