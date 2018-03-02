//
//  MainViewController.swift
//  twitsplit
//
//  Created by Leon Yuu on 1/12/18.
//  Copyright © 2018 Leon Yuu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MainViewController: UIViewController {

    // MARK: - Variables
    let cellID = "TWIT_POST_CELL"
    var twitAddPostView:TwitAddPostView?
    let disposeBag = DisposeBag()
    let twitPostListVariable = Variable<[TwitPost]>([])
    
    // MARK: - Outlets
    @IBOutlet weak var postButton:UIButton!
    @IBOutlet weak var resetButton:UIButton!
    @IBOutlet weak var twitPostTableView:UITableView!
    
    // MARK: - Actions
    private func onResetButton() {
        // Clear Current Data Base
        DataBaseManager.cleanDataBase()

        // Clear List
        twitPostListVariable.value = []
        
    }
    
    private func onPostButton() {
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
        loadTwitPostData()
        
        // Subscribe for Post, Reset Tap event
        postButton.rx.tap.throttle(0.5, scheduler: MainScheduler.instance)
            .subscribe( onNext: { [weak self] in
            guard let _ = self else {return}
            self!.onPostButton()
            }).disposed(by: disposeBag)
        
        resetButton.rx.tap.throttle(0.5, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
            guard let _ = self else {return}
            self!.onResetButton()
        }).disposed(by: disposeBag)
        
        // Subcribe for twitPostList
        twitPostListVariable.asObservable().subscribe( onNext: { [weak self] posts in
            guard let _ = self else {return}
            self!.twitPostTableView.reloadData()
            let lastRow = self!.twitPostListVariable.value.count - 1;
            if (!self!.twitPostListVariable.value.isEmpty) {
                self!.twitPostTableView.scrollToRow(at: IndexPath.init(row: lastRow, section: 0),
                                                  at: UITableViewScrollPosition.top,
                                                  animated: true)
            }
        })
        .disposed(by: disposeBag)
        
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
    
    private func loadTwitPostData() {
        TwitPostManager.fecthAllPostData(completion: { (postList,state) -> Void in
            if (postList != nil && state) {
                self.twitPostListVariable.value = postList!
            }
        })
    }
    
    private func saveNewTwitPostData(_ postContent:String) {
        
        // Save to Data Base
        TwitPostManager.postNewData(postContent,completion: { [weak self] (postlist,state) -> Void in
            guard let _ = self else {return}
            if (state) {
                var tempArrays:[TwitPost] = self!.twitPostListVariable.value
                // Append new element to current list
                for post in postlist {
                    tempArrays.append(post)
                }
                self!.twitPostListVariable.value = tempArrays
            }
        })
    }
    
}

// MARK: - UI Table View Delegate, Data Source
extension MainViewController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.twitPostListVariable.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! TwitPostViewCell
        let post = self.twitPostListVariable.value[indexPath.row]
        cell.post = post
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

