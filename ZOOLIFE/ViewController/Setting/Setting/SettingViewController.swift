//
//  SettingViewController.swift
//  ComplexCuisines
//
//  Created by Hafiz Anser  on 6/2/20.
//  Copyright © 2020 Joe Singh. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController
{
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var btnAbout: UIButton!
    @IBOutlet weak var btnContactUs: UIButton!
    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet weak var btnPrivacy: UIButton!
    
    
    @IBOutlet weak var lblComplexApartmentInformation: UILabel!
    
    //let modelName = UIDevice.modelName
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
//        if UserDefaults.standard.bool(forKey: "isLogin") == false
//        {
//            let viewController = LoginViewController()
//            viewController.hidesBottomBarWhenPushed = true
//            self.navigationController?.pushViewController(viewController, animated: true)
//        }
        
        //setupUI()
//        if modelName.contains("iPad")
//        {
//            lblHeader.font = lblHeader.font.withSize(30)
//            btnAbout.titleLabel?.font =  UIFont(name: "Muli", size: 25)
//            btnContactUs.titleLabel?.font =  UIFont(name: "Muli", size: 25)
//            btnLogout.titleLabel?.font =  UIFont(name: "Muli", size: 25)
//            btnPrivacy.titleLabel?.font =  UIFont(name: "Muli", size: 25)
//        }
    }
    
    
    //MARK: - Funtions
//    func setupUI()
//    {
//        let complexName =  USER_DEAULTS.string(forKey: "ComplexName")
//        let complexNumer =  USER_DEAULTS.string(forKey: "ComplexUserName")
//        let apartmentNumber = USER_DEAULTS.string(forKey: "appartmentNumber")
//        lblComplexApartmentInformation.text = "Your complex name \(complexName!), user name \(complexNumer!) and aprartment number \(apartmentNumber!)."
//    }
    //MARK: Button Action
    @IBAction func aboutTapped(_ sender: Any)
    {
        let viewController = AboutAppViewController()
        self.present(viewController, animated: true, completion: nil)
    }
    
    @IBAction func policyTapped(_ sender: Any)
    {
        
        let viewController = PrivacyViewController()
        self.present(viewController, animated: true, completion: nil)
        
//        guard let url = URL(string: "https://www.privacypolicygenerator.info/live.php?token=inLcI7Md5dmjdFQ6WJnSy7qsQ4ruj625") else { return }
//        UIApplication.shared.open(url)
    }
    @IBAction func logoutTapped(_ sender: Any)
    {
        let alert = UIAlertController(title: "", message: loc.LogoutMessage.localized(), preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: Okey(), style: .default, handler: { (action: UIAlertAction!) in
            self.dismiss(animated: false, completion: nil)
//            UserDefaults.standard.set(nil, forKey: "ComplexUserName")
            
            //appDelegate.loadLogin()
        }))
        
        alert.addAction(UIAlertAction(title: Cancel(), style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func backTapped(_ sender: Any)
    {
        _ = self.navigationController?.popViewController(animated: true)
//        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func contactUSTapped(_ sender: Any)
    {
        let viewController = ContactUSViewController()
        self.present(viewController, animated: true, completion: nil)
    }
    @IBAction func changePasswordTapped(_ sender: Any)
    {
        let viewController = ChangePasswordViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
