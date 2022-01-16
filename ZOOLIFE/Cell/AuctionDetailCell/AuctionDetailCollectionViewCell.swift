//
//  AuctionDetailCollectionViewCell.swift
//  ZOOLIFE
//
//  Created by Zohaib Manzoor kushwaha on 19/12/2021.
//  Copyright © 2021 Hafiz Anser. All rights reserved.
//

import UIKit

class AuctionDetailCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var bgroundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func didPlayTapped(_ sender: UIButton) {
    }
    
}
