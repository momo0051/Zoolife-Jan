//
//  ContactUSViewController.swift
//  ComplexCuisines
//
//  Created by Hafiz Anser  on 6/11/20.
//  Copyright © 2020 Joe Singh. All rights reserved.
//

import UIKit

class ContactUSViewController: UIViewController
{

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
    }

    @IBAction func backTapped(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
}
