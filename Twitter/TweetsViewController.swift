//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Caleb Ripley on 2/20/16.
//  Copyright © 2016 Caleb Ripley. All rights reserved.
//

import UIKit
import AFNetworking

var TWEETS: [Tweet]?
var USER: User?

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TweetCellDelegate {

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        TwitterClient.sharedInstance.homeTimeline({ (tweets: [Tweet]) -> () in
            TWEETS = tweets
            self.tableView.reloadData()
            }, failure: { (error: NSError) -> () in
                print(error.localizedDescription)
        })
        
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
    }
    
    override func viewDidAppear(animated: Bool) {
        TwitterClient.sharedInstance.homeTimeline({ (tweets: [Tweet]) -> () in
            TWEETS = tweets
            self.tableView.reloadData()
            }, failure: { (error: NSError) -> () in
                print(error.localizedDescription)
        })

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogoutButton(sender: AnyObject) {
        TwitterClient.sharedInstance.logout()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if TWEETS != nil {
            return (TWEETS?.count)!
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        
        cell.tweet = TWEETS![indexPath.row]
        cell.retweetButton.tag = indexPath.row
        cell.favoriteButton.tag = indexPath.row
        cell.replyButton.tag = indexPath.row
        
        cell.delegate = self
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "TweetDetails" {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            let tweet = TWEETS![indexPath!.row]
            
            let detailsViewController = segue.destinationViewController as! DetailsViewController
            detailsViewController.tweet = tweet
        } else if segue.identifier == "Compose" {
            
            let user = User.currentUser
            let navController = segue.destinationViewController as! UINavigationController
            let composeViewController = navController.topViewController as! ComposeViewController
            composeViewController.user = user
        } else if segue.identifier == "ProfilePage" {
            let profileViewController = segue.destinationViewController as! ProfileViewController
            profileViewController.user = USER
        } else if segue.identifier == "Reply" {
            let user = User.currentUser
            let navController = segue.destinationViewController as! UINavigationController
            let composeViewController = navController.topViewController as! ComposeViewController
            composeViewController.user = user
        }
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    @IBAction func cancelToTweetsViewController(segue:UIStoryboardSegue) {
    }
    
    func tweetCellProfileImageTap(sender: AnyObject?) {
        let recog = sender as! UITapGestureRecognizer
        let view = recog.view
        let cell = view!.superview?.superview as! TweetCell
        let indexPath = tableView.indexPathForCell(cell)
        USER = TWEETS![indexPath!.row].user
        self.performSegueWithIdentifier("ProfilePage", sender: nil)
    }
    
    /*// MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }*/
    

}
