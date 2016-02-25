//
//  TweetCell.swift
//  Twitter
//
//  Created by Caleb Ripley on 2/20/16.
//  Copyright © 2016 Caleb Ripley. All rights reserved.
//

import UIKit

var tweets: [Tweet]?
var tweet: Tweet?

class TweetCell: UITableViewCell {

    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //self.reloadTweet()
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
    
    @IBAction func onRetweet(sender: AnyObject) {
        TwitterClient.sharedInstance.retweetWithCompletion((tweet!.tweetId!)) { (tweet, error) -> () in
            if tweet != nil {
                if tweet?.retweeted! == true {
                    tweet?.retweeted! = false
                    tweet?.retweetCount -= 1
                } else {
                    tweet?.retweeted! = true
                    tweet?.retweetCount += 1
                }
                self.updateCounts()
            }
        }
    }
    
    @IBAction func onFavorite(sender: AnyObject) {
        TwitterClient.sharedInstance.favoriteWithCompletion(tweet!.tweetId!) { (tweet, error) -> () in
            if tweet != nil {
                if tweet?.favorited! == true {
                    tweet?.favorited! = false
                    tweet?.favoriteCount -= 1
                } else {
                    tweet?.favorited! = true
                    tweet?.favoriteCount += 1
                }
                self.updateCounts()
            }

        }
    }
    
    func updateCounts() {
        favoriteCountLabel.text = String(tweet?.favoriteCount)
        retweetCountLabel.text = String(tweet?.retweetCount)
    }
    
    /*func reloadTweet() {
        userNameLabel.text = String(tweet?.user?.name)
        tweetLabel.text = tweet?.text
        if let profileImageUrl = tweet?.user?.profileImageURL {
            profileImageView.setImageWithURL(NSURL(string: profileImageUrl)!)
        }
        
        timeStampLabel.text = String(tweet?.createdAt)
        
        /*let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d"
        timeStampLabel.text = formatter.stringFromDate((tweet?.createdAt?)!)*/
        
        favoriteCountLabel.text = String(tweet?.favoriteCount)
        retweetCountLabel.text = String(tweet?.retweetCount)
        
        //self.screennameLabel.text
   
        /*if let favorited = self.tweet?.favorited {
            self.favoriteButton.enabled = !(favorited)
        }
        
        if let retweeted = self.tweet?.retweeted {
            self.retweetButton.enabled = !(retweeted)
        }*/
    }*/
    
}
