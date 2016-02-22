//
//  TweetCell.swift
//  Twitter
//
//  Created by Caleb Ripley on 2/20/16.
//  Copyright © 2016 Caleb Ripley. All rights reserved.
//

import UIKit



class TweetCell: UITableViewCell {

    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    var tweet: Tweet! {
        didSet {
            tweetLabel.text = tweet.text
            timeStampLabel.text = String(tweet.createdAt)
        }
    }
    
    var user: User! {
        didSet {
            userNameLabel.text = String(user.screenName)
            profileImageView.setImageWithURL(user.profileImageURL!)
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        userNameLabel.preferredMaxLayoutWidth = userNameLabel.frame.size.width
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        userNameLabel.preferredMaxLayoutWidth = userNameLabel.frame.size.width
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
