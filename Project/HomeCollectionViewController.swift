//
//  HomeCollectionViewController.swift
//  Project
//
//  Created by 신지호 on 07/08/2019.
//  Copyright © 2019 신지호. All rights reserved.
//

import UIKit

private let reuseIdentifier = "CollectionCell"

class HomeCollectionViewController: UICollectionViewController {
    private let refreshControl = UIRefreshControl()
    lazy var dao = FavoritesDAO()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBAction func refreshCollection(_ sender: Any) {
        self.collectionView.reloadData()
    }
    @IBAction func moveHistory(_ sender: UITextField) {
        guard let uvc = self.storyboard?.instantiateViewController(withIdentifier: "HistoryViewController") else {
            return
        }
        self.navigationController?.pushViewController(uvc, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        self.collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshCollection), for: UIButton.Event.valueChanged)
        refreshControl.endRefreshing()*/
    }
    override func viewWillAppear(_ animated: Bool) {
        self.appDelegate.favoriteslist = self.dao.fetch()
        self.collectionView.reloadData()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        let count = self.appDelegate.favoriteslist.count
        if count > 12 {
            return 12
        }
        return count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row = self.appDelegate.favoriteslist[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell
        let url = "http://223.194.77.134:8080/store/store/id/\(row.id!)"
        let apiURI: URL! = URL(string: url)
        
        let apidata = try! Data(contentsOf: apiURI)
        let log = NSString(data: apidata, encoding: String.Encoding.utf8.rawValue) ?? ""
        NSLog("API Result=\(log)")
        
        do{
            let apiDictionary = try JSONSerialization.jsonObject(with: apidata, options: []) as! NSDictionary
            guard apiDictionary["success"] as! Bool == true else {
                cell.title.text = row.name
                return cell
            }
            let store = apiDictionary["data"] as! NSDictionary
            let seatCount = store["seatCount"] as! Int
            let totalCount = store["totalCount"] as! Int
            let persent = 100 * (Double(seatCount)/Double(totalCount))
            cell.percent.text = "\(Int(persent))%"
        }catch {
            
        }
    
        // Configure the cell
        cell.categoryID = row.categoryID
        cell.id = row.id
        cell.objectID = row.objectID
        cell.title.text = row.name
        if let image = row.image {
            cell.img.image = image
        }
        return cell
    }
    
 // 즐겨찾기 화면에서 item을 선택했을때
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = self.appDelegate.favoriteslist[indexPath.row]
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "Segue_Detail") as? DetailViewController else {
            return
        }
        dao.addCount(item.objectID!)
        vc.paramID = item.id
        vc.favoritesSwitch.isOn = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
