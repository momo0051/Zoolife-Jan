//
//  VideoCell.swift
//  ZOOLIFE
//
//  Created by TGI-2 on 20/12/2021.
//  Copyright © 2021 Hafiz Anser. All rights reserved.
//

import UIKit

class VideoCell: UIView {

    @IBOutlet weak var ivBackground: UIImageView!
    class func instanceFromNib() -> VideoCell {
        let view = UINib(nibName: "VideoCell", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! VideoCell
        return view
    }
}
