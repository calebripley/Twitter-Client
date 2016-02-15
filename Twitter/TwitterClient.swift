//
//  TwitterClient.swift
//  Twitter
//
//  Created by Caleb Ripley on 2/14/16.
//  Copyright © 2016 Caleb Ripley. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

let twitterConsumerKey = "V6xapbggOGgSEfS6N1HTdJCHC"
let twitterConsumerSecret = "66PrMlrNIF9S8qREIyov9JWiWevYkNfAsinsdcFGLZpvWq9AXn"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1SessionManager {

    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        return Static.instance
    }
}
