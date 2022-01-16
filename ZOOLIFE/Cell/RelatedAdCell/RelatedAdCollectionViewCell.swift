//
//  RelatedAdCollectionViewCell.swift
//  ZOOLIFE
//
//  Created by Muhammad Yousaf on 24/12/2020.
//  Copyright © 2020 Hafiz Anser. All rights reserved.
//

import UIKit

class RelatedAdCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var relatedImageView:UIImageView!
    @IBOutlet weak var lblAdsTitle: UILabel!
    @IBOutlet weak var lblAdsCity: UILabel!
    @IBOutlet weak var lblAdsDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       // shadowDecorate()
        // Initialization code
        relatedImageView.layer.cornerRadius = 10.0
    }

}



extension UICollectionViewCell {
    func shadowDecorate() {
        let radius: CGFloat = 8
        contentView.layer.cornerRadius = radius
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true
    
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1.0)
        layer.shadowRadius = 2.0
        layer.shadowOpacity = 0.5
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: radius).cgPath
        layer.cornerRadius = radius
    }
}


