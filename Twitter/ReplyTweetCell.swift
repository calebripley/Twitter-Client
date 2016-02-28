//
//  ReplyTweetCell.swift
//  Twitter
//
//  Created by Caleb Ripley on 2/27/16.
//  Copyright © 2016 Caleb Ripley. All rights reserved.
//

import UIKit

class ReplyTweetCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var replyTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
