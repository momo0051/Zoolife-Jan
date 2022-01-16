//
//  SettingCell.swift
//  ZOOLIFE
//
//  Created by Hafiz Anser  on 11/25/20.
//  Copyright © 2020 Hafiz Anser. All rights reserved.
//

import UIKit

class SettingCell: UITableViewCell {

    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblTititle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
