//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Caleb Ripley on 2/26/16.
//  Copyright © 2016 Caleb Ripley. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    var user: User?
    
    @IBOutlet weak var profileBackgroundImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var totalTweetsLabel: UILabel!
    @IBOutlet weak var tagLineLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let profileBackgroundImageUrl = user?.profileBackgroundImageURL {
            profileBackgroundImageView.setImageWithURL(NSURL(string: profileBackgroundImageUrl)!)
        }
        if let profileImageUrl = user?.profileImageURL {
            profileImageView.setImageWithURL(NSURL(string: profileImageUrl)!)
        }
        followersLabel.text = "\(user!.followersCount!) FOLLOWERS"
        followingLabel.text = "\(user!.followingCount!) FOLLOWING"
        totalTweetsLabel.text = "\(user!.totalTweetsCount!) TWEETS"
        tagLineLabel.text = user!.tagLine
        screenNameLabel.text = "@\(user!.screenName!)"
        userNameLabel.text = user!.name
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
