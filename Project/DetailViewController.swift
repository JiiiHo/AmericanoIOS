//
//  DetailViewController.swift
//  Project
//
//  Created by 신지호 on 15/08/2019.
//  Copyright © 2019 신지호. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
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
    
    @IBAction func favoritesTouchDown(_ sender: UIButton) {
        
    }
    @IBAction func mapTouchDown(_ sender: UIButton) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
