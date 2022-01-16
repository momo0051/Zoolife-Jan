//
//  ExploreResultViewController.swift
//  ZOOLIFE
//
//  Created by Hafiz Anser  on 11/26/20.
//  Copyright © 2020 Hafiz Anser. All rights reserved.
//

import UIKit
import Alamofire
import ActionSheetPicker_3_0
import SwiftyJSON

class ExploreResultViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var btnCityDropDown: UIButton!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblCentgerText: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var arrAdsData = [Ad]() //= NSMutableArray()
    var arrCityData = NSMutableArray()
    var arrCityNames:[String] = []
    @IBOutlet weak var lblNoAds: UILabel!
    
    var categoryID = ""
    var subCategoryID = ""
    var cityName = ""
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        txtCity.delegate = self
        lblNoAds.isHidden=true
        tableView.tableFooterView = UIView()
        self.navigationController?.isNavigationBarHidden = true
        UIView.appearance().semanticContentAttribute = .forceRightToLeft
        
        if #available(iOS 13.0, *) {
           
        } else {
            // Fallback on earlier versions
        }
        getCity()
        getAds()
    }
    override func viewWillAppear(_ animated: Bool) {
        UpdateLang_UI()
    }
    func UpdateLang_UI(){
        if let lang = UserDefaults.standard.object(forKey: "appLang") as? String {
            if lang == "en" {
                lblTitle.localizeKey = "Search Result"
                lblCentgerText.localizeKey = "There is no subcategory against this category"
                UIView.appearance().semanticContentAttribute = .forceLeftToRight
                if #available(iOS 13.0, *) {
                  
                } else {
                    // Fallback on earlier versions
                }
                txtCity.placeholder = "City"
            } else {
                lblTitle.localizeKey = "نتيجة البحث"
                lblCentgerText.localizeKey = "لا توجد فئة فرعية مقابل هذه الفئة"
                txtCity.placeholder = "اختر المدينة"
                UIView.appearance().semanticContentAttribute = .forceRightToLeft
                if #available(iOS 13.0, *) {
                  
                } else {
                    // Fallback on earlier versions
                }
            }
        } else {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }
    }
    // MARK: - TableView Delegate
     func numberOfSections(in tableView: UITableView) -> Int
     {
        return 1
     }
     
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
     {
        return arrAdsData.count
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
     {
//        tableView.register(UINib(nibName: "AdsCell", bundle: nil), forCellReuseIdentifier: "AdsCell")
//        var cell: AdsCell! = tableView.dequeueReusableCell(withIdentifier: "AdsCell") as? AdsCell

        tableView.register(UINib(nibName: "FavouriteTableViewCell", bundle: nil), forCellReuseIdentifier: "FavouriteTableViewCell")
        var cell: FavouriteTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "FavouriteTableViewCell") as? FavouriteTableViewCell
        
        if (cell == nil)
        {
            cell = FavouriteTableViewCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: "FavouriteTableViewCell")
        }
        
//        let obj = arrDataObjects[indexPath.row]
//        cell.lblName.text = obj.kidName
        
//        let objC:Ad = self.arrAdsData.object(at: indexPath.row) as! Ad
//
//        cell.lblUserName.text = objC.id!
//        cell.lblCity.text = objC.city
//        cell.lblTitle.text = objC.itemTitle!
//        let dateTime = createDateTime(timestamp: objC.createAt!)
//        cell.lblDate.text = dateTime
//
//        AppUtility.setImage(url:objC.previewImgUrl!, image: cell.imgAd)
//
//
//        cell.selectionStyle = .none
        
        let objC:Ad = self.arrAdsData[indexPath.row] //as! Ad
        cell.lblUserName.text = objC.username ?? ""
        cell.lblCity.text = objC.city
        cell.lblTitle.text = objC.itemTitle!
        let dateTime = createDateTime(timestamp: objC.createAt!)
        cell.lblDate.text = AppUtility.getFormattedDate(dateString: objC.created_at ?? "")
        if let created_at = objC.created_at{
            if let localDateAd = AppUtility.adFormattedDate(dateString: created_at){
            
                let localTimeAdString = TimeFormatHelper.timeAgoString(date: localDateAd)
                print(localTimeAdString)
                
                cell.lblDate.text = localTimeAdString
            }
        }
        if let imgUrl = objC.imgUrl{
            AppUtility.setImage(url:(imgUrl), image: cell.imgAd)
        }
        
        
//        if objC.priority == "" || objC.priority == "0"{
//            cell.backgroundColor = .white
//
//            cell.backView.borderWidth = 0
//            cell.backView.borderColor = .clear
//            cell.backView.cornerRadius = 0
//
//            cell.separator(hide: false)
//        }else{
//            cell.backgroundColor = UIColor.colorWithHex(hexString: "#fdf9e0")
//
//            cell.backView.borderWidth = 1
//            cell.backView.borderColor = UIColor.colorWithHex(hexString: "#FFD700")
//            cell.backView.cornerRadius = 4
//
//            cell.separator(hide: true)
//        }
        
//        AppUtility.setImage(url:objC.previewImgUrl!, image: cell.imgAd)
        

        cell.selectionStyle = .none

        return cell
     }
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
     {
        return 140
     }
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        let post = self.arrAdsData[indexPath.row]
        
        let viewController = AdDetailViewController()
        viewController.hidesBottomBarWhenPushed = true
        viewController.post = post
        viewController.delegate = self
        viewController.indexSelected = indexPath.row
        self.navigationController?.pushViewController(viewController, animated: true)
        
//        let viewController = EditProfileViewController()
//        self.navigationController?.pushViewController(viewController, animated: true)
     }
    var nextPage = ""
    var firsttime = false
    
    func getAds ()
    {
        
        var requestURL = URL(string: GET_ALL_ITEMS_BY_CATEGORY)!
        if firsttime
        {
            if nextPage == nil || nextPage.count == 0
            {
                print("nextpageurl return")
                return
            }
            requestURL = URL(string: nextPage)!
            nextPage = ""
        }
        else{
            
            arrAdsData.removeAll()
        }
        AppUtility.showProgress()

        
        let headers = ["Content-Type": "application/json","X-Localization":"\(appLanguage)"]
        
        
        let paramDict = ["category_id": categoryID,
                         "subcategory_id": subCategoryID,
                         "city": cityName]

        
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

                        if((response.result.value) != nil){
                            
                            let swiftyJsonVar = JSON(response.result.value!)
                            print(swiftyJsonVar)

                            let dict = swiftyJsonVar.dictionaryValue
                            let message = dict["msg"]?.string
                            let error = dict["error"]?.bool
                            
                            AppUtility.hideProgress()
                            
                            if error == false
                            {
                                //let result: Dictionary<String, JSON> = swiftyJsonVar["data"].dictionaryValue
                                let data = JSON(dict["data"])
                                let dict2 = data.dictionaryValue
                                self.nextPage = dict2["next_page_url"]?.string ?? ""
                                print("\(dict2)")
                                print("nextpageurl \(self.nextPage)")
                                //let result: Dictionary<String, JSON> = swiftyJsonVar["data"].dictionaryValue
                                if let dataArray : [JSON] = (dict2["data"]?.arrayValue)
                                {
                                    self.lblNoAds.isHidden = false
                                    for dic in dataArray
                                    {
                                        let dicts: Dictionary<String, JSON> = dic.dictionaryValue
                                        let objD = Ad.init(withDictionary:dicts)
                                        if objD.id?.isEmpty ?? false {
                                            
                                        } else {
                                            self.arrAdsData.append(objD)
                                        }
                                        
                                        
                                        //self.arrAdsData.add(objD)
                                        self.lblNoAds.isHidden = true
                                        
                                    }
                                    self.tableView.reloadData()
                                }
                                
    
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
                            self.lblNoAds.isHidden = false
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
                    self.lblNoAds.isHidden = false
                    AppUtility.hideProgress()
                    
                    print(encodingError)
                    let alert = UIAlertController(title: "Zoolife", message:encodingError.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: Okey(), style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
        })
    }
    
    func AllItem_With_City()
    {
        
        var requestURL = URL(string: GET_ITEMS_BY_CITY)!
        if firsttime
        {
            if nextPage == nil || nextPage.count == 0
            {
                print("nextpageurl return")
                return
            }
            requestURL = URL(string: nextPage)!
            nextPage = ""
        }
        else{
            
            arrAdsData.removeAll()
        }
        AppUtility.showProgress()

        
        let headers = ["Content-Type": "application/json","X-Localization":"\(appLanguage)"]
        
        
        let paramDict = ["category_id": categoryID,
                         "subcategory_id": subCategoryID,
                         "city": cityName]

        
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

                        if((response.result.value) != nil){
                            
                            let swiftyJsonVar = JSON(response.result.value!)
                            print(swiftyJsonVar)

                            let dict = swiftyJsonVar.dictionaryValue
                            let message = dict["msg"]?.string
                            let error = dict["error"]?.bool
                            
                            AppUtility.hideProgress()
                            
                            if error == false
                            {
                                //let result: Dictionary<String, JSON> = swiftyJsonVar["data"].dictionaryValue
                                let data = JSON(dict["data"])
                                let dict2 = data.dictionaryValue
                                self.nextPage = dict2["next_page_url"]?.string ?? ""
                                print("\(dict2)")
                                print("nextpageurl \(self.nextPage)")
                                //let result: Dictionary<String, JSON> = swiftyJsonVar["data"].dictionaryValue
                                if let dataArray : [JSON] = (dict2["data"]?.arrayValue)
                                {
                                    self.lblNoAds.isHidden = false
                                    for dic in dataArray
                                    {
                                        let dicts: Dictionary<String, JSON> = dic.dictionaryValue
                                        let objD = Ad.init(withDictionary:dicts)
                                        if objD.id?.isEmpty ?? false {
                                            
                                        } else {
                                            self.arrAdsData.append(objD)
                                        }
                                        
                                        
                                        //self.arrAdsData.add(objD)
                                        self.lblNoAds.isHidden = true
                                        
                                    }
                                    self.tableView.reloadData()
                                }
                                
    
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
                            self.lblNoAds.isHidden = false
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
                    self.lblNoAds.isHidden = false
                    AppUtility.hideProgress()
                    
                    print(encodingError)
                    let alert = UIAlertController(title: "Zoolife", message:encodingError.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: Okey(), style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
        })
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

    func createDateTime(timestamp: String) -> String
    {
        var strDate = "undefined"
            
        if let unixTime = Double(timestamp) {
            let date = Date(timeIntervalSince1970: unixTime)
            let dateFormatter = DateFormatter()
            let timezone = TimeZone.current.abbreviation() ?? "CET"  // get current TimeZone abbreviation or set to CET
            dateFormatter.timeZone = TimeZone(abbreviation: timezone) //Set timezone that you want
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateFormat = "dd.MM.yyyy HH:mm" //Specify your format that you want
            strDate = dateFormatter.string(from: date)
        }
            
        return strDate
    }
    
    //MARK: - Button Actions
    @IBAction func backTapped(_ sender: Any)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
}


extension ExploreResultViewController : HomeDelegate {
    
    func updateLikePost(post: Ad, index: Int) {
        self.arrAdsData[index] = post
        self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
    }
    
    func updateReportStatus(post: Ad, index: Int) {
        self.arrAdsData[index] = post
        self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
    }
    
    func updatePost(post: Ad, index: Int) {
        self.arrAdsData[index] = post
        self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
    }
}

extension ExploreResultViewController: UITextFieldDelegate {
    //MARK:- UITextField Delegate Methods
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtCity{
            var word = "اختيار موقع"
            if appLanguage == "en" {
                word = "Choose a site"
            }
            ActionSheetStringPicker.show(withTitle: word, rows: arrCityNames, initialSelection: 0, doneBlock: {
                picker, indexes, values in
                
                self.cityName = values as! String
                self.txtCity.text = values as? String
                self.firsttime = false
                self.AllItem_With_City()
                return
            }, cancel: { ActionSheetStringPicker in return},origin: textField)
            return false
        }
        return true
    }
}
