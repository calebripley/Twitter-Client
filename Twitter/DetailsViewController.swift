//
//  DetailsViewController.swift
//  Twitter
//
//  Created by Caleb Ripley on 2/25/16.
//  Copyright © 2016 Caleb Ripley. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var tweet: Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let profileImageUrl = tweet!.user?.profileImageURL {
            profileImageView.setImageWithURL(NSURL(string: profileImageUrl)!)
        }
        tweetTextLabel.text = tweet?.text
        screenNameLabel.text = "@\((tweet!.user?.screenName)!)"
        userNameLabel.text = tweet!.user?.name
        //timeStampLabel.text =
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d"
        timeStampLabel.text = formatter.stringFromDate(tweet!.createdAt!)
        retweetLabel.text = "\((tweet!.retweetCount)) RETWEETS"
        likeLabel.text = "\((tweet!.favoriteCount)) LIKES"
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        tableView.hidden = true

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                    self.retweetLabel.text = "\(currentTweet.retweetCount)"
                    self.setRetweetImage(currentTweet.retweeted!)
                }
            }
        } else {
            TwitterClient.sharedInstance.unRetweetWithCompletion(tweetId!) { (tweet, error) -> () in
                if error == nil {
                    currentTweet.retweeted! = false
                    currentTweet.retweetCount -= 1
                    self.retweetLabel.text = "\(currentTweet.retweetCount)"
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
                    self.likeLabel.text = "\(currentTweet.favoriteCount)"
                    self.setFavoriteImage(currentTweet.favorited!)
                }
            }
        } else {
            TwitterClient.sharedInstance.favoriteWithCompletion(tweetId!) { (tweet, error) -> () in
                if error == nil {
                    currentTweet.favorited! = false
                    currentTweet.favoriteCount -= 1
                    self.likeLabel.text = "\(currentTweet.favoriteCount)"
                    self.setFavoriteImage(currentTweet.favorited!)
                }
            }
            
        }
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /*if TWEETS != nil {
            return (TWEETS?.count)!
        } else { */
        return 10

    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ReplyTweetCell", forIndexPath: indexPath) as! ReplyTweetCell
        /*
        cell.tweet = TWEETS![indexPath.row]
        cell.retweetButton.tag = indexPath.row
        cell.favoriteButton.tag = indexPath.row*/
        
        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Reply" {
            let user = User.currentUser
            let navController = segue.destinationViewController as! UINavigationController
            let composeViewController = navController.topViewController as! ComposeViewController
            composeViewController.user = user
        }

        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
