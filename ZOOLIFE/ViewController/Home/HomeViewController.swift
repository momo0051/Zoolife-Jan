//
//  HomeViewController.swift
//  ZOOLIFE
//
//  Created by Hafiz Anser  on 11/20/20.
//  Copyright © 2020 Hafiz Anser. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import ImageSlideshow
import GoogleMobileAds
class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate{
    
   
    @IBOutlet weak var viewSetting: UIView!
    @IBOutlet weak var svMainScrolView: UIScrollView!
    @IBOutlet weak var lblSearch: UILabel!
    @IBOutlet weak var lblAddPost: UILabel!
    
    @IBOutlet weak var btnSetting: UIButton!
    @IBOutlet var slideshow: ImageSlideshow!
    //Done by Shahzaib
    var CurrentSliderPage: Int = 0
    var sliders = [Articles]() //me [SliderModel]()
    var timer:Timer? = nil
    var x = 1
   
    
    @IBOutlet weak var viewMainHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var adCollectionViewheightConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblNoAds: UILabel!
    @IBOutlet weak var lblNoSubCategory: UILabel!
    @IBOutlet weak var adCollectionView: UICollectionView!
    @IBOutlet weak var collectionCategory: UICollectionView!
    
    @IBOutlet weak var collectionSubCategory: UICollectionView!
    
    
    
    var arrCategory = ["ic_other","ic_food","ic_fish","ic_cuttle","ic_cat"]
    var arrSubCategory = ["ic_avatarone","ic_avatarthree","ic_avatartwo","ic_avatarone","ic_avatarthree","ic_avatartwo"]
    var arrCategoryImagesName = ["ic_avatarone","ic_avatarthree","ic_avatartwo","ic_avatarone","ic_avatarthree","ic_avatartwo"]
    
    
    
    var arrCategoryUnselected = ["ic_other_selected","ic_food_selected","ic_fish_selected","ic_cuttle_selected","ic_cat_selected"]
    
    
    
    let selectedColor = UIColor(red: 13/255, green: 158/255, blue: 227/255, alpha: 1.0)
    
    var selelectedCategoyrIndex = 9999
    var selelectedSubCategoyrIndex = 999
    
    var categoryID = ""
    var subCategoryID = ""
    
    var arrAdsData = [Ad]()
    
//    var arrAdsData = NSMutableArray()
    var arrCategoryData = NSMutableArray()
    var arrSubCategoryData = NSMutableArray()
    
    @IBOutlet weak var tfSearchBar: UISearchBar!
    var nativeAdView: GADNativeAdView!
    var adLoader: GADAdLoader = GADAdLoader()
    let adUnitID = "ca-app-pub-3940256099942544/3986624511"
    var nativeAds = [GADNativeAd]()
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print("scrollViewDidScroll  scrolled")
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height {
//            print("scrollViewDidScroll  end")
            if itemselected == 0
            {
                AllItem_GetMethod()
            }
            else{
                AllItem_PostMethod()
            }
        }
    }
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        loadNativeAds()
//        collectionCategory.scroll
        self.navigationController?.isNavigationBarHidden = true
    
        svMainScrolView.delegate = self
        viewSetting.layer.borderWidth = 1
        viewSetting.layer.borderColor = #colorLiteral(red: 0, green: 0.5856580138, blue: 0.7662277222, alpha: 1)
        viewSetting.layer.cornerRadius = 6
        self.tabBarController?.delegate = self
//        tableView.tableFooterView = UIView()
        
        lblNoSubCategory.isHidden = true
        lblNoAds.isHidden = true
        getCategory()
        self.getSlider()
        //Gesture recognizer Image click on slider to open details page //Done by Shahzaib
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.didTap(sender:)))
          slideshow.addGestureRecognizer(gestureRecognizer)
//        viewMainHeightConstraint.constant = 500//500 + 225
        
        
    }
 
    override func viewWillDisappear(_ animated: Bool) {
        timer?.invalidate()
    }
    //MARK: - Custome Functions
    func loadNativeAds(){
        adCollectionView.register(UINib(nibName: "NativeAdsCollectionCell", bundle: nil), forCellWithReuseIdentifier: "NativeAdsCollectionCell")
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
    //Image click on slider to open details page //Done by Shahzaib
    @objc func didTap(sender:UIButton) {
        print("didTap:::")
        
        var article : Articles?
//        if isSearching{
//            article = self.filteredArticles?[indexPath.item]
//        }else{
        article = self.sliders[CurrentSliderPage]
//        }
        
        let articleDetailViewController = ArticleDetailViewController()
        articleDetailViewController.article = article
        self.navigationController?.pushViewController(articleDetailViewController, animated: true)
      //slideshow.presentFullScreenController(from: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getAds()
        self.UpdateLang_UI()
//        setBadgeValues()
        
    }
    func UpdateLang_UI(){
        if let lang = UserDefaults.standard.object(forKey: "appLang") as? String {
            if lang == "en" {
                lblAddPost.localizeKey = "Add Post"
                lblSearch.localizeKey = "Explore"
                lblNoAds.localizeKey = "No Ads found"
                UIView.appearance().semanticContentAttribute = .forceLeftToRight
            } else {
                lblAddPost.localizeKey = "اضافة اعلان"
                lblSearch.localizeKey = "اكتشف"
                lblNoAds.localizeKey = "لايوجد اعلانات"
                UIView.appearance().semanticContentAttribute = .forceRightToLeft
            }
        } else {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }
    }

    //MARK: - Button Actions
    @IBAction func searchTapped(_ sender: Any)
    {
        let viewController = HomeSearchViewController()
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func didSettingTapped(_ sender: UIButton) {
       
        let viewController = SettingsViewController()
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func exploreTapped(_ sender: Any)
    {
        let viewController = SearchViewController()
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    @IBAction func addPostTapped(_ sender: Any)
    {
        if UserDefaults.standard.bool(forKey: "isLogin") == false{
            appDelegate.loadLogin()
            return
        }
        let viewController = AddAdViewController()
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    // MARK: - Collection Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if collectionView == collectionCategory
        {
            return arrCategoryData.count
        } else if collectionView == adCollectionView {
            //need to show ad after 5 cells
            if arrAdsData.count > 5{
                return arrAdsData.count + 1
            }
            return arrAdsData.count
        } else {
            return arrSubCategoryData.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if collectionView == collectionCategory
        {
            collectionView.register(UINib(nibName: "CategoryCell", bundle: nil), forCellWithReuseIdentifier: "CategoryCell")
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath as IndexPath) as! CategoryCell
            
            //cell.imgCategory.image = UIImage(named: arrCategory[indexPath.row])
            let objC:Category = self.arrCategoryData.object(at: indexPath.row) as! Category
            cell.lblCategoryName.text = objC.title!
            
            
            if selelectedCategoyrIndex == indexPath.row{
//                cell.viewBackGround.backgroundColor = UIColor.white
//                cell.lblCategoryName.textColor = UIColor.black
//                AppUtility.setImage(url:objC.img_selected!, image: cell.imgCategory)
                
                cell.viewBackGround.backgroundColor =  UIColor.init(red: 130/255, green: 177/255, blue: 207/255, alpha: 1.0)//.white//UIColor.colorWithHex(hexString: "#0D9EE3")
                cell.lblCategoryName.textColor = UIColor.white //white
//                cell.shadowDecorate()
                AppUtility.setImage(url:objC.img_unSelected!, image: cell.imgCategory)
            }
            else
            {
//                cell.viewBackGround.backgroundColor = UIColor.colorWithHex(hexString: "#0D9EE3")
//                cell.lblCategoryName.textColor = UIColor.white
//                AppUtility.setImage(url:objC.img_unSelected!, image: cell.imgCategory)
//
                cell.viewBackGround.backgroundColor = UIColor.init(red: 235/255, green: 242/255, blue: 238/255, alpha: 1.0)
                cell.lblCategoryName.textColor = UIColor.gray
                AppUtility.setImage(url:objC.img_selected!, image: cell.imgCategory)
            }

            return cell
        } else if collectionView == adCollectionView {
            collectionView.register(UINib(nibName: "HomeAdsCell", bundle: nil), forCellWithReuseIdentifier: "HomeAdsCell")
           
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
                   
            let cell: HomeAdsCell! = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeAdsCell", for: indexPath as IndexPath) as? HomeAdsCell
            
    //        let objC:Ad = self.arrAdsData.object(at: indexPath.row) as! Ad
    //
            var index = indexPath.row
            if indexPath.row > 5{
                index = indexPath.row - 1
            }
            let objC:Ad = self.arrAdsData[index]
            
            cell.lblUserName.text = objC.username ?? ""
            cell.lblCity.text = objC.city
            cell.lblTitle.text = objC.itemTitle!
           // let dateTime = createDateTime(timestamp: objC.createAt!)
            cell.lblDate.text = AppUtility.getFormattedDate(dateString: objC.created_at ?? "")
            if appLanguage == "en" {
                cell.lblTitle.textAlignment = .left
            } else {
                cell.lblTitle.textAlignment = .right
            }
            if let created_at = objC.created_at {
                if let localDateAd = AppUtility.adFormattedDate(dateString: created_at){
                    let localTimeAdString = TimeFormatHelper.timeAgoString(date: localDateAd)
                    print(localTimeAdString)
                    cell.lblDate.text = localTimeAdString
                }
            }
            
            if objC.priority == "" || objC.priority == "0" {
                cell.crowImg.isHidden = true
                cell.imgAd.borderWidth = 0
                cell.imgAd.borderColor = UIColor.init(red: 235/255, green: 242/255, blue: 238/255, alpha: 1.0)
            }else{
                cell.crowImg.isHidden = false
                cell.imgAd.borderWidth = 2
                cell.imgAd.borderColor = UIColor.init(red: 239/255, green: 1, blue: 0, alpha: 1.0)
            }
            
            if let imgUrl = objC.imgUrl{
                print("image url ---- \(objC.id)")
                AppUtility.setImage(url:(imgUrl), image: cell.imgAd)
                let last4 = String(imgUrl.suffix(10))
                print(last4)
                if last4 == "holder.png" {
                    cell.imgWaterMark.isHidden = true
                }else{
                    cell.imgWaterMark.isHidden = false
                }
              
                
            }else {
                cell.imgWaterMark.isHidden = true
            }
           
            
            if index == (self.arrAdsData.count - 1)
            {
                
            }
//            print("scrollingcheck \(indexPath.row) ----- \(self.arrAdsData.count)")
            
            return cell
        }
        else
        {
            collectionView.register(UINib(nibName: "SubCategoryCell", bundle: nil), forCellWithReuseIdentifier: "SubCategoryCell")
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubCategoryCell", for: indexPath as IndexPath) as! SubCategoryCell
            
            
            let objC:SubCategory = self.arrSubCategoryData.object(at: indexPath.row) as! SubCategory
            cell.lblName.text = objC.title!
            
            if selelectedSubCategoyrIndex == indexPath.row{
//                cell.viewBackground.backgroundColor = UIColor.white
//                cell.lblName.textColor = UIColor.black
                
                cell.viewBackground.backgroundColor = UIColor.init(red: 97/255, green: 157/255, blue: 195/255, alpha: 1.0)//UIColor.clear
                //cell.lblName.textColor = UIColor.white //white
            }
            else
            {
                cell.viewBackground.backgroundColor = UIColor.init(red: 173/255, green: 204/255, blue: 224/255, alpha: 1.0)
                
//                cell.viewBackground.backgroundColor = UIColor.colorWithHex(hexString: "#0D9EE3")//UIColor.clear
//                cell.lblName.textColor = UIColor.white
            }
            return cell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectionCategory {
            let objC:Category = self.arrCategoryData.object(at: indexPath.item) as! Category
            selelectedSubCategoyrIndex = 999
            selelectedCategoyrIndex = indexPath.item
            categoryID = objC.id!
            self.subCategoryID = ""
            self.getSubCategory(categoryID: self.categoryID)
            
        } else if collectionView == adCollectionView {
            if indexPath.row == 6{
                return
            }
           
            var index = indexPath.row
            if indexPath.row > 5{
                index = indexPath.row - 1
            }
            let post = self.arrAdsData[index]
            
            let viewController = AdDetailViewController()//PostDetailViewController()
            viewController.hidesBottomBarWhenPushed = true
            viewController.post = post //as? Ad
            viewController.delegate = self
            viewController.indexSelected = index
            self.navigationController?.pushViewController(viewController, animated: true)
        } else {
            if categoryID == ""{
                
                let alert = UIAlertController(title: loc.error.localized(), message:loc.SelectCat.localized(), preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: Okey(), style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            else{
                let objCS:SubCategory = self.arrSubCategoryData.object(at: indexPath.item) as! SubCategory
                selelectedSubCategoyrIndex = indexPath.item
                self.subCategoryID = objCS.id!
                getAds()
            }
            
        }
        
        collectionView.reloadData()
        
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
//        let width = CGFloat (collectionView.frame.size.width) / 2
        
        if collectionView == collectionCategory {
            return CGSize (width: 110, height: 120)
        } else if collectionView == adCollectionView {
            if indexPath.row == 6{
                if nativeAds.count > 0{
                    let width = CGFloat (collectionView.frame.size.width)
                    return CGSize (width: width, height: nativeAdView.frame.size.height)
                }
                let width = CGFloat (collectionView.frame.size.width)
                return CGSize (width: width, height: 120)
            }
            else{
                let width = CGFloat (collectionView.frame.size.width) / 2 - 10
                return CGSize (width: width, height: 325)
            }
            
        } else {
            return CGSize (width: 132, height: 43)
        }
    }
    func getAds() {
        if categoryID == "" {
            AllItem_GetMethod()
        } else {
            firsttime = false
            AllItem_PostMethod()
        }
    }
    func ClearAndCallGetAllMethod()
    {
        
        /*self.arrSubCategoryData.add(objD)
         self.lblNoSubCategory.isHidden = true
     }
     //
     DispatchQueue.main.async {
         self.viewWillLayoutSubviews()
         self.view.layoutIfNeeded()
         self.adCollectionView.reloadData()
         self.collectionSubCategory.reloadData()
             }*/
//        collectionSubCategory
        self.arrSubCategoryData = NSMutableArray()
        self.collectionSubCategory.reloadData()
        if itemselected == 0
        {
            return
        }
        firsttime = false
        AllItem_GetMethod()
    }
    var nextPage = ""
    var firsttime = false
    
    func AllItem_GetMethod() {
        itemselected = 0
        var requestURL = URL(string: GET_ALL_ITEMS)!
        
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
            
            self.adCollectionView.reloadData()
            self.viewWillLayoutSubviews()
            self.adCollectionViewheightConstraint.constant =
                self.adCollectionView.contentSize.height + 10
            
        }
        AppUtility.showProgress()
        firsttime = true
        print("nextpageurl \(requestURL)")
        let paramDict = [:] as [String : Any]
        let headers = ["Content-Type": "application/json","X-Localization":"\(appLanguage)"]
        //paramDict["post_type"] = "normal"
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in paramDict
            {
                multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
            }
        },usingThreshold:UInt64.init(),
            to: requestURL ,
            method:.get,
            headers:headers,
            encodingCompletion: { encodingResult in

                switch encodingResult {
                case .success(let upload, _, _):

                    upload.responseJSON { response in

//                        print("response JSONgetAds: '\(response)'")

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
                                    self.lblNoAds.isHidden = false
                                   
    //                                self.arrAdsData.removeAll()
                                    
                                    for dic in dataArray
                                    {
                                        let dicts: Dictionary<String, JSON> = dic.dictionaryValue
                                        print(dicts)
                                        
                                        
                                        let objD = Ad.init(withDictionary:dicts)
                                        if objD.id?.isEmpty ?? false {
                                            
                                        } else {
                                            self.arrAdsData.append(objD)
                                        }
                                        if let title = objD.itemTitle
                                        {
                                            if title.contains("test")
                                            {
                                                print(dicts)
                                            }
                                        }
//                                        print("showWhatsapp ---- \(objD.showWhatsapp)")
                                        self.lblNoAds.isHidden = true
                                        
                                    }
    //                                self.viewMainHeightConstraint.constant = CGFloat((500 + (((self.arrAdsData.count + 1) / 2) * 330)))
                                    self.adCollectionViewheightConstraint.constant = CGFloat(((self.arrAdsData.count + 1) / 2) * 330)
                                    
                                    DispatchQueue.main.async {
                                        self.adCollectionView.reloadData()
                                        self.viewWillLayoutSubviews()
                                        let seconds = 1.0
                                        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                                            self.adCollectionViewheightConstraint.constant =
                                                self.adCollectionView.contentSize.height + 10
                                            // Put your code which should be executed with a delay here
                                        }
                                    }
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

//                            let alert = UIAlertController(title: "Zoolife", message:error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
//                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
//                            self.present(alert, animated: true, completion: nil)
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
    var itemselected = 0
    func AllItem_PostMethod()
    {
        itemselected = 1
        var requestURL = URL(string: GET_ALL_ITEMS_BY_CATEGORY)!
        var  paramDict = [:] as [String : Any]
        if categoryID != "" && subCategoryID == "" {
            paramDict = ["category_id": categoryID]
        } else {
//            subCategoryID = "118"
            requestURL = URL(string: GET_ALL_ITEMS_BY_SUB_CATEGORY)!
            paramDict = ["category_id": subCategoryID]
        }
        if firsttime
        {
            if nextPage == nil || nextPage.count == 0
            {
                print("nextpageurl post return")
                return
            }
            requestURL = URL(string: nextPage)!
            nextPage = ""
        }
        else{
            
            arrAdsData.removeAll()
        }
        print("nextpageurlurl post \(requestURL)")
        firsttime = true
        AppUtility.showProgress()
//        arrAdsData.removeAll()
//        let requestURL = URL(string: GET_ALL_ITEMS_BY_CATEGORY)!
        paramDict["post_type"] = "normal"
        let headers = ["Content-Type": "application/json","X-Localization":"\(appLanguage)"]
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
                        print("response JSONgetAds: '\(response)'")
                        if((response.result.value) != nil) {
                            let swiftyJsonVar = JSON(response.result.value!)
                            print(swiftyJsonVar)

                            let dict = swiftyJsonVar.dictionaryValue
                            let message = dict["msg"]?.string
                            let error = dict["error"]?.bool
                            
                            AppUtility.hideProgress()
                            if error == false {
                                //let result: Dictionary<String, JSON> = swiftyJsonVar["data"].dictionaryValue
                                let data = JSON(dict["data"])
                                let dict2 = data.dictionaryValue
                                self.nextPage = dict2["next_page_url"]?.string ?? ""
                                print("\(dict2)")
                                print("nextpageurlurl post \(self.nextPage) ----")
                                //let result: Dictionary<String, JSON> = swiftyJsonVar["data"].dictionaryValue
                                if let dataArray : [JSON] = (dict2["data"]?.arrayValue)
                                {
                                    self.lblNoAds.isHidden = false
                                   
//                                    self.arrAdsData.removeAll()
                                    
                                    for dic in dataArray{
                                        let dicts: Dictionary<String, JSON> = dic.dictionaryValue
                                        print(dicts)
                                        let objD = Ad.init(withDictionary:dicts)
                                        if objD.id?.isEmpty ?? false {
                                            
                                        } else {
                                            self.arrAdsData.append(objD)
                                        }
                                        self.lblNoAds.isHidden = true
                                    }
    //                                self.viewMainHeightConstraint.constant = CGFloat((500 + (((self.arrAdsData.count + 1) / 2) * 330)))
                                    self.adCollectionViewheightConstraint.constant = CGFloat(((self.arrAdsData.count + 1) / 2) * 330)
                                    
                                    DispatchQueue.main.async {
                                        self.adCollectionView.reloadData()
                                        self.viewWillLayoutSubviews()
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                            self.adCollectionViewheightConstraint.constant =
                                                self.adCollectionView.contentSize.height + 10
                                            // Put your code which should be executed with a delay here
                                        }
                                            }
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

//                            let alert = UIAlertController(title: "Zoolife", message:error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
//                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
//                            self.present(alert, animated: true, completion: nil)
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
    func getCategory(){
        
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
            to: requestURL,
            method:.post,
            headers:headers,
            encodingCompletion: { encodingResult in

                switch encodingResult {
                case .success(let upload, _, _):

                    upload.responseJSON { response in

                        print("response JSONgetCategory: '\(response)'")

                        if((response.result.value) != nil)
                        {
                            let swiftyJsonVar = JSON(response.result.value!)
                            print(swiftyJsonVar)

                            let dict = swiftyJsonVar.dictionaryValue
                            let message = dict["msg"]?.string
                            let error = dict["error"]?.bool
                            
                            AppUtility.hideProgress()
                            
                            if error == false || error == nil
                            {
                                if let dataArray : [JSON] = (dict["data"]?.arrayValue) {
                                    for dic in dataArray
                                    {
                                        let dicts: Dictionary<String, JSON> = dic.dictionaryValue
                                        let objD = Category.init(withDictionary:dicts)
                                        
                                        self.arrCategoryData.add(objD)

                                    }
                                    self.collectionCategory.reloadData()
//                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                                        self.startTimer()
//                                    }
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
    
    
    func getSubCategory(categoryID: String){
        AppUtility.showProgress()
        arrSubCategoryData.removeAllObjects()
        let requestURL = URL(string: GET_SUB_CATEGORIES)!
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
                                self.lblNoSubCategory.isHidden = false
                                self.arrSubCategoryData.removeAllObjects()
                                self.arrAdsData.removeAll()
                                
                                for dic in dataArray
                                {
                                    let dicts: Dictionary<String, JSON> = dic.dictionaryValue
                                    let objD = SubCategory.init(withDictionary:dicts)
                                    
                                    self.arrSubCategoryData.add(objD)
                                    self.lblNoSubCategory.isHidden = true
                                }
                                //
                                DispatchQueue.main.async {
                                    self.viewWillLayoutSubviews()
                                    self.view.layoutIfNeeded()
                                    self.adCollectionView.reloadData()
                                    self.collectionSubCategory.reloadData()
                                        }
                                DispatchQueue.main.async {
                                    // done by shahzaib 
                                        self.getAds()
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
    func createDateTime(timestamp: String) -> String
    {
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
}








//extension UITextField {
//  open override func awakeFromNib() {
//    super.awakeFromNib()
//    if UserDefaults.languageCode == "ar" {
//        if textAlignment == .natural {
//            self.textAlignment = .right
//        }
//    }
//}
//}

extension UIView {
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        if #available(iOS 11, *) {
            var cornerMask = CACornerMask()
            if(corners.contains(.topLeft)){
                cornerMask.insert(.layerMinXMinYCorner)
            }
            if(corners.contains(.topRight)){
                cornerMask.insert(.layerMaxXMinYCorner)
            }
            if(corners.contains(.bottomLeft)){
                cornerMask.insert(.layerMinXMaxYCorner)
            }
            if(corners.contains(.bottomRight)){
                cornerMask.insert(.layerMaxXMaxYCorner)
            }
            self.layer.cornerRadius = radius
            self.layer.maskedCorners = cornerMask

        } else {
            let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            self.layer.mask = mask
        }
    }
}





protocol HomeDelegate {
    func updatePost(post:Ad, index:Int)
    
    
    func updateLikePost(post:Ad, index:Int)
    
    
    func updateReportStatus(post:Ad, index:Int)
}



extension HomeViewController : HomeDelegate {
    func updateLikePost(post: Ad, index: Int) {
        self.arrAdsData[index] = post
        self.adCollectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
    }
    
    
    func updateReportStatus(post: Ad, index: Int) {
        self.arrAdsData[index] = post
        self.adCollectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
    }
    
    func updatePost(post: Ad, index: Int) {
        self.arrAdsData[index] = post
        self.adCollectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
    }
}



extension HomeViewController{
    
    func startTimer() {

         timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(autoScroll), userInfo: nil, repeats: true);


     }
  
    @objc func autoScroll() {
      
        if self.x < self.arrCategory.count + 3 {
          let indexPath = IndexPath(item: x, section: 0)
            
         
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
                self.collectionCategory.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
                    }, completion: nil)
          self.x = self.x + 1
        }else{
          self.x = 0
       
            self.collectionCategory.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: false)
          
        }
    }
    
    func getSlider(){
  
        let requestURL = URL(string: GET_ALL_SLIDERS)!
        print(requestURL)
        

        let headers = ["Content-Type": "application/json","X-Localization":"\(appLanguage)"]
        let paramDict = ["pass":"all_sliders"] as [String : Any]
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
                            let message = dict["message"]?.string
                            let error = dict["error"]?.bool
                            
                            if error == false{
                                //let result: Dictionary<String, JSON> = swiftyJsonVar["data"].dictionaryValue
                                let dataArray : [JSON] = (dict["data"]?.arrayValue)!
                                
                                for dic in dataArray{
                                    
                                    let dicts: Dictionary<String, JSON> = dic.dictionaryValue
                                    //Done by Shahzaib
                                    let objD = Articles.init(withDictionary:dicts)
                                    
                                    self.sliders.append(objD)
                                    
                                }
                               
                                self.showSlider()
                                return
                            }
                            else{
                                let alert = UIAlertController(title: "Zoolife", message:message, preferredStyle: UIAlertController.Style.alert)
                                alert.addAction(UIAlertAction(title:  Okey(), style: UIAlertAction.Style.default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                        else{
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
    
    func showSlider(){
       
//        slideshow.scrollView.layer.cornerRadius = 30
//        slideshow.scrollView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
//        slideshow.scrollView.clipsToBounds = true
//
//        slideshow.clipsToBounds = true
//        slideshow.layer.cornerRadius = 30
//        slideshow.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        var sdWebImageSource = [SDWebImageSource]()
        
        for slider in self.sliders{
            if let image = slider.image1{
                if !image.isEmpty{
                    sdWebImageSource.append(SDWebImageSource(urlString: image)!)
                }
            }
        }
        
        slideshow.slideshowInterval = 5.0
        slideshow.pageIndicatorPosition = .init(horizontal: .center, vertical: .under)
        slideshow.contentScaleMode = .scaleToFill
        
        slideshow.layer.cornerRadius = 6
        slideshow.layer.borderWidth = 1
        slideshow.layer.borderColor = #colorLiteral(red: 0, green: 0.5141282082, blue: 0.7158483863, alpha: 1)
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = UIColor.lightGray
        pageControl.pageIndicatorTintColor = UIColor.black
        slideshow.pageIndicator = pageControl
        
        // optional way to show activity indicator during image load (skipping the line will show no activity indicator)
        slideshow.activityIndicator = DefaultActivityIndicator()
        slideshow.delegate = self
        for slide in slideshow.slideshowItems{
//            slide.imageViewWrapper.layer.cornerRadius = 0
        }
        slideshow.setImageInputs(sdWebImageSource)
        slideshow.cornerRadius = 50
    }
    
}


extension HomeViewController: ImageSlideshowDelegate {
    func imageSlideshow(_ imageSlideshow: ImageSlideshow, didChangeCurrentPageTo page: Int) {
//        print("current page:", page)
        CurrentSliderPage = page
    }
    func imageSlideshowWillBeginDragging(_ imageSlideshow: ImageSlideshow) {
        print("dragging end:")
    }
    func imageSlideshowDidEndDecelerating(_ imageSlideshow: ImageSlideshow) {
//        print("Decelerating end:")
    }
}



extension UITableViewCell {
  func separator(hide: Bool) {
    separatorInset.left = hide ? bounds.size.width : 0
  }
}





extension HomeViewController:UITabBarControllerDelegate{
    
//    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
//        switch item.tag{
//        case 0: //code here
//
//            print("Home is pressed")
//             break
//        default: break
//        }
//
//    }
    
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
            let tabBarIndex = tabBarController.selectedIndex

        
        if tabBarIndex == 0 {
//            self.viewDidLoad()
//            self.viewWillAppear(true)
            
            
            self.selelectedCategoyrIndex = 9999
            self.selelectedSubCategoyrIndex = 999
            self.categoryID = ""
            self.subCategoryID = ""
            
            self.collectionCategory.reloadData()
            self.collectionSubCategory.reloadData()
            
            self.getAds()
        }
        //print(tabBarIndex)
    }
    
}
extension HomeViewController: GADNativeAdLoaderDelegate,GADNativeAdDelegate,GADVideoControllerDelegate{
    
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
        adCollectionView.reloadData()
    }
    
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
        
    }
    
    
}
