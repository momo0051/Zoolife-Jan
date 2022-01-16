//
//  DeliveryPostViewController.swift
//  ZOOLIFE
//
//  Created by Muhammad Yousaf on 23/12/2020.
//  Copyright © 2020 Hafiz Anser. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import PopupDialog
import ActionSheetPicker_3_0


class DeliveryPostViewController: UIViewController {
    
    
    @IBOutlet weak var lbLocation: UILabel!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var topTableViewConstraints:NSLayoutConstraint!
    @IBOutlet weak var addPostButton:UIButton!
    
    var deliveryPost : [Ad]?
    var deliveryPostAll : [Ad]?
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var noDeliveryAvaiable:UILabel!
    var selectedIndex = 0
    @IBAction func locationTapped(_ sender: Any){
        
        let action = ActionSheetStringPicker(title: loc.choosSite.localized(), rows: arrCityNames, initialSelection: selectedIndex, doneBlock: {
            picker, indexes, values in
            
            self.selectedIndex = indexes
            self.lbLocation.text = values as! String?
            let val = self.lbLocation.text ?? ""
            var alt = ""
            if indexes < self.arrCityNamesAlt.count
            {
                alt = self.arrCityNamesAlt[indexes]
            }
            print("citynamecheck \(alt) ----- \(val) ---- \(self.deliveryPostAll?.count)")
            self.deliveryPost = [Ad]()
            if let all = self.deliveryPostAll
            {
                for post in all {
                    if let cityName = post.city
                    {
                        print("citynamecheck \(cityName)")
                        if cityName.compare(alt).rawValue == 0 || cityName.compare(val).rawValue == 0 || indexes == 0
                        {
                            self.deliveryPost?.append(post)
                        }
                    }
                }
            }
            
            
//            or dic in dataArray {
//                if !dic.isEmpty {
//                    let dicts: Dictionary<String, JSON> = dic.dictionaryValue
//                    let objD = Ad.init(withDictionary:dicts)
//                    self.deliveryPost?.append(objD)
//                    self.deliveryPostAll?.append(objD)
//                }
////                                  self.arrAdsData.add(objD)
//                self.noDeliveryAvaiable.isHidden = true
//
//            }
            self.tableView.reloadData()
            //self.getSubCategory()

            return
        }, cancel: { ActionSheetStringPicker in return},origin: sender)
        let doneButton:UIButton =  UIButton(type: .custom)
            doneButton.setTitle(appLanguage.compare("en").rawValue == 0 ? "Done" : "موافق", for: .normal)
        doneButton.setTitleColor(UIColor.blue, for: .normal)
        
        
        let cancelButton:UIButton =  UIButton(type: .custom)
        cancelButton.setTitle(appLanguage.compare("en").rawValue == 0 ? "Cancel" : "الغاء", for: .normal)
        cancelButton.setTitleColor(UIColor.blue, for: .normal)
        action?.setDoneButton(UIBarButtonItem(customView: doneButton))
        action?.setCancelButton(UIBarButtonItem(customView: cancelButton))
        action?.show()
    }
    
    var arrCityNames:[String] = []
    var arrCityData = NSMutableArray()
    func getCity()
    {
//        AppUtility.showProgress()
        getCityNotSelected()
        arrCityData.removeAllObjects()
        let requestURL = URL(string: GET_ALL_CITY)!
        print(requestURL)
        if appLanguage.compare("en").rawValue == 0
        {
            lbLocation.text = "All cities"
        }
        else{
            lbLocation.text = "كل المدن"
        }
        print("appLanguage \(appLanguage)")

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
                                self.arrCityNames.append(self.lbLocation.text ?? "")
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
    
    var arrCityNamesAlt:[String] = []
    var arrCityDataAlt = NSMutableArray()
    func getCityNotSelected()
    {
//        AppUtility.showProgress()
        
        arrCityDataAlt.removeAllObjects()
        let requestURL = URL(string: GET_ALL_CITY)!
        print(requestURL)
        let lan = appLanguage.compare("en").rawValue == 0 ? "ar" : "en"
        print("appLanguage \(appLanguage)")

        let headers = ["Content-Type": "application/json","X-Localization":"\(lan)"]
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
                                self.arrCityNamesAlt = []
                                self.arrCityNamesAlt.append(self.lbLocation.text ?? "")
                                for dic in dataArray {
                                    let dicts: Dictionary<String, JSON> = dic.dictionaryValue
                                    let objD = Category.init(withDictionary:dicts)
                                    self.arrCityDataAlt.add(objD)
                                    self.arrCityNamesAlt.append("\(dic["name"])")

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
    override func viewDidLoad() {
        super.viewDidLoad()

        self.deliveryPost = []
        self.deliveryPostAll = []
        tableView.tableFooterView = UIView()
        
        tableView.register(UINib(nibName: "DeliveryPostTableViewCell", bundle: nil), forCellReuseIdentifier: "DeliveryPostTableViewCell")

        getDeliveries()
        
        getCity()
       
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        UpdateLang_UI()
    }
    func UpdateLang_UI(){
        if let lang = UserDefaults.standard.object(forKey: "appLang") as? String {
            if lang == "en" {
                lblTitle.localizeKey = "Add Delivery Post"
                btnAdd.localizeKey = "ADD POST"
                noDeliveryAvaiable.localizeKey = "No Delivery availabe"
                UIView.appearance().semanticContentAttribute = .forceLeftToRight
            } else {
                lblTitle.localizeKey = "طلب توصيل/نقل"
                btnAdd.localizeKey = "اضافة اعلان توصيل"
                noDeliveryAvaiable.localizeKey = "لا توجد فئة فرعية مقابل هذه الفئة"
                UIView.appearance().semanticContentAttribute = .forceRightToLeft
            }
        } else {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }
    }
    
    
    
    @IBAction func addPostPopUp(_ sender: Any){
        
//
//        if AppUtility.getSession() == nil {
//
//        }
//
        if UserDefaults.standard.bool(forKey: "isLogin") == false{
            appDelegate.loadLogin()
            return
        }
        
        
        let datePicker = AddDeliveryPostViewController(nibName: "AddDeliveryPostViewController", bundle: nil)
        let popup = PopupDialog(viewController: datePicker, buttonAlignment: .horizontal, transitionStyle: .bounceUp, tapGestureDismissal: true)
        datePicker.delegate = self
//        let buttonOne = CancelButton(title: "CANCEL") {
//            print("You canceled the car dialog.")
//        }
//
//        // This button will not the dismiss the dialog
//        let buttonTwo = DefaultButton(title: "ADMIRE CAR", dismissOnTap: false) {
//            print("What a beauty!")
//        }
//
//        let buttonThree = DefaultButton(title: "BUY CAR", height: 60) {
//            print("Ah, maybe next time :)")
//        }
//
//        // Add buttons to dialog
//        // Alternatively, you can use popup.addButton(buttonOne)
//        // to add a single button
//        popup.addButtons([buttonOne, buttonTwo, buttonThree])
        
        self.present(popup, animated: true, completion: nil)
    }
    
    
    
    @IBAction func backTapped(_ sender: Any){
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    var nextPage = ""
    var firsttime = false
    func getDeliveries(){
        
        var requestURL = URL(string: GET_ALL_DELIVERIES)!
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
            print("nextpageurl removeAll")
            
            deliveryPost?.removeAll()
            deliveryPostAll?.removeAll()
        }
        AppUtility.showProgress()
        firsttime = true
        print("nextpageurl \(requestURL)")
//        else{
//
//            arrAdsData.removeAll()
//        }
        print(requestURL)
        
        let headers = ["Content-Type": "application/json","X-Localization":"\(appLanguage)"]
        
        var  paramDict = [:] as [String : Any]
        print(AppUtility.getSession()?.ID)
        if let u = AppUtility.getSession() {
            paramDict = ["user_id":u.ID ?? ""]
        }
        
        print("params",paramDict)
        
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
                
                print("nextpageurl response")
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
                                let data = JSON(dict["data"])
                                print(data)
                                let dict2 = data.dictionaryValue
                                self.nextPage = dict2["next_page_url"]?.string ?? ""
                                print("\(dict2)")
                                print("nextpageurl \(self.nextPage)")
                                
                                self.getDeliveries()
                                self.noDeliveryAvaiable.isHidden = false
                                if let dataArray : [JSON] = (dict2["data"]?.arrayValue)
                                {
                                    for dic in dataArray {
                                        if !dic.isEmpty {
                                            let dicts: Dictionary<String, JSON> = dic.dictionaryValue
                                            let objD = Ad.init(withDictionary:dicts)
                                            self.deliveryPostAll?.append(objD)
                                            self.deliveryPost?.append(objD)
                                        }
    //                                  self.arrAdsData.add(objD)
                                        self.noDeliveryAvaiable.isHidden = true
                                        
                                    }
                                    print("citynamecheck --- \(self.deliveryPostAll?.count)")
                                    print("citynamecheck --- \(self.deliveryPost?.count)")
                                    self.tableView.reloadData()
                                }
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

    
    
    
    func startChatAcion(post:Ad?){

        var user: User
        
        if let u = AppUtility.getSession() {
            user = u
            if user.ID == post?.fromUserId{
                return
            }
            startChat(user: user, post: post)
 
        }else{
            
            let alert = UIAlertController(title: "Zoolife", message:loc.mustLogin.localized(), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: Okey(), style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
 
        
        
    }
    
    func startChat(user: User,post:Ad?){
        let receiver:User = User(ID: post?.fromUserId, fullname: post?.username, email: post?.email, phone: post?.phone, avatar: post?.itemImage,msg_badge: "",noti_badge: "")

        if let post = post{
            AppUtility.showProgress()
            FirebaseNotificationServices.checkUserCreate(sender: user, recipient: receiver, post: post) { (success) in
                if let success = success
                {
                    
                    let uiConfig = ChatUIConfiguration(primaryColor: UIColor.colorWithHex(hexString: "#5574F7"),
                                                       secondaryColor: UIColor.colorWithHex(hexString: "#5574F7"),
                                                       inputTextViewBgColor: message_textfield_background_color,
                                                       inputTextViewTextColor: message_textfield_text_color,
                                                       inputPlaceholderTextColor: message_textfield_placeholder_color)

                    FirebaseNotificationServices.fetchChannel(channelId: success) { (channel) in
                        
                        print("channel ye ",channel)
                        
                        if let channel = channel{

                            let cv = ChatViewController()


                            cv.channel = channel
                            cv.user = user
                            cv.recipients = [receiver]
                            cv.uiConfig = uiConfig
                            cv.deviceToken = post.deviceToken
                            DispatchQueue.main.async {
                                AppUtility.hideProgress()
                            }

                            self.navigationController?.pushViewController(cv, animated: true)
                        }else{
                            print("not  found")
                            DispatchQueue.main.async {
                                AppUtility.hideProgress()
                            }
                        }
                    }
                }
            }
        }
    }


}



extension DeliveryPostViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let deliveryPost = self.deliveryPost{
            return deliveryPost.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var deliveryPost: Ad?
        deliveryPost = self.deliveryPost?[indexPath.item]
        var cell : DeliveryPostTableViewCell?

        cell = tableView.dequeueReusableCell(withIdentifier: "DeliveryPostTableViewCell", for: indexPath as IndexPath) as? DeliveryPostTableViewCell
        
        
        if let deliveryPost = deliveryPost{
            
            if let cell = cell{
//
                if let deliveryPost = self.deliveryPost{
                    if indexPath.row == (deliveryPost.count - 1)
                    {
                        getDeliveries()
                    }
                }
                cell.post = deliveryPost
                cell.setUpData()
                cell.delegate = self
                return cell
                
            }
        }
        
        
         return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}



extension DeliveryPostViewController:DeliveryCellDelegate{
    func whatsAppAction(post: Ad?) {
        
        if let phone = post?.phone{
            whatsAppCallAction(number: phone)
        }
    }
    
    func messageAction(post: Ad?) {
        startChatAcion(post: post)
    }
    
    func callAction(post: Ad?) {
        if let phone = post?.phone{
            let phoneNumber =  "+966\(phone)"
            dialNumber(number: phoneNumber)
        }
    }
    
    

    func deletePost(post: Ad?) {
        if let post = post{
            self.deleteDelivery(post: post)
        }
    }
    
    func deleteDelivery(post:Ad){
        AppUtility.showProgress()
        let requestURL = URL(string: DELETE_DELIVERY)!
        print(requestURL)
        
        let headers = ["Content-Type": "application/json","X-Localization":"\(appLanguage)"]
        
        var  paramDict = [:] as [String : Any]
        
        if let u = AppUtility.getSession() {
            paramDict = ["user_id":u.ID ?? "","id":post.id ?? ""]
        }else{
            return
        }
        
        print("params",paramDict)
        
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
                                self.getDeliveries()
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
    
    
}

extension DeliveryPostViewController:DeliveryPostDelegate{
    func reloadDeliveryPosts() {
        self.getDeliveries()
    }
}


protocol DeliveryPostDelegate {
    func reloadDeliveryPosts()
}
