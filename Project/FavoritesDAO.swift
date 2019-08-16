//
//  FavoritesDAO.swift
//  Project
//
//  Created by 신지호 on 15/08/2019.
//  Copyright © 2019 신지호. All rights reserved.
//

import UIKit
import CoreData

class FavoritesDAO {
    /*
    lazy var list: [NSManagedObject] = {
        return self.fetch()
    }()
 */
    lazy var context: NSManagedObjectContext = {
       let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }()
    
    func fetch(keyword text: String? = nil) -> [FavoritesData] {
        var favoriteslist = [FavoritesData]()
        
        let fetchRequest: NSFetchRequest<FavoritesMO> = FavoritesMO.fetchRequest()
        // 방문 순으로 정렬
        let countDesc = NSSortDescriptor(key: "count", ascending: false)
        fetchRequest.sortDescriptors = [countDesc]
        
        if let t = text, t.isEmpty == false {
                fetchRequest.predicate =  NSPredicate(format: "title CONTAINS[c] %@", t)
        }
        
        do {
            let resultset = try self.context.fetch(fetchRequest)
            
            for record in resultset {
                let data = FavoritesData()
                data.title = record.title
                data.serial = Int(record.serial)
                data.count = Int(record.count)
                data.objectID = record.objectID
                
                if let image = record.image as Data? {
                    data.image = UIImage(data: image)
                }
                favoriteslist.append(data)
            }
        } catch let e as NSError{
            NSLog("An error has occurred : %s", e.localizedDescription)
        }
        return favoriteslist
    }
    func add(_ data: FavoritesData) {
        let object = NSEntityDescription.insertNewObject(forEntityName: "Favorites", into: self.context) as! FavoritesMO
        
        object.title = data.title
        object.serial = Int64(data.serial!)
        object.count = Int64(data.count!)
        
        if let image = data.image {
            object.image = image.pngData()!
        }
        
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
    
    func delete(_ serial: Int64) -> Bool {
        let fetchRequest: NSFetchRequest<FavoritesMO> = FavoritesMO.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "serial == %d", serial)
        do {
            let object = try self.context.fetch(fetchRequest).first!
            self.context.delete(object)
            do{
                try self.context.save()
                return true
            } catch let e as NSError {
                NSLog("An error has occurred : %s", e.localizedDescription)
                return false
            }
            
        } catch let e as NSError {
            NSLog("An error has occurred : %s", e.localizedDescription)
            return false
        }
    }
    
}
