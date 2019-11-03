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
    lazy var detailData = DetailVO()
    lazy var dao = FavoritesDAO()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    //var searchData
    
    lazy var favoritesSwitch: UISwitch = {
        let starSwitch: UISwitch = UISwitch()
        starSwitch.layer.position = CGPoint(x: 177, y: 387)
        //starSwitch.onImage = UIImage(named: "star.png")
        //starSwitch.offImage = UIImage(named: "emptytar.png")
        
        starSwitch.addTarget(self, action: #selector(onClickSwitch(sender:)), for: UIControl.Event.valueChanged)
        return starSwitch
    }()
    
    @IBOutlet var temp: UIButton!
    @IBOutlet var setInfo: UIButton!
    @IBOutlet var image: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var index: UILabel!
    @IBOutlet var address: UILabel!
    @IBOutlet var opentime: UILabel!
    @IBOutlet var tel: UIButton!
    @IBOutlet var url: UIButton!
    @IBOutlet var businessDay: UILabel!
    @IBOutlet var isBusiness: UILabel!

    @IBAction func mapTouchDown(_ sender: UIButton) {
    }
    @IBAction func onClicktel(_ sender: Any) {
        let btn = sender as? UIButton
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let exec = UIAlertAction(title: btn?.titleLabel?.text, style: .default) { (_) in
            var call = btn?.titleLabel?.text ?? ""
            call = "tel://" + call.components(separatedBy: [" ","-"]).joined()
            let url = URL(string: call)
            UIApplication.shared.open(url!, options: [:])

        }
        alert.addAction(exec)
        alert.addAction(cancel)
        self.present(alert, animated: false)

    }
    @IBAction func onClickURL(_ sender: Any) {
        let btn = sender as? UIButton
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let exec = UIAlertAction(title: btn?.titleLabel?.text, style: .default){ (_) in
            let url = URL(string: btn?.titleLabel?.text ?? "")
            UIApplication.shared.open(url!, options: [:])
        }
        alert.addAction(exec)
        alert.addAction(cancel)
        self.present(alert, animated: false)
    }
    
    @objc func onClickSwitch(sender: UISwitch) {
        if sender.isOn{
            let data = FavoritesData()
            data.id = detailData.id
            data.count = 0
            data.name = detailData.name
            data.categoryID = detailData.category?["id"] as? Int
            if let storeImage = image.image {
                data.image = storeImage
            }
            
            dao.add(data)
            
        }else {
            dao.delete(dao.getObjectID(paramID!)!)
        }
    }
    
    @IBAction func touchSetInfo(_ sender: Any) {
        
    }
    
    
    override func viewDidLoad() {
        // Do any additional setup after loading the view.
        let url = "http://223.194.77.134:8080/store/store/id/\(paramID!)"
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
            detailData.startTime = store["startTime"] as? String
            detailData.endTime = store["endTime"] as? String
            detailData.website = store["website"] as? String
            detailData.pictureURL = store["pictureURL"] as? String
            detailData.category = store["category"] as? NSDictionary
            detailData.seatCount = store["seatCount"] as? Int
            detailData.totalCount = store["totalCount"] as? Int
        }catch {
            
        }

        self.navigationItem.title = detailData.name
        self.name.text = detailData.name
        self.view.addSubview(self.favoritesSwitch)
        //
        self.address.text = detailData.address
        self.tel.setTitle(detailData.callNumber, for: .normal)
        self.tel.contentHorizontalAlignment = .left
        self.opentime.text = "\(detailData.startTime!) ~ \(detailData.endTime!)"
        self.url.setTitle(detailData.website, for: .normal)
        self.url.contentHorizontalAlignment = .left
        //self.businessDay.text =
        if detailData.pictureURL != "null" {
            self.image.image = UIImage(data: try! Data(contentsOf: URL(string: detailData.pictureURL!)!))
        }
        let persent = Int(100*(Double(detailData.seatCount!)/Double(detailData.totalCount!)))
        if persent > 60 {
            self.setInfo.backgroundColor = UIColor.red
        }else if persent > 30 {
            self.setInfo.backgroundColor = UIColor.orange
        }else {
            self.setInfo.backgroundColor = UIColor.green
        }
        self.setInfo.setTitle("\(Int(100*(Double(detailData.seatCount!)/Double(detailData.totalCount!))))%", for: .normal)
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
