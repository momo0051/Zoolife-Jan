//
//  FavouriteTableViewCell.swift
//  ZOOLIFE
//
//  Created by Muhammad Yousaf on 02/12/2020.
//  Copyright © 2020 Hafiz Anser. All rights reserved.
//

import UIKit

class FavouriteTableViewCell: UITableViewCell {
   // @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var imgAd: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
