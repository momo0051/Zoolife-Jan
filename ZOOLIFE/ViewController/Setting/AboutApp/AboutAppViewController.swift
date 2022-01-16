//
//  AboutAppViewController.swift
//  ClientOnBoarding
//
//  Created by Hafiz Anser  on 1/22/20.
//  Copyright © 2020 com.JoeSingh. All rights reserved.
//

import UIKit

class AboutAppViewController: UIViewController, UITextViewDelegate
{

    @IBOutlet weak var tvAbout: UITextView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        tvAbout.dataDetectorTypes = .link
        
//        let attributedString = NSMutableAttributedString(string: "This app is brought to you by the United African Foundation. Go to: www.unitedafricanfoundation.org to learn more")
//        attributedString.addAttribute(.link, value: "https://www.hackingwithswift.com", range: NSRange(location: 12, length: 55))
//
//        tvAbout.attributedText = attributedString
        
    }

    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool
    {
        UIApplication.shared.open(URL)
        return false
    }
    
    //MARK: - Button Actions
    @IBAction func backTapped(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
}

extension UITextView {

  func addHyperLinksToText(originalText: String, hyperLinks: [String: String]) {
    let style = NSMutableParagraphStyle()
    style.alignment = .left
    let attributedOriginalText = NSMutableAttributedString(string: originalText)
    for (hyperLink, urlString) in hyperLinks {
        let linkRange = attributedOriginalText.mutableString.range(of: hyperLink)
        let fullRange = NSRange(location: 0, length: attributedOriginalText.length)
        attributedOriginalText.addAttribute(NSAttributedString.Key.link, value: urlString, range: linkRange)
        attributedOriginalText.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: fullRange)
        //attributedOriginalText.addAttribute(NSAttributedString.Key.font, value: YourFont, range: fullRange)
    }

    self.linkTextAttributes = [
        //NSAttributedString.Key.foregroundColor: YourColor,
        NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
    ]
    self.attributedText = attributedOriginalText
  }
}
