//
//  HomeSearchViewController.swift
//  ZOOLIFE
//
//  Created by Hafiz Anser  on 11/29/20.
//  Copyright © 2020 Hafiz Anser. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class HomeSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var tfSearchT: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var arrAdsData = [Ad]()
    @IBOutlet weak var lblNoAds: UILabel!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "AdsCell", bundle: nil), forCellReuseIdentifier: "AdsCell")
        self.navigationController?.isNavigationBarHidden = true
        UIView.appearance().semanticContentAttribute = .forceRightToLeft
        
        lblNoAds.isHidden = true
    }
    
    
    //MARK: - Button Actions
    
    @IBAction func backTapped(_ sender: Any){
        _ = self.navigationController?.popViewController(animated: true)
    }
    @IBAction func searchTapped(_ sender: Any){
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
        
        if indexPath.row == (self.arrAdsData.count - 1)
        {
            getSearch()
        }
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
    var nextPage = ""
    var firsttime = false

    //MARK: - Functions
    func getSearch (){
        var requestURL = URL(string: ITEM_SEARCH)!
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
//        arrAdsData.removeAll()
//        arrAdsData.removeAllObjects()
//        let requestURL = URL(string: ITEM_SEARCH)!
        print(requestURL)
        

//        let user:User = AppUtility.getSession()

        
        let headers = ["Content-Type": "application/json","X-Localization":"\(appLanguage)"]
        
        let  paramDict = ["search":tfSearchT.text!,"user_id": AppUtility.getSession()?.ID] as [String : Any]

        
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
                                
                                let data = JSON(dict["data"])
                                let dict2 = data.dictionaryValue
                                self.nextPage = dict2["next_page_url"]?.string ?? ""
                                print("\(dict2)")
                                print("nextpageurl \(self.nextPage)")
                                //let result: Dictionary<String, JSON> = swiftyJsonVar["data"].dictionaryValue
                                if let dataArray : [JSON] = (dict2["data"]?.arrayValue)
                                {
                                    //let result: Dictionary<String, JSON> = swiftyJsonVar["data"].dictionaryValue
//                                    let dataArray : [JSON] = (dict["data"]?.arrayValue)!
                                    self.lblNoAds.isHidden = false
                                    for dic in dataArray
                                    {
                                        let dicts: Dictionary<String, JSON> = dic.dictionaryValue
                                        let objD = Ad.init(withDictionary:dicts)
                                        
                                        self.arrAdsData.append(objD)
    //                                    self.arrAdsData.add(objD)
                                        self.lblNoAds.isHidden = true
                                        
                                    }
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
    
  
    func CheckFields() -> Bool
    {
        if (tfSearchT.text?.trimmingCharacters(in: .whitespaces).isEmpty)!
        {
            let alert = UIAlertController(title: "", message: loc.EnterTextToFindJob.localized(), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: Okey(), style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            let test = false
            return test
        }
        
        let test = true
        return test
    }

}


extension HomeSearchViewController : HomeDelegate {
    
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
