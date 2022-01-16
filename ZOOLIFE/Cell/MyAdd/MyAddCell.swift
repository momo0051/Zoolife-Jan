//
//  MyAddCell.swift
//  ZOOLIFE
//
//  Created by Hafiz Anser  on 11/27/20.
//  Copyright © 2020 Hafiz Anser. All rights reserved.
//

import UIKit

class MyAddCell: UITableViewCell
{

    @IBOutlet weak var viewTopHeader: UIView!
    @IBOutlet weak var viewBottom: UIView!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
        viewTopHeader.roundCorners([.topLeft, .topRight], radius: 10)
        viewBottom.roundCorners([.bottomLeft, .bottomRight], radius: 10)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
