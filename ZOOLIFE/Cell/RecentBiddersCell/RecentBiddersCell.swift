//
//  RecentBiddersCell.swift
//  ZOOLIFE
//
//  Created by iMac on 01/12/21.
//  Copyright © 2021 Hafiz Anser. All rights reserved.
//

import UIKit

class RecentBiddersCell: UITableViewCell {

    @IBOutlet weak var lblBidPrice: UILabel!
    @IBOutlet weak var lblBidTime: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
