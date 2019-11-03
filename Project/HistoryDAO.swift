//
//  HistoryDAO.swift
//  Project
//
//  Created by 신지호 on 2019/10/29.
//  Copyright © 2019 신지호. All rights reserved.
//

import UIKit
import CoreData

class HistoryDAO {
    lazy var context: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
         return appDelegate.persistentContainer.viewContext
    }()
    
    func fetch() -> [HistoryData] {
        var historylist = [HistoryData]()
        let fetchRequest : NSFetchRequest<HistoryMO> = HistoryMO.fetchRequest()
        let regdateDesc = NSSortDescriptor(key: "regdate", ascending: false)
        fetchRequest.sortDescriptors = [regdateDesc]

        do {
            let resultset = try self.context.fetch(fetchRequest)
            
            for record in resultset {
                let data = HistoryData()
                data.objectID = record.objectID
                data.name = record.name
                data.regdate = record.regdate
                
                historylist.append(data)
            }
        } catch let e as NSError {
            NSLog("An error has occurred : %s", e.localizedDescription)
        }
        return historylist
    }
    func add(_ data: HistoryData) {
        let object = NSEntityDescription.insertNewObject(forEntityName: "History", into: self.context) as! HistoryMO
        
        object.name = data.name
        object.regdate = data.regdate
        
        do {
            try self.context.save()
        } catch let e as NSError {
            NSLog("An error has occurred : %s", e.localizedDescription)
        }
    }
    func delete(_ objectID: NSManagedObjectID) -> Bool {
        let object = self.context.object(with: objectID)
        self.context.delete(object)
        do{
            try self.context.save()
            return true
        } catch let e as NSError {
            NSLog("An error has occurred : %s", e.localizedDescription)
            return false
        }
    }
}
