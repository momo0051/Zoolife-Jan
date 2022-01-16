
//
//  MyAdsViewController.swift
//  ZOOLIFE
//
//  Created by Hafiz Anser  on 11/27/20.
//  Copyright © 2020 Hafiz Anser. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class MyAdsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var arrAdsData = [Ad]()
    @IBOutlet weak var lblNoAds: UILabel!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.tableView.tableFooterView = UIView()
        lblNoAds.isHidden = true
        getAds()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UpdateLang_UI()
    }
    
    func UpdateLang_UI(){
        if let lang = UserDefaults.standard.object(forKey: "appLang") as? String {
            if lang == "en" {
                lblTitle.localizeKey = "My Ads"
                lblNoAds.localizeKey = "No Ads Found"
                UIView.appearance().semanticContentAttribute = .forceLeftToRight
            } else {
                lblTitle.localizeKey = "إعلاناتي"
                lblNoAds.localizeKey = "لا يوجد اعلانات"
                UIView.appearance().semanticContentAttribute = .forceRightToLeft
            }
        } else {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }
    }
    @IBAction func backTapped(_ sender: Any){
        _ = self.navigationController?.popViewController(animated: true)
    }
    // MARK: - TableView Delegate
     func numberOfSections(in tableView: UITableView) -> Int{
        
        return 1
        
     }
     
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        if arrAdsData.count > 0
        {
            self.lblNoAds.isHidden = true
        }
        else
        {
            self.lblNoAds.isHidden = false
        }
        
        return arrAdsData.count
     }
     
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
        
        let objC = self.arrAdsData[indexPath.row]
        
        cell.lblUserName.text = objC.username!
        cell.lblCity.text = objC.city
        cell.lblTitle.text = objC.itemTitle!

        cell.lblDate.text = AppUtility.getFormattedDate(dateString: objC.created_at ?? "")
        
        if let created_at = objC.created_at {
            if let localDateAd = AppUtility.adFormattedDate(dateString: created_at){
                let localTimeAdString = TimeFormatHelper.timeAgoString(date: localDateAd)
                print(localTimeAdString)
                cell.lblDate.text = localTimeAdString
            }
        }
        
        
        
        
        if let imgUrl = objC.imgUrl{
            AppUtility.setImage(url:(imgUrl), image: cell.imgAd)
        }
        
        if let imgUrl = objC.imgUrl{
            AppUtility.setImage(url:(imgUrl), image: cell.imgAd)
        }
        cell.selectionStyle = .none
        
        return cell
    }
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        return 140
        
     }
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
//        let viewController = PostDetailViewController()
//        viewController.hidesBottomBarWhenPushed = true
//        viewController.isComingFromMyAds = true
//        self.navigationController?.pushViewController(viewController, animated: true)
        
        
        let viewController = AddAdViewController()
        viewController.hidesBottomBarWhenPushed = true
        viewController.post = self.arrAdsData[indexPath.row]
        viewController.editAd = true
        let selectedIndex = indexPath.row
        
        viewController.deleteCallback =
        {
            print("delete callback")
            self.arrAdsData.remove(at: selectedIndex)
            self.tableView.reloadData()
        }
        self.navigationController?.pushViewController(viewController, animated: true)
        
     }
    
    func getAds (){
        
        self.arrAdsData.removeAll()
        AppUtility.showProgress()
        let requestURL = URL(string: GET_POST_BY_USER)!
        print(requestURL)
        

//        let user:User = AppUtility.getSession()
        var user: User
        
        if let u = AppUtility.getSession() {
            user = u
        }else{
            return
        }
        
        let headers = ["Content-Type": "application/json","X-Localization":"\(appLanguage)"]
        
        let  paramDict = ["user_id":user.ID!] as [String : Any]

        
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
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String?
        {
            return "حذف الاعلان"
        }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
          let objC:Ad = self.arrAdsData[indexPath.row]
            
            let alert = UIAlertController(title: "Zoo Life", message: loc.deleteExt.localized(), preferredStyle: .alert)
            
            let confirmAction = UIAlertAction(title: Okey(), style: .destructive) { (_) in
                self.deleteAd(adId: objC.id!,indexPath: indexPath)
            }
            
            let cancelAction = UIAlertAction(title: Cancel(), style: .cancel,handler: nil)
            
            alert.addAction(cancelAction)
            alert.addAction(confirmAction)
            
            present(alert, animated: true, completion: nil)
          
        }
      }
      func deleteAd (adId : String,indexPath: IndexPath){
        AppUtility.showProgress()
        let requestURL = URL(string: DELETE_ITEM)!
        print(requestURL)
    //    let user:User = AppUtility.getSession()
        var user: User
        if let u = AppUtility.getSession() {
          user = u
        }else{
          return
        }
        print(user.ID!)
        let headers = ["Content-Type": "application/json","X-Localization":"\(appLanguage)"]
        let paramDict = [
                 "user_id":user.ID!,
                 "id": adId] as [String : Any]
        print(paramDict)
        print(paramDict)
        Alamofire.upload(multipartFormData: { (multipartFormData) in
          for (key, value) in paramDict
          {
            multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
          }
        },      usingThreshold:UInt64.init(),
          to: requestURL ,
          method:.post,
          headers:headers,
          encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
              upload.responseJSON { response in
                print("response JSON: ‘\(response)‘")
                if((response.result.value) != nil)
                {
                  let swiftyJsonVar = JSON(response.result.value!)
                  print(swiftyJsonVar)
                  let dict = swiftyJsonVar.dictionaryValue
                  let message = dict["msg"]?.string
                  let error = dict["error"]?.bool
                  AppUtility.hideProgress()
                  if error == false {
                    self.arrAdsData.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                    let alert = UIAlertController(title: "ZOO LIFE", message:"تم حذف الإعلان بنجاح", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: Okey(), style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
                  } else {
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
                  print("response JSON: ‘\(result)’")
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

}
