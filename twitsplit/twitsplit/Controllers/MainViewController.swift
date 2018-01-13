//
//  MainViewController.swift
//  twitsplit
//
//  Created by Leon Yuu on 1/12/18.
//  Copyright © 2018 Leon Yuu. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    // MARK: - Variables
    let cellID = "TWIT_POST_CELL"
    var twitPostList:[TwitPost] = []
    var twitAddPostView:TwitAddPostView?
    
    // MARK: - Outlets
    @IBOutlet weak var twitPostTableView:UITableView!
    
    // MARK: - Actions
    @IBAction func onTapResetButton() {
        // Clear Current Data Base
        DataBaseManager.cleanDataBase()
        
        // Clear List
        twitPostList = []
        twitPostTableView.reloadData()
        
    }
    
    @IBAction func onTapPostButton() {
        if (twitAddPostView != nil) {
            twitAddPostView!.setContentDialog("Cancel",
                                              "Post",
                                              cancelHandler: { // Tap Cancel
                                                self.twitAddPostView!.dismissView()
                                                
            }, confirmHandler: { // Tap Confirm
                self.twitAddPostView!.dismissView()
                self.saveNewTwitPostData(self.twitAddPostView!.getCurrentPostContent())
            })
            twitAddPostView!.showViewinSuperView(self.view)
        }
    }
    
    // MARK: - View Controllers
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Init Twit Post View to add a Post
        setUpAddTwitPostView()
        
        // Fetch Current Data Twit Post Table View
        loadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        printDebug(message: "Deinit Main View Controller")
    }
    
    // MARK: - Support Functions
    private func setUpAddTwitPostView() {
        if (twitAddPostView == nil) {
            twitAddPostView = TwitAddPostView(frame: CGRect(x: 0,
                                                            y: 0,
                                                            width: ScreenSize.SCREEN_WIDTH,
                                                            height: ScreenSize.SCREEN_HEIGHT))
        }
    }
    
    private func saveNewTwitPostData(_ postContent:String) {
        // Create New Post Data
        let post = TwitPost.init()
        post.postTimeStamp = Utils.getCurrentTime()
        post.postContent = postContent
        post.printOut()
        
        // Save to Data Base
        TwitPostData.init(post).saveToDataBase()
        
        // Refresh Current List
        self.twitPostList.append(post)
        self.twitPostTableView.reloadData()
        if (!self.twitPostList.isEmpty) {
            self.twitPostTableView.scrollToRow(at: IndexPath.init(row: self.twitPostList.count - 1, section: 0), at: UITableViewScrollPosition.top, animated: true)
        }
    }
    
    private func loadData() {
        let didFirstTimeInit = UserDefaults.standard.bool(forKey: "DID_FIRST_TIME_INIT")
        let postArray = DataBaseManager.getAllTwistPostData()
        if (postArray != nil) {
            for i in 0...(postArray!.count - 1) {
                twitPostList.append(postArray![i].convertValueToTwitPostObject())
            }
        } else {
            if (!didFirstTimeInit) {
                UserDefaults.standard.set(true, forKey: "DID_FIRST_TIME_INIT")
                initWelcomeData()
            }
        }
        twitPostTableView.reloadData()
        if (!self.twitPostList.isEmpty) {
            self.twitPostTableView.scrollToRow(at: IndexPath.init(row: self.twitPostList.count - 1, section: 0), at: UITableViewScrollPosition.top, animated: true)
        }
    }
    
    private func initWelcomeData() {
        var post = TwitPost.init()
        post.postTimeStamp = Utils.getCurrentTime()
        post.postContent = "Welcome to TwitSplit!"
        TwitPostData.init(post).saveToDataBase()
        twitPostList.append(post)
        
        post = TwitPost.init()
        post.postTimeStamp = Utils.getCurrentTime()
        post.postContent = "1/2 I can't believe Tweeter now supports chunking"
        TwitPostData.init(post).saveToDataBase()
        twitPostList.append(post)
        
        post = TwitPost.init()
        post.postTimeStamp = Utils.getCurrentTime()
        post.postContent = "2/2 my messages, so I don't have to do it myself."
        TwitPostData.init(post).saveToDataBase()
        twitPostList.append(post)
    }
    
}

// MARK: - UI Table View Delegate, Data Source
extension MainViewController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return twitPostList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! TwitPostViewCell
        let post = twitPostList[indexPath.row]
        cell.post = post
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

