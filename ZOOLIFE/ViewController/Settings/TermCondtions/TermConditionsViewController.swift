//
//  TermConditionsViewController.swift
//  ZOOLIFE
//
//  Created by Hafiz Anser  on 11/29/20.
//  Copyright © 2020 Hafiz Anser. All rights reserved.
//

import UIKit
import PDFKit

class TermConditionsViewController: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var pdfView: PDFView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = true
        UIView.appearance().semanticContentAttribute = .forceRightToLeft
        var term = "bannedads"
        if appLanguage == "en" {
            lblTitle.localizeKey = "Banned Ads"
            term = "Eng_Terms_Policy"
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        } else {
            lblTitle.localizeKey = "السلع والإعلانات الممنوعة"
            term = "terms-condition-zoolife"
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }
        if let path = Bundle.main.path(forResource: term, ofType: "pdf") {
            if let pdfDocument = PDFDocument(url: URL(fileURLWithPath: path)) {
                pdfView.displayMode = .singlePageContinuous
                pdfView.autoScales = true
                pdfView.displayDirection = .vertical
                pdfView.document = pdfDocument
            }
        }
    }


    @IBAction func backTapped(_ sender: Any)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
