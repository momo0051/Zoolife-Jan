//
//  DisclaimerViewController.swift
//  ZOOLIFE
//
//  Created by Yousaf Shafiq on 18/01/2021.
//  Copyright © 2021 Hafiz Anser. All rights reserved.
//

import UIKit
import PDFKit

class DisclaimerViewController: UIViewController {
    
    @IBOutlet weak var btnNoAgree: UIButton!
    
    @IBOutlet weak var btnAgree: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var pdfView: PDFView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = true
      
        
        if let path = Bundle.main.path(forResource: "disclaimerNew", ofType: "pdf") {
            if let pdfDocument = PDFDocument(url: URL(fileURLWithPath: path)) {
                pdfView.displayMode = .singlePageContinuous
                pdfView.autoScales = true
                pdfView.displayDirection = .vertical
                pdfView.document = pdfDocument
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.UpdateLang_UI()
    }
    func UpdateLang_UI(){
        if let lang = UserDefaults.standard.object(forKey: "appLang") as? String {
            if lang == "en" {
                lblTitle.localizeKey = "Terms and Policy"
                btnAgree.localizeKey = "Agree"
                btnNoAgree.localizeKey = "Not Agree"
                UIView.appearance().semanticContentAttribute = .forceLeftToRight
            } else {
                lblTitle.localizeKey = "السياسة والشروط"
                btnAgree.localizeKey = "موافق"
                btnNoAgree.localizeKey = "غير موافق"
                UIView.appearance().semanticContentAttribute = .forceRightToLeft
            }
        } else {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }
    }
    
    @IBAction func acceptDisclaimer(){
        
        if let u = AppUtility.getSession() {
            if let user_id = u.ID{
                aceptDisclaimer(userId: user_id,viewController:self)
            }
        }
    }
    
    
    @IBAction func rejectDisclaimer(){
        
        self.dismiss(animated: true, completion: nil)
        
    }

}



