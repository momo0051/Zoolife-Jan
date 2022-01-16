
//
//  ChangePasswordViewController.swift
//  RenatalCar
//
//  Created by Hafiz Anser  on 2/18/20.
//  Copyright © 2020 Joe Singh. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class ChangePasswordViewController: UIViewController, UITextFieldDelegate
{
    @IBOutlet weak var btnSend: UIButton!
    
    @IBOutlet weak var lblConfPass: UILabel!
    @IBOutlet weak var lblNewPass: UILabel!
    @IBOutlet weak var tfNewPassword: UITextField!
    @IBOutlet weak var tfNewPasswordReCheck: UITextField!
    
    //let user:User = AppUtility.getSession()
    
    var isComingFrom = ""
    var otp = ""
    var userName = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
        self.tfNewPassword.textAlignment = NSTextAlignment.right
        self.tfNewPasswordReCheck.textAlignment = NSTextAlignment.right
        
        //textfeild()
    }
    override func viewWillAppear(_ animated: Bool) {
        UpdateLang_UI()
    }
    func UpdateLang_UI(){
        if let lang = UserDefaults.standard.object(forKey: "appLang") as? String {
            if lang == "en" {
                btnSend.localizeKey = "Send"
                lblConfPass.localizeKey = "Confirm Password"
                lblNewPass.localizeKey = "New Password"
                self.tfNewPassword.textAlignment = NSTextAlignment.left
                self.tfNewPasswordReCheck.textAlignment = NSTextAlignment.left
                UIView.appearance().semanticContentAttribute = .forceLeftToRight
            } else {
                btnSend.localizeKey = "موافق"
                lblConfPass.localizeKey = "تأكيد كلمة المرور الجديدة"
                lblNewPass.localizeKey = "كلمة سر جديدة"
                self.tfNewPassword.textAlignment = NSTextAlignment.right
                self.tfNewPasswordReCheck.textAlignment = NSTextAlignment.right
                UIView.appearance().semanticContentAttribute = .forceRightToLeft
            }
        } else {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }
    }
    
    //MARK: - TextField Delegate
    func textfeild()
    {
        //tfOldPassword.returnKeyType = UIReturnKeyType.next
        tfNewPassword.returnKeyType = UIReturnKeyType.next
        tfNewPasswordReCheck.returnKeyType = UIReturnKeyType.done
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
//        if textField == tfOldPassword
//        {
//            textField.resignFirstResponder()
//            tfNewPassword.becomeFirstResponder()
//        }
        if textField == tfNewPassword
        {
            textField.resignFirstResponder()
            tfNewPasswordReCheck.becomeFirstResponder()
        }
        else if textField == tfNewPasswordReCheck
        {
            textField.resignFirstResponder()
            if CheckFields()
            {
                //login()
            }
        }
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        let maxLength = 70
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
    // MARK: - Functions
    func CheckFields() -> Bool
    {
        if (tfNewPassword.text?.trimmingCharacters(in: .whitespaces).isEmpty)!
        {
            var word = "الرجاء إدخال كلمة المرور الجديدة الخاصة بك"
                        if appLanguage == "en" {
                            word = "Please enter your new password"
                        }
            let alert = UIAlertController(title: "", message: word, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: Okey(), style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            let test = false
            return test
        }
            
        else if (tfNewPasswordReCheck.text?.trimmingCharacters(in: .whitespaces).isEmpty)!
        {
            let alert = UIAlertController(title: "", message: loc.enterNewConfirmPass.localized(), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: Okey(), style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            let test = false
            return test
        }
        else if tfNewPasswordReCheck.text!  != tfNewPassword.text!
        {
            let alert = UIAlertController(title: "", message: loc.NewAndConfirmPassSame.localized(), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: Okey(), style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            let test = false
            return test
        }
        
        let test = true
        return test
    }
    func ChangePassword ()
    {
        AppUtility.showProgress()
        let requestURL = URL(string: CHANGE_PASSWORD)!
        print(requestURL)


        let headers = ["Content-Type": "application/json","X-Localization":"\(appLanguage)"]
        let paramDict = ["phone":userName,
                         "password":tfNewPassword.text!] as [String : Any]
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
                                self.tfNewPassword.text = ""
                                self.tfNewPasswordReCheck.text = ""
                                
                                let alert = UIAlertController(title:"Zoolife" , message:message, preferredStyle: UIAlertController.Style.alert)
                                
                                alert.addAction(UIAlertAction(title: Okey(), style: .default, handler: { (action: UIAlertAction!) in
                                    
                                    let viewController = LoginViewController()
                                    self.navigationController?.pushViewController(viewController, animated: true)
                                    
                                }))
                                self.present(alert, animated: true, completion: nil)
                                
                                
                                
                                
                                return
                            }
                            else
                            {
                                let alert = UIAlertController(title: "Zoolife", message:message, preferredStyle: UIAlertController.Style.alert)
                                alert.addAction(UIAlertAction(title:  Okey(), style: UIAlertAction.Style.default, handler: nil))
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
    
    //MARK: - Button Actions
    @IBAction func proceedTapped(_ sender: Any)
    {
        if CheckFields()
        {
            ChangePassword()
        }
//        appDelegate.loadTabbar()
    }
    @IBAction func backTapped(_ sender: Any)
    {
        //self.dismiss(animated: true, completion: nil)
        _ = self.navigationController?.popViewController(animated: true)
    }
}
