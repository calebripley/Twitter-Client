//
//  ViewController.swift
//  Twitter
//
//  Created by Caleb Ripley on 2/14/16.
//  Copyright © 2016 Caleb Ripley. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogin(sender: AnyObject) {
        TwitterClient.sharedInstance.login({ () -> () in
            self.performSegueWithIdentifier("loginSegue", sender: nil)
            }) { (error: NSError) -> () in
                print(error.localizedDescription)
        }
    }

}

extension UIColor {
    convenience init(hex: Int, alpha: CGFloat) {
        
        let components = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255,
            A: alpha
        )
        
        self.init(red: components.R, green: components.G, blue: components.B, alpha: components.A)
    }
}

