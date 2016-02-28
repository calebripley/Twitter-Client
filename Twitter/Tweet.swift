//
//  Tweet.swift
//  Twitter
//
//  Created by Caleb Ripley on 2/15/16.
//  Copyright © 2016 Caleb Ripley. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var user: User?
    var text: String?
    var createdAt: NSDate?
    var retweetCount: Int = 0
    var favoriteCount: Int = 0
    var tweetId: String?
    var favorited: Bool?
    var retweeted: Bool?
    
    init(dictionary: NSDictionary) {
        
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        text = (dictionary["text"] as? String)
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoriteCount = (dictionary["favorite_count"] as? Int) ?? 0
        tweetId = dictionary["id_str"] as? String
        favorited = dictionary["favorited"] as? Bool
        retweeted = dictionary["retweeted"] as? Bool

        let createdAtString = dictionary["created_at"] as? String
        if let createdAtString = createdAtString {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            createdAt = formatter.dateFromString(createdAtString)
        }
    }

    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        
        return tweets
    }
    
}
