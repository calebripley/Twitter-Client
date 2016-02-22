//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Caleb Ripley on 2/20/16.
//  Copyright © 2016 Caleb Ripley. All rights reserved.
//

import UIKit
import AFNetworking

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var users: [User]?
    var tweets: [Tweet]?
    var tweet: Tweet!
    var user: User!
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        TwitterClient.sharedInstance.homeTimeline({ (tweets: [Tweet]) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
            }, failure: { (error: NSError) -> () in
                print(error.localizedDescription)
        })
        
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogoutButton(sender: AnyObject) {
        TwitterClient.sharedInstance.logout()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets != nil {
            return (tweets?.count)!
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        let tweet = tweets![indexPath.row]
        
        cell.userNameLabel.text = "@" + (tweet.user!.screenName! as String)
        cell.profileImageView.setImageWithURL(tweet.user!.profileImageURL!)
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d"
        cell.timeStampLabel.text = formatter.stringFromDate(tweet.createdAt!)
        cell.tweetLabel.text = tweet.text
    
        return cell
    }

    @IBAction func onRetweet(sender: AnyObject) {
        let indexPath = self.tableView.indexPathForSelectedRow
        let tweet = tweets![indexPath!.row]
        TwitterClient.sharedInstance.retweet(tweet.tweetId!)
    }
    
    @IBAction func onFavorite(sender: AnyObject) {
        let indexPath = self.tableView.indexPathForSelectedRow
        let tweet = tweets![indexPath!.row]
        TwitterClient.sharedInstance.favorite(tweet.tweetId!)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
