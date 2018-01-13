//
//  TwitPostData.swift
//  twitsplit
//
//  Created by Leon Yuu on 1/13/18.
//  Copyright © 2018 Leon Yuu. All rights reserved.
//

import CoreData
import UIKit

class TwitPostData: NSManagedObject {
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: (UIApplication.shared.delegate as! AppDelegate).managedObjectContext)
    }
    
    init(_ item:TwitPost) {
        let context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        let entity = NSEntityDescription.entity(forEntityName: "TwitPostData", in: context)
        super.init(entity: entity!, insertInto: context)
        
        postID = NSNumber(value: item.postID)
        postTimeStamp = NSNumber(value: item.postTimeStamp)
        postSubTitle = item.postSubTitle
        postContent = item.postContent
        
    }
    
    func saveToDataBase() {
        
        // Save New Data
        let context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
        do {
            try context.save()
            printDebug(message: "Succeeded to Save: \(String(describing: postID)) - \(String(describing: postContent))")
        } catch let error as NSError {
            printDebug(message: "Failed to Save: \(String(describing: postID)) - \(String(describing: postContent)) \(error), \(error.userInfo)")
        }
        
    }
    
    func convertValueToTwitPostObject () -> TwitPost {
        let post = TwitPost.init()
        post.postID = postID!.int32Value
        post.postTimeStamp = postTimeStamp!.doubleValue
        post.postSubTitle = postSubTitle!
        post.postContent = postContent!
        return post
    }
    
}
