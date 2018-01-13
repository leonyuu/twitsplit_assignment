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
    public var postTimeStamp:Double = 0
    public var postSubTitle:String = ""
    public var postContent:String = ""
    
    override init() {
        super.init()
    }
    
    init(_ post:TwitPost) {
        super.init()
        postID = post.postID
        postTimeStamp = post.postTimeStamp
        postSubTitle = post.postSubTitle
        postContent = post.postContent
    }
    
    public func printOut() {
        printDebug(message: "Post ID:  + \(postID)")
        printDebug(message: "Post Time Stamp: + \(postTimeStamp)")
        printDebug(message: "Post Sub Title: " + postSubTitle)
        printDebug(message: "Post Content: " + postContent)
        print("=======================\n")
    }

}
