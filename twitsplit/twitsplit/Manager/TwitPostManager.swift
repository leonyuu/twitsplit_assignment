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
                    DispatchQueue.main.async(execute: {
                        postList = initWelcomeData()
                    })
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
    public static func postNewData(_ postContent:String, completion:@escaping ([TwitPost],Bool) -> Void) {
        
        var postList:[TwitPost] = []
        Utils.splitContent(postContent) { (results, state) in
            printDebug(message: "Results: \(results) - State: \(state)")
            if (state) { // Split String Successfully
                SVProgressHUD.setDefaultMaskType(.black)
                SVProgressHUD.show(withStatus: "Posting...")
                
                for i in 0..<results.count {
                    let post = TwitPost.init()
                    post.postTimeStamp = Utils.getCurrentTime()
                    post.postContent = results[i]
                    postList.append(post)
                    TwitPostData.init(post).saveToDataBase()
                }
                
                let when = DispatchTime.now() + 0.3
                DispatchQueue.main.asyncAfter(deadline: when, execute: {
                    completion(postList,state)
                    SVProgressHUD.dismiss()
                })
                
            } else { // Error Occurs
                SVProgressHUD.showError(withStatus: results[0])
                completion(postList,state)
            }
        }
    }
    
    // Init First Welcome Data, if needed
    private static func initWelcomeData() -> [TwitPost]! {
        
        let initString = ["Welcome to TwitSplit!","I can't believe Tweeter now supports chunking my messages, so I don't have to do it myself."]
        
        var postList:[TwitPost] = []
        
        for string in initString {
            Utils.splitContent(string) { (results, state) in
                printDebug(message: "Results: \(results) - State: \(state)")
                if (state) { // Split String Successfully
                    
                    for i in 0..<results.count {
                        let post = TwitPost.init()
                        post.postTimeStamp = Utils.getCurrentTime()
                        post.postContent = results[i]
                        postList.append(post)
                        TwitPostData.init(post).saveToDataBase()
                    }
                    
                }
            }
        }
        
        return postList
    }
    
}
