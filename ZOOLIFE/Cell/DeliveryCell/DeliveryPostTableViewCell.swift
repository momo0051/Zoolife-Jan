//
//  DeliveryPostTableViewCell.swift
//  ZOOLIFE
//
//  Created by Muhammad Yousaf on 23/12/2020.
//  Copyright © 2020 Hafiz Anser. All rights reserved.
//

import UIKit

class DeliveryPostTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var crossButton:UIButton!
    
    var post:Ad?
    var delegate:DeliveryCellDelegate?
    
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var locationLabel:UILabel!
    @IBOutlet weak var backView:ShadowView!
    @IBOutlet weak var deliveryButton:UIButton!
    
//    
//    var shadowLayer: CAShapeLayer!
//    var corneadius: CGFloat = 8.0
//    var fillColor: UIColor = .white // the color applied to the shadowLayer, rather than the view's backgroundColor
//    

    override func awakeFromNib() {
        super.awakeFromNib()
        
//        backView.addShadow(shadowColor: .darkGray, offSet: .zero, opacity: 1.0, shadowRadius: 3, cornerRadius: 8, corners: .allCorners)
//        deliveryButton.addShadow(shadowColor: .darkGray, offSet: .zero, opacity: 1.0, shadowRadius: 3, cornerRadius: 8, corners: .allCorners)
//
        
    

    }
    
//    override func layoutIfNeeded() {
//        super.layoutIfNeeded()
//        if shadowLayer == nil {
//            shadowLayer = CAShapeLayer()
//         // backView.layer.masksToBounds = false
//          shadowLayer.path = UIBezierPath(roundedRect: backView.bounds, cornerRadius: corneadius).cgPath
//
//          shadowLayer.fillColor = fillColor.cgColor
//
//            shadowLayer.shadowColor = UIColor.lightGray.cgColor
//            shadowLayer.shadowPath = shadowLayer.path
//          shadowLayer.shadowOffset = .zero//CGSize(width: 0.0, height: 1.0)
//          shadowLayer.shadowOpacity = 0.6
//            shadowLayer.shadowRadius = 3
//
//            backView.layer.insertSublayer(shadowLayer, at: 0)
//        }
//    }
    
   
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        //backView.addShadow(shadowColor: .darkGray, offSet: .zero, opacity: 1.0, shadowRadius: 3, cornerRadius: 8, corners: .allCorners)
//          if shadowLayer == nil {
//              shadowLayer = CAShapeLayer()
//           // backView.layer.masksToBounds = false
//            shadowLayer.path = UIBezierPath(roundedRect: backView.bounds, cornerRadius: corneadius).cgPath
//
//            shadowLayer.fillColor = fillColor.cgColor
//
//              shadowLayer.shadowColor = UIColor.lightGray.cgColor
//              shadowLayer.shadowPath = shadowLayer.path
//            shadowLayer.shadowOffset = .zero//CGSize(width: 0.0, height: 1.0)
//            shadowLayer.shadowOpacity = 0.6
//              shadowLayer.shadowRadius = 3
//
//              backView.layer.insertSublayer(shadowLayer, at: 0)
//          }
//    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setUpData() {
        var titles = ""
        var shortDesc = ""
        if let userName = post?.username{
            if !userName.isEmpty{
                titles = userName
            }
        }
        
        if let desc = post?.itemDesc{
            if !desc.isEmpty{
                shortDesc += desc
            }
        }
        
        self.titleLabel.text = titles
        self.desc.text = shortDesc
        self.locationLabel.text = post?.city
        
        if appLanguage == "en" {
            self.titleLabel.textAlignment = .left
            self.desc.textAlignment = .left
            self.locationLabel.textAlignment = .left
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        } else {
            self.titleLabel.textAlignment = .right
            self.desc.textAlignment = .right
            self.locationLabel.textAlignment = .right
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }
        
        if let u = AppUtility.getSession() {
            if u.ID == post?.fromUserId{
                crossButton.isHidden = false
            } else {
                crossButton.isHidden = true
            }
        } else {
            crossButton.isHidden = true
        }
    }
    
    @IBAction func callAction(){
        if delegate != nil {
            self.delegate?.callAction(post: post)
        }
    }
    
    @IBAction func messageAction(){
        if delegate != nil {
            self.delegate?.messageAction(post: post)
        }
    }
    
    @IBAction func whatsAppAction(){
        if delegate != nil {
            self.delegate?.whatsAppAction(post: post)
        }
    }

    
    @IBAction func deletePost(){
        if delegate != nil {
            self.delegate?.deletePost(post: post)
        }
    }

    
}



protocol DeliveryCellDelegate {
    func whatsAppAction(post:Ad?)
    func messageAction(post:Ad?)
    func callAction(post:Ad?)
    
    func deletePost(post:Ad?)
}


//class ShadowView: UIView {
//    override var bounds: CGRect {
//        didSet {
//            setupShadow()
//        }
//    }
//
//    private func setupShadow() {
//        self.layer.cornerRadius = 8
//        self.layer.shadowOffset = CGSize(width: 0, height: 3)
//        self.layer.shadowRadius = 3
//        self.layer.shadowOpacity = 1.0
//        self.layer.shadowColor = UIColor.black.cgColor
//        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 8, height: 8)).cgPath
//        self.layer.shouldRasterize = true
//        self.layer.rasterizationScale = UIScreen.main.scale
//    }
//}


class ShadowView: UIView {

    var setupShadowDone: Bool = false
    
    public func setupShadow() {
        if setupShadowDone { return }
        print("Setup shadow!")
        self.layer.cornerRadius = 21
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowRadius = 2
        self.layer.shadowOpacity = 0.2
        self.layer.shadowColor = UIColor.darkGray.cgColor
//        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds,
//byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 8, height: 8)).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    
        setupShadowDone = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        print("Layout subviews!")
        setupShadow()
    }
}
