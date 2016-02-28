//
//  TweetCell.swift
//  Twitter
//
//  Created by Caleb Ripley on 2/20/16.
//  Copyright © 2016 Caleb Ripley. All rights reserved.
//

import UIKit


protocol TweetCellDelegate {
    func tweetCellProfileImageTap(sender: AnyObject?)
}

class TweetCell: UITableViewCell {

    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var replyButton: UIButton!
    
    var tapRec: UITapGestureRecognizer = UITapGestureRecognizer()
    var delegate: TweetCellDelegate?
    
    var tweet: Tweet! {
        didSet {
            self.userNameLabel.text = tweet.user!.name
            self.tweetLabel.text = tweet.text
            if let profileImageUrl = tweet.user?.profileImageURL {
                self.profileImageView.setImageWithURL(NSURL(string: profileImageUrl)!)
            }
            self.screenNameLabel.text = "@\((tweet.user?.screenName)!)"
            
            //cell.timeStampLabel.text = String(tweet.createdAt)
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EEE MMM d"
            self.timeStampLabel.text = formatter.stringFromDate(tweet.createdAt!)
            
            self.favoriteCountLabel.text = "\(tweet.favoriteCount)"
            self.retweetCountLabel.text = "\(tweet.retweetCount)"
            
            setRetweetImage(tweet.retweeted!)
            setFavoriteImage(tweet.favorited!)
            
            self.tapRec.addTarget(self, action: "profileImageTapped:")
            self.profileImageView.addGestureRecognizer(tapRec)
        }
    }
    
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
        let retweetBtn = sender as! UIButton
        let currentTweet = TWEETS![retweetBtn.tag]
        let tweetId = TWEETS![retweetBtn.tag].tweetId
        if !currentTweet.retweeted! {
            TwitterClient.sharedInstance.retweetWithCompletion(tweetId!) { (tweet, error) -> () in
                if error == nil {
                    currentTweet.retweeted! = true
                    currentTweet.retweetCount += 1
                    self.retweetCountLabel.text = "\(currentTweet.retweetCount)"
                    self.setRetweetImage(currentTweet.retweeted!)
                }
            }
        } else {
            TwitterClient.sharedInstance.unRetweetWithCompletion(tweetId!) { (tweet, error) -> () in
                if error == nil {
                    currentTweet.retweeted! = false
                    currentTweet.retweetCount -= 1
                    self.retweetCountLabel.text = "\(currentTweet.retweetCount)"
                    self.setRetweetImage(currentTweet.retweeted!)
                }
            }
        }
    }
    
    @IBAction func onFavorite(sender: AnyObject) {
        let favBtn = sender as! UIButton
        let currentTweet = TWEETS![favBtn.tag]
        let tweetId = TWEETS![favBtn.tag].tweetId
        if !currentTweet.favorited! {
            TwitterClient.sharedInstance.favoriteWithCompletion(tweetId!) { (tweet, error) -> () in
                if error == nil {
                    currentTweet.favorited! = true
                    currentTweet.favoriteCount += 1
                    self.favoriteCountLabel.text = "\(currentTweet.favoriteCount)"
                    self.setFavoriteImage(currentTweet.favorited!)
                }
            }
        } else {
            TwitterClient.sharedInstance.favoriteWithCompletion(tweetId!) { (tweet, error) -> () in
                if error == nil {
                    currentTweet.favorited! = false
                    currentTweet.favoriteCount -= 1
                    self.favoriteCountLabel.text = "\(currentTweet.favoriteCount)"
                    self.setFavoriteImage(currentTweet.favorited!)
                }
            }

        }
    }
    
    @IBAction func onReply(sender: AnyObject) {
    }
    
    func setRetweetImage(status: Bool) {
        if status {
            self.retweetButton.setImage(UIImage(named: "retweet-action-on"), forState: UIControlState.Normal)
        } else {
            self.retweetButton.setImage(UIImage(named: "retweet-action-off"), forState: UIControlState.Normal)
        }
    }
    
    func setFavoriteImage(status: Bool) {
        if status {
            self.favoriteButton.setImage(UIImage(named: "like-action-on"), forState: UIControlState.Normal)
        } else {
            self.favoriteButton.setImage(UIImage(named: "like-action-off"), forState: UIControlState.Normal)
        }
    }
    
    func profileImageTapped(sender: AnyObject) {
        delegate?.tweetCellProfileImageTap(sender)
        //print("profile image tapped")
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
