//
//  TwitPostManager.swift
//  twitsplit
//
//  Created by Leon Yuu on 1/13/18.
//  Copyright © 2018 Leon Yuu. All rights reserved.
//

import UIKit
import SVProgressHUD

class TwitPostManager: NSObject {
 
    // Fetch All Post Data
    public static func fecthAllPostData(completion:@escaping ([TwitPost]?,Bool) -> Void) {
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show(withStatus: "Loading...")
        
        var postList:[TwitPost] = []
        let didFirstTimeInit = UserDefaults.standard.bool(forKey: "DID_FIRST_TIME_INIT")
        let postArray = DataBaseManager.getAllTwistPostData()
        
        DispatchQueue.global(qos: .default).async(execute: {
            if (postArray != nil) {
                for i in 0...(postArray!.count - 1) {
                    postList.append(postArray![i].convertValueToTwitPostObject())
                }
            } else {
                if (!didFirstTimeInit) {
                    UserDefaults.standard.set(true, forKey: "DID_FIRST_TIME_INIT")
                    postList = initWelcomeData()
                }
            }
            
            let when = DispatchTime.now() + 0.3
            DispatchQueue.main.asyncAfter(deadline: when, execute: {
                completion(postList,true)
                SVProgressHUD.dismiss()
            })
        })
    }
    
    // Post New Post Data
    public static func postNewData(_ post:TwitPost, completion:@escaping (Bool) -> Void) {
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show(withStatus: "Posting...")
        
        TwitPostData.init(post).saveToDataBase()
        let when = DispatchTime.now() + 0.3
        DispatchQueue.main.asyncAfter(deadline: when, execute: {
            completion(true)
            SVProgressHUD.dismiss()
        })
    }
    
    // Init First Welcome Data, if needed
    private static func initWelcomeData() -> [TwitPost]! {
        var postList:[TwitPost] = []
        
        var post = TwitPost.init()
        post.postTimeStamp = Utils.getCurrentTime()
        post.postContent = "Welcome to TwitSplit!"
        TwitPostData.init(post).saveToDataBase()
        postList.append(post)
        
        post = TwitPost.init()
        post.postTimeStamp = Utils.getCurrentTime()
        post.postContent = "1/2 I can't believe Tweeter now supports chunking"
        TwitPostData.init(post).saveToDataBase()
        postList.append(post)
        
        post = TwitPost.init()
        post.postTimeStamp = Utils.getCurrentTime()
        post.postContent = "2/2 my messages, so I don't have to do it myself."
        TwitPostData.init(post).saveToDataBase()
        postList.append(post)
        
        return postList
    }
    
}
