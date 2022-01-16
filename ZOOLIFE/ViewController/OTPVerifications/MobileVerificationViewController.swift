//
//  MobileVerificationViewController.swift
//  Motor
//
//  Created by Hafiz Anser on 12/27/17.
//  Copyright © 2017 Hafiz Anser. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import PinCodeTextField

class MobileVerificationViewController: UIViewController , UITextFieldDelegate
{
    
    
    var second = 60
    var totalTime = 60
    var timer = Timer()

    @IBOutlet weak var btnResend: UIButton!
    @IBOutlet weak var lblHeader1: UILabel!
    @IBOutlet weak var lblHeader2: UILabel!
    
    @IBOutlet var tfCode1: UITextField!
    @IBOutlet var tfCode2: UITextField!
    @IBOutlet var tfCode3: UITextField!
    @IBOutlet var tfCode4: UITextField!
    @IBOutlet weak var tfCode5: UITextField!
    @IBOutlet weak var tfCode6: UITextField!
    @IBOutlet weak var textFieldOTP: PinCodeTextField!
    @IBOutlet weak var resendCodeButton: UIButton!
    
    @IBOutlet weak var resendCodeLabel: UILabel!
    @IBOutlet weak var lblOTP: UILabel!
    var isComingFrom = ""
    var otp = ""
    var userName = ""
    
    var phoneNumber = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        textFieldOTP.becomeFirstResponder()
        textFieldOTP.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
        resendCodeButton.isHidden = false
        textFieldOTP.keyboardType = UIKeyboardType.phonePad
        self.resendCodeButton.addTarget(self, action: #selector(resendOTP), for: .touchUpInside)

        lblOTP.text = otp
        scheduledTimerWithTimeInterval()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.UpdateLang_UI()
    }
    
    //MARK: - Custome Functions
    func UpdateLang_UI(){
        if let lang = UserDefaults.standard.object(forKey: "appLang") as? String {
            if lang == "en" {
                btnResend.localizeKey = "Send"
                lblHeader1.localizeKey = "We have sent a confirmation number to your e-mail!"
                lblHeader2.localizeKey = "Please enter verification number we sent!"
                UIView.appearance().semanticContentAttribute = .forceLeftToRight
            } else {
                btnResend.localizeKey = "ارسال"
                lblHeader1.localizeKey = "لقد أرسلنا لك رمز وصول عبر الرسائل القصيرة للتحقق من رقم الهاتف المحمول"
                lblHeader2.localizeKey = "أدخل رمز هنا"
                UIView.appearance().semanticContentAttribute = .forceRightToLeft
            }
        } else {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }
    }
    func scheduledTimerWithTimeInterval() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateCounting), userInfo: nil, repeats: true)
    }

    @objc func updateCounting() {
        
        if self.second == 0 {
            timer.invalidate()
            self.second = self.totalTime
            self.resendCodeButton.isHidden = false
            if appLanguage == "en" {
                self.resendCodeLabel.text = "Resend the code"
            } else {
                self.resendCodeLabel.text = "أعد إرسال الرمز"
            }
            resendCodeButton.isEnabled = true
        } else {
            var string = String.init(format: "إعادة ارسال الرمز بعد %d ثانية", self.second)
            if appLanguage == "en" {
                string = String.init(format: "Resend the code after %d seconds", self.second)
            } else {
                string = String.init(format: "إعادة ارسال الرمز بعد %d ثانية", self.second)
            }
            self.resendCodeLabel.text = string
            self.resendCodeButton.isHidden = false
            resendCodeButton.isEnabled = false
            self.second -= 1
        }
        
        
        NSLog("counting..")
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @objc
    func resendOTP(_ sender: UIButton) {
        resendVerificationCode()
    }
    
    // MARK: - TextField Delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if textField == tfCode1
        {
            if (tfCode1.text?.count)! >= 1 && range.length == 0
            {
                return false
            }
            else
            {
                self .perform(#selector(checkTF), with: nil, afterDelay: 0.1)
                return true
            }
        }
        else if textField == tfCode2
        {
            if (tfCode2.text?.count)! >= 1 && range.length == 0
            {
                return false
            }
            else
            {
                self .perform(#selector(checkTF), with: nil, afterDelay: 0.1)
                return true
            }
        }
        else if textField == tfCode3
        {
            if (tfCode3.text?.count)! >= 1 && range.length == 0
            {
                return false
            }
            else
            {
                self .perform(#selector(checkTF), with: nil, afterDelay: 0.1)
                return true
            }
        }
        else if textField == tfCode4
        {
            if (tfCode4.text?.count)! >= 1 && range.length == 0
            {
                return false
            }
            else
            {
                self .perform(#selector(checkTF), with: nil, afterDelay: 0.1)
                return true
            }
        }
        
        else if textField == tfCode5
        {
            if (tfCode5.text?.count)! >= 1 && range.length == 0
            {
                return false
            }
            else
            {
                self .perform(#selector(checkTF), with: nil, afterDelay: 0.1)
                return true
            }
        }
        
        else if textField == tfCode6
        {
            if (tfCode6.text?.count)! >= 1 && range.length == 0
            {
                return false
            }
            else
            {
                self .perform(#selector(checkTF), with: nil, afterDelay: 0.1)
                return true
            }
        }
        
        return true
    }
    
    //MARK: - Functions
    @objc func checkTF()
    {
        if tfCode1.text?.count == 1
        {
            tfCode2.becomeFirstResponder()
        }
        if tfCode2.text?.count == 1
        {
            tfCode3.becomeFirstResponder()
        }
        if tfCode3.text?.count == 1
        {
            tfCode4.becomeFirstResponder()
        }
        if tfCode4.text?.count == 1
        {
            tfCode5.becomeFirstResponder()
        }
        if tfCode5.text?.count == 1
        {
            tfCode6.becomeFirstResponder()
        }
        if tfCode6.text?.count == 1
        {
            self.view.endEditing(true)
        }
    }
    
    func resendVerificationCode() {
        
        AppUtility.showProgress()
        let requestURL = URL(string: RESEND_OTP)!
        print(requestURL)
        
        
        let headers = ["Content-Type": "application/json","X-Localization":"\(appLanguage)"]
        let paramDict = ["phone": phoneNumber] as [String : Any]
        
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
                            
                            self.otp = String(otp ?? 0)
                            self.scheduledTimerWithTimeInterval()
                            return
                        }
                        else
                        {
                            let alert = UIAlertController(title: "Zoolife", message:message, preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: Okey(), style: UIAlertAction.Style.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
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
    
    func pinVerification ()
    {
        //AppUtility.showHud(view: self.view)
        AppUtility.showProgress()
        
        let requestURL = URL(string: PINVRIFICATION)!
        
        //let user:User = AppUtility.getSession()
        
        let headers = ["Content-Type": "application/json","X-Localization":"\(appLanguage)"]
        
       if  let code = textFieldOTP.text
       {
        
        var paramDict : [String: Any] = [:]
        if isComingFrom == "Singup"
        {
            paramDict = ["phone":phoneNumber,
                         "otp":code]
        }
        else
        {
            paramDict = ["phone":userName,
                         "otp":code]
        }
        
        print(paramDict)
        
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
                        
                        if((response.result.value) != nil) {
                            let swiftyJsonVar = JSON(response.result.value!)
                            print(swiftyJsonVar)
                            
                            let dict = swiftyJsonVar.dictionaryValue
                            let error = dict["error"]?.bool
                            let message = dict["message"]?.string
                            // AppUtility.hideHud(view: self.view)
                            AppUtility.hideProgress()
                            
                            if error == false
                            {
                                if self.isComingFrom == "Singup"
                                {
                                    let result: Dictionary<String, JSON> = swiftyJsonVar["data"].dictionaryValue
                                    //let userDict = result["data"]?.dictionaryValue
                                    
                                    let u = User.init(withDictionary: result)
                                    AppUtility.saveUserSession(u: u)
                                    UserDefaults.standard.set(true, forKey: "isLogin")
                                    UserDefaults.standard.setValue(true, forKey: "isLogin")
                                    
                                    //                                    let user:User = AppUtility.getSession()
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

                                                        let alert = UIAlertController(title:"Zoolife" , message:loc.accountCreated.localized(), preferredStyle: UIAlertController.Style.alert)

                                                        alert.addAction(UIAlertAction(title: Okey(), style: .default, handler: { (action: UIAlertAction!) in

                                                            appDelegate.loadTabbar()

                                                        }))
                                                        self.present(alert, animated: true, completion: nil)

                                                    }
                                                case .failure(_):
                                                    let alert = UIAlertController(title:"Zoolife" , message:loc.accountCreated.localized(), preferredStyle: UIAlertController.Style.alert)

                                                    alert.addAction(UIAlertAction(title: Okey(), style: .default, handler: { (action: UIAlertAction!) in

                                                        appDelegate.loadTabbar()

                                                    }))
                                                    self.present(alert, animated: true, completion: nil)
                                                    break

                                                }
                                        })

                                    }
                                    

                                }
                                else
                                {
                                    let alert = UIAlertController(title:"Zoolife" , message:loc.NowYouCanChangePass.localized(), preferredStyle: UIAlertController.Style.alert)
                                    
                                    alert.addAction(UIAlertAction(title: Okey(), style: .default, handler: { (action: UIAlertAction!) in
                                        
                                        self.textFieldOTP.text = ""
//                                        self.tfCode1.text = ""
//                                        self.tfCode2.text = ""
//                                        self.tfCode3.text = ""
//                                        self.tfCode4.text = ""
//                                        self.tfCode5.text = ""
//                                        self.tfCode6.text = ""
                                        //appDelegate.loadTabbar()
                                        let viewController = ChangePasswordViewController()
                                        viewController.userName = self.userName
                                        self.navigationController?.pushViewController(viewController, animated: true)
                                        
                                        
                                    }))
                                    self.present(alert, animated: true, completion: nil)
                                }
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
                            //AppUtility.hideHud(view: self.view)
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
                    //AppUtility.hideHud(view: self.view)
                    print(encodingError)
                    let alert = UIAlertController(title: "Zoolife", message:encodingError.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: Okey(), style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        )
       }
        
//        let code = String(format:"%@%@%@%@%@%@",tfCode1.text!, tfCode2.text!, tfCode3.text!, tfCode4.text!, tfCode5.text!, tfCode6.text!)

    }
    
    
    //MARK: - Button Actions
    @IBAction func submitTapped(_ sender: UIButton)
    {
        if isComingFrom ==  "Singup"
        {
            
            print("pin code text field text = ", textFieldOTP.text , "pin code text count",textFieldOTP.text?.count)
            
            if let text = textFieldOTP.text, text.count == 6
            {
                self.pinVerification()
            }
            else
            {
                var msg = "الرجاء إدخال الرمز الخاص بك"
                if appLanguage == "en" {
                    msg = "Please enter your code"
                } else {
                    msg = "الرجاء إدخال الرمز الخاص بك"
                }
                let alert = UIAlertController(title: "", message: msg, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: Okey(), style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
//            if (tfCode1.text?.count == 1 && tfCode2.text?.count == 1 && tfCode3.text?.count == 1 && tfCode4.text?.count == 1 && tfCode5.text?.count == 1 && tfCode6.text?.count == 1)
//            {
//                self.pinVerification()
//                //UserDefaults.standard.setValue(true, forKey: "isLogin")
//                //appDelegate.loadTabbar()
//            }
//            else
//            {
//                let alert = UIAlertController(title: "تشبث!", message: "الرجاء إدخال الرمز الخاص بك", preferredStyle: UIAlertController.Style.alert)
//                alert.addAction(UIAlertAction(title: Okey(), style: UIAlertAction.Style.default, handler: nil))
//                self.present(alert, animated: true, completion: nil)
//            }
        }
        else
        {
            self.pinVerification()
        }
    }

    
    @IBAction func backTapped(_ sender: UIButton)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
}
