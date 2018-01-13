//
//  TwitPostViewCell.swift
//  twitsplit
//
//  Created by Leon Yuu on 1/12/18.
//  Copyright © 2018 Leon Yuu. All rights reserved.
//

import UIKit

class TwitPostViewCell: UITableViewCell {

    @IBOutlet weak var postAvatar:UIImageView!
    @IBOutlet weak var postSubLabel:UILabel!
    @IBOutlet weak var postContent:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        postAvatar.layer.cornerRadius = 5
        postAvatar.layer.borderWidth = 0.5
        postAvatar.layer.borderColor = UIColor.gray.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    var post:TwitPost? {
        didSet {
            postSubLabel.text = Utils.convertTimefromTimeStamp(post!.postTimeStamp)
            postContent.text = post!.postSubTitle.isEmpty ? post!.postContent: post!.postSubTitle + " " + post!.postContent
        }
    }

}
