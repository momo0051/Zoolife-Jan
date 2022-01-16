//
//  AuctionListViewController.swift
//  ZOOLIFE
//
//  Created by iMac on 30/11/21.
//  Copyright © 2021 Hafiz Anser. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import Alamofire
import SwiftyJSON
import GoogleMobileAds
class AuctionListViewController: UIViewController, UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {

    //MARK:- Outlet
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var viewCityBG: UIView!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var viewCategoryBG: UIView!
    @IBOutlet weak var txtCategory: UITextField!
    @IBOutlet weak var collectionviewAUction: UICollectionView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblNoDataFound: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //MARK: - Actions
    @IBAction func actionAdd(_ sender: Any) {
        if UserDefaults.standard.bool(forKey: "isLogin") == false{
            appDelegate.loadLogin()
        }else{
            let viewController = AddAuctionViewController()
            viewController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    //MARK:- Variable
    var arrCityData = NSMutableArray()
    var arrCategoryData = NSMutableArray()
    
    var arrCategory = [Any]()
    var arrCityNames:[String] = []
    var arrCityId:[String] = []
    var arrAuctionList: [auctionList]?
    var filteredArrAuctionList: [auctionList]?
    var isSearching = false
    var cityName = ""
    var cityId = ""
    var categoryID = ""
    var nextPage = ""
    var firsttime = false
    var nativeAdView: GADNativeAdView!
    var adLoader: GADAdLoader = GADAdLoader()
    let adUnitID = "ca-app-pub-3940256099942544/3986624511"
    var nativeAds = [GADNativeAd]()
    //MARK:- UIView Controller Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        loadNativeAds()
        self.setUI()
        self.arrAuctionList = []
        self.filteredArrAuctionList = []
        collectionviewAUction.register(UINib(nibName: "AuctionCell", bundle: nil), forCellWithReuseIdentifier: "AuctionCell")
        getCategory()
        getCity()
        self.AllItem_GetMethod()
        
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 20))
        tfSearch.rightView = paddingView
        tfSearch.leftView = paddingView
        tfSearch.leftViewMode = .always
        tfSearch.rightViewMode = .always
        
        if let lang = UserDefaults.standard.object(forKey: "appLang") as? String {
            if lang == "en" {
                tfSearch.textAlignment = .left
                lblTitle.localizeKey = "Auction"
                txtCity.placeholder = "City"
                tfSearch.localizeKey = "Search"
                txtCategory.placeholder = "Category"
                UIView.appearance().semanticContentAttribute = .forceLeftToRight
            } else {
                lblTitle.localizeKey = "مزاد علني"
                txtCity.placeholder = "مدينة"
                tfSearch.localizeKey = "بحث"
                tfSearch.textAlignment = .right
                txtCategory.placeholder = "الفئة"
                UIView.appearance().semanticContentAttribute = .forceRightToLeft
            }
        } else {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }
    }
    
    //MARK:- Setup UI
    func setUI(){
        viewCityBG.layer.cornerRadius = 10.0
        viewCategoryBG.layer.cornerRadius = 10.0
    }

    //MARK:- Custom Action
    func AllItem_GetMethod() {
        var requestURL = URL(string: GET_ALL_AUCTION_ITEMS)!
        
        if firsttime
        {
            if nextPage.isEmpty
            {
                print("nextpageurl return")
                return
            }
            requestURL = URL(string: nextPage)!
            nextPage = ""
        }
        else{
            
            arrAuctionList?.removeAll()
            
            self.collectionviewAUction.reloadData()
            self.viewWillLayoutSubviews()
            
        }
        AppUtility.showProgress()
        firsttime = true
        print("nextpageurl \(requestURL)")
        var paramDict = [:] as [String : Any]
        paramDict["category"] = categoryID
        paramDict["city_id"] = cityName
        let headers = ["Content-Type": "application/json","X-Localization":"\(appLanguage)"]
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in paramDict
            {
                multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
            }
        },usingThreshold:UInt64.init(),
            to: requestURL ,
            method:.post,
            headers:headers,
            encodingCompletion: { encodingResult in

                switch encodingResult {
                case .success(let upload, _, _):

                    upload.responseJSON { response in

                        print("response JSONgetAds: '\(response)'")

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
                                
                                self.lblNoDataFound.isHidden = true
                                let data = JSON(dict["data"])
                                let dict2 = data.dictionaryValue
                                self.nextPage = dict2["next_page_url"]?.string ?? ""
                                print("\(dict2)")
                                print("nextpageurl \(self.nextPage)")
                                //let result: Dictionary<String, JSON> = swiftyJsonVar["data"].dictionaryValue
                                if let dataArray : [JSON] = (dict2["data"]?.arrayValue)
                                {
                                    self.lblNoDataFound.isHidden = true
                                    for dic in dataArray
                                    {
                                        let objD = auctionList.init(fromDictionary: dic.dictionaryObject ?? [String:AnyObject]())
                                        self.arrAuctionList?.append(objD)
                                    }
                                    DispatchQueue.main.async {
                                        self.collectionviewAUction.reloadData()
                                       
                                    }
                                }else{
                                    self.lblNoDataFound.isHidden = false
                                }
                                return
                            }
                            else
                            {
                                self.lblNoDataFound.isHidden = false
                                let alert = UIAlertController(title: "Zoolife", message:message, preferredStyle: UIAlertController.Style.alert)
                                alert.addAction(UIAlertAction(title:  Okey(), style: UIAlertAction.Style.default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                                
                            }
                        }
                        else
                        {
                            AppUtility.hideProgress()
                            self.lblNoDataFound.isHidden = false
                            let result = response.result
                            print("response JSON: '\(result)'")
                            //let userInfo = response.error as? Error
                            let error = response.error

//                            let alert = UIAlertController(title: "Zoolife", message:error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
//                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
//                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                case .failure(let encodingError):
                    AppUtility.hideProgress()
                    self.lblNoDataFound.isHidden = false
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
                                    self.arrCityId.append("\(dic["id"])")
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
    func loadNativeAds(){
        collectionviewAUction.register(UINib(nibName: "NativeAdsCollectionCell", bundle: nil), forCellWithReuseIdentifier: "NativeAdsCollectionCell")
        guard
          let nibObjects = Bundle.main.loadNibNamed("NativeAdView", owner: nil, options: nil),
          let adView = nibObjects.first as? GADNativeAdView
        else {
          assert(false, "Could not load nib file for adView")
        }
        setAdView(adView)
        refreshAd(nil)
    }
    func setAdView(_ view: GADNativeAdView) {
      // Remove the previous ad view.
      nativeAdView = view
      nativeAdView.translatesAutoresizingMaskIntoConstraints = false
    
    }

    // MARK: - Actions

    /// Refreshes the native ad.
    @IBAction func refreshAd(_ sender: AnyObject!) {
     
      adLoader = GADAdLoader(
        adUnitID: adUnitID, rootViewController: self,
        adTypes: [.native], options: nil)
      adLoader.delegate = self
      adLoader.load(GADRequest())
    }

    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Collection Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if isSearching{
            if let filteredArrAuctionList = self.filteredArrAuctionList{
                return filteredArrAuctionList.count
            }
        }else{
            if let arrAuctionList = self.arrAuctionList{
                if arrAuctionList.count > 5{
                    return arrAuctionList.count + 1
                }
                return arrAuctionList.count
            }
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if indexPath.row  == 6{
            let cell: NativeAdsCollectionCell! = collectionView.dequeueReusableCell(withReuseIdentifier: "NativeAdsCollectionCell", for: indexPath as IndexPath) as? NativeAdsCollectionCell
            if cell.addView?.subviews.count == 0 && nativeAds.count > 0{
                cell.addView?.addSubview(nativeAdView)
                let viewDictionary = ["_nativeAdView": nativeAdView!]
                cell.addView?.addConstraints(
                  NSLayoutConstraint.constraints(
                    withVisualFormat: "H:|[_nativeAdView]|",
                    options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewDictionary)
                )
                cell.addView?.addConstraints(
                  NSLayoutConstraint.constraints(
                    withVisualFormat: "V:|[_nativeAdView]|",
                    options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewDictionary)
                )
            }
            return cell
        }
        var auction : auctionList?
        
        let cell: AuctionCell! = collectionView.dequeueReusableCell(withReuseIdentifier: "AuctionCell", for: indexPath as IndexPath) as? AuctionCell
        
        //            let objC:Ad = self.arrAdsData.object(at: indexPath.row) as! Ad
        
        var index = indexPath.row
        if indexPath.row > 5{
            index = indexPath.row - 1
        }
        
        if isSearching{
            auction = self.filteredArrAuctionList?[index]
        }else{
            auction = self.arrAuctionList?[index]
        }
        
        cell.lblCity.text = auction?.city ?? ""
        cell.lblTitle.text = auction?.itemTitle ?? ""
        // let dateTime = createDateTime(timestamp: objC.createAt!)
        //            cell.lblDate.text = AppUtility.getFormattedDate(dateString: objC.createdAt ?? "")
        if appLanguage == "en" {
            cell.lblTitle.textAlignment = .left
        } else {
            cell.lblTitle.textAlignment = .right
        }
        
        if let lang = UserDefaults.standard.object(forKey: "appLang") as? String {
            if lang == "en" {
                cell.lblBid.localizeKey = "Latest Bid : \(auction?.latestBid ?? "")"
                UIView.appearance().semanticContentAttribute = .forceLeftToRight
            } else {
                cell.lblBid.localizeKey = "\(auction?.latestBid ?? "") :اخر مزايدة"
                UIView.appearance().semanticContentAttribute = .forceRightToLeft
            }
        } else {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }
        
//        cell.lblDate.localizeKey = objC.remainingTime ?? ""
        
        cell.setTimer(expiryTime: auction?.auctionExpiryTime ?? "")
        
        if auction?.priority == "" || auction?.priority == "0" {
            cell.crowImg.isHidden = true
            cell.imgAd.borderWidth = 0
            cell.imgAd.borderColor = UIColor.init(red: 235/255, green: 242/255, blue: 238/255, alpha: 1.0)
        }else{
            cell.crowImg.isHidden = false
            cell.imgAd.borderWidth = 2
            cell.imgAd.borderColor = UIColor.init(red: 239/255, green: 1, blue: 0, alpha: 1.0)
        }
        
        if let videoUrl = auction?.videoUrl, let url = URL(string: videoUrl){
            if videoUrl.isEmpty{
                if let imgUrl = auction?.imgUrl{
                    AppUtility.setImage(url:(imgUrl), image: cell.imgAd)
                }
            } else {
                cell.imgAd.image = UIImage(named: "applogo_new")
                getThumbnailImageFromVideoUrl(url: url) { (thumbNailImage) in
                    cell.imgAd.image = thumbNailImage
                }
            }
        } else if let imgUrl = auction?.imgUrl{
            AppUtility.setImage(url:(imgUrl), image: cell.imgAd)
        }
        if index == (self.arrAuctionList!.count - 1)
        {
            print("Calling Next Page")
            self.AllItem_GetMethod()
        }
        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isSearching{
            
            let viewController = AuctionDetailsViewController()
            viewController.selectedAuction = self.filteredArrAuctionList?[indexPath.row]
            self.navigationController?.pushViewController(viewController, animated: true)
        }else{
            if indexPath.row == 6{
                return
            }
            var index = indexPath.row
            if indexPath.row > 5{
                index = indexPath.row - 1
            }
            let viewController = AuctionDetailsViewController()
            viewController.selectedAuction = self.arrAuctionList?[index]
            self.navigationController?.pushViewController(viewController, animated: true)
        }
      
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if indexPath.row == 6{
            if nativeAds.count > 0{
                let width = CGFloat (collectionView.frame.size.width)
                return CGSize (width: width, height: nativeAdView.frame.size.height)
            }
            let width = CGFloat (collectionView.frame.size.width)
            return CGSize (width: width, height: 120)
        }
        let width = CGFloat (collectionView.frame.size.width) / 2 - 5
        return CGSize (width: width, height: 325)
        
    }
  
    
    //MARK:- UITextField Delegate Methods
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtCategory{
            if arrCategory.count == 0{
                getCategory()
            }
            else{
                var word = "اختر الفئة"
                if appLanguage == "en" {
                    word = "Choose a category"
                }
                ActionSheetStringPicker.show(withTitle: word, rows: arrCategory, initialSelection: 0, doneBlock: {
                    picker, indexes, values in
                    
                    let objC:Category = self.arrCategoryData.object(at: indexes) as! Category
                    if objC.title! == values as! String
                    {
                        self.categoryID = objC.id!
                    }
                    self.txtCategory.text = values as? String
                    self.firsttime = false
                    self.AllItem_GetMethod()
                    return
                }, cancel: { ActionSheetStringPicker in return},origin: textField)
                
                return false
            }
        }else if textField == txtCity{
            var word = "اختيار موقع"
            if appLanguage == "en" {
                word = "Choose a site"
            }
            ActionSheetStringPicker.show(withTitle: word, rows: arrCityNames, initialSelection: 0, doneBlock: {
                picker, indexes, values in
                
                self.cityName = values as! String
                self.txtCity.text = values as? String
                self.firsttime = false
                self.AllItem_GetMethod()
                return
            }, cancel: { ActionSheetStringPicker in return},origin: textField)
            return false
        }
        return true
    }
    
    @IBAction func didChange(_ sender: UITextField) {
        
        print(self.tfSearch.text!)
        print("search")
        if let text = self.tfSearch.text{
            
            if text.isEmpty{
                self.isSearching = false
                self.filteredArrAuctionList?.removeAll()
                self.collectionviewAUction.reloadData()
            }else{
                self.isSearching = true
                self.filteredArrAuctionList?.removeAll()
                
                if let articles = self.arrAuctionList{
                    for article in articles{
                        if article.itemTitle?.range(of: self.tfSearch.text!, options: .caseInsensitive) != nil{
                            self.filteredArrAuctionList?.append(article)
                        }
                    }
                }
                self.collectionviewAUction.reloadData()
            }
            
        }
    }
    
}
extension AuctionListViewController: GADNativeAdLoaderDelegate,GADNativeAdDelegate,GADVideoControllerDelegate{
    
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
        nativeAds.append(nativeAd)

          nativeAd.delegate = self

         
          (nativeAdView.headlineView as? UILabel)?.text = nativeAd.headline
          nativeAdView.mediaView?.mediaContent = nativeAd.mediaContent

          // Some native ads will include a video asset, while others do not. Apps can use the
          // GADVideoController's hasVideoContent property to determine if one is present, and adjust their
          // UI accordingly.
          let mediaContent = nativeAd.mediaContent
          if mediaContent.hasVideoContent {
            // By acting as the delegate to the GADVideoController, this ViewController receives messages
            // about events in the video lifecycle.
            mediaContent.videoController.delegate = self
          //  videoStatusLabel.text = "Ad contains a video asset."
          } else {
            //videoStatusLabel.text = "Ad does not contain a video."
          }

          // This app uses a fixed width for the GADMediaView and changes its height to match the aspect
          // ratio of the media it displays.
          if let mediaView = nativeAdView.mediaView, nativeAd.mediaContent.aspectRatio > 0 {
//            heightConstraint = NSLayoutConstraint(
//              item: mediaView,
//              attribute: .height,
//              relatedBy: .equal,
//              toItem: mediaView,
//              attribute: .width,
//              multiplier: CGFloat(1 / nativeAd.mediaContent.aspectRatio),
//              constant: 0)
//            heightConstraint?.isActive = true
          }

          // These assets are not guaranteed to be present. Check that they are before
          // showing or hiding them.
          (nativeAdView.bodyView as? UILabel)?.text = nativeAd.body
          nativeAdView.bodyView?.isHidden = nativeAd.body == nil

          (nativeAdView.callToActionView as? UIButton)?.setTitle(nativeAd.callToAction, for: .normal)
          nativeAdView.callToActionView?.isHidden = nativeAd.callToAction == nil

          (nativeAdView.iconView as? UIImageView)?.image = nativeAd.icon?.image
          nativeAdView.iconView?.isHidden = nativeAd.icon == nil

         // (nativeAdView.starRatingView as? UIImageView)?.image = imageOfStars(from: nativeAd.starRating)
          nativeAdView.starRatingView?.isHidden = nativeAd.starRating == nil

          (nativeAdView.storeView as? UILabel)?.text = nativeAd.store
          nativeAdView.storeView?.isHidden = nativeAd.store == nil

          (nativeAdView.priceView as? UILabel)?.text = nativeAd.price
          nativeAdView.priceView?.isHidden = nativeAd.price == nil

          (nativeAdView.advertiserView as? UILabel)?.text = nativeAd.advertiser
          nativeAdView.advertiserView?.isHidden = nativeAd.advertiser == nil

          // In order for the SDK to process touch events properly, user interaction should be disabled.
          nativeAdView.callToActionView?.isUserInteractionEnabled = false

          // Associate the native ad view with the native ad object. This is
          // required to make the ad clickable.
          // Note: this should always be done after populating the ad views.
          nativeAdView.nativeAd = nativeAd
        collectionviewAUction.reloadData()
    }
    
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
        
    }
    
    
}
