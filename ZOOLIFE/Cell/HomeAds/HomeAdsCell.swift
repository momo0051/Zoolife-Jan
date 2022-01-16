//
//  HomeAdsCell.swift
//  ZOOLIFE
//
//  Created by mac on 2/21/21.
//  Copyright © 2021 Hafiz Anser. All rights reserved.
//

import UIKit

class HomeAdsCell: UICollectionViewCell {

    @IBOutlet weak var imgWaterMark: UIImageView!
    @IBOutlet weak var crowImg: UIImageView!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var imgAd: UIImageView!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var backView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
