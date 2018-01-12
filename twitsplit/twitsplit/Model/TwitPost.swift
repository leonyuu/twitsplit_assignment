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
    public var postSubTitle:String = ""
    public var postContent:String = ""
    
    override init() {
        super.init()
    }
    
    init(_ post:TwitPost) {
        super.init()
        postID = post.postID
        postSubTitle = post.postSubTitle
        postContent = post.postContent
    }
    
    public func printOut() {
        print("Post ID:  + \(postID)")
        print("Post Sub Title: " + postSubTitle)
        print("Post Content: " + postContent)
        print("=======================\n")
    }

}
