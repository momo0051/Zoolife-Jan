//
//  ExploreViewController.swift
//  ZOOLIFE
//
//  Created by Hafiz Anser  on 11/26/20.
//  Copyright © 2020 Hafiz Anser. All rights reserved.
//

import UIKit
import Alamofire
import ActionSheetPicker_3_0
import SwiftyJSON

class ExploreViewController: UIViewController{
    
    
    
    //These are SearchViewControllers
    
    @IBOutlet weak var tfSearchT: UITextField!
    @IBOutlet weak var tableView: UITableView!

    var arrAdsData = [Ad]()
    @IBOutlet weak var lblNoAds: UILabel!

    @IBOutlet weak var searchView: UIView!

    
    //Till Here
    
    
    @IBOutlet weak var exploreView: UIView!
    
    @IBOutlet weak var btnLocation: UIButton!
    @IBOutlet weak var btnSubCategory: UIButton!
    @IBOutlet weak var btnCategory: UIButton!
    
    
    var arrCategoryData = NSMutableArray()
    var arrSubCategoryData = NSMutableArray()
    var categoryID = ""
    var subCategoryID = ""
    var cityName = ""
    

    var arrCategory = [Any]()
    var arrSubCategory = [Any]()
    
    
    
    var arrCityNames = ["الرياض","الشرقية","جدة","مكة","ينبع","حفر الباطن","المدينة","الطائف","تبوك","القصيم","حائل","ابها","الباحة","جيزان","نجران","الجوف","عرعر","الكويت","الأمارات","البحرين"]
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        
        self.navigationController?.isNavigationBarHidden = true
        UIView.appearance().semanticContentAttribute = .forceRightToLeft
        
        btnCategory.contentHorizontalAlignment = .right
        btnSubCategory.contentHorizontalAlignment = .right
        btnLocation.contentHorizontalAlignment = .right
        
        getCategory ()
        
        
        //These are SearchViewControllers
        tableView.register(UINib(nibName: "AdsCell", bundle: nil), forCellReuseIdentifier: "AdsCell")
        self.navigationController?.isNavigationBarHidden = true
        UIView.appearance().semanticContentAttribute = .forceRightToLeft

        lblNoAds.isHidden = true
        
        
        //Till Here
        
    }
    
 
    
    func getSubCategory (categoryID: String){
        
        AppUtility.showProgress()
        
        arrSubCategoryData.removeAllObjects()
        
        let requestURL = URL(string: GET_SUB_CATEGORIES)!
        print(requestURL)
        

        let headers = ["Content-Type": "application/json","X-Localization":"\(appLanguage)"]
        let paramDict = ["category_id":categoryID] as [String : Any]
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
                            let message = dict["msg"]?.string
                            let error = dict["error"]?.bool
                            
                            AppUtility.hideProgress()
                            
                            if error == false
                            {
                                //let result: Dictionary<String, JSON> = swiftyJsonVar["data"].dictionaryValue
                                let dataArray : [JSON] = (dict["data"]?.arrayValue)!
                                
                                for dic in dataArray
                                {
                                    let dicts: Dictionary<String, JSON> = dic.dictionaryValue
                                    let objD = SubCategory.init(withDictionary:dicts)
                                    
                                    self.arrSubCategoryData.add(objD)
                                    self.arrSubCategory.append(objD.title!)
                                    
                                }
                                //self.collectionSubCategory.reloadData()
                                
    
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
    
    func getCategory ()
    {
        AppUtility.showProgress()
        
        arrCategoryData.removeAllObjects()
        let requestURL = URL(string: GET_ALL_CATEGORIES)!
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
                            let message = dict["msg"]?.string
                            let error = dict["error"]?.bool
                            
                            AppUtility.hideProgress()
                            
                            if error == false
                            {
                                //let result: Dictionary<String, JSON> = swiftyJsonVar["data"].dictionaryValue
                                let dataArray : [JSON] = (dict["data"]?.arrayValue)!
                                
                                for dic in dataArray
                                {
                                    let dicts: Dictionary<String, JSON> = dic.dictionaryValue
                                    let objD = Category.init(withDictionary:dicts)
                                    
                                    self.arrCategoryData.add(objD)
                                    self.arrCategory.append(objD.title!)

                                }
                                //self.collectionCategory.reloadData()
                                
    
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
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
        })
    }
    
    //MARK: - Button Actions
    @IBAction func backTapped(_ sender: Any)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    @IBAction func locationTapped(_ sender: Any)
    {
        ActionSheetStringPicker.show(withTitle: "اختيار موقع", rows: arrCityNames, initialSelection: 0, doneBlock: {
            picker, indexes, values in

            self.btnLocation.setTitle(values as! String?, for: .normal)
            self.btnLocation.setTitleColor(UIColor.black, for: .normal)
            self.cityName = values as! String
            //self.getSubCategory()

            return
        }, cancel: { ActionSheetStringPicker in return},origin: sender)
    }
    @IBAction func categoryTapped(_ sender: Any)
    {
        if arrCategory.count == 0
        {
            getCategory()
        }
        else
        {
            ActionSheetStringPicker.show(withTitle: "اختر الفئة", rows: arrCategory, initialSelection: 0, doneBlock: {
                picker, indexes, values in

                let objC:Category = self.arrCategoryData.object(at: indexes) as! Category
                if objC.title! == values as! String
                {
                    self.categoryID = objC.id!
                }

                self.btnCategory.setTitle(values as! String?, for: .normal)
                self.btnCategory.setTitleColor(UIColor.black, for: .normal)
                self.getSubCategory(categoryID: self.categoryID)

                return
            }, cancel: { ActionSheetStringPicker in return},origin: sender)
            
        }
    
    }
    @IBAction func subCategoryTapped(_ sender: Any)
    {
        if btnCategory.titleLabel?.text == "اختر الفئة"
        {
            var word = "الرجاء تحديد الفئة أولا"
                        if appLanguage == "en" {
                            word = "Please select the category first."
                        }
            let alert = UIAlertController(title:"", message:word, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: Okey(), style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
        else
        {
            if arrSubCategory.count == 0
            {
                self.getSubCategory(categoryID: categoryID)
            }
            else
            {
                var word = "حدد فئة فرعية"
                            if appLanguage == "en" {
                                word = "Select subcategory"
                            }
                ActionSheetStringPicker.show(withTitle: word, rows: arrSubCategory, initialSelection: 0, doneBlock: {
                    picker, indexes, values in

                    let objC:SubCategory = self.arrSubCategoryData.object(at: indexes) as! SubCategory
                    if objC.title! == values as! String
                    {
                        self.subCategoryID = objC.id!
                    }
                    
                    self.btnSubCategory.setTitleColor(UIColor.black, for: .normal)
                    self.btnSubCategory.setTitle(values as! String?, for: .normal)

                    return
                }, cancel: { ActionSheetStringPicker in return},origin: sender)
            }
        }
    }
    
    @IBAction func searchTapped(_ sender: Any)
    {
//        if btnLocation.titleLabel?.text == "اختيار موقع" || btnCategory.titleLabel?.text == "اختر الفئة" || btnSubCategory.titleLabel?.text == "حدد فئة فرعية"
        if categoryID.isEmpty || subCategoryID.isEmpty || cityName.isEmpty
        {
            var word = "الرجاء اختيار الموقع أو الفئة أو الفئة الفرعية"
                        if appLanguage == "en" {
                            word = "Please select a site, category, or sub-category"
                        }
            let alert = UIAlertController(title: "", message: word, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: Okey(), style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            let viewController = ExploreResultViewController()
            viewController.categoryID = categoryID
            viewController.subCategoryID = subCategoryID
            viewController.cityName = cityName
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
}




import UIKit
import SwiftyJSON
import Alamofire

extension ExploreViewController: UITableViewDelegate, UITableViewDataSource{



    @IBAction func searchHeaderTapped(_ sender: Any){
        if CheckFields(){
            getSearch()
        }
    }

    // MARK: - TableView Delegate
     func numberOfSections(in tableView: UITableView) -> Int{
        return 1
     }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return arrAdsData.count
     }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{

        var cell: AdsCell! = tableView.dequeueReusableCell(withIdentifier: "AdsCell") as? AdsCell
        if (cell == nil)
        {
            cell = AdsCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: "AdsCell")
        }


        let objC:Ad = self.arrAdsData[indexPath.row]
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
        
        if objC.priority == "" || objC.priority == "0"{
            cell.backgroundColor = .white
            
            cell.backView.borderWidth = 0
            cell.backView.borderColor = .clear
            cell.backView.cornerRadius = 0
            
            cell.separator(hide: false)
        }else{
            cell.backgroundColor = UIColor.colorWithHex(hexString: "#fdf9e0")
            
            cell.backView.borderWidth = 1
            cell.backView.borderColor = UIColor.colorWithHex(hexString: "#FFD700")
            cell.backView.cornerRadius = 4
            
            cell.separator(hide: true)
        }
        cell.selectionStyle = .none
        return cell
     }
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
     {
        return 110
     }
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let post = self.arrAdsData[indexPath.row]

        let viewController = AdDetailViewController()//PostDetailViewController()
        viewController.hidesBottomBarWhenPushed = true
        viewController.post = post //as? Ad
        viewController.delegate = self
        viewController.indexSelected = indexPath.row
        self.navigationController?.pushViewController(viewController, animated: true)
     }


    //MARK: - Functions
    func getSearch (){

        AppUtility.showProgress()
        arrAdsData.removeAll()
//        arrAdsData.removeAllObjects()
        let requestURL = URL(string: ITEM_SEARCH)!
        print(requestURL)


//        let user:User = AppUtility.getSession()


        let headers = ["Content-Type": "application/json","X-Localization":"\(appLanguage)"]
        let user = AppUtility.getSession()
        let  paramDict = ["search":tfSearchT.text!,"user_id": user!.ID ?? ""] as [String : Any]


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
                            let message = dict["msg"]?.string
                            let error = dict["error"]?.bool

                            AppUtility.hideProgress()

                            if error == false
                            {
                                //let result: Dictionary<String, JSON> = swiftyJsonVar["data"].dictionaryValue
                                let dataArray : [JSON] = (dict["data"]?.arrayValue)!
                                self.lblNoAds.isHidden = false
                                for dic in dataArray
                                {
                                    let dicts: Dictionary<String, JSON> = dic.dictionaryValue
                                    let objD = Ad.init(withDictionary:dicts)

                                    self.arrAdsData.append(objD)
//                                    self.arrAdsData.add(objD)
                                    self.lblNoAds.isHidden = true

                                }
                                self.tableView.reloadData()


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


    func createDateTime(timestamp: String) -> String{

        var strDate = "undefined"

        if let unixTime = Double(timestamp) {
            let date = Date(timeIntervalSince1970: unixTime)
            let dateFormatter = DateFormatter()
            let timezone = TimeZone.current.abbreviation() ?? "CET"  // get current TimeZone abbreviation or set to CET
            dateFormatter.timeZone = TimeZone(abbreviation: timezone) //Set timezone that you want
            dateFormatter.locale = NSLocale.current
            //dateFormatter.dateFormat = "dd.MM.yyyy HH:mm" //Specify your format that you want
            dateFormatter.dateFormat = "EEEE, MMM d, 2020" //Specify your format that you want
            strDate = dateFormatter.string(from: date)
        }

        return strDate
    }


    func CheckFields() -> Bool{

        if (tfSearchT.text?.trimmingCharacters(in: .whitespaces).isEmpty)!
        {
            var word = "الرجاء إدخال النص للعثور على الوظائف"
                        if appLanguage == "en" {
                            word = "Please enter text to find jobs"
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

}


extension ExploreViewController : HomeDelegate {

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


extension ExploreViewController{
    
    //MARK: TextField
      @IBAction func searchEditingChangeAction(_ sender: UITextField) {
    
        if let text = self.tfSearchT.text{
            
            if text.isEmpty{
                self.arrAdsData.removeAll()
                self.tableView.reloadData()
                self.searchView.isHidden = true
                self.exploreView.isHidden = false
                
            }else{
                self.searchView.isHidden = false
                self.exploreView.isHidden = true
                if text.count > 4{
                    self.getSearch()
                }
              
            }
            
        }
    }
    
}
