//
//  LoginViewController.swift
//  ZOOLIFE
//
//  Created by Hafiz Anser  on 11/24/20.
//  Copyright © 2020 Hafiz Anser. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class LoginViewController: UIViewController {

    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnForgotPass: UIButton!
    
    @IBOutlet weak var lblPassCaption: UILabel!
    @IBOutlet weak var lblLoginCalption: UILabel!
    @IBOutlet weak var lblHeaderLine2: UILabel!
    @IBOutlet weak var lblHeaderLine1: UILabel!
    @IBOutlet weak var lblHiThere: UILabel!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = true
        UIView.appearance().semanticContentAttribute = .forceRightToLeft
      
        //self.parentViewOfTextF.semanticContentAttribute = UISemanticContentAttribute.forceRightToLeft
    }
    override func viewWillAppear(_ animated: Bool) {
        self.UpdateLang_UI()
    }
    
    //MARK: - Custome Functions
    func UpdateLang_UI(){
        self.tfEmail.textAlignment = NSTextAlignment.right
        self.tfPassword.textAlignment = NSTextAlignment.right
        if let lang = UserDefaults.standard.object(forKey: "appLang") as? String {
            if lang == "en" {
                self.tfEmail.textAlignment = NSTextAlignment.left
                self.tfPassword.textAlignment = NSTextAlignment.left
                UIView.appearance().semanticContentAttribute = .forceLeftToRight
            } else {
                UIView.appearance().semanticContentAttribute = .forceRightToLeft
            }
        } else {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }
        lblHiThere.text = loc.welcome.localized()
        lblHeaderLine1.text = loc.loginHeader1.localized()
        lblHeaderLine2.text = loc.loginHeader2.localized()
        lblLoginCalption.text = loc.yourEmail.localized()
        lblPassCaption.text = loc.password.localized()
        btnForgotPass.setTitle("\(loc.forgotPass.localized())", for: UIControl.State.normal)
        btnSubmit.setTitle("\(loc.submit.localized())", for: UIControl.State.normal)
        btnSignUp.setTitle("\(loc.signUp.localized())", for: UIControl.State.normal)
        
    }
    //MARK: - Button Actions
    @IBAction func loginTapped(_ sender: Any) {
        if CheckFields() {
            self.view.endEditing(true)
            login()
        }
    }
    @IBAction func signupTapped(_ sender: Any)
    {
        let viewController = SignupViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    @IBAction func forgotPasswordTapped(_ sender: Any)
    {
        let viewController = ForgotPasswordViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func crossTapped(_ sender: Any)
    {
        appDelegate.loadTabbar()
    }
    
    //MARK: - Functions
    func CheckFields() -> Bool
    {
        if (tfEmail.text?.trimmingCharacters(in: .whitespaces).isEmpty)!{
            
            
            let alert = UIAlertController(title: "", message: loc.enterPhone.localized(), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: Okey(), style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            let test = false
            return test
        }
        else if (tfPassword.text?.trimmingCharacters(in: .whitespaces).isEmpty)!{
            
            let alert = UIAlertController(title: "", message: loc.enterPassword.localized(), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: Okey(), style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            let test = false
            return test
        }
        
        let test = true
        return test
    }
    
    func login()
    {
        AppUtility.showProgress()
        let requestURL = URL(string: LOGIN_URL)!
        

        print(requestURL)
        let headers = ["Content-Type": "application/json","X-Localization":"\(appLanguage)"]
        let paramDict = ["phone":tfEmail.text!,
                         "password":tfPassword.text!] as [String : Any]
        
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
                            
                            AppUtility.hideProgress()
                            
                            if error == false
                            {
                                let result: Dictionary<String, JSON> = swiftyJsonVar["data"].dictionaryValue
                                //let userDict = result["data"]?.dictionaryValue

                                let u = User.init(withDictionary: result)
                                
                                AppUtility.saveUserSession(u: u)
                                UserDefaults.standard.set(true, forKey: "isLogin")
                                UserDefaults.standard.setValue(true, forKey: "isLogin")
                                
//                                let user:User = AppUtility.getSession()
                                var user: User
                                
                                if let u = AppUtility.getSession() {
                                    user = u
                                }else{
                                    return
                                }
                                let token = UserDefaults.standard.object(forKey: "DEVICE_TOKEN")
                                if let u = AppUtility.getSession() {

                                    let requestURL = URL(string: UPDATE_USER_DEVICE_TOKEN)!
                                    print(requestURL)

                                    let headers = ["Content-Type": "application/json","X-Localization":"\(appLanguage)"]

                                    let  paramDict = ["device_token" : token ?? "",
                                                      "device_type" : "iOS",
                                                      "user_id":u.ID!] as [String : Any]


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
                                                    appDelegate.loadTabbar()
//                                                    let alert = UIAlertController(title:"Zoolife" , message:loc.accountCreated.localized(), preferredStyle: UIAlertController.Style.alert)
//
//                                                    alert.addAction(UIAlertAction(title: Okey(), style: .default, handler: { (action: UIAlertAction!) in
//
//                                                        appDelegate.loadTabbar()
//
//                                                    }))
//                                                    self.present(alert, animated: true, completion: nil)0550655213
                                                                                                        //1234

                                                }
                                            case .failure(_):
                                                let alert = UIAlertController(title:"Zoolife" , message:loc.accountCreated.localized(), preferredStyle: UIAlertController.Style.alert)

                                                alert.addAction(UIAlertAction(title: Okey(), style: .default, handler: { (action: UIAlertAction!) in

                                                    appDelegate.loadTabbar()

                                                }))
                                                //
//                                                appDelegate.loadTabbar()
                                                                                                    
                                                self.present(alert, animated: true, completion: nil)
                                                break

                                            }
                                    })

                                }
                                
//                                appDelegate.loadTabbar()
                                
                                return
                            }
                            else
                            {
//                                let alert = UIAlertController(title: "Zoolife", message:message, preferredStyle: UIAlertController.Style.alert)
//                                alert.addAction(UIAlertAction(title:  Okey(), style: UIAlertAction.Style.default, handler: nil))
//                                self.present(alert, animated: true, completion: nil)
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
                            alert.addAction(UIAlertAction(title:  Okey(), style: UIAlertAction.Style.default, handler: nil))
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
