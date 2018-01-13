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
    @IBAction func onTapPostButton() {
        if (twitAddPostView != nil) {
            twitAddPostView!.setContentDialog("Cancel",
                                              "Post",
                                              cancelHandler: { // Tap Cancel
                                                self.twitAddPostView!.dismissView()
                                                
            }, confirmHandler: { // Tap Confirm
                self.twitAddPostView!.dismissView()
                
            })
            twitAddPostView!.showViewinSuperView(self.view)
        }
    }
    
    // MARK: - View Controllers
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpAddTwitPostView()
        setUpPostTableView()
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
    
    private func setUpPostTableView() {
        twitPostTableView.rowHeight = UITableViewAutomaticDimension
    }
    
    private func loadData() {
        for _ in 0...5 {
            let post:TwitPost = TwitPost.init()
            post.postSubTitle = "Today, 6:39 PM"
            post.postContent = "I can't believe Tweeter now supports chunking my messages, so I don't have to do it myself."
            twitPostList.append(post)
        }
        
        twitPostTableView.reloadData()
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

