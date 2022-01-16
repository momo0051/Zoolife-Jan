
//
//  CommentsCell.swift
//  jaminwithus
//
//  Created by Hafiz Anser  on 9/16/20.
//  Copyright © 2020 Hafiz Anser. All rights reserved.
//

import UIKit

class CommentsCell: UITableViewCell {

    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblEventInfromation: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    var comment: Comment? {
//        didSet {
//            imgUser.image = UIImage(named: "pr_plceholder#")
//            if let profileImg = comment?.user?.getImageUrl() {
//                imgUser.setImageWith(profileImg, placeholderImage: UIImage(named: "pr_plceholder#"))
//            }
//            lblName.text = comment?.user?.getUserName()
//            lblEventInfromation.text = comment?.cmnt
//        }
//    }
    
}
