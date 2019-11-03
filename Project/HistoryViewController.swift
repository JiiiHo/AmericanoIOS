//
//  HistoryViewController.swift
//  Project
//
//  Created by 신지호 on 07/08/2019.
//  Copyright © 2019 신지호. All rights reserved.
//

import UIKit

class HistoryViewController: UITableViewController, UITextFieldDelegate {
    
    lazy var dao = HistoryDAO()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var name: String?
    /*
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
     */
    @IBOutlet var searchTextField: UITextField!
    @IBAction func onSearch(_ sender: UIBarButtonItem) {
        let data = HistoryData()
        data.regdate = Date()
        data.name = self.searchTextField.text!
        self.name = self.searchTextField.text
        dao.add(data)
        // 검색 했으면 검색한 데이터에 추가
        self.performSegue(withIdentifier: "SearchSegue", sender: self)
        
    }
    //return 버튼 클릭시
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.isEqual(self.searchTextField) {
            onSearch(self.navigationItem.rightBarButtonItem!)
        }
        return true
    }

    // MARK: - Table view data source
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination
        guard let rvc = dest as? SearchViewController else {
            return
        }
        
        rvc.paramText = self.name!
    }
    override func viewWillAppear(_ animated: Bool) {
        self.appDelegate.historylist = self.dao.fetch()
        self.tableView.reloadData()
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.appDelegate.historylist.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as! HistoryCell
        let row = self.appDelegate.historylist[indexPath.row]
        cell.title.text = row.name
        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let data = self.appDelegate.historylist[indexPath.row]
        
        if dao.delete(data.objectID!) {
            self.appDelegate.historylist.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    //table에서 목록을 선택할때
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = self.appDelegate.historylist[indexPath.row]
        self.name = row.name
        self.performSegue(withIdentifier: "SearchSegue", sender: self)
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
