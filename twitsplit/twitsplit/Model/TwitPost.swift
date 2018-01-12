//
//  TwitPost.swift
//  twitsplit
//
//  Created by Leon Yuu on 1/12/18.
//  Copyright © 2018 Leon Yuu. All rights reserved.
//

import UIKit

class TwitPost: NSObject {
    
    public var postID:Int32 = 0
    public var postContent:String = ""
    
    override init() {
        super.init()
    }
    
    init(_ contact:TwitPost) {
        super.init()
        postID = contact.postID
        postContent = contact.postContent
    }
    
    public func printOut() {
        print("Post ID:  + \(postID)")
        print("Name: " + postContent)
        print("=======================\n")
    }

}
