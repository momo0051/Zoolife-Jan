//
//  PrivacyViewController.swift
//  mo
//
//  Created by Hafiz Anser on 9/26/19.
//  Copyright © 2019 com.HafizAnser. All rights reserved.
//

import UIKit

class PrivacyViewController: UIViewController {
    @IBOutlet weak var tvDescription: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
         self.navigationController?.isNavigationBarHidden = true
    }
    
    //MARK: - Button Actions
    @IBAction func crossTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
