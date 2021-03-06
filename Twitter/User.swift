//
//  User.swift
//  Twitter
//
//  Created by Caleb Ripley on 2/15/16.
//  Copyright © 2016 Caleb Ripley. All rights reserved.
//

import UIKit

class User: NSObject {
    var name: String?
    var screenName: String?
    var profileImageURL: String?
    var tagLine: String?
    var dictionary: NSDictionary?
    var totalTweetsCount: Int?
    var followersCount: Int?
    var followingCount: Int?
    var profileBackgroundImageURL: String?
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        profileImageURL = dictionary["profile_image_url"] as? String
        tagLine = dictionary["description"] as? String
        
        totalTweetsCount = dictionary["statuses_count"] as? Int
        followersCount = dictionary["followers_count"] as? Int
        followingCount = dictionary["friends_count"] as? Int
        profileBackgroundImageURL = dictionary["profile_background_image_url"] as? String
    }
    
    static let userDidLogoutNotification = "userDidLogout"
    static var _currentUser: User?
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let defaults = NSUserDefaults.standardUserDefaults()
                let userData = defaults.objectForKey("currentUserData") as? NSData
        
                if let userData = userData {
                    let dictionary = try! NSJSONSerialization.JSONObjectWithData(userData, options: []) as! NSDictionary
                    _currentUser = User(dictionary: dictionary)
                }
            }
            return _currentUser
        }
        set(user) {
            _currentUser = user
            let defaults = NSUserDefaults.standardUserDefaults()
            
            if let user = user {
                let data = try! NSJSONSerialization.dataWithJSONObject(user.dictionary!, options: [])
                defaults.setObject(data, forKey: "currentUserData")
            } else {
                defaults.setObject(nil, forKey: "currentUserData")
            }
            defaults.synchronize()
        }
    }
    
    
}
