//
//  NotificatioViewController.swift
//  ZOOLIFE
//
//  Created by Hafiz Anser  on 11/20/20.
//  Copyright © 2020 Hafiz Anser. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class NotificatioViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var lblCenterText: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    var arrData = NSMutableArray()
    @IBOutlet weak var lblNoData: UILabel!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
      
        if UserDefaults.standard.bool(forKey: "isLogin") == false{
            appDelegate.loadLogin()
        }else{
            tableView.register(UINib(nibName: "NotificationCell", bundle: nil), forCellReuseIdentifier: "NotificationCell")
            self.tableView.rowHeight = UITableView.automaticDimension
            tableView.estimatedRowHeight = 78
            tableView.tableFooterView = UIView()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getNotification()
        self.UpdateLang_UI()
        clearBadgesNotificationForcedNotificationTab()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        clearBadgesNotificationForcedNotificationTab()
    }
    
    // MARK: - Custome Function
    func UpdateLang_UI(){
        if let lang = UserDefaults.standard.object(forKey: "appLang") as? String {
            if lang == "en" {
                lblTitle.localizeKey = "Notification"
                lblCenterText.localizeKey = "There are no notifications available right now"
                UIView.appearance().semanticContentAttribute = .forceLeftToRight
            } else {
                lblTitle.localizeKey = "الإشعارات"
                lblCenterText.localizeKey = "لا توجد إشعارات متاحة الآن"
                UIView.appearance().semanticContentAttribute = .forceRightToLeft
            }
        } else {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }
       
    }

    // MARK: - TableView Delegate
     func numberOfSections(in tableView: UITableView) -> Int{
        return 1
     }
     
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return arrData.count
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        var cell: NotificationCell! = tableView.dequeueReusableCell(withIdentifier: "NotificationCell") as? NotificationCell
        if (cell == nil)
        {
            cell = NotificationCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: "NotificationCell")
        }

        let objC:NotificationModel = self.arrData.object(at: indexPath.row) as! NotificationModel
        
        if let isRead = objC.isread{
            if isRead == 0 {
                cell.backgroundColor = .white
                cell.lbldescrition.textColor = .black
                cell.lblDateTime.textColor = .black
                cell.lbldescrition.font = .systemFont(ofSize: 18)
                cell.lblDateTime.font = .systemFont(ofSize: 13)
            }else{
                cell.backgroundColor = .lightGray
        
                cell.lbldescrition.textColor = .darkGray
                cell.lblDateTime.textColor = .darkGray
                
                cell.lbldescrition.font = .boldSystemFont(ofSize: 18)
                cell.lblDateTime.font = .boldSystemFont(ofSize: 13)
            }
        }

//        cell.lblDateTime.text = objC.created_at
        cell.lbldescrition.text = objC.content
        
        if let created_at = objC.created_at{
            if let localDateAd = AppUtility.adFormattedDate(dateString: created_at){
            
                let localTimeAdString = TimeFormatHelper.timeAgoString(date: localDateAd)
                print(localTimeAdString)
                
                cell.lblDateTime.text = localTimeAdString
            }
        }
        
        
        cell.selectionStyle = .none

        return cell
     }
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
       // return 80
        return UITableView.automaticDimension
     }
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let objC:NotificationModel = self.arrData.object(at: indexPath.row) as! NotificationModel
        let viewController = AdDetailViewController()
        viewController.hidesBottomBarWhenPushed = true
        viewController.isComingFromMyAds = true
        viewController.postId = String(objC.ads_id ?? 0)
        self.navigationController?.pushViewController(viewController, animated: true)
        
        
     }
    
    
    func getNotification (){
        
        AppUtility.showProgress()
        let requestURL = URL(string: GET_ALL_NOTIFICATIONS_BY_USERID)!
        print(requestURL)

        var user: User
        
        if let u = AppUtility.getSession() {
            user = u
        }else{
            return
        }
        
        let headers = ["Content-Type": "application/json","X-Localization":"\(appLanguage)"]
        
        let  paramDict = ["user_id":user.ID!] as [String : Any]

        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in paramDict{
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
                            
                            if error == false{
                                //let result: Dictionary<String, JSON> = swiftyJsonVar["data"].dictionaryValue
                                let dataArray : [JSON] = (dict["data"]?.arrayValue)!
                                self.lblNoData.isHidden = false
                                self.arrData.removeAllObjects()
                                for dic in dataArray{
                                    let dicts: Dictionary<String, JSON> = dic.dictionaryValue
                                    let objD = NotificationModel.init(withDictionary:dicts)
                                    
                                    self.arrData.add(objD)
                                    self.lblNoData.isHidden = true
                                    
                                }
                                self.tableView.reloadData()
                                
    
                                return
                            }
                            else{
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

}
