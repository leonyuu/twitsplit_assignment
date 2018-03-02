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
    let twitPostList = Variable<[TwitPost]>([])
    
    // MARK: - Outlets
    @IBOutlet weak var postButton:UIButton!
    @IBOutlet weak var resetButton:UIButton!
    @IBOutlet weak var twitPostTableView:UITableView!
    
    // MARK: - Actions
    private func onResetButton() {
        // Clear Current Data Base
        DataBaseManager.cleanDataBase()

        // Clear List
        twitPostList.value = []
        
    }
    
    private func onPostButton() {
        if (twitAddPostView != nil) {
            twitAddPostView!.setContentDialog("Cancel",
                                              "Post",
                                              cancelHandler: { [weak self ] in // Tap Cancel
                                                guard let _ = self else {return}
                                                self!.twitAddPostView!.dismissView()
                                                
            }, confirmHandler: { [weak self] in // Tap Confirm
                guard let _ = self else {return}
                self!.twitAddPostView!.dismissView()
                self!.saveNewTwitPostData(self!.twitAddPostView!.getCurrentPostContent())
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
        
        // Subcribe for Twit Post List Bind data to Table View
        twitPostList.asObservable().bind(to: twitPostTableView.rx.items(cellIdentifier: cellID, cellType: TwitPostViewCell.self)) { (row, element, cell) in
            cell.post = element
            }.disposed(by: disposeBag)
        
        // Subcribe for Twit Post List Updated Value
        twitPostList.asObservable().subscribe( onNext: { [weak self] posts in
            guard let _ = self else {return}
            self!.twitPostTableView.reloadData()
            let lastRow = self!.twitPostList.value.count - 1;
            if (!self!.twitPostList.value.isEmpty) {
                self!.twitPostTableView.scrollToRow(at: IndexPath.init(row: lastRow, section: 0),
                                                    at: UITableViewScrollPosition.top,
                                                    animated: true)
            }
        }).disposed(by: disposeBag)
        
        // Set Up Table View
        twitPostTableView.rx.itemSelected.throttle(0.5, scheduler: MainScheduler.instance)
            .subscribe(onNext: {[weak self] indexpath in
            guard let _ = self else {return}
            self!.twitPostTableView.deselectRow(at: indexpath, animated: true)
        }).disposed(by: disposeBag)
        
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
        TwitPostManager.fecthAllPostData(completion: { [weak self] (postList,state) -> Void in
            guard let _ = self else {return}
            if (postList != nil && state) {
                self!.twitPostList.value = postList!
            }
        })
    }
    
    private func saveNewTwitPostData(_ postContent:String) {
        
        // Save to Data Base
        TwitPostManager.postNewData(postContent,completion: { [weak self] (postlist,state) -> Void in
            guard let _ = self else {return}
            if (state) {
                var tempArrays:[TwitPost] = self!.twitPostList.value
                // Append new element to current list
                for post in postlist {
                    tempArrays.append(post)
                }
                self!.twitPostList.value = tempArrays
            }
        })
    }
    
}

