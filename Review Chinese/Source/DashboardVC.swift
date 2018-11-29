import UIKit

class DashboardVC: UITableViewController {
    
    let PREDEFINED_LISTS_COUNT = 6
    let REVIEW_MODE_COUNT = 2


    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return REVIEW_MODE_COUNT
        }
        else{
            return PREDEFINED_LISTS_COUNT
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let wordListVC = segue.destination as! WordListVC
        let cell = sender as! UITableViewCell
        let cellLabel = cell.textLabel!
        wordListVC.listName = cellLabel.text!
    }
    
}
