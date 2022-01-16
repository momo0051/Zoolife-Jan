//
//  AuctionDetailsViewController.swift
//  ZOOLIFE
//
//  Created by iMac on 30/11/21.
//  Copyright © 2021 Hafiz Anser. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import ImageSlideshow
import ActionSheetPicker_3_0
import SDWebImage
import AVKit
import AVFoundation

class AuctionDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    //MARK:- Outlet
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var userId: UILabel!
    @IBOutlet weak var imageSlideShow: ImageSlideshow!
    @IBOutlet weak var scrollviewBG: UIScrollView!
    @IBOutlet weak var lblTilte: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblRemmingTime: UILabel!
    @IBOutlet weak var lblCityName: UILabel!
    @IBOutlet weak var txtBid: UITextField!
    @IBOutlet weak var txtMinBid: UILabel!
    @IBOutlet weak var btnPlacebid: UIButton!
    @IBOutlet weak var tableviewRecentBidders: UITableView!
    @IBOutlet weak var constraintRecentBiddersHeight: NSLayoutConstraint!
    @IBOutlet weak var lblRecentBidders: UILabel!
    @IBOutlet weak var btnStartChat: UIButton!
    @IBOutlet weak var btnCall: UIButton!
    @IBOutlet weak var btnWhatsApp: UIButton!
    @IBOutlet weak var lblWinnerBidPrice: UILabel!
    @IBOutlet weak var lblWinnerBidTime: UILabel!
    @IBOutlet weak var lblWinnerBidName: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var alertMessageLabel: UILabel!
    @IBOutlet weak var viewBidWinner: UIView!
    @IBOutlet weak var constraintDetailViewHeight: NSLayoutConstraint! //50
    @IBOutlet weak var constraintViewButton: NSLayoutConstraint! //85
    
    @IBOutlet weak var postIDValueLabel: UILabel!
    @IBOutlet weak var ageHeadingLabel: UILabel!
    @IBOutlet weak var ageValueLabel: UILabel!
    @IBOutlet weak var sexHeadingLabel: UILabel!
    @IBOutlet weak var sexValueLabel: UILabel!
    @IBOutlet weak var vaccineDetailsHeadingLabel: UILabel!
    @IBOutlet weak var vaccineDetailsValueLabel: UILabel!
    @IBOutlet weak var passportHeadingLabel: UILabel!
    @IBOutlet weak var passportValueLabel: UILabel!
    
    //MARK:- Variable
    var imageArr:[String] = []
    var videoURl: String = ""
    var sdWebImageSource = [InputSource]()
    var cellHeight = 60.0
    var selectedAuction: auctionList?
    var auctionDetails: auctionList?
    var releaseDate: NSDate?
    var countdownTimer = Timer()
    var nextPage = ""
    var firsttime = false
    var arrBidsList: [LatestBids] = [LatestBids]()
    var arrBidPrices = ["0 SAR","10 SAR","50 SAR","100 SAR","500 SAR","1000 SAR"]
    var winnerBid: LatestBids?
    var winnerBidDict: [String:JSON] = [String:JSON]()
    var videoIndex = -1
    var showingPage = 0
    var fullScreenController: FullScreenSlideshowViewController!
    var ownerPhone = ""
    var ownerID = ""
    var post: Ad?
    
    //MARK:- UIView Controller Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            self.scrollviewBG.contentInsetAdjustmentBehavior = .never
        }
        btnPlacebid.layer.cornerRadius = 10.0
        
    
        collectionView.register(UINib(nibName: "AuctionDetailCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "auctionImageCell")
        
        self.configureRefreshControl()
        self.getSinglePost()
        self.AllItem_GetBIDS()
        
        btnWhatsApp.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        btnWhatsApp.setImage(#imageLiteral(resourceName: "ic_whatsapp"), for: .normal)
        btnWhatsApp.isUserInteractionEnabled = true
        
        btnCall.backgroundColor = #colorLiteral(red: 0.1951332688, green: 0.5047534108, blue: 0.6908060312, alpha: 1)
        btnCall.setImage(#imageLiteral(resourceName: "ic_call_new"), for: .normal)
        btnCall.isUserInteractionEnabled = true
        
        btnStartChat.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        btnStartChat.setImage(#imageLiteral(resourceName: "ic_chat_new"), for: .normal)
        btnStartChat.isUserInteractionEnabled = true
        if let lang = UserDefaults.standard.object(forKey: "appLang") as? String {
            if lang == "en" {
                txtBid.placeholder = "Enter Bid"
                btnPlacebid.setTitle("Place bid", for: .normal)
                lblRecentBidders.localizeKey = "Recent bidders"
                txtBid.textAlignment = .left
                alertMessageLabel.localizeKey = "\"Zoolife\" warns against dealing outside the application and strongly advises to deal through private messages only, to deal hand in hand, to beware of agents, and to make sure that the bank account belongs to the same person who owns the goods."
                
                userId.localizeKey = "POST ID : "
                sexHeadingLabel.localizeKey = "Sex:"
                sexHeadingLabel.textAlignment = .left
                ageHeadingLabel.localizeKey = "Age:"
                ageHeadingLabel.textAlignment = .left
                passportHeadingLabel.localizeKey = "Passport:"
                passportHeadingLabel.textAlignment = .left
                vaccineDetailsHeadingLabel.localizeKey = "Vaccine Details:"
                vaccineDetailsHeadingLabel.textAlignment = .left
                UIView.appearance().semanticContentAttribute = .forceLeftToRight
            } else {
                btnPlacebid.setTitle("إضافة مزايدة", for: .normal)
                lblRecentBidders.localizeKey = "المزايدات"
                txtBid.placeholder = "قيمة المزايدة"
                txtBid.textAlignment = .right
                alertMessageLabel.localizeKey = "يحذر \" زوولايف \" من التعامل خارج التطبيق وينصح بشدة بالتعامل عبر الرسائل الخاصة فقط والتعامل يد بيد والحذر من الوسطاء والتأكد أن الحساب البنكي يعود لنفس الشخص صاحب السلعة ."
                userId.localizeKey = "رقم المزاد: "
                sexHeadingLabel.localizeKey = "الجنس:"
                sexHeadingLabel.textAlignment = .right
                ageHeadingLabel.localizeKey = "العمر:"
                ageHeadingLabel.textAlignment = .right
                passportHeadingLabel.localizeKey = "جواز السفر:"
                passportHeadingLabel.textAlignment = .right
                vaccineDetailsHeadingLabel.localizeKey = "بيانات التطعيم:"
                vaccineDetailsHeadingLabel.textAlignment = .right
                UIView.appearance().semanticContentAttribute = .forceRightToLeft
            }
        } else {
            txtBid.textAlignment = .right
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }
    }
    
    
    //MARK:- Other Methods
    func getSinglePost(){
        AppUtility.showProgress()
        let requestURL = URL(string: GET_ITEM)!
        let headers = ["Content-Type": "application/json","X-Localization":"\(appLanguage)"]
        var paramDict : [String : Any]
        var postid = ""
        
        if postid == "" {
            postid = "\(selectedAuction?.id ?? 0)"
        }
        if let u = AppUtility.getSession() {
            paramDict = ["id":postid,
                         "user_id":u.ID ?? ""
            ] as [String : Any]
        }else{
            paramDict = ["id":postid
            ] as [String : Any]
        }
        
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
                
                upload.responseJSON { [self] response in
                    
                    print("response JSONgetSinglePost: '\(response)'")
                    
                    if((response.result.value) != nil){
                        let swiftyJsonVar = JSON(response.result.value!)
                        print(swiftyJsonVar)
                        let dict = swiftyJsonVar.dictionaryValue
                        if let data : Dictionary<String, JSON> = (dict["data"]?.dictionaryValue){
                            let adDetail = Ad.init(withDictionary:data)
                            self.post = adDetail
                        }
                        let imgsData = dict["data"]!["images"].arrayValue
                        let phone = dict["data"]!["phone"].stringValue
                        ownerPhone = String(Int(phone) ?? 0)
                        ownerID = dict["data"]!["fromUserId"].stringValue
                        for image in imgsData{
                            self.imageArr.append(image["file_name"].stringValue)
                        }
                        if let videoURL = dict["data"]!["videoUrl"].string{
//                            self.imageArr.append(videoURL)
                            self.videoURl = videoURL
                        }
                        if let img = dict["data"]!["imgUrl"].string {
                            self.imageArr.append(img)
                        }
                        
                        self.collectionView.reloadData()
                        let message = dict["message"]?.string
                        let error = dict["error"]?.bool
                        
                        AppUtility.hideProgress()
                        
                        if error == false {
                            let adDetail = auctionList.init(fromDictionary: dict["data"]?.dictionaryObject ?? [String:AnyObject]())
                            self.auctionDetails = adDetail
                            self.showSlider()
                            self.setUpData()
                            
                        }
                        else{
                            
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
    func configureRefreshControl() {
        scrollviewBG.refreshControl = UIRefreshControl(frame: CGRect(x: UIScreen.main.bounds.width / 2, y: 50, width: 50, height: 50))
        scrollviewBG.refreshControl?.addTarget(self, action:
                                                #selector(handleRefreshControl),
                                               for: .valueChanged)
    }
    override func viewWillAppear(_ animated: Bool) {
        print("asfdasd")
    }
    @objc func handleRefreshControl() {
        DispatchQueue.main.async{
            self.scrollviewBG.refreshControl?.endRefreshing()
        }
        self.getSinglePost()
        self.AllItem_GetBIDS()
    }

    func AllItem_GetBIDS() {
        var requestURL = URL(string: GET_POST_BIDS)!
        
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
            
            arrBidsList.removeAll()
            
            self.tableviewRecentBidders.reloadData()
            self.viewWillLayoutSubviews()
            
        }
        AppUtility.showProgress()
        firsttime = true
        print("nextpageurl \(requestURL)")
        var paramDict = [:] as [String : Any]
        paramDict["item_id"] = "\(selectedAuction?.id ?? 0)" //"848"
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
                                var isWinnerUser:Bool = false
                                self.txtBid.text = ""
                                for dic in dataArray
                                {
                                    let objD = LatestBids.init(fromDictionary: dic.dictionaryObject ?? [String:AnyObject]())
                                    self.arrBidsList.append(objD)
                                    if objD.isWinner == 1{
                                        self.winnerBid = objD
                                        self.winnerBidDict = dic.dictionaryValue
                                    
                                        self.lblWinnerBidPrice.text = "SAR \(objD.bidAmount ?? 0)"
                                        self.lblWinnerBidTime.text = objD.readableTime ?? ""
                                        self.lblWinnerBidName.text =  objD.username ?? ""
                                    
                                        isWinnerUser = true
                    
                                    }
                                }
                                
                                DispatchQueue.main.async {
                                    if isWinnerUser{
                                        self.viewBidWinner.layer.borderWidth = 2
                                        self.viewBidWinner.layer.borderColor = UIColor.init(red: 255/255, green: 215/255, blue: 0/255, alpha: 1).cgColor
                                       self.viewBidWinner.isHidden = false
                                        self.constraintDetailViewHeight.constant = 50
                                        self.constraintViewButton.constant = 85
                                    }else{
                                        self.viewBidWinner.layer.borderWidth = 0
                                        self.viewBidWinner.layer.borderColor = UIColor.clear.cgColor
                                        
                                        self.viewBidWinner.isHidden = true
                                        self.constraintDetailViewHeight.constant = 0
                                        self.constraintViewButton.constant = 0
                                    }
                                    self.constraintRecentBiddersHeight.constant = CGFloat(Double(self.arrBidsList.count) * self.cellHeight)
                                    self.tableviewRecentBidders.reloadData()
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
    
    
    func AddBID() {
        var requestURL = URL(string: ADD_BID)!
        var bidAmout = "0"
        let bidAmoutArr = txtBid.text!.components(separatedBy: " ")
        if !bidAmoutArr.isEmpty{
            bidAmout = bidAmoutArr[0]
        }
        
        AppUtility.showProgress()
        var paramDict = [:] as [String : Any]
        if let user = AppUtility.getSession() {
            paramDict["item_id"] = "\(selectedAuction?.id ?? 0)" //"848"
            paramDict["fromUserId"] = "\(user.ID ?? "")"
            paramDict["amount"] = "\(bidAmout.convertedDigitsToLocale(Locale(identifier: "EN")))"
        }else{
            let alert = UIAlertController(title: "Zoolife", message:loc.mustLogin.localized(), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: Okey(), style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
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
                            var stMsg =  "تمت إضافةالمزايدة بنجاح."
                            
                            if appLanguage == "en" {
                                stMsg = "Bid successfully added."
                            } else {
                                stMsg = "تمت إضافةالمزايدة بنجاح."
                            }
                            
                            let alert = UIAlertController(title: "Zoolife", message:stMsg, preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: Okey(), style: UIAlertAction.Style.default, handler: { (alert) in
                                self.firsttime = false
                                self.AllItem_GetBIDS()
                                self.getSinglePost()
                            }))
                            self.present(alert, animated: true, completion: nil)
                            
                            
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
    
    func setUpData() {
        lblTilte.localizeKey = auctionDetails?.itemTitle ?? ""
        lblDesc.localizeKey = auctionDetails?.itemDesc ?? ""
        lblCityName.localizeKey = auctionDetails?.city ?? ""
        
        
        if appLanguage == "en" {
            txtMinBid.localizeKey = "Min bid : \(auctionDetails?.minBid ?? 0)"
            userId.localizeKey = "POST ID :"
            lblUserName.localizeKey = "Username :  \(auctionDetails?.userName ?? "")"
            lblUserName.textAlignment = .left
        } else {
            txtMinBid.localizeKey = "\(auctionDetails?.minBid ?? 0) : السعر الحالي"
            userId.localizeKey = "رقم المزاد: \(auctionDetails?.id ?? 0)"
            lblUserName.textAlignment = .right
            lblUserName.localizeKey = "المعلن:: \(auctionDetails?.userName ?? "")"
        }
        if let sex = auctionDetails?.sex{
            self.sexValueLabel.text = sex
        }
        if let age = auctionDetails?.age{
            self.ageValueLabel.text = "\(age)"
        }
        if let passport = auctionDetails?.passport{
            self.passportValueLabel.text = passport
        }
        if let vaccineDetails = auctionDetails?.vaccine_detail{
            self.vaccineDetailsValueLabel.text = vaccineDetails
        }
        if let postId = auctionDetails?.id{
            self.postIDValueLabel.text = "\(postId)"
        }
        let releaseDateString = auctionDetails?.auctionExpiryTime ?? ""
        if releaseDateString.isEmpty { return }
        let releaseDateFormatter = DateFormatter()
        releaseDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        releaseDateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        releaseDate = releaseDateFormatter.date(from: releaseDateString)! as NSDate
        
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        
        var filterBidPrices: [String] = [String]()
        for stBidPrices in arrBidPrices{
            var bidPrices = "0"
            let bidPricesArr = stBidPrices.components(separatedBy: " ")
            if !bidPricesArr.isEmpty{
                bidPrices = bidPricesArr[0]
            }
            if (auctionDetails?.minBid ?? 0) < Int(bidPrices)!{
                filterBidPrices.append(stBidPrices)
            }
        }
        arrBidPrices = filterBidPrices
    }
    
    @objc func updateTime() {
        
        let currentDate = Date()
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "UTC")!
        let diffDateComponents = calendar.dateComponents([.day, .hour, .minute, .second], from: currentDate, to: releaseDate! as Date)
        
        let countdownEn = "\(diffDateComponents.day ?? 0) D \(diffDateComponents.hour ?? 0) H \(diffDateComponents.minute ?? 0) M \(diffDateComponents.second ?? 0) S"
        let countdownArbic = "\(diffDateComponents.day ?? 0) يوم \(diffDateComponents.hour ?? 0) سا \(diffDateComponents.minute ?? 0) \(diffDateComponents.second ?? 0) ث"
        
//        print(countdownEn)
        if (diffDateComponents.day ?? 0) > 0 || (diffDateComponents.hour ?? 0) > 0 || (diffDateComponents.minute ?? 0) > 0 || (diffDateComponents.second ?? 0) > 0{
            if appLanguage == "en" {
                lblRemmingTime.localizeKey = countdownEn
            } else {
                lblRemmingTime.localizeKey = countdownArbic
            }
            btnPlacebid.isUserInteractionEnabled = true
        }else{
            btnPlacebid.isUserInteractionEnabled = false
            
            if appLanguage == "en" {
                lblRemmingTime.localizeKey = "Auction Close"
            } else {
                lblRemmingTime.localizeKey = "إغلاق المزاد"
            }
            
        }
        
    }
    
    func showSlider() {
       
        sdWebImageSource.removeAll()
        
        //        if let imagesArray = auctionDetails?.images {
        //            for image in imagesArray {
        //                let stImage = image.fileName ?? ""
        //                if !stImage.isEmpty {
        //                    if let url = stImage.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
        //                        sdWebImageSource.append(SDWebImageSource(urlString: url)!)
        //                    }
        //                }
        //            }
        //        }
        
        for img in self.imageArr {
            if let url = img.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                if let source = SDWebImageSource(urlString: url){
                    sdWebImageSource.append(source)
                }
            }
        }
        if self.imageArr.count == 0{
            if let imgUrl = auctionDetails?.imgUrl{
                if let imageSource = SDWebImageSource(urlString: imgUrl) {
                    sdWebImageSource.append(imageSource)
                }
            }
        }
        if let url = URL(string: videoURl){
            if let thumbnailImage = getThumbnailImage(forUrl: url) {
                let videoCell = VideoCell.instanceFromNib()
                videoCell.ivBackground.image = thumbnailImage
                videoCell.frame = self.imageSlideShow.frame
                self.view.addSubview(videoCell)
                let image = videoCell.asImage()
                let source = ImageSource(image: image)
                sdWebImageSource.append(source)
                videoIndex = sdWebImageSource.count - 1
                videoCell.removeFromSuperview()
                
            }
        }
        
        imageSlideShow.slideshowInterval = 5.0
        imageSlideShow.pageIndicatorPosition = .init(horizontal: .center, vertical: .under)
        imageSlideShow.contentScaleMode = UIViewContentMode.scaleToFill
        
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = UIColor.lightGray
        pageControl.pageIndicatorTintColor = UIColor.black
        imageSlideShow.pageIndicator = pageControl
        
        imageSlideShow.scrollView.layer.cornerRadius = 35
        imageSlideShow.scrollView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        imageSlideShow.scrollView.clipsToBounds = true
        
        imageSlideShow.clipsToBounds = true
        imageSlideShow.layer.cornerRadius = 35
        imageSlideShow.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        // optional way to show activity indicator during image load (skipping the line will show no activity indicator)
        imageSlideShow.activityIndicator = DefaultActivityIndicator()
        imageSlideShow.delegate = self
        for slide in imageSlideShow.slideshowItems {
            //            slide.imageViewWrapper.layer.cornerRadius = 0
        }
        imageSlideShow.setImageInputs(sdWebImageSource)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
        imageSlideShow.addGestureRecognizer(recognizer)
    }
    
    @objc func didTap() {
        if showingPage == videoIndex{
            if let url = URL(string: videoURl){
                self.playVideo(url: url)
            }
        } else {
            fullScreenController = imageSlideShow.presentFullScreenController(from: self)
            fullScreenController.slideshow.currentPageChanged = { page in
                self.showingPage = page
            }
            let img:UIImageView? = UIImageView(frame: CGRect(x: 20, y: UIScreen.main.bounds.height - 100, width: 60, height: 60))
            img!.image = UIImage(named: "Artboard@4x")
            fullScreenController.view.addSubview(img!)
            fullScreenController.dismissCallBack = {
                img?.removeFromSuperview()
            }
            // set the activity indicator for full screen controller (skipping the line will show no activity indicator)
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(didTapFull))
            fullScreenController.view.addGestureRecognizer(recognizer)
            fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
        }
    }
    @objc func didTapFull(){
        if showingPage == videoIndex{
            fullScreenController.closeButton.sendActions(for: .touchUpInside)
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
                if let url = URL(string: self.videoURl){
                    self.playVideo(url: url)
                }
            })
            
        }
    }
    func playVideo(url: URL) {
        let player = AVPlayer(url: url)
        
        let vc = AVPlayerViewController()
        vc.player = player
        
        self.present(vc, animated: true) { vc.player?.play() }
    }
    
    //MARK:- UIButton Action
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didShareTapped(_ sender: Any) {
        guard let url = URL(string: "https://apps.apple.com/pk/app/zoolife/id1549373638") else { return }
        UIApplication.shared.open(url)
    }
    
    @IBAction func btnPlaceBidAction(_ sender: UIButton) {
        if txtBid.text!.isEmpty{
            var word = "الرجاء إدخال مبلغ المزايدة"
            if appLanguage == "en" {
                word = "Please enter the bid amount"
            }
            let alert = UIAlertController(title: "", message: word, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: Okey(), style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let bidAmout = txtBid.text!
        //        let bidAmoutArr = txtBid.text!.components(separatedBy: " ")
        //        if !bidAmoutArr.isEmpty{
        //            bidAmout = bidAmoutArr[0]
        //        }
        if Int(bidAmout.isEmpty ? "0" : bidAmout.convertedDigitsToLocale(Locale(identifier: "EN")))! < (auctionDetails?.minBid ?? 0){
            var word = "الرجاء إدخال مبلغ صالح للمزايدة"
            if appLanguage == "en" {
                word = "The minimum bid is \(auctionDetails?.minBid ?? 0) usd"
            }
            let alert = UIAlertController(title: "", message: word, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: Okey(), style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        txtBid.resignFirstResponder()
        self.AddBID()
    }
    
    @IBAction func btnWhatsAppTapped(_ sender: Any){
        
        if let phone = winnerBid?.phone{
            whatsAppCallAction(number: phone)
        }
        
    }
    
    
    @IBAction func btnCallTapped(_ sender: Any) {
        if let phone = winnerBid?.phone{
            let phoneNumber =  "+966\(phone)"
            dialNumber(number: phoneNumber)
        }
        
    }
    @IBAction func btnChatTappedTapped(_ sender: Any) {
        startChatAcion()
    }
    
    @IBAction func actionCallOwner(_ sender: Any) {
        let phoneNumber =  "+966\(ownerPhone)"
        dialNumber(number: phoneNumber)
    }
    @IBAction func actionMessageOwner(_ sender: Any) {
        var user: User
        if let u = AppUtility.getSession() {
            user = u
            if user.ID == ownerID{
                return
            }
            startChatOwner(user: user)
        }else{
            let alert = UIAlertController(title: "Zoolife", message:loc.mustLogin.localized(), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: Okey(), style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
    }
    @IBAction func actionWhatsappOwner(_ sender: Any) {
        whatsAppCallAction(number: "0\(ownerPhone)")
    }
    func startChatAcion(){
        
        var user: User
        
        if let u = AppUtility.getSession() {
            user = u
            
            if user.ID == "\(winnerBid?.id ?? 0)"{
                return
            }
            
            startChat(user: user)
            
            
        }else{
            
            let alert = UIAlertController(title: "Zoolife", message:loc.mustLogin.localized(), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: Okey(), style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
    }
    func startChatOwner(user: User){
        let receiver:User = User(ID: ownerID, fullname: post?.username, email: post?.email, phone: post?.phone, avatar: post?.itemImage,msg_badge: "",noti_badge: "")
        if let post = post{
            AppUtility.showProgress()
            FirebaseNotificationServices.checkUserCreate(sender: user, recipient: receiver, post: post) { (success) in
                if let success = success{
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
                            DispatchQueue.main.async {
                                AppUtility.hideProgress()
                            }
                        }
                    }
                }
            }
        }
    }
    func startChat(user: User){
        let receiver:User = User(ID: "\(winnerBid?.id ?? 0)", fullname: winnerBid?.name, email: winnerBid?.email, phone: winnerBid?.phone, avatar: "",msg_badge: "",noti_badge: "")

        //        let sender = User(ID: user.ID, fullname: user.fullname, email: user.email, phone: user.phone, avatar: "")

        if let post = winnerBid{
            AppUtility.showProgress()
            let ad = Ad.init(withDictionary: winnerBidDict)
            FirebaseNotificationServices.checkUserCreate(sender: user, recipient: receiver, post: ad) { (success) in
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
                            //
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
    
    
    //MARK:- UITableView DataSource and Delegate Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrBidsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: RecentBiddersCell! = tableView.dequeueReusableCell(withIdentifier: "RecentBiddersCell") as? RecentBiddersCell
        if cell == nil {
            tableView.register(UINib(nibName: "RecentBiddersCell", bundle: nil), forCellReuseIdentifier: "RecentBiddersCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "RecentBiddersCell") as? RecentBiddersCell
        }
        cell.backgroundColor = UIColor.white
        if indexPath.row % 2 == 1{
            cell.backgroundColor = UIColor(red: 235.0/255.0, green: 235.0/255.0, blue: 235.0/255.0, alpha: 1)
        }
        let data = arrBidsList[indexPath.row]
        cell.lblUserName.text = data.username ?? ""
        cell.lblBidPrice.text = "SAR \(data.bidAmount ?? 0)"
        cell.lblBidTime.text =  data.readableTime ?? ""
        if indexPath.row == (self.arrBidsList.count - 1)
        {
            print("Calling Next Page")
            self.AllItem_GetBIDS()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(cellHeight)
    }
    
    //MARK:- UITextField Delegate Methods
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        //
        //        if textField == txtBid{
        //
        //            var word = "حدد عرض سعر"
        //            if appLanguage == "en" {
        //                word = "Select bid"
        //            }
        //            ActionSheetStringPicker.show(withTitle: word, rows: arrBidPrices, initialSelection: 0, doneBlock: {
        //                picker, indexes, values in
        //                self.txtBid.text = values as? String
        //                return
        //            }, cancel: { ActionSheetStringPicker in return},origin: textField)
        //
        //            return false
        //        }
        
        return true
    }
    
    
     func getThumbnailFromUrl(_ url: String?, _ completion: @escaping ((_ image: UIImage?)->Void)) {
             
             guard let url = URL(string: (url ?? "")) else { return }
             DispatchQueue.main.async {
                 let asset = AVAsset(url: url)
                 let assetImgGenerate = AVAssetImageGenerator(asset: asset)
                 assetImgGenerate.appliesPreferredTrackTransform = true
                 
                 let time = CMTimeMake(value: 2, timescale: 1)
                 do {
                     let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
                     let thumbnail = UIImage(cgImage: img)
                     completion(thumbnail)
                 } catch let error{
                     print("Error :: ", error)
                     completion(nil)
                 }
             }
         }
}

extension AuctionDetailsViewController: ImageSlideshowDelegate {
    func imageSlideshow(_ imageSlideshow: ImageSlideshow, didChangeCurrentPageTo page: Int) {
//        print("current page:", page)
        showingPage = page
    }
    //Done by Shahzaib
    func imageSlideshowWillBeginDragging(_ imageSlideshow: ImageSlideshow) {
        print("dragging end:")
    }
    func imageSlideshowDidEndDecelerating(_ imageSlideshow: ImageSlideshow) {
//        print("Decelerating end:")
    }
}


    
 

extension UIView {
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
func getThumbnailImage(forUrl url: URL) -> UIImage? {
    let asset: AVAsset = AVAsset(url: url)
    let imageGenerator = AVAssetImageGenerator(asset: asset)
    
    do {
        let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60), actualTime: nil)
        return UIImage(cgImage: thumbnailImage)
    } catch let error {
        print(error)
    }
    
    return nil
}
func getThumbnailImageFromVideoUrl(url: URL, completion: @escaping ((_ image: UIImage?)->Void)) {
    DispatchQueue.global().async { //1
        let asset = AVAsset(url: url) //2
        let avAssetImageGenerator = AVAssetImageGenerator(asset: asset) //3
        avAssetImageGenerator.appliesPreferredTrackTransform = true //4
        let thumnailTime = CMTimeMake(value: 2, timescale: 1) //5
        do {
            let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumnailTime, actualTime: nil) //6
            let thumbNailImage = UIImage(cgImage: cgThumbImage) //7
            DispatchQueue.main.async { //8
                completion(thumbNailImage) //9
            }
        } catch {
            print(error.localizedDescription) //10
            DispatchQueue.main.async {
                completion(nil) //11
            }
        }
    }
}
extension String {
    private static let formatter = NumberFormatter()

    func clippingCharacters(in characterSet: CharacterSet) -> String {
        components(separatedBy: characterSet).joined()
    }

    func convertedDigitsToLocale(_ locale: Locale = .current) -> String {
        let digits = Set(clippingCharacters(in: CharacterSet.decimalDigits.inverted))
        guard !digits.isEmpty else { return self }

        Self.formatter.locale = locale

        let maps: [(original: String, converted: String)] = digits.map {
            let original = String($0)
            let digit = Self.formatter.number(from: original)!
            let localized = Self.formatter.string(from: digit)!
            return (original, localized)
        }

        return maps.reduce(self) { converted, map in
            converted.replacingOccurrences(of: map.original, with: map.converted)
        }
    }
}
