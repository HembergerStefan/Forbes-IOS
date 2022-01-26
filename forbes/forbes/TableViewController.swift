//
//  TableViewController.swift
//  forbes
//
//  Created by Abs on 23.12.21.
//

import UIKit

class TableViewController: UITableViewController {
    var queue = DispatchQueue(label: "download")
    var model = ForbesModel()
    let path = "https://unofficial-forbes.herokuapp.com/forbes/list?top=50"
    var currentPerson: Entry?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = URL(string: path) {
            download(url: url)
        }
        
    }
    
    func download(url: URL) {
        queue.async {
            let tmpModel = self.asyncDownload(url: url)
            DispatchQueue.main.async {
                self.model = tmpModel
                self.tableView.reloadData()
                print("done")
            }
        }
        
    }
    
    func asyncDownload(url: URL) -> ForbesModel {
        var model = ForbesModel()
        if let data = try? Data(contentsOf: url) {
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                if let array = json as? [[String: Any]] {
                    model = parseArray(array: array)
                }
            }
        } else {
            print("ohje :(")
        }
        return model
    }
    
    func parseArray(array: [[String: Any]]) -> ForbesModel {
        let model = ForbesModel()
        for el in array {
            let entry = Entry()
            entry.uri = el["uri"] as! String
            entry.finalWorth = el["finalWorth"] as! Double
            entry.personName = el["personName"] as! String
            // entry.birthDate = el["birthDate"] as! Int
            entry.squareImage = el["squareImage"] as! String
            model.persons.append(entry)
            
        }
        return model
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return model.persons.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "person", for: indexPath)
        let person = model.persons[indexPath.row]
        cell.textLabel?.text = person.personName
        cell.detailTextLabel?.text = person.uri

        return cell
    }
    
    // OnRowClick()
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected row \(indexPath)")
        self.currentPerson = model.persons[indexPath.row]
        performSegue(withIdentifier: "detail", sender: self)
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("PREPARE")
        if let viewController = segue.destination as? ViewController {
            viewController.entry = self.currentPerson
        }
    }
    

}
