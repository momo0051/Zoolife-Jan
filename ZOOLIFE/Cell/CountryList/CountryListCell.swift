//
//  CountryListCell.swift
//  jaminwithus
//
//  Created by Hafiz Anser  on 9/19/20.
//  Copyright © 2020 Hafiz Anser. All rights reserved.
//

import UIKit

class CountryListCell: UITableViewCell
{
    @IBOutlet weak var viewBackGround: UIView!
    
    @IBOutlet weak var lblCountryName: UILabel!
    @IBOutlet weak var imgNext: UIImageView!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
        //imgTickTapped.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
        
        viewBackGround.layer.masksToBounds = false
        viewBackGround.layer.shadowOffset = CGSize(width: -1, height: 1)
        viewBackGround.layer.shadowOpacity = 0.5
    }
    
}
