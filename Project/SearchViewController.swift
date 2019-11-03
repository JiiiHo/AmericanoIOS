//
//  SearchViewController.swift
//  Project
//
//  Created by 신지호 on 07/08/2019.
//  Copyright © 2019 신지호. All rights reserved.
//

import UIKit

class SearchViewController: UITableViewController {
    lazy var dao = FavoritesDAO()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var list: [SearchData] = {
        var datalist = [SearchData]()
        return datalist
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        paramText = paramText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = "http://223.194.77.134:8080/store/store/search/\(paramText)"
        let apiURI: URL! = URL(string: url)
        
        let apidata = try! Data(contentsOf: apiURI)
        
        let log = NSString(data: apidata, encoding: String.Encoding.utf8.rawValue) ?? ""
        NSLog("API Result=\(log)")
        
        do{
            let apiDictionary = try JSONSerialization.jsonObject(with: apidata, options: []) as! NSDictionary
            guard apiDictionary["success"] as! Bool == true else {
                return
            }
            let store = apiDictionary["list"] as! NSArray
            
            for row in store {
                let r = row as! NSDictionary
                let mvo = SearchData()
                mvo.latitude = r["latitude"] as? Double
                mvo.longitude = r["longitude"] as? Double
                mvo.name = r["name"] as? String
                mvo.seatCount = r["seatCount"] as? Int
                mvo.totalCount = r["totalCount"] as? Int
                mvo.pictureURL = r["pictureURL"] as? String
                mvo.id = r["id"] as? Int
                let category = r["category"] as! NSDictionary
                mvo.categoryID = category["id"] as? Int
                self.list.append(mvo)
            }
        }catch {
            
        }
    }
     
    
    @IBOutlet var searchTextField: UITextField!
    var paramText: String = ""
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
        // #warning Incomplete implementation, return the number of rows
        return self.list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = self.list[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as! SearchCell
        cell.title.text = row.name
        cell.distance.text = "\(33)m"
        cell.state.text = "원할"
        // Configure the cell...

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailSegue" {
            let path = self.tableView.indexPath(for: sender as! SearchCell)
            let detailVC = segue.destination as? DetailViewController
            detailVC?.paramID = self.list[path!.row].id

            detailVC?.favoritesSwitch.isOn = false

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
