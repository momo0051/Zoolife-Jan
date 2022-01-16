//
//  MissingPostViewController.swift
//  ZOOLIFE
//
//  Created by Muhammad Yousaf on 11/01/2021.
//  Copyright © 2021 Hafiz Anser. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MissingPostViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var lblCenterText: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    var arrAdsData = [Ad]()
    @IBOutlet weak var lblNoAds: UILabel!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "AdsCell", bundle: nil), forCellReuseIdentifier: "AdsCell")
        self.navigationController?.isNavigationBarHidden = true
        UIView.appearance().semanticContentAttribute = .forceRightToLeft
        getAds()
        lblNoAds.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        self.UpdateLang_UI()
    }
    func UpdateLang_UI(){
        if let lang = UserDefaults.standard.object(forKey: "appLang") as? String {
            if lang == "en" {
                lblCenterText.localizeKey = "There are no ads"
                lblTitle.localizeKey = "Missing report"                
                UIView.appearance().semanticContentAttribute = .forceLeftToRight
            } else {
                lblCenterText.localizeKey = "لا يوجد اعلانات"
                lblTitle.localizeKey = "بلاغ مفقود"
                UIView.appearance().semanticContentAttribute = .forceRightToLeft
            }
        } else {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }
    }
  
    
    
    //MARK: - Button Actions
    
    @IBAction func backTapped(_ sender: Any){
        _ = self.navigationController?.popViewController(animated: true)
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
//        viewController.hidesBottomBarWhenPushed = true
        
        viewController.missingPost = true
        viewController.post = post //as? Ad
        viewController.delegate = self
        viewController.indexSelected = indexPath.row
        self.navigationController?.pushViewController(viewController, animated: true)
     }
     



}


extension MissingPostViewController : HomeDelegate {
    
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


extension MissingPostViewController{
    
    
    func getAds (){
        AppUtility.showProgress()
        arrAdsData.removeAll()
        let requestURL = URL(string: GET_ALL_ITEMS_BY_CATEGORY)!
        print(requestURL)
 
        let headers = ["Content-Type": "application/json","X-Localization":"\(appLanguage)"]
        
        var  paramDict = [:] as [String : Any]
        if let u = AppUtility.getSession() {
            paramDict = ["category_id": "98"]
        }else{
            paramDict = ["category_id": "98"]
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
                                //let result: Dictionary<String, JSON> = swiftyJsonVar["data"].dictionaryValue
                                let dataArray : [JSON] = (dict["data"]?.arrayValue)!
                                self.lblNoAds.isHidden = false
                               // self.tableView.isHidden = true
                                for dic in dataArray{
                                    let dicts: Dictionary<String, JSON> = dic.dictionaryValue
                                    let objD = Ad.init(withDictionary:dicts)
                                    if objD.id?.isEmpty ?? false {
                                        
                                    } else {
                                        self.arrAdsData.append(objD)
                                    }
                                    
                                   
                                    self.lblNoAds.isHidden = true
                                  //  self.tableView.isHidden = false
                                    
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
        })
    }
    
}
