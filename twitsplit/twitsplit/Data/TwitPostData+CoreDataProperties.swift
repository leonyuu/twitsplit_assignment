//
//  TwitPostData+CoreDataProperties.swift
//  twitsplit
//
//  Created by Leon Yuu on 1/13/18.
//  Copyright © 2018 Leon Yuu. All rights reserved.
//

import Foundation
import CoreData

extension TwitPostData {
    
    @NSManaged internal var postID:NSNumber?
    @NSManaged internal var postTimeStamp:NSNumber?
    @NSManaged internal var postSubTitle:String?
    @NSManaged internal var postContent:String?
    
}
