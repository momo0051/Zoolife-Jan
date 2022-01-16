//
//  EventCell.swift
//  jaminwithus
//
//  Created by Hafiz Anser  on 9/16/20.
//  Copyright © 2020 Hafiz Anser. All rights reserved.
//

import UIKit

class EventCell: UICollectionViewCell
{
    @IBOutlet weak var imgPost: UIImageView!
    @IBOutlet weak var imgProfile: UIImageView!
    
    @IBOutlet weak var btnHeart: UIButton!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblName: UILabel!
    
    
    @IBOutlet weak var lblEventName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
//    var event: Event? {
//        didSet {
//            lblName.text = event?.user?.getUserName()
//            lblDate.text = event?.getTimeAndDate()
//            
//            if event?.save == true {
//                btnHeart.isSelected = true
//            } else {
//                btnHeart.isSelected = false
//            }
//            
//            imgProfile.image = UIImage(named: "pr_plceholder#")
//            imgPost.image = UIImage(named: "placeholder")
//            if let profileImg = event?.user?.getImageUrl() {
//                imgProfile.setImageWith(profileImg)
//            }
//            
//            if event?.file?.isImageType() == true {
//                if let url = event?.file?.getMediaUrl() {
//                    self.imgPost.setImageWith(url, placeholderImage: UIImage(named: "placeholder"))
//                }
//        }
//     }
//    
//    }
}
