//
//  ProfileViewController.swift
//  P.I.M.P
//
//  Created by Hafiz Anser  on 7/26/20.
//  Copyright © 2020 Hafiz Anser. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import Alamofire
import SwiftyJSON
import SVProgressHUD

class ProfileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate
{
    @IBOutlet weak var btnSaveHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblLName: UILabel!
    @IBOutlet weak var lblFName: UILabel!
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    
    @IBOutlet weak var viewFNameHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewLNameHeightConstraint: NSLayoutConstraint!
    
    
    
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var tfLastName: UITextField!
    @IBOutlet weak var btnSFirstNameEdit: UIButton!
    @IBOutlet weak var btnLastNameEdit: UIButton!
    @IBOutlet weak var imgProfile: UIImageView!
    
    @IBOutlet weak var tfFirstName: UITextField!
    
    var image = UIImage.init(named: "myImage")
    var imgData:Data?
    var UIPicker = UIImagePickerController()
    var name = ""
    var isPhotoChange = false
    
    let modelName = UIDevice.modelName
    //let user:User = AppUtility.getSession()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        UIView.appearance().semanticContentAttribute = .forceRightToLeft
        
        self.tfLastName.textAlignment = NSTextAlignment.right
        self.tfFirstName.textAlignment = NSTextAlignment.right
        setupView()
        //getMyProfile()
    }
    override func viewWillAppear(_ animated: Bool) {
        UpdateLang_UI()
    }
    func UpdateLang_UI(){
        if let lang = UserDefaults.standard.object(forKey: "appLang") as? String {
            if lang == "en" {
                //lblTitle.localizeKey = "Favorite Posts"
                UIView.appearance().semanticContentAttribute = .forceLeftToRight
            } else {
               // lblTitle.localizeKey = "المفضل لدي"
                UIView.appearance().semanticContentAttribute = .forceRightToLeft
            }
        } else {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }
    }
    func setupView()
    {
        UIPicker.delegate = self
        
        imgProfile.layer.borderWidth = 2
        imgProfile.layer.masksToBounds = false
        imgProfile.layer.borderColor = UIColor.white.cgColor
        imgProfile.layer.cornerRadius = imgProfile.frame.height/2
        imgProfile.clipsToBounds = true
        btnSave.isHidden = true
        
        tfFirstName.isEnabled = false
        tfLastName.isEnabled = false
        
        if modelName.contains("iPad")
        {
            lblHeader.font = lblHeader.font.withSize(30)
            lblEmail.font = lblEmail.font.withSize(30)
            viewFNameHeightConstraint.constant = 130
            viewLNameHeightConstraint.constant = 130
            lblFName.font = lblFName.font.withSize(30)
            lblLName.font = lblLName.font.withSize(30)
            tfLastName.font = tfLastName.font?.withSize(25)
            tfFirstName.font = tfFirstName.font?.withSize(25)
            btnSave.titleLabel?.font =  UIFont(name: "Muli", size: 25)
            btnSaveHeightConstraint.constant = 70
        }
//        if UserDefaults.standard.bool(forKey: "isAppleLogin")
//        {
//            lblEmail.text = "hide@apple.com"
//            tfFirstName.text = user.firstName!
//            tfLastName.text = user.lastName!
//        }
//        else
//        {
//            lblEmail.text = user.email!
//            tfFirstName.text = user.firstName!
//            tfLastName.text = user.lastName!
//        }
        
    }
    //MARK: - Button Actions
    @IBAction func settingTapped(_ sender: Any)
    {
        let viewController = SettingViewController()
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    @IBAction func firstNameEditTapped(_ sender: Any)
    {
        tfFirstName.isEnabled = true
        btnSave.isHidden = false
        btnSFirstNameEdit.isHidden = true
        tfFirstName.borderWidth = 1
        tfFirstName.borderColor = UIColor(red: 208/255, green: 183/255, blue: 88/255, alpha: 1.0)
        tfFirstName.resignFirstResponder()
    }
    @IBAction func lastNameEditTapped(_ sender: Any)
    {
        tfLastName.isEnabled = true
        btnSave.isHidden = false
        btnLastNameEdit.isHidden = true
        tfLastName.borderWidth = 1
        tfLastName.borderColor = UIColor(red: 208/255, green: 183/255, blue: 88/255, alpha: 1.0)
        tfLastName.resignFirstResponder()
    }
    @IBAction func saveTapped(_ sender: Any)
    {
        btnSave.isHidden = true
        btnSFirstNameEdit.isHidden = false
        tfFirstName.borderWidth = 0
        
        btnLastNameEdit.isHidden = false
        tfLastName.borderWidth = 0
        
        tfFirstName.isEnabled = false
        tfLastName.isEnabled = false
//        if CheckFields()
//        {
//            editProfile()
//        }
    }
    @IBAction func profileChangeTapped(_ sender: Any)
    {
        changePhoto()
    }
    @IBAction func backTapped(_ sender: Any)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Functions
    func CheckFields() -> Bool
    {
        if (tfFirstName.text?.trimmingCharacters(in: .whitespaces).isEmpty)!
        {
            var word = "الرجاء إدخال الاسم الأول"
                        if appLanguage == "en" {
                            word = "Please enter the first name"
                        }
            let alert = UIAlertController(title: "", message: word, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: Okey(), style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            let test = false
            return test
        }
        else if (tfLastName.text?.trimmingCharacters(in: .whitespaces).isEmpty)!
        {
            var word = "الرجاء إدخال الاسم الأخير"
                        if appLanguage == "en" {
                            word = "Please enter the last name"
                        }
            let alert = UIAlertController(title: "", message: word, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: Okey(), style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            let test = false
            return test
        }
        let test = true
        return test
    }
    
    
    //MARK: - Change Photo
    func changePhoto()
    {
        var select = "تحديد صورة"
                    if appLanguage == "en" {
                        select = "Select Picture"
                    }
        let actionSheet = UIAlertController(title: nil, message: select, preferredStyle: .actionSheet)
        var word = "التقط صورة من الكاميرا"
                    if appLanguage == "en" {
                        word = "Take a picture from the camera"
                    }
        let cameraAction = UIAlertAction(title: word, style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera)
            {
                self.UIPicker.allowsEditing = false
                self.UIPicker.sourceType = UIImagePickerController.SourceType.camera
                self.UIPicker.cameraCaptureMode = .photo
                self.UIPicker.modalPresentationStyle = .fullScreen
                self.present(self.UIPicker, animated: true, completion: nil)
            }
        })
        var word1 = "اختيار صورة من المعرض"
                    if appLanguage == "en" {
                        word1 = "Choose a picture from the gallery"
                    }
        let libraryAction = UIAlertAction(title: word1, style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            self.UIPicker.allowsEditing = false
            self.UIPicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.UIPicker.modalPresentationStyle = .fullScreen
            self.present(self.UIPicker, animated: true, completion: nil)
        })
        
        let cancelAction = UIAlertAction(title: Cancel(), style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.isPhotoChange = false
            print("Cancel")
        })
        
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(libraryAction)
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    
    //MARK: -ImagePickerView Delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        btnSave.isHidden = false
        isPhotoChange = true
        let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        self.imgProfile.layer.cornerRadius = imgProfile.frame.size.width/2
        self.imgProfile.clipsToBounds = true
        
        self.imgProfile.image = chosenImage
        imgData = chosenImage.jpegData(compressionQuality: 0.2)!
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        isPhotoChange = false
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Methods Functions
//    func editProfile ()
//    {
//        AppUtility.showProgress()
//        let requestURL = URL(string: SERVER_BASE_URL + GET_PRofile_URL)!
//
//        let headers = ["Content-Type": "application/json"]
//        let paramDict = ["accessKey": user.accessKey!,
//                         "firstName":tfFirstName.text!,
//                         "lastName":tfLastName.text!] as [String : Any]
//
//        print(paramDict)
//
//        Alamofire.upload(multipartFormData: { (multipartFormData) in
//
//            if self.imgData != nil
//            {
//                //let image:UIImage = self.imgProfile.image!
//                //multipartFormData.append(image.jpegData(compressionQuality: 0.5)!, withName: "image", fileName: "photo.png", mimeType: "image/jpeg")
//
//
//                multipartFormData.append(self.imgData!, withName: "image",fileName: "photo.png", mimeType: "image/jpeg")
//            }
//
//            for (key, value) in paramDict
//            {
//                multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
//            }
//        },  usingThreshold:UInt64.init(),
//            to: requestURL ,
//            method:.post,
//            headers:headers,
//            encodingCompletion: { encodingResult in
//
//                switch encodingResult {
//                case .success(let upload, _, _):
//
//                    upload.responseJSON { response in
//
//                        print("response JSON: '\(response)'")
//
//                        if((response.result.value) != nil)
//                        {
//                            let swiftyJsonVar = JSON(response.result.value!)
//                            print(swiftyJsonVar)
//
//                            let dict = swiftyJsonVar.dictionaryValue
//                            let message = dict["message"]?.string
//                            let error = dict["error"]?.bool
//
//                            AppUtility.hideProgress()
//
//                            if error == false
//                            {
//                                let result: Dictionary<String, JSON> = swiftyJsonVar["data"].dictionaryValue
//                                //let userDict = result["data"]?.dictionaryValue
//
////                                let u = User.init(withDictionary: result)
////                                AppUtility.saveUserSession(u: u)
////
////                                let user:User = AppUtility.getSession()
//
//                                print(user.ID!)
//                                return
//                            }
//                            else
//                            {
//                                let alert = UIAlertController(title: "Zoolife", message:message, preferredStyle: UIAlertController.Style.alert)
//                                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
//                                self.present(alert, animated: true, completion: nil)
//                            }
//                        }
//                        else
//                        {
//                            AppUtility.hideProgress()
//                            let result = response.result
//                            print("response JSON: '\(result)'")
//                            //let userInfo = response.error as? Error
//                            let error = response.error
//
//                            let alert = UIAlertController(title: "Zoolife", message:error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
//                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
//                            self.present(alert, animated: true, completion: nil)
//                        }
//                    }
//                case .failure(let encodingError):
//                    AppUtility.hideProgress()
//                    print(encodingError)
//                    let alert = UIAlertController(title: "Zoolife", message:encodingError.localizedDescription, preferredStyle: UIAlertController.Style.alert)
//                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
//                    self.present(alert, animated: true, completion: nil)
//                }
//        })
//    }
//
//    func getMyProfile()
//    {
//        AppUtility.showProgress()
//        let requestURL = URL(string: SERVER_BASE_URL + GET_PRofile_URL)!
//
//        let user:User = AppUtility.getSession()
//        let paramDict : [String: Any] = ["accessKey": user.accessKey!]
//
//        Alamofire.request(
//            requestURL,
//            method: .get,
//            parameters: paramDict,
//            headers: ["Content-Type": "application/json",//"multipart/form-data",
//                "Cache-Control": "no-cache",
//                "Accept": "\"[\"application/json\", \"text/html\"]"])
//
//            .validate(statusCode: 200..<600)
//
//            .responseJSON { (response) -> Void in
//
//                if((response.result.value) != nil)
//                {
//                    AppUtility.hideProgress()
//
//                    let swiftyJsonVar = JSON(response.result.value!)
//                    print(swiftyJsonVar)
//
//                    let dict = swiftyJsonVar.dictionaryValue
//                    let status = dict["error"]?.boolValue
//                    let message = dict["message"]?.string
//
//                    if status == false
//                    {
//                        let result: Dictionary<String, JSON> = swiftyJsonVar["data"].dictionaryValue
//
//                        let u = User.init(withDictionary: result)
//                        AppUtility.saveUserSession(u: u)
//
//                        if let profilePhoto = result["image"]?.string
//                        {
//                            AppUtility.setImage(url: String(format:"%@%@",Image_PROFILE_BASE_URL, profilePhoto), image: self.imgProfile)
//                        }
//                    }
//                    else
//                    {
//                        let alert = UIAlertController(title: "Information", message:message, preferredStyle: UIAlertController.Style.alert)
//                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
//                        self.present(alert, animated: true, completion: nil)
//                    }
//                }
//                else
//                {
//                    AppUtility.hideProgress()
//
//                    let result = response.result
//                    print("response JSON: '\(result)'")
//                    let error = response.error
//
//                    let alert = UIAlertController(title: "Zoolife", message:error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
//                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
//                    self.present(alert, animated: true, completion: nil)
//                }
//        }
//    }
    
}
