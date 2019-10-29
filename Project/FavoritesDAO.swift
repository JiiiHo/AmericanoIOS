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
                data.name = record.name
                data.id = Int(record.id)
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
        
        object.name = data.name
        object.id = Int64(data.id!)
        object.categoryID = Int64(data.categoryID!)
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
    
    func getObjectID(_ favoritesData: FavoritesData) -> NSManagedObjectID? {
        let fetchRequest: NSFetchRequest<FavoritesMO> = FavoritesMO.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "categoryID == %d && id == %d", favoritesData.categoryID!, favoritesData.id!)
        do{
            let object = try self.context.fetch(fetchRequest).first!
            return object.objectID
        } catch let e as NSError {
            NSLog("An error has occurred : %s", e.localizedDescription)
            return nil
        }
    }
    
    // 방문시 count 값 1 증가하는 함수
    func addCount(_ objectID: NSManagedObjectID) -> Bool {
        let object = self.context.object(with: objectID)
        let count = object.value(forKey: "count") as! Int
        object.setValue(count + 1, forKey: "count")
        do {
            try self.context.save()
            return true
        } catch let e as NSError {
            NSLog("An error has occurred : %s", e.localizedDescription)
            return false
        }
    }
}
