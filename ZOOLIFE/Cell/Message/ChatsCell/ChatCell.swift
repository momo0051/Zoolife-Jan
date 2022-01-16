//
//  ChatCell.swift
//  ZOOLIFE
//
//  Created by Hafiz Anser  on 11/26/20.
//  Copyright © 2020 Hafiz Anser. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {
    
    @IBOutlet weak var adTitle:UILabel!
    @IBOutlet weak var lastMessageLabel:UILabel!
    @IBOutlet weak var lastMessageTime:UILabel!
    @IBOutlet weak var senderName:UILabel!
    @IBOutlet weak var unreadMessage:UILabel!
    @IBOutlet weak var adImage:UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
