//
//  SignupViewController.swift
//  ZOOLIFE
//
//  Created by Hafiz Anser  on 11/24/20.
//  Copyright © 2020 Hafiz Anser. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class SignupViewController: UIViewController {
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblConfPass: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblHeaderLine3: UILabel!
    @IBOutlet weak var lblHeaderLine2: UILabel!
    @IBOutlet weak var lblHeaderLine1: UILabel!
    @IBOutlet weak var tfFullName: UITextField!
    @IBOutlet weak var tfPhonenumber: UITextField! {
        didSet{
            tfPhonenumber.keyboardType = .phonePad
        }
    }
    @IBOutlet weak var tfUserName: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = true
        
        
        self.tfFullName.textAlignment = NSTextAlignment.right
        self.tfPhonenumber.textAlignment = NSTextAlignment.right
        self.tfUserName.textAlignment = NSTextAlignment.right
        self.tfPassword.textAlignment = NSTextAlignment.right
    }
    override func viewWillAppear(_ animated: Bool) {
        UpdateLang_UI()
    }
    
    //MARK: - Bution Actions
    func UpdateLang_UI(){
        if let lang = UserDefaults.standard.object(forKey: "appLang") as? String {
            if lang == "en" {
                self.tfFullName.textAlignment = NSTextAlignment.left
                self.tfPhonenumber.textAlignment = NSTextAlignment.left
                self.tfUserName.textAlignment = NSTextAlignment.left
                self.tfPassword.textAlignment = NSTextAlignment.left
                lblUsername.localizeKey = "User Name:"
                UIView.appearance().semanticContentAttribute = .forceLeftToRight
            } else {
                lblUsername.localizeKey = "اسم االمستخدم"
                UIView.appearance().semanticContentAttribute = .forceRightToLeft
            }
        } else {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }
        lblHeaderLine1.text = loc.signUp_Header1.localized()
        lblHeaderLine2.text = loc.signUp_Header2.localized()
        lblHeaderLine3.text = loc.signUp_Header3.localized()
        lblEmail.text = loc.yourEmail.localized()
        
        lblConfPass.text = loc.password.localized()
        btnNext.setTitle("\(loc.next.localized())", for: UIControl.State.normal)
        btnLogin.setTitle("\(loc.signUp_Login.localized())", for: UIControl.State.normal)
        btnLogin.semanticContentAttribute  = .unspecified
    }
    @IBAction func backTapped(_ sender: Any)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    @IBAction func signupTapped(_ sender: Any)
    {
        if checkFields()
        {
            SignUp()
        }
    }
    @IBAction func loginTapped(_ sender: Any)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    //00966 550655213
    
    //MARK: - Funtions
    
    func checkFields() -> Bool
    {
//        if (tfFullName.text?.trimmingCharacters(in: .whitespaces).isEmpty)!
//        {
//            let alert = UIAlertController(title: "", message: "من فضلك ادخل اسمك الكامل", preferredStyle: UIAlertController.Style.alert)
//            alert.addAction(UIAlertAction(title: Okey(), style: UIAlertAction.Style.default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//
//            let test = false
//            return test
//        }
        
//        else
        if (tfPhonenumber.text?.trimmingCharacters(in: .whitespaces).isEmpty)!
        {
            let alert = UIAlertController(title: "", message: loc.enterPhone.localized(), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: Okey(), style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            let test = false
            return test
        }
        else if (tfPhonenumber.text?.count ?? 0 < 9){
            let alert = UIAlertController(title: "", message: loc.enterPhoneatLeast9Char.localized(), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: Okey(), style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            let test = false
            return test
        }
        
        
        if (tfUserName.text?.trimmingCharacters(in: .whitespaces).isEmpty)!{
            let alert = UIAlertController(title: "", message: loc.enterUsername.localized(), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: Okey(), style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            let test = false
            return test
        }
        
//        else if !(AppUtility.isValidEmail(testStr:tfUserName.text!)){
//            let alert = UIAlertController(title: "", message: "الرجاء إدخال البريد الإلكتروني الصحيح", preferredStyle: UIAlertController.Style.alert)
//            alert.addAction(UIAlertAction(title: Okey(), style: UIAlertAction.Style.default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//
//            let test = false
//            return test
//        }
        
        else if (tfPassword.text?.trimmingCharacters(in: .whitespaces).isEmpty)!
        {
            let alert = UIAlertController(title: "", message: loc.enterPassword.localized(), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: Okey(), style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            let test = false
            return test
        }
        let test = true
        return test
    }
    func SignUp ()
    {
        AppUtility.showProgress()
        let requestURL = URL(string: SIGNUP_URL)!
        print(requestURL)
        

        let headers = ["Content-Type": "application/json","X-Localization":"\(appLanguage)"]
//        if tfUserName.text! == ""
//        {
//
//        }
        
       // "phone":tfPhonenumber.text!,
        
        let paramDict = ["username":tfUserName.text!,
                         "password":tfPassword.text!,
                         "phone":tfPhonenumber.text!] as [String : Any]
        print(paramDict)
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in paramDict
            {
                multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
            }
        },            usingThreshold:UInt64.init(),
            to: requestURL ,
            method:.post,
            headers:headers,
            encodingCompletion: { encodingResult in

                switch encodingResult {
                case .success(let upload, _, _):

                    upload.responseJSON { response in

                        print("response JSON: '\(response)'")

                        if((response.result.value) != nil)
                        {
                            let swiftyJsonVar = JSON(response.result.value!)
                            print(swiftyJsonVar)

                            let dict = swiftyJsonVar.dictionaryValue
                            let message = dict["message"]?.string
                            let error = dict["error"]?.bool
                            let otp = dict["otp"]?.int
                            
                            AppUtility.hideProgress()
                            
                            if error == false
                            {

                                
                                let alert = UIAlertController(title:"Zoolife" , message:message, preferredStyle: UIAlertController.Style.alert)
                                
                                alert.addAction(UIAlertAction(title: Okey(), style: .default, handler: { (action: UIAlertAction!) in
   
                                    let viewController = MobileVerificationViewController()
                                    viewController.isComingFrom = "Singup"
                                    viewController.otp = String(otp ?? 0) 
                                    viewController.userName = self.tfUserName.text!
                                    viewController.phoneNumber = self.tfPhonenumber.text!
                                    self.navigationController?.pushViewController(viewController, animated: true)
                                    
                                }))
                                self.present(alert, animated: true, completion: nil)
                                
                                
                                return
                            }
                            else
                            {
                                let alert = UIAlertController(title: "Zoolife", message:message, preferredStyle: UIAlertController.Style.alert)
                                alert.addAction(UIAlertAction(title: Okey(), style: UIAlertAction.Style.default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                        else
                        {
                            AppUtility.hideProgress()
                            let result = response.result
                            print("response JSON: '\(result)'")
                            //let userInfo = response.error as? Error
                            let error = response.error

                            let alert = UIAlertController(title: "Zoolife", message:error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: Okey(), style: UIAlertAction.Style.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                case .failure(let encodingError):
                    AppUtility.hideProgress()
                    print(encodingError)
                    let alert = UIAlertController(title: "Zoolife", message:encodingError.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title:  Okey(), style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
        })
    }

}
