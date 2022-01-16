//
//  ForgotPasswordViewController.swift
//  Amerni
//
//  Created by Hafiz Anser on 8/6/18.
//  Copyright © 2018 com.Devicebee. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class ForgotPasswordViewController: UIViewController, UITextFieldDelegate
{
    
    @IBOutlet weak var lblHeader1: UILabel!
    @IBOutlet weak var lblHeader2: UILabel!
    @IBOutlet weak var lblHeader3: UILabel!
    
    @IBOutlet weak var lblemail: UILabel!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var tfEmail: UITextField!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
        tfEmail.returnKeyType = UIReturnKeyType.done
        
        self.tfEmail.textAlignment = NSTextAlignment.right
    
//        let user:User = AppUtility.getSession()
//        
//        print(user.email!)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.UpdateLang_UI()
    }
    //MARK: - Custome Functions
    func UpdateLang_UI(){
        if let lang = UserDefaults.standard.object(forKey: "appLang") as? String {
            if lang == "en" {
                self.lblHeader2.textAlignment = .left
                self.lblHeader3.textAlignment = .left
                self.tfEmail.textAlignment = NSTextAlignment.left
                UIView.appearance().semanticContentAttribute = .forceLeftToRight
            } else {
                self.tfEmail.textAlignment = NSTextAlignment.right
                self.lblHeader2.textAlignment = .right
                self.lblHeader3.textAlignment = .right
                UIView.appearance().semanticContentAttribute = .forceRightToLeft
            }
        } else {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }
        lblHeader1.text = loc.forgotHeade1.localized()
        lblHeader2.text = loc.forgotHeade2.localized()
        lblHeader3.text = loc.forgotHeade3.localized()
        lblemail.text = loc.yourEmail.localized()
        btnSubmit.setTitle("\(loc.forgotSEND.localized())", for: UIControl.State.normal)
    }
    
    // MARK: - TextFiedl Delegate Functions
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        let maxLength = 400
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    // MARK: - Functions
    func CheckFields() -> Bool
    {
        
        
//        if !(AppUtility.isValidEmail(testStr:tfEmail.text ?? "")){
//            let alert = UIAlertController(title: "", message: "الرجاء إدخال رقم هاتفك أو بريدك الإلكتروني", preferredStyle: UIAlertController.Style.alert)
//            alert.addAction(UIAlertAction(title: Okey(), style: UIAlertAction.Style.default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//
//            let test = false
//            return test
//        }
        
        
        if (tfEmail.text?.trimmingCharacters(in: .whitespaces).isEmpty)!
        {
            let alert = UIAlertController(title: "", message: loc.enterPhoneOrUsername.localized(), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: Okey(), style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            let test = false
            return test
        }
        
        let test = true
        return test
    }
    func ForgotPassword ()
    {
        AppUtility.showProgress()

        let requestURL = URL(string: RESET_PASSWORD)!
        let headers = ["Content-Type": "application/json","X-Localization":"\(appLanguage)"]
        
        let paramDict : [String: Any] = ["phone": tfEmail.text!] as [String : Any]
        

        Alamofire.upload(
            multipartFormData: { multipartFormData in

                for (key, value) in paramDict
                {
                    multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
                }
        },
            usingThreshold:UInt64.init(),
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
                            let error = dict["error"]?.bool
                            let message = dict["message"]?.string
                            let otp = dict["otp"]?.int

                            AppUtility.hideProgress()

                            if error == false
                            {
                               let alertController = UIAlertController(title: "Zoolife", message: message, preferredStyle:UIAlertController.Style.alert)

                               alertController.addAction(UIAlertAction(title: Okey(), style: UIAlertAction.Style.default)
                               { action -> Void in
                                
                                
                                let viewController = MobileVerificationViewController()
                                viewController.userName = self.tfEmail.text!
                                viewController.otp = String(otp ?? 0) ?? ""
                                self.navigationController?.pushViewController(viewController, animated: true)
                                
                               })
                               self.present(alertController, animated: true, completion: nil)
                            }
                            else
                            {
                                let alertController = UIAlertController(title: "Zoolife", message: message, preferredStyle:UIAlertController.Style.alert)

                                alertController.addAction(UIAlertAction(title: Okey(), style: UIAlertAction.Style.default)
                                { action -> Void in
                                    self.tfEmail.text = ""
                                    self.tfEmail.placeholder = "ادخل رقم الهاتف"
                                })
                                self.present(alertController, animated: true, completion: nil)
                            }
                        }
                        else{
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
                    alert.addAction(UIAlertAction(title: Okey(), style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
        }
        )
    }
    
    //MARK: - Buttons Actions
    @IBAction func submitTapped(_ sender: UIButton)
    {
        if CheckFields()
        {
            self.view.endEditing(true)
            ForgotPassword()
        }
        
//        let viewController = MobileVerificationViewController()
//        self.navigationController?.pushViewController(viewController, animated: true)
    }
    @IBAction func backTapped(_ sender: UIButton)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
}
