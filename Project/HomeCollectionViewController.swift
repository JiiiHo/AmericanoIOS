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
    lazy var dao = FavoritesDAO()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBAction func moveHistory(_ sender: UITextField) {
        guard let uvc = self.storyboard?.instantiateViewController(withIdentifier: "HistoryViewController") else {
            return
        }
        self.navigationController?.pushViewController(uvc, animated: true)
    }
    override func viewDidLoad() {
        let fv1 = FavoritesData()
        fv1.id = 1
        fv1.categoryID = 1
        fv1.count = 3
        fv1.name = "홍대스타벅스"
        appDelegate.favoriteslist.append(fv1)
        let fv2 = FavoritesData()
        fv2.id = 2
        fv2.categoryID = 1
        fv2.count = 2
        fv2.name = "홍대카페"
        appDelegate.favoriteslist.append(fv2)
        let fv3 = FavoritesData()
        fv3.id = 2
        fv3.categoryID = 1
        fv3.count = 2
        fv3.name = "건대스타벅스"
        appDelegate.favoriteslist.append(fv3)
        self.collectionView.reloadData()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        //self.appDelegate.favoriteslist = self.dao.fetch()
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
    
        // Configure the cell
    
        cell.title.text = row.name
        cell.percent.text = "30%"
        return cell
    }
    
 // 즐겨찾기 화면에서 item을 선택했을때
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = self.appDelegate.favoriteslist[indexPath.row]
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "Segue_Detail") as? DetailViewController else {
            return
        }
        vc.param = item
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
