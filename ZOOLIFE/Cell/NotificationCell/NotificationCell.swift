//
//  NotificationCell.swift
//  ZOOLIFE
//
//  Created by Hafiz Anser  on 11/23/20.
//  Copyright © 2020 Hafiz Anser. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {

    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var lbldescrition: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
