//
//  DataBaseManager.swift
//  twitsplit
//
//  Created by Leon Yuu on 1/13/18.
//  Copyright © 2018 Leon Yuu. All rights reserved.
//

import UIKit
import CoreData

class DataBaseManager: NSObject {
    
    static func cleanDataBase() {
        let app = UIApplication.shared.delegate as! AppDelegate
        let managedContext = app.managedObjectContext
        let entityNamesArray = ["TwitPostData"]
        
        for entity in entityNamesArray {
            let fetchRequest : NSFetchRequest = NSFetchRequest<NSManagedObject>(entityName: entity);
            fetchRequest.includesPropertyValues = false;
            do {
                let fetchedObjects = try managedContext.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>);
                for object in fetchedObjects{
                    let fetchedObject = object as! NSManagedObject;
                    managedContext.delete(fetchedObject);
                }
                app.saveContext()
            }
            catch {
                 printDebug(message: "Failed to clean Data Base");
            }
        }
    }
    
    static func cleanTable(tableName: String) {
        let app = UIApplication.shared.delegate as! AppDelegate
        let managedContext = app.managedObjectContext
        
        let fetchRequest : NSFetchRequest = NSFetchRequest<NSManagedObject>(entityName: tableName);
        fetchRequest.includesPropertyValues = false;
        do {
            let fetchedObjects = try managedContext.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>);
            for object in fetchedObjects{
                let fetchedObject = object as! NSManagedObject;
                managedContext.delete(fetchedObject);
            }
            app.saveContext()
        }
        catch {
            printDebug(message: "Failed to clean table \(tableName) from Data Base");
        }
    }
    
    static func deleteObjectsByIds(ids: [Int], entity: String, propertyName: String) {
        var numberIds = [NSNumber]()
        for id in ids{
            numberIds.append(NSNumber(value: id))
        }
        
        let app = UIApplication.shared.delegate as! AppDelegate
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        request.returnsObjectsAsFaults = false
        request.sortDescriptors = [NSSortDescriptor(key: propertyName, ascending: true)]
        request.predicate = NSPredicate(format: "%K in %@", propertyName, numberIds) //propertyName,
        do {
            let dataArray = try app.managedObjectContext.fetch(request)
            for obj in dataArray{
                app.managedObjectContext.delete(obj as! NSManagedObject)
            }
            app.saveContext()
        } catch {
            printDebug(message: "Failed to delete object from Data Base");
        }
    }
    
    // MARK: - Twit Post Data
    static func getItemArticleDataById(id: Int) -> TwitPostData? {
        let app = UIApplication.shared.delegate as! AppDelegate
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TwitPostData")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "id == %d", id)
        do {
            let dataArray = try app.managedObjectContext.fetch(request) as! [TwitPostData]
            if dataArray.count > 0 {
                return dataArray[0]
            }
        } catch {
            printDebug(message: "Error fetching Twit Post Data")
        }
        return nil
    }
    
}
