//
//  DetailVO.swift
//  Project
//
//  Created by 신지호 on 2019/10/28.
//  Copyright © 2019 신지호. All rights reserved.
//

import UIKit
import CoreData
class DetailVO {
    var id : Int?
    var category : NSDictionary?
    var seatCount : Int?
    var totalCount : Int?
    var latitude : Double?
    var longitude : Double?
    var name : String?
    var address : String?
    var website : String?
    var callNumber : String?
    var startTime : Date?
    var endTime : Date?
    var closedDay : Bool?
    var running : Bool?
    var pictureURL : String?
    var image : UIImage? // 이미지
}
