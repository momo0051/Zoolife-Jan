//
//  SearchCell.swift
//  ZOOLIFE
//
//  Created by Hafiz Anser  on 11/25/20.
//  Copyright © 2020 Hafiz Anser. All rights reserved.
//

import UIKit

class SearchCell: UICollectionViewCell {
    
    @IBOutlet weak var image1:UIImageView!
    @IBOutlet weak var image2:UIImageView!
    @IBOutlet weak var image3:UIImageView!
    
    @IBOutlet weak var articlePostedDate:UILabel!
    @IBOutlet weak var articleTitle:UILabel! 
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
