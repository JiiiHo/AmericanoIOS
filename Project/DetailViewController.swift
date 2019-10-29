//
//  DetailViewController.swift
//  Project
//
//  Created by 신지호 on 15/08/2019.
//  Copyright © 2019 신지호. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    var paramID : Int?
    var param : FavoritesData?
    lazy var detailData = DetailVO()
    //var searchData
    
    lazy var favoritesSwitch: UISwitch = {
        let starSwitch: UISwitch = UISwitch()
        starSwitch.layer.position = CGPoint(x: 177, y: 376)
        starSwitch.isOn = false
        let starImage = UIImage(named: "star.png")
        starSwitch.offImage = starImage
        //starSwitch.onImage = UIImage(named: "star.png")
        //starSwitch.offImage = UIImage(named: "emptytar.png")
        return starSwitch
    }()
    @IBOutlet var setInfo: UIButton!
    @IBOutlet var image: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var index: UILabel!
    @IBOutlet var favorites: UIButton!
    @IBOutlet var address: UILabel!
    @IBOutlet var opentime: UILabel!
    @IBOutlet var tel: UILabel!
    @IBOutlet var url: UILabel!
    @IBOutlet var businessDay: UILabel!
    @IBOutlet var isBusiness: UILabel!

    @IBAction func mapTouchDown(_ sender: UIButton) {
    }
    
    
    override func viewDidLoad() {
        // Do any additional setup after loading the view.
        let url = "http://13.209.226.113:8080/store/store/id/\(paramID!)"
        let apiURI: URL! = URL(string: url)
        
        let apidata = try! Data(contentsOf: apiURI)
        
        let log = NSString(data: apidata, encoding: String.Encoding.utf8.rawValue) ?? ""
        NSLog("API Result=\(log)")
        
        do{
            let apiDictionary = try JSONSerialization.jsonObject(with: apidata, options: []) as! NSDictionary
            guard apiDictionary["success"] as! Bool == true else {
                return
            }
            let store = apiDictionary["data"] as! NSDictionary
            detailData.id = store["id"] as? Int
            detailData.address = store["address"] as? String
            detailData.latitude = store["latitude"] as? Double
            detailData.longitude = store["longitude"] as? Double
            detailData.name = store["name"] as? String
            detailData.callNumber = store["callNumber"] as? String
            detailData.startTime = store["startTime"] as? Date
            detailData.endTime = store["endTime"] as? Date
            detailData.website = store["website"] as? String
            detailData.pictureURL = store["pictureURL"] as? String
            detailData.category = store["category"] as? NSDictionary
        }catch {
            
        }

        self.navigationItem.title = detailData.name
        self.name.text = detailData.name
        self.view.addSubview(self.favoritesSwitch)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
