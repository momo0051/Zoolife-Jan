//
//  AdsCell.swift
//  ZOOLIFE
//
//  Created by Hafiz Anser  on 11/20/20.
//  Copyright © 2020 Hafiz Anser. All rights reserved.
//

import UIKit

class AdsCell: UITableViewCell {

    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var imgAd: UIImageView!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    
    
    @IBOutlet weak var backView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var lblTitle: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
