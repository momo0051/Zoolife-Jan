//
//  ArticleDetailViewController.swift
//  ZOOLIFE
//
//  Created by Muhammad Yousaf on 21/12/2020.
//  Copyright © 2020 Hafiz Anser. All rights reserved.
//

import ImageSlideshow
import UIKit
import SDWebImage
import Kingfisher

class ArticleDetailViewController: UIViewController {
    
    var article:Articles?
    
    
    
    @IBOutlet weak var dateArticle:UILabel!
    @IBOutlet weak var articleTitleLabel:UILabel!
    @IBOutlet weak var articleDescriptionTextView:UITextView!
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    @IBOutlet var slideshow: ImageSlideshow!
    
    var images : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        for item in slideshow.slideshowItems{
//            
//          //  item.imageViewWrapper.addShadow(shadowColor: .black, offSet: .zero, opacity: 1.0, shadowRadius: 1, cornerRadius: 8, corners: .allCorners)
//        }
        
        
//        slideshow.addShadow(shadowColor: .darkGray, offSet: .zero, opacity: 1.0, shadowRadius: 3, cornerRadius: 8, corners: .allCorners)
   //     slideshow.slideshowItems//.ima
        
        slideshow.scrollView.layer.cornerRadius = 35
        slideshow.scrollView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
//
//        //slideshow.layer.cornerRadius = 8
////        slideshow.layer.masksToBounds = true
        slideshow.scrollView.clipsToBounds = true
        
        slideshow.clipsToBounds = true
        slideshow.layer.cornerRadius = 35
        slideshow.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        
//        slideshow.scrollView.layer.shadowColor = UIColor.black.cgColor
//        slideshow.scrollView.layer.shadowOpacity = 1
//        slideshow.scrollView.layer.shadowOffset = CGSize(width: 3, height: 3)
//        slideshow.scrollView.layer.shadowRadius = 10
//
//        slideshow.scrollView.layer.shadowPath = UIBezierPath(rect: slideshow.scrollView.bounds).cgPath
//
//        slideshow.layer.shouldRasterize = true
//
//        slideshow.layer.rasterizationScale = UIScreen.main.scale
//
        if let article = self.article{
            
            
            dateArticle.text = article.date
            articleTitleLabel.text = article.title
            
            articleDescriptionTextView.text = article.articleDescription
            articleDescriptionTextView.textAlignment = NSTextAlignment.right
         
            var sdWebImageSource = [SDWebImageSource]()
            
            if let image = article.image1{
                if !image.isEmpty{
                    sdWebImageSource.append(SDWebImageSource(urlString: image)!)
                }
            }
            if let image = article.image2{
                if !image.isEmpty{
                    sdWebImageSource.append(SDWebImageSource(urlString: image)!)
                }
            }
            if let image = article.image3{
                if !image.isEmpty{
                    sdWebImageSource.append(SDWebImageSource(urlString: image)!)
                }
            }
            
            slideshow.slideshowInterval = 5.0
            slideshow.pageIndicatorPosition = .init(horizontal: .center, vertical: .under)
            slideshow.contentScaleMode = UIViewContentMode.scaleToFill
            
            let pageControl = UIPageControl()
            pageControl.currentPageIndicatorTintColor = UIColor.lightGray
            pageControl.pageIndicatorTintColor = UIColor.black
            slideshow.pageIndicator = pageControl
            
            // optional way to show activity indicator during image load (skipping the line will show no activity indicator)
            slideshow.activityIndicator = DefaultActivityIndicator()
            slideshow.delegate = self
            
//            imageViewWrapper.layer.cornerRadius = 8
            for slide in slideshow.slideshowItems{
//                slide.imageViewWrapper.layer.cornerRadius = 8
            }
            slideshow.setImageInputs(sdWebImageSource)
            
            
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(ArticleDetailViewController.didTap))
            slideshow.addGestureRecognizer(recognizer)
        }
        
    }

    @objc func didTap() {
        let fullScreenController = slideshow.presentFullScreenController(from: self)
        // set the activity indicator for full screen controller (skipping the line will show no activity indicator)
        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
    }
    
    @IBAction func backTapped(_ sender: Any){
        _ = self.navigationController?.popViewController(animated: true)
    }
}



extension ArticleDetailViewController: ImageSlideshowDelegate {
    func imageSlideshow(_ imageSlideshow: ImageSlideshow, didChangeCurrentPageTo page: Int) {
//        print("current page:", page)
    }
}



import UIKit

extension UIView {

    func addShadow(shadowColor: UIColor, offSet: CGSize, opacity: Float, shadowRadius: CGFloat, cornerRadius: CGFloat, corners: UIRectCorner, fillColor: UIColor = .white) {

        let shadowLayer = CAShapeLayer()
        let size = CGSize(width: cornerRadius, height: cornerRadius)
        let cgPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: size).cgPath //1
        layer.masksToBounds = false
        shadowLayer.path = cgPath //2
        shadowLayer.fillColor = fillColor.cgColor
        shadowLayer.shadowColor = shadowColor.cgColor
        shadowLayer.shadowPath = cgPath
        shadowLayer.shadowOffset = offSet
        shadowLayer.shadowOpacity = opacity
        shadowLayer.shadowRadius = shadowRadius

        self.layer.insertSublayer(shadowLayer, at: 0)
    }
}


//extension UIScrollView {
//
//    @objc @objc func addShadow(shadowColor: UIColor, offSet: CGSize, opacity: Float, shadowRadius: CGFloat, cornerRadius: CGFloat, corners: UIRectCorner, fillColor: UIColor = .white) {
//
//        let shadowLayer = CAShapeLayer()
//        let size = CGSize(width: cornerRadius, height: cornerRadius)
//        let cgPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: size).cgPath //1
//        layer.masksToBounds = false
//        shadowLayer.path = cgPath //2
//        shadowLayer.fillColor = fillColor.cgColor //3
//        shadowLayer.shadowColor = shadowColor.cgColor //4
//        shadowLayer.shadowPath = cgPath
//        shadowLayer.shadowOffset = offSet //5
//        shadowLayer.shadowOpacity = opacity
//        shadowLayer.shadowRadius = shadowRadius
//        //self.layer.addSublayer(shadowLayer)
////        self.layer.backgroundColor
////        self.send
//
//        self.layer.insertSublayer(shadowLayer, at: 0)
//    }
//}


extension UIImageView {
    func applyshadowWithCorner(containerView : UIView, cornerRadious : CGFloat){
        self.clipsToBounds = true
        self.layer.cornerRadius = cornerRadious
        containerView.clipsToBounds = false
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        containerView.layer.shadowOpacity = 0.5
        containerView.layer.shadowRadius = 1.0
        containerView.layer.masksToBounds = false
        containerView.layer.shadowPath = UIBezierPath(roundedRect: containerView.bounds, cornerRadius: cornerRadious).cgPath
        containerView.layer.cornerRadius = cornerRadious
        
        print(containerView.bounds,"Boundss")
        
        //containerView.b
        
        
//        let radius: CGFloat = 8
//        contentView.layer.cornerRadius = radius
//        contentView.layer.borderWidth = 1
//        contentView.layer.borderColor = UIColor.clear.cgColor
//        contentView.layer.masksToBounds = true
//    
//        layer.shadowColor = UIColor.black.cgColor
//        layer.shadowOffset = CGSize(width: 0, height: 1.0)
//        layer.shadowRadius = 2.0
//        layer.shadowOpacity = 0.5
//        layer.masksToBounds = false
//        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: radius).cgPath
//        layer.cornerRadius = radius
//        
//        
    }
}
extension UITextView {
    func hyperLink(originalText: String, hyperLink: String, urlString: String) {
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        let attributedOriginalText = NSMutableAttributedString(string: originalText)
        let linkRange = attributedOriginalText.mutableString.range(of: hyperLink)
        let fullRange = NSMakeRange(0, attributedOriginalText.length)
        attributedOriginalText.addAttribute(NSAttributedString.Key.link, value: urlString, range: linkRange)
        attributedOriginalText.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: fullRange)
        attributedOriginalText.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 10), range: fullRange)
        self.linkTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.green,
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
        ]
        self.attributedText = attributedOriginalText
    }
}
