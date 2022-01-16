//
//  SettingsViewController.swift
//  ZOOLIFE
//
//  Created by Hafiz Anser  on 11/20/20.
//  Copyright © 2020 Hafiz Anser. All rights reserved.
//

import UIKit
import Localize_Swift

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    @IBOutlet weak var tblSettings: UITableView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var lblVersion:UILabel!
    
    @IBOutlet weak var btnEngLang: UIButton!
    @IBOutlet weak var btnArLang: UIButton!
    var arrDataObjects = [SettingTitle]()
//    var arrTitles = ["أضف إعلان","المفضلة","إعلاناتي","تغير المدينة","طلب توصيل / نقل","طلب بيطرة","بلاغ مفقود"," السلع والإعلانات الممنوعة ","القائمة السوداء"," السياسة والشروط "," اتصل بنا ","تسجيل خروج"]
    
//    var arrTitles = ["أضف إعلان","المفضلة","إعلاناتي","طلب توصيل / نقل","طلب بيطرة","بلاغ مفقود"," السلع والإعلانات الممنوعة "," السياسة والشروط "," اتصل بنا ","تسجيل خروج"]
    
    var arrTitles = ["أضف إعلان","إعلاناتي","طلب توصيل / نقل"," السلع والإعلانات الممنوعة "," السياسة والشروط "," اتصل بنا ","تسجيل خروج"]
    
    
    
    var cityName = ""
    
    var arrImages = ["ic_add-1","ic_heart","ic_user-1","ic_add-1","ic_user-1","shopping_bag","alert","tandc","callus","ic_logout"]
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
    
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 41
        contentView.layer.maskedCorners = [.layerMinXMinYCorner]
//        if UserDefaults.standard.bool(forKey: "isLogin") == false
//        {
//            let viewController = LoginViewController()
//            viewController.hidesBottomBarWhenPushed = true
//            self.navigationController?.pushViewController(viewController, animated: true)
//        }
        
        

//        tableViewHeightConstraint.constant = CGFloat(arrDataObjects.count*74)
//        tableViewAddedLanguages.reloadData()
        
       

    }
    override func viewWillAppear(_ animated: Bool) {
        self.UpdateUI()
    }
    // MARK: - Custome functions
    func UpdateLang(){
        if let lang = UserDefaults.standard.object(forKey: "appLang") as? String {
            let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
            
            if lang == "en" {
                           arrTitles = ["Add New Post","Favorites","My Posts","Add Auction Post","My Auction","Delivery Post","Banned Ads","Terms And Policy","Contact Us","Log Out"]
                           lblVersion.localizeKey = "Version: " + (appVersion ?? "")
                       } else {
                        arrTitles = [
                                                                          "أضف إعلان"
                                                                                      ,"المفضلة"
                                                                                      ,"إعلاناتي",
                                                                         "إضافة اعلان للمزاد" ,
                                                                         "المزاد الخاص بي ",
                                                                         "طلب توصيل / نقل ",
                                                                         "السلع والإعلانات الممنوعة",
                                                                         " السياسة والشروط ",
                                                                         " اتصل بنا ",
                                                                         "تسجيل خروج"]
                        
                        
                        
                        lblVersion.localizeKey = "رقم الاصدار: " + (appVersion ?? "")
                       }
                       
                       
        } else {
            arrTitles =  ["أضف إعلان","المفضلة","إعلاناتي","طلب توصيل / نقل","المزاد الخاص بي"," السلع والإعلانات الممنوعة ","مزاد علني","أضف إعلان المزاد"," السياسة والشروط "," اتصل بنا ","تسجيل خروج"]
        }
    }
    func deactivateRTL(of view: UIView) {
        // 1. code here do something with view
        for subview in view.subviews {
            if let lang = UserDefaults.standard.object(forKey: "appLang") as? String {
                if lang == "en" {
                    subview.semanticContentAttribute = .forceLeftToRight
                } else {
                    subview.semanticContentAttribute = .forceRightToLeft
                }
            } else {
                subview.semanticContentAttribute = .forceRightToLeft
            }
            deactivateRTL(of: subview)
        }
    }
    func UpdateUI() {
        if let lang = UserDefaults.standard.object(forKey: "appLang") as? String {
            if lang == "en" {
                btnEngLang.backgroundColor = app_theme_color_dark
                btnArLang.backgroundColor = UIColor.clear
                UIView.appearance().semanticContentAttribute = .forceLeftToRight
            } else {
                btnEngLang.backgroundColor = UIColor.clear
                btnArLang.backgroundColor = app_theme_color_dark
                UIView.appearance().semanticContentAttribute = .forceRightToLeft
            }
        } else {
            btnEngLang.backgroundColor = UIColor.clear
            btnArLang.backgroundColor = app_theme_color_dark
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }
        self.tblSettings.reloadData()
        self.deactivateRTL(of: self.view)
        self.UpdateLang()
    }
    func ApplyLangueageLoacalisation(){
        
    }
    
    // MARK: - Button click events
    @IBAction func btnEng_Lang_Click(_ sender: Any) {
        UserDefaults.standard.setValue("en", forKey: "appLang")
        UserDefaults.standard.synchronize()
        btnEngLang.backgroundColor = app_theme_color_dark
        btnArLang.backgroundColor = UIColor.clear
        self.UpdateUI()
        Localize.setCurrentLanguage("en")
        appLanguage = "en"
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadTabbar"), object: nil, userInfo: nil)
    }
    
    @IBAction func tbnAr_Lang_Click(_ sender: Any) {
        UserDefaults.standard.setValue("ar", forKey: "appLang")
        UserDefaults.standard.synchronize()
        btnEngLang.backgroundColor = UIColor.clear
        btnArLang.backgroundColor = app_theme_color_dark
        self.UpdateUI()
        Localize.setCurrentLanguage("ar")
        appLanguage = "ar"
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadTabbar"), object: nil, userInfo: nil)
    }
    
    @IBAction func didBackTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - TableView Delegate
     func numberOfSections(in tableView: UITableView) -> Int
     {
        return 1
     }
     
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
     {
        return arrTitles.count
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
     {
        tableView.register(UINib(nibName: "SettingCell", bundle: nil), forCellReuseIdentifier: "SettingCell")
        var cell: SettingCell! = tableView.dequeueReusableCell(withIdentifier: "SettingCell") as? SettingCell
        if (cell == nil)
        {
            cell = SettingCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: "SettingCell")
        }
        
        let obj = arrTitles[indexPath.row]
        cell.lblTititle.text = obj
        if indexPath.row == arrTitles.count - 1
        {
            if  UserDefaults.standard.bool(forKey: "isLogin") == false
            {
                if let lang = UserDefaults.standard.object(forKey: "appLang") as? String {
                    if lang == "en" {
                        cell.lblTititle.text = "Log In"
                    } else {
                        cell.lblTititle.text = "تسجيل دخول "
                    }
                } else {
                    cell.lblTititle.text = "تسجيل دخول "
                }
            }
        }
        
        cell.imgIcon.image = UIImage(named: arrImages[indexPath.row])

        cell.selectionStyle = .none

        return cell
     }
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
     {
        return 65
     }
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
     {
        let indexpath = indexPath.row
//        else if indexpath == 5{
//            let viewController = MissingPostViewController()
//            viewController.hidesBottomBarWhenPushed = true
//            self.navigationController?.pushViewController(viewController, animated: true)
//            return
//        }
        if indexpath == 6
        {
            let viewController = BandAdViewController()
            viewController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(viewController, animated: true)
            return
        }
 
        else if indexpath == 7 {
            let viewController = TermConditionsViewController()
            viewController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(viewController, animated: true)
            return
        } else if indexpath == 8{
            let viewController = CallUsViewController()
            viewController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(viewController, animated: true)
            return
        }
         
        if UserDefaults.standard.bool(forKey: "isLogin") == false{
            appDelegate.loadLogin()
        }
        else
        {
            if indexpath == 0
            {
                let viewController = AddAdViewController()
                viewController.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(viewController, animated: true)
            }
            else if indexpath == 1
            {
                let viewController = MyFavouriteViewController()
                viewController.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(viewController, animated: true)
            }
            else if indexpath == 2
            {
                let viewController = MyAdsViewController()
                viewController.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(viewController, animated: true)
            }
            else if indexpath == 3
            {
                let viewController = AddAuctionViewController()
                viewController.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(viewController, animated: true)
            }
//            else if indexpath == 4
//            {
//                let viewController = AuctionListViewController()
//                viewController.hidesBottomBarWhenPushed = true
//                self.navigationController?.pushViewController(viewController, animated: true)
//            }
            else if indexpath == 4
            {
                let viewController = MyAuctionListVC()
                viewController.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(viewController, animated: true)
            }
            else if indexpath == 5
            {
                let viewController = DeliveryPostViewController ()
                viewController.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(viewController, animated: true)
//                
//                let alert = UIAlertController(title: "انتظار", message:"في الإصدار التالي ، سنضيف هذه الميزة.", preferredStyle: UIAlertController.Style.alert)
//                alert.addAction(UIAlertAction(title: Okey(), style: UIAlertAction.Style.default, handler: nil))
//                self.present(alert, animated: true, completion: nil)
            }
//            else if indexpath == 4
//            {
//                let alert = UIAlertController(title: "انتظار", message:"في الإصدار التالي ، سنضيف هذه الميزة.", preferredStyle: UIAlertController.Style.alert)
//                alert.addAction(UIAlertAction(title: Okey(), style: UIAlertAction.Style.default, handler: nil))
//                self.present(alert, animated: true, completion: nil)
//            }
//            else if indexpath == 5{
//                let viewController = MissingPostViewController()
//                viewController.hidesBottomBarWhenPushed = true
//                self.navigationController?.pushViewController(viewController, animated: true)
//
//            }
            else if indexpath == 6
            {
                let viewController = BandAdViewController()
                viewController.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(viewController, animated: true)
            }
//            else if indexpath == 8
//            {
//                let alert = UIAlertController(title: "انتظار", message:"في الإصدار التالي ، سنضيف هذه الميزة.", preferredStyle: UIAlertController.Style.alert)
//                alert.addAction(UIAlertAction(title: Okey(), style: UIAlertAction.Style.default, handler: nil))
//                self.present(alert, animated: true, completion: nil)
//            }
            
            
            else if indexpath == 7
            {
                let viewController = TermConditionsViewController()
                viewController.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(viewController, animated: true)
            }
            else if indexpath == 8
            {
                let viewController = CallUsViewController()
                viewController.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(viewController, animated: true)
//                let viewController = EditProfileViewController()
//                self.navigationController?.pushViewController(viewController, animated: true)
            }
            else if indexpath == 9
            {
                var word = "هل تريد تسجيل الخروج ؟"
                if appLanguage == "en" {
                    word = "Do you want to log out?"
                }
                let alert = UIAlertController(title: "", message: word, preferredStyle: UIAlertController.Style.alert)
                
                alert.addAction(UIAlertAction(title: Okey(), style: .destructive, handler: { (action: UIAlertAction!) in
                    self.dismiss(animated: false, completion: nil)

                    //UserDefaults.standard.set(nil, forKey: "isEmailHide")

                    UserDefaults.standard.set(nil, forKey: "isLogin")
                    
                    UserDefaults.standard.set(nil, forKey: "USER_LOGIN")
                                        
                    AppUtility.saveUserSession(u: nil)
                    //AppUtility.getSession()
                    appDelegate.loadLogin()
                    
                    
                }))
                var words = "إلغاء"
                if appLanguage == "en" {
                    words = "Cancel"
                }
                alert.addAction(UIAlertAction(title: words, style: .default, handler: { (action: UIAlertAction!) in
                }))
                present(alert, animated: true, completion: nil)
            }
            

        }
        
     }

}
