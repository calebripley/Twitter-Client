//
//  TwitterClient.swift
//  Twitter
//
//  Created by Caleb Ripley on 2/14/16.
//  Copyright © 2016 Caleb Ripley. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {

    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com")!, consumerKey: "V6xapbggOGgSEfS6N1HTdJCHC", consumerSecret: "66PrMlrNIF9S8qREIyov9JWiWevYkNfAsinsdcFGLZpvWq9AXn")
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError) -> ())?
    
    func login(success: () ->(), failure: (NSError) -> ()) {
        loginSuccess = success
        loginFailure = failure
        
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            let authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(authURL!)
            }) { (error: NSError!) -> Void in
                print(error.localizedDescription)
                self.loginFailure!(error)
        }
    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        
        NSNotificationCenter.defaultCenter().postNotificationName(User.userDidLogoutNotification, object: nil)
    }
    
    func handleOpenUrl(url: NSURL) {
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken: BDBOAuth1Credential!) -> Void in
            self.requestSerializer.saveAccessToken(accessToken)
            
            self.currentAccount({ (user: User) -> () in
                    User.currentUser = user
                    self.loginSuccess?()
                }, failure: { (error: NSError) -> () in
                    self.loginFailure!(error)
            })
            }) { (error: NSError!) -> Void in
                print (error.localizedDescription)
                self.loginFailure!(error)
        }
    }

    func homeTimeline(success: ([Tweet]) -> (), failure: (NSError) -> ()) {
        GET("1.1/statuses/home_timeline.json", parameters: nil, progress:  nil, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
            
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries)
            //print(dictionaries)
            success(tweets)
            }, failure: { (operaiton: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        })
    }
    
    func currentAccount(success: (User) -> (), failure: (NSError) -> ()) {
        GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            //print(userDictionary)
            success(user)
            
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        })
    }
    
    func retweetWithCompletion(tweetId: String, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        
        POST("1.1/statuses/retweet/\(tweetId).json", parameters: nil, progress: nil,
            success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let tweet = Tweet(dictionary: response as! NSDictionary)
            completion(tweet: tweet, error: nil)

            },
            
            failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                
            print(error.localizedDescription)
            completion(tweet: nil, error: error)
            })
    }
    
    func unRetweetWithCompletion(tweetId: String, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        
        POST("1.1/statuses/unretweet/\(tweetId).json", parameters: nil, progress: nil,
            success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
                let tweet = Tweet(dictionary: response as! NSDictionary)
                completion(tweet: tweet, error: nil)
                
            },
            failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                print(error.localizedDescription)
                completion(tweet: nil, error: error)
        })
    }
    
    func favoriteWithCompletion(tweetId: String, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        
        POST("1.1/favorites/create.json?id=\(tweetId)", parameters: nil, progress: nil,
            success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
                let tweet = Tweet(dictionary: response as! NSDictionary)
                completion(tweet: tweet, error: nil)
            
            },
            failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                print(error.localizedDescription)
                completion(tweet: nil, error: error)
        })
    }
    
    func unFavoriteWithCompletion(tweetId: String, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        
        POST("1.1/favorites/destroy.json?id=\(tweetId)", parameters: nil, progress: nil,
            success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
                let tweet = Tweet(dictionary: response as! NSDictionary)
                completion(tweet: tweet, error: nil)
                
            },
            failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                print(error.localizedDescription)
                completion(tweet: nil, error: error)
        })
    }
    
    func tweet(status: String) {
        POST("1.1/statuses/update.json", parameters: ["status": status], progress: nil,
            success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
                //print("succesfull tweet")
            
            },
            failure: { (operation, error) -> Void in
                print(error.localizedDescription)
        })
    }
}
