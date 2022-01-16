//
//  AuctionCell.swift
//  ZOOLIFE
//
//  Created by iMac on 30/11/21.
//  Copyright © 2021 Hafiz Anser. All rights reserved.
//

import UIKit

class AuctionCell: UICollectionViewCell {

    @IBOutlet weak var crowImg: UIImageView!
    @IBOutlet weak var imgAd: UIImageView!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblBid: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var backView: UIView!
    
    var releaseDate: NSDate?
    var countdownTimer = Timer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setTimer(expiryTime:String){
        let releaseDateString = expiryTime
        if releaseDateString.isEmpty { return }
        let releaseDateFormatter = DateFormatter()
        releaseDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        releaseDateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        releaseDate = releaseDateFormatter.date(from: releaseDateString)! as NSDate
        
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
        
        let currentDate = Date()
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "UTC")!
        let diffDateComponents = calendar.dateComponents([.day, .hour, .minute, .second], from: currentDate, to: releaseDate! as Date)
        
        let countdownEn = "\(diffDateComponents.day ?? 0) D \(diffDateComponents.hour ?? 0) H \(diffDateComponents.minute ?? 0) M \(diffDateComponents.second ?? 0) S"
        let countdownArbic = "\(diffDateComponents.day ?? 0)  يوم \(diffDateComponents.hour ?? 0)  ساعة \(diffDateComponents.minute ?? 0)  دقيقة \(diffDateComponents.second ?? 0)   ثانية "
        if (diffDateComponents.day ?? 0) > 0 || (diffDateComponents.hour ?? 0) > 0 || (diffDateComponents.minute ?? 0) > 0 || (diffDateComponents.second ?? 0) > 0{
            
            if appLanguage == "en" {
                lblDate.localizeKey = countdownEn
            } else {
                lblDate.localizeKey = countdownArbic
            }
            
          
        }else{
          
            if appLanguage == "en" {
                lblDate.localizeKey = "Auction Close"
            } else {
                lblDate.localizeKey = "المزاد منتهي "
            }
    
        }
        
    }
}
