//
//  MyAuctionListVC.swift
//  ZOOLIFE
//
//  Created by iMac on 03/12/21.
//  Copyright © 2021 Hafiz Anser. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class MyAuctionListVC: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {

    
    //MARK:- Outlet
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblNoDataFound: UILabel!
    @IBOutlet weak var collectionviewAUction: UICollectionView!
    
    //MARK:- Variable
    var arrAuctionList: [auctionList] = [auctionList]()

    //MARK:- UIView Controller Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let lang = UserDefaults.standard.object(forKey: "appLang") as? String {
            if lang == "en" {
                lblTitle.localizeKey = "My Auction"
                UIView.appearance().semanticContentAttribute = .forceLeftToRight
            } else {
                lblTitle.localizeKey = "المزاد الخاص بي"
                
                UIView.appearance().semanticContentAttribute = .forceRightToLeft
            }
        } else {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }
        collectionviewAUction.register(UINib(nibName: "AuctionCell", bundle: nil), forCellWithReuseIdentifier: "AuctionCell")
        self.getAds()
    }

    //MARK:- Other Mehtods
    func getAds (){
        
        self.arrAuctionList.removeAll()
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
        
        let  paramDict = ["user_id":user.ID!,
                          "auction":1] as [String : Any]

        
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
                                self.lblNoDataFound.isHidden = false
                                for dic in dataArray
                                {
                                    
                                    let objD = auctionList.init(fromDictionary: dic.dictionaryObject ?? [String:AnyObject]())
                                    
                                    self.arrAuctionList.append(objD)
                                    self.lblNoDataFound.isHidden = true
                                    
                                }
                                self.collectionviewAUction.reloadData()
                                
    
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
  

    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - Collection Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        
        return arrAuctionList.count
      
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        let cell: AuctionCell! = collectionView.dequeueReusableCell(withReuseIdentifier: "AuctionCell", for: indexPath as IndexPath) as? AuctionCell
        
        //            let objC:Ad = self.arrAdsData.object(at: indexPath.row) as! Ad
        
        var index = indexPath.row
     
        let objC:auctionList = self.arrAuctionList[index]
        
        
        cell.lblCity.text = objC.city ?? ""
        cell.lblTitle.text = objC.itemTitle ?? ""
        // let dateTime = createDateTime(timestamp: objC.createAt!)
        //            cell.lblDate.text = AppUtility.getFormattedDate(dateString: objC.createdAt ?? "")
        if appLanguage == "en" {
            cell.lblTitle.textAlignment = .left
        } else {
            cell.lblTitle.textAlignment = .right
        }
        
        if let lang = UserDefaults.standard.object(forKey: "appLang") as? String {
            if lang == "en" {
                cell.lblBid.localizeKey = "Min Bid : \(objC.minBid ?? 0)"
                UIView.appearance().semanticContentAttribute = .forceLeftToRight
            } else {
                cell.lblBid.localizeKey = "\(objC.minBid ?? 0) :اخر مزايدة"
                UIView.appearance().semanticContentAttribute = .forceRightToLeft
            }
        } else {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }
        
        cell.setTimer(expiryTime: objC.auctionExpiryTime ?? "")
        
        if let created_at = objC.createdAt {
            if let localDateAd = AppUtility.adFormattedDate(dateString: created_at){
                let localTimeAdString = TimeFormatHelper.timeAgoString(date: localDateAd)
                print(localTimeAdString)
                cell.lblDate.text = localTimeAdString
            }
        }
        
//        if objC.priority == "" || objC.priority == "0" {
            cell.crowImg.isHidden = true
//            cell.imgAd.borderWidth = 0
//            cell.imgAd.borderColor = UIColor.init(red: 235/255, green: 242/255, blue: 238/255, alpha: 1.0)
//        }else{
//            cell.crowImg.isHidden = false
//            cell.imgAd.borderWidth = 2
//            cell.imgAd.borderColor = UIColor.init(red: 239/255, green: 1, blue: 0, alpha: 1.0)
//        }
        
        if let imgUrl = objC.imgUrl{
            AppUtility.setImage(url:(imgUrl), image: cell.imgAd)
        }
//        if indexPath.row == (self.arrAuctionList.count - 1)
//        {
//            print("Calling Next Page")
//            self.AllItem_GetMethod()
//        }
        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let viewController = AddAuctionViewController()
        viewController.hidesBottomBarWhenPushed = true
        var index = indexPath.row
        
        viewController.post = self.arrAuctionList[index]
        viewController.editAd = true
        let selectedIndex = index
        
        viewController.deleteCallback =
        {
            print("delete callback")
            self.arrAuctionList.remove(at: selectedIndex)
            self.collectionviewAUction.reloadData()
        }
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        
        let width = CGFloat (collectionView.frame.size.width) / 2 - 5
        return CGSize (width: width, height: 325)
        
    }

}

