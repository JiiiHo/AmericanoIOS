//
//  FavoritesViewController.swift
//  Project
//
//  Created by 신지호 on 02/09/2019.
//  Copyright © 2019 신지호. All rights reserved.
//

import UIKit

class FavoritesViewController: UITableViewController {
    lazy var dao = FavoritesDAO()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    func initUI() {
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        self.tableView.allowsSelectionDuringEditing = true
    }
    override func viewDidLoad() {
        self.initUI()
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func viewWillAppear(_ animated: Bool) {
        self.appDelegate.favoriteslist = self.dao.fetch()
        self.tableView.reloadData()

    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.appDelegate.favoriteslist.count
        return count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = self.appDelegate.favoriteslist[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoritesCell", for: indexPath)
        cell.textLabel?.text = row.name
        // Configure the cell...

        return cell
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let data = self.appDelegate.favoriteslist[indexPath.row]
        
        if dao.delete(data.objectID!) {
            self.appDelegate.favoriteslist.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FaDetailSegue" {
            let path = self.tableView.indexPath(for: sender as! UITableViewCell)
            let detailVC = segue.destination as? DetailViewController
            detailVC?.paramID = self.appDelegate.favoriteslist[path!.row].id
            detailVC?.favoritesSwitch.isOn = true
            dao.addCount(self.appDelegate.favoriteslist[path!.row].objectID!)
        }
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
