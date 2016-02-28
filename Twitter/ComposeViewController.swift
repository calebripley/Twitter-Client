//
//  ComposeViewController.swift
//  Twitter
//
//  Created by Caleb Ripley on 2/26/16.
//  Copyright © 2016 Caleb Ripley. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UITextView!
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let profileImageUrl = user?.profileImageURL {
            profileImageView.setImageWithURL(NSURL(string: profileImageUrl)!)
        }
        userNameLabel.text = user!.name
        screenNameLabel.text = "@\((user!.screenName)!)"
        tweetTextLabel.text = "Tap here to tweet!"
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onTweet(sender: AnyObject) {
        //print("tweet button pressed")
        TwitterClient.sharedInstance.tweet(tweetTextLabel.text)
        dismissViewControllerAnimated(true) { () -> Void in
        }
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
