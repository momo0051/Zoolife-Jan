//
//  AddDeliveryPostViewController.swift
//  ZOOLIFE
//
//  Created by Muhammad Yousaf on 24/12/2020.
//  Copyright © 2020 Hafiz Anser. All rights reserved.
//


import UIKit
import Alamofire
import ActionSheetPicker_3_0
import SwiftyJSON

class AddDeliveryPostViewController: UIViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnAdd: UIButton!
    
    @IBOutlet weak var lblSubTitle: UILabel!
    var delegate:DeliveryPostDelegate?
    
    @IBOutlet weak var shortDesc:UITextField!
//    @IBOutlet weak var de:UITextField!
    
    
    @IBOutlet weak var btnLocation: UIButton!
    //var arrCityNames = ["الرياض","الشرقية","جدة","مكة","ينبع","حفر الباطن","المدينة","الطائف","تبوك","القصيم","حائل","ابها","الباحة","جيزان","نجران","الجوف","عرعر","الكويت","الأمارات","البحرين"]
    var arrCityNames:[String] = []
    var arrCityData = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        btnLocation.contentHorizontalAlignment = .right
        // Do any additional setup after loading the view.
        self.getCity()
    }
    override func viewWillAppear(_ animated: Bool) {
        UpdateLang_UI()
    }
    func getCity()
    {
        AppUtility.showProgress()
        
        arrCityData.removeAllObjects()
        let requestURL = URL(string: GET_ALL_CITY)!
        print(requestURL)
        

        let headers = ["Content-Type": "application/json","X-Localization":"\(appLanguage)"]
        let paramDict = [String : Any]()
        print(paramDict)
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in paramDict
            {
                multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
            }
        },            usingThreshold:UInt64.init(),
            to: requestURL ,
            method:.get,
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
                            let message = dict["msg"]?.string
                            let error = dict["error"]?.bool
                            
                            AppUtility.hideProgress()
                            
                            if error == false
                            {
                                //let result: Dictionary<String, JSON> = swiftyJsonVar["data"].dictionaryValue
                                let dataArray : [JSON] = (dict["data"]?.arrayValue)!
                                self.arrCityNames = []
                                for dic in dataArray {
                                    let dicts: Dictionary<String, JSON> = dic.dictionaryValue
                                    let objD = Category.init(withDictionary:dicts)
                                    self.arrCityData.add(objD)
                                    self.arrCityNames.append("\(dic["name"])")

                                }
                                //self.collectionCategory.reloadData()
//                                if self.editAd{
//                                    self.setUpCategoryData()
//                                }
    
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
    func UpdateLang_UI(){
        if let lang = UserDefaults.standard.object(forKey: "appLang") as? String {
            if lang == "en" {
                lblTitle.localizeKey = "Add Delivery Post"
                lblSubTitle.localizeKey = "Choose Your City"
                shortDesc.localizeKey = "Add short text"
                btnAdd.localizeKey = "Add Post"
                btnLocation.contentHorizontalAlignment = .left
                shortDesc.textAlignment = .left
                
                UIView.appearance().semanticContentAttribute = .forceLeftToRight
            } else {
                lblTitle.localizeKey = "إعلاناتي"
                lblSubTitle.localizeKey = "موقعك"
                shortDesc.localizeKey = "اختيار موقع"
                btnAdd.localizeKey = "اضف الاعلان"
                shortDesc.textAlignment = .right
                btnLocation.contentHorizontalAlignment = .right
                UIView.appearance().semanticContentAttribute = .forceRightToLeft
            }
        } else {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }
    }
    @IBAction func backTapped(_ sender: Any){
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func locationTapped(_ sender: Any){
        
        ActionSheetStringPicker.show(withTitle: loc.choosSite.localized(), rows: arrCityNames, initialSelection: 0, doneBlock: {
            picker, indexes, values in

            self.btnLocation.setTitle(values as! String?, for: .normal)
            self.btnLocation.setTitleColor(UIColor.black, for: .normal)
            //self.getSubCategory()

            return
        }, cancel: { ActionSheetStringPicker in return},origin: sender)
    }
    
    
    @IBAction func addPostDeliveryAction(_ sender: Any){
        addPostDelivery()
    }
    
    func addPostDelivery(){
        
        AppUtility.showProgress()
        let requestURL = URL(string: ADD_DELIVERY)!

        let headers = ["Content-Type": "application/json","X-Localization":"\(appLanguage)"]

//         let user:User = AppUtility.getSession()
        var user: User
        
        if let u = AppUtility.getSession() {
            user = u
        }else{
            return
        }

        var paramDict : [String: Any]
        paramDict  = [
            "city":btnLocation.titleLabel?.text! ?? "مكه",
            "country": "المملكة العربية السعودية",
            "phone":user.phone!,
            "user_id":user.ID!,
            "location":btnLocation.titleLabel?.text! ?? "as",
            "itemTitle":"",
            "itemDesc":shortDesc.text!,
            "category":"4000",
            "subCategory":"4",
            "showComments":"1",
            "showPhoneNumber":"1",
            "showMessage":"1"
        ]

        print(paramDict)
        Alamofire.upload(
            multipartFormData: { [self] multipartFormData in
                for (key, value) in paramDict{
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

                        if((response.result.value) != nil) {
                            let swiftyJsonVar = JSON(response.result.value!)
                            //print(swiftyJsonVar)

                            let dict:Dictionary<String, JSON> = swiftyJsonVar.dictionaryValue
                            let error = dict["error"]?.boolValue
                            let message = dict["message"]?.string

                            AppUtility.hideProgress()

                            print(dict)

                            if error == false
                            {
//                                let data = dict["data"]?.intValue
//                                let dataString = String(format:"%d",data!)
//                                self.arrPostImages.add(dataString)
                                let alert = UIAlertController(title:"Zoolife" , message:message, preferredStyle: UIAlertController.Style.alert)
                                
                                alert.addAction(UIAlertAction(title: Okey(), style: .default, handler: { (action: UIAlertAction!) in
   
                                    
                                    if self.delegate != nil {
                                        self.delegate?.reloadDeliveryPosts()
                                    }
                                    
                                    
                                    self.dismiss(animated: true, completion: nil)
                                    
                                }))
                                self.present(alert, animated: true, completion: nil)
                                

                                //self.loadPhoto()

                            }
                            else
                            {
                                AppUtility.hideProgress()

                                let alert = UIAlertController(title:"Zoolife" , message:message, preferredStyle: UIAlertController.Style.alert)
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
        }
        )
    }
}
