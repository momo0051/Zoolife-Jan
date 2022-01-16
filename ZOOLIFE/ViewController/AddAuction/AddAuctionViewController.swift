//
//  AddAuctionViewController.swift
//  ZOOLIFE
//
//  Created by Infinity S on 29/11/21.
//  Copyright © 2021 Hafiz Anser. All rights reserved.
//

import UIKit
import Alamofire
import Photos
import NohanaImagePicker
import ActionSheetPicker_3_0
import SwiftyJSON
import SDWebImage
import Kingfisher
import MobileCoreServices

class AddAuctionViewController: UIViewController, UITextFieldDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, NohanaImagePickerControllerDelegate {

    //MARK: - Outlets
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblUplaodImage: UILabel!
    @IBOutlet weak var viewUploadImage: UIView!
    @IBOutlet weak var lblAddLocation: UILabel!
    @IBOutlet weak var viewAddLocation: UIView!
    @IBOutlet weak var txtAddLocation: UITextField!
    @IBOutlet weak var viewCategory: UIView!
    @IBOutlet weak var lblChooseCategory: UILabel!
    @IBOutlet weak var viewCategoryTxtContainer: UIView!
    @IBOutlet weak var txtCategory: UITextField!
    @IBOutlet weak var viewSubCategory: UIView!
    @IBOutlet weak var lblChooseSubCategory: UILabel!
    @IBOutlet weak var viewSubCategoryTxtContainer: UIView!
    @IBOutlet weak var txtSubCategory: UITextField!
    @IBOutlet weak var lblAddAuctionTitle: UILabel!
    @IBOutlet weak var viewAddAuctionTitle: UIView!
    @IBOutlet weak var txtAddAuctionTitle: UITextField!
    @IBOutlet weak var lblAddDescTitle: UILabel!
    @IBOutlet weak var viewAddDesc: UIView!
    @IBOutlet weak var textviewAddDesc: UITextView!
//    @IBOutlet weak var lblAddMinimumBidTitle: UILabel!
//    @IBOutlet weak var viewAddMinimumBid: UIView!
//    @IBOutlet weak var txtAddMinimumBid: UITextField!
    @IBOutlet weak var lblTotalDaysTitle: UILabel!
    @IBOutlet weak var viewTotalDays: UIView!
    @IBOutlet weak var txtTotalDays: UITextField!
    @IBOutlet weak var lblHoursTitle: UILabel!
    @IBOutlet weak var viewHours: UIView!
    @IBOutlet weak var txtHours: UITextField!
    @IBOutlet weak var btnPost: UIButton!
    @IBOutlet weak var heightDeleteImagesButton: NSLayoutConstraint!
    @IBOutlet weak var buttonDeleteImages: UIButton!
    @IBOutlet weak var collectionUpload: UICollectionView!
    @IBOutlet weak var lblStarterPrice: UILabel!
    @IBOutlet weak var txtStarterPrice: UITextField!
    @IBOutlet weak var viewStarterPrice: UIView!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var ageHeadingLabel: UILabel!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var sexHeadingLabel: UILabel!
    
    @IBOutlet weak var sexFemaleSelectionBtn: UIButton!
    @IBOutlet weak var femaileContainerView: UIView!
    @IBOutlet weak var sexMaleSelectionBtn: UIButton!
    @IBOutlet weak var maleContainerView: UIView!
    @IBOutlet weak var vaccineDetailHeadingLabel: UILabel!
    @IBOutlet weak var vaccineDetailTextField: UITextField!
    @IBOutlet weak var passportHeadingLabel: UILabel!
    @IBOutlet weak var passportYesBtn: UIButton!
    @IBOutlet weak var passportYesContainerView: UIView!
    @IBOutlet weak var passportNoBtn: UIButton!
    @IBOutlet weak var passportNoContainerView: UIView!
    //MARK: - Variables
    var arrCityData = NSMutableArray()
    var arrCategoryData = NSMutableArray()
    var arrSubCategoryData = NSMutableArray()
    var arrData = NSMutableArray()
    
    var arrCategory = [Any]()
    var arrSubCategory = [Any]()
    
    var arrCityNames:[String] = []
    var arrDays:[String] = []
    var arrTimes:[String] = []
    var arrBidPrices:[String] = []
    var cityName = ""
    var categoryID = ""
    var subCategoryID = ""
    var editAd = false
    var deleteCallback : (() -> ())?
    var post:auctionList?
    
    var UIPicker = UIImagePickerController()
    var picker = NohanaImagePickerController()
    var imageCover:UIImage? = UIImage.init(named: "logo")
    var imagePickerController = UIImagePickerController()
    var videoURL : URL?
    var arrVideo = [URL?]()
    var arrVideoData = [Data]()
    
    var arrImages = NSMutableArray()
    var imagesArray = [UIImage]()
    var arrImagePost = [UIImage]()
    {
        didSet
        {
            if editAd
            {
                print("array Images Count = ",arrImagePost.count)
                if arrImagePost.count > 0
                {
                    
                    buttonDeleteImages.isHidden = false
                    heightDeleteImagesButton.constant = 25
                }
                else
                {
                    buttonDeleteImages.isHidden = true
                    heightDeleteImagesButton.constant = 0
                }
            }
        }
    }
    
    //MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        getCategory()
        getCity()
        if arrImagePost.count > 0
        {
            buttonDeleteImages.isHidden = false
            heightDeleteImagesButton.constant = 25
        }
        else
        {
            buttonDeleteImages.isHidden = true
            heightDeleteImagesButton.constant = 0
        }
        
        if let post = post
        {
            print("post id = ", post.id)
        }
        
        if self.editAd{
           
            btnDelete.isHidden = false
            
            if arrImagePost.count > 0
            {
                buttonDeleteImages.isHidden = false
                heightDeleteImagesButton.constant = 25
            }
            else
            {
                buttonDeleteImages.isHidden = true
                heightDeleteImagesButton.constant = 0
            }
            
            self.setUpPost()
        }
        else
        {
            btnDelete.isHidden = true
//            buttonDeleteImages.isHidden = true
//            heightDeleteImagesButton.constant = 0
        }
    }

    //MARK:- Other Methods
    func setUI(){
        viewUploadImage.layer.cornerRadius = 20
        viewAddLocation.layer.cornerRadius = viewAddLocation.frame.size.height / 2.0
        viewCategoryTxtContainer.layer.cornerRadius = viewCategoryTxtContainer.frame.size.height / 2.0
        viewSubCategoryTxtContainer.layer.cornerRadius = viewSubCategoryTxtContainer.frame.size.height / 2.0
        viewAddAuctionTitle.layer.cornerRadius = viewAddAuctionTitle.frame.size.height / 2.0
        viewAddDesc.layer.cornerRadius = 20
//        viewAddMinimumBid.layer.cornerRadius = viewAddMinimumBid.frame.size.height / 2.0
        viewTotalDays.layer.cornerRadius = viewTotalDays.frame.size.height / 2.0
        viewHours.layer.cornerRadius = viewHours.frame.size.height / 2.0
        viewStarterPrice.layer.cornerRadius = viewStarterPrice.frame.size.height / 2.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UpdateLang_UI()
    }
    
    
    
    func UpdateLang_UI(){
        if let lang = UserDefaults.standard.object(forKey: "appLang") as? String {
            if lang == "en" {
                lblTitle.localizeKey = "Add New Auction"
               
              
                lblAddDescTitle.localizeKey = "Add Auction Description"
                lblAddAuctionTitle.localizeKey = "Add Auction Title"
                lblChooseSubCategory.localizeKey = "Choose Subcategory"
                lblChooseCategory.localizeKey = "Choose Category"
                lblUplaodImage.localizeKey = "Upload Image"
                lblAddLocation.localizeKey = "Add location"
//                lblAddMinimumBidTitle.localizeKey = "Add Maximum bid"
                lblTotalDaysTitle.localizeKey = "Total Days"
                lblHoursTitle.localizeKey = "Hours"
                lblStarterPrice.localizeKey = "Add Starter price"
//                btnDelete.contentHorizontalAlignment = .left
//                btnPost.contentHorizontalAlignment = .left
                txtAddAuctionTitle.textAlignment = NSTextAlignment.left
                textviewAddDesc.textAlignment = NSTextAlignment.left
                arrDays = ["1 Days","2 Days","3 Days","4 Days","5 Days","6 Days","7 Days"]
                arrTimes = ["1 Hours","2 Hours","3 Hours","4 Hours","5 Hours","6 Hours","7 Hours","8 Hours","9 Hours","10 Hours","11 Hours","12 Hours"]
                arrBidPrices = ["10 SAR","50 SAR","100 SAR","500 SAR","1000 SAR"]
                if self.editAd{
                    btnPost.localizeKey = "Edit"
                }else{
                    btnPost.localizeKey = "Add"
                }
                btnDelete.localizeKey = "Delete"
                
                sexHeadingLabel.localizeKey = "Sex"
                sexFemaleSelectionBtn.localizeKey = "Female"
                sexMaleSelectionBtn.localizeKey = "Male"
                sexFemaleSelectionBtn.contentHorizontalAlignment = .center
                sexMaleSelectionBtn.contentHorizontalAlignment = .center
                passportHeadingLabel.localizeKey = "Passport"
                passportYesBtn.localizeKey = "Yes"
                passportNoBtn.localizeKey = "No"
                passportNoBtn.contentHorizontalAlignment = .center
                passportYesBtn.contentHorizontalAlignment = .center
                vaccineDetailHeadingLabel.localizeKey = "Vaccine Details"
                vaccineDetailTextField.textAlignment = .left
                ageHeadingLabel.localizeKey = "Age"
                ageHeadingLabel.textAlignment = .left
                
                UIView.appearance().semanticContentAttribute = .forceLeftToRight
            } else {
//                btnDelete.contentHorizontalAlignment = .right
//                btnPost.contentHorizontalAlignment = .right
                txtAddAuctionTitle.textAlignment = NSTextAlignment.right
                textviewAddDesc.textAlignment = NSTextAlignment.right
                
                lblTitle.localizeKey = "أضف مزاد جديد"
              
                lblAddDescTitle.localizeKey = "تفاصيل المزاد"
                lblAddAuctionTitle.localizeKey = "عنوان المزاد"
                lblChooseSubCategory.localizeKey = "تصنيف فرعي"
                lblChooseCategory.localizeKey = "الفئة"
                lblUplaodImage.localizeKey = "تحميل الصور"
                lblAddLocation.localizeKey = "موقعك"
//                lblAddMinimumBidTitle.localizeKey = "إضافة الحد الأقصى للمزايدة"
                lblTotalDaysTitle.localizeKey = "مدة المزاد"
                lblHoursTitle.localizeKey = "ساعة"
                lblStarterPrice.localizeKey = "إضافة السعر المبدئي"
                btnDelete.localizeKey = "حذف"
                arrDays = ["1 Days","2 Days","3 Days","4 Days","5 Days","6 Days","7 Days"]
                arrTimes = ["1 Hours","2 Hours","3 Hours","4 Hours","5 Hours","6 Hours","7 Hours","8 Hours","9 Hours","10 Hours","11 Hours","12 Hours"]
                arrBidPrices = ["10 SAR","50 SAR","100 SAR","500 SAR","1000 SAR"]
                
                if self.editAd{
                    btnPost.localizeKey = "تعديل"
                }else{
                    btnPost.localizeKey = "اضافة الى المزاد"
                }
                
                sexHeadingLabel.localizeKey = "الجنس"
                sexFemaleSelectionBtn.localizeKey = "انثى"
                sexMaleSelectionBtn.localizeKey = "ذكر"
                sexFemaleSelectionBtn.contentHorizontalAlignment = .center
                sexMaleSelectionBtn.contentHorizontalAlignment = .center
                passportHeadingLabel.localizeKey = "جواز السفر"
                passportYesBtn.localizeKey = "نعم"
                passportNoBtn.localizeKey = "لا"
                passportNoBtn.contentHorizontalAlignment = .center
                passportYesBtn.contentHorizontalAlignment = .center
                vaccineDetailHeadingLabel.localizeKey = "بيانات التطعيم"
                vaccineDetailTextField.textAlignment = .right
                ageHeadingLabel.localizeKey = "العمر"
                ageHeadingLabel.textAlignment = .right
                UIView.appearance().semanticContentAttribute = .forceRightToLeft
            }
        } else {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }
    }
    
    func setUpPost(){
        
        
        if let post = post{
//            for image in post.images{
//
//                if let url = URL(string: image.fileName){
//                    KingfisherManager.shared.retrieveImage(with: url, options: nil, progressBlock: nil, completionHandler: { result in
//
//                        switch result {
//
//                        case .success(let value):
//
//                            self.imageCover = value.image
//                            self.arrImageS.append(value.image )
//
//                            self.arrImages.insert((value.image ), at: 0)
//
//                            if self.arrImageS.count == (post.images.count + 1){
//                                self.collectionUpload.reloadData()
//                            }
//                        case .failure:
//                            self.arrImageS.append(UIImage.init(named: "logo") ?? UIImage())
//
//                            self.arrImages.insert((UIImage.init(named: "logo") ?? UIImage()), at: 0)
//
//                            if self.arrImageS.count == (post.images.count + 1){
//                                self.collectionUpload.reloadData()
//                            }
//                        }
//                    })
//                }
//            }
            
            if !post.images.isEmpty {
                for (index,link) in post.images.enumerated() {
                    let fileName = link.fileName ?? ""
                    if let url = URL(string: String(fileName)){
                        self.imagesArray.append(UIImage.init(named: "logo") ?? UIImage())
                        self.collectionUpload.reloadData()
                        loadImage(url: url, index: index)
                    }
                }
            }
            if let imgUrl = post.imgUrl {
                if let url = URL(string: imgUrl){
                    KingfisherManager.shared.retrieveImage(with: url, options: nil, progressBlock: nil, completionHandler: { result in
                        
                        switch result {
                        case .success(let value):
                            
                            self.imageCover = value.image
                            
                            let img = value.image
//                            self.arrImagePost.insert(img, at: 0)
//                            self.arrImageS.append(img)
                            self.imagesArray.insert(img, at: 0)
                            self.arrImages.insert(img, at: 0)
                            self.collectionUpload.reloadData()
                            
                        case .failure:
                            self.loadImage(url: url, index: 0)
                        }
                    })
                }
            }
            if let videoURL = post.videoUrl {
                if let url = URL(string: videoURL){
                    getThumbnailImageFromVideoUrl(url: url) { [self] (thumbNailImage) in
                        if let thumbNailImage = thumbNailImage{
                            imagesArray.insert(thumbNailImage, at: 0)
                            self.arrData.insert(thumbNailImage, at: 0)
                            self.collectionUpload.reloadData()
                        } else {
                            imagesArray.append(UIImage(named: "logo") ?? UIImage())
                        }
                    }
                }
                DispatchQueue.global(qos: .background).async {
                    if let url = URL(string: videoURL),
                        let urlData = NSData(contentsOf: url) {
                        DispatchQueue.main.async {
                            self.arrVideoData.append(urlData as Data)
                        }
                    }
                }
            }
            
            self.categoryID = "\(post.category ?? 0)"
            self.subCategoryID = "\(post.subCategory ?? 0)"
            
            self.cityName = post.city ?? ""
            self.txtAddLocation.text = post.city ?? ""
            self.txtAddAuctionTitle.text = post.itemTitle ?? ""
            self.textviewAddDesc.text = post.itemDesc ?? ""
            self.txtHours.text = "\(post.expiryHours ?? 0) Hours"
            self.txtTotalDays.text = "\(post.expiryDays ?? 0) Days"
            self.txtStarterPrice.text = "\(post.minBid ?? 0)"
//            self.txtAddMinimumBid.text = "\(post.maxBid ?? 0) SAR"

        }
    }
    func loadImage(url:URL, index:Int, isThumb:Bool? = false){
        KingfisherManager.shared.retrieveImage(with: url, options: nil, progressBlock: nil, completionHandler: { result in
            
            switch result {
            
            case .success(let value):
                
                self.imageCover = value.image
//                self.arrImagePost.append(value.image )
                if isThumb ?? false{
                    self.imagesArray.insert(value.image, at: 0)
                } else {
                    self.imagesArray[index] = value.image
                }
                self.arrImages.insert((value.image ), at: 0)
                self.collectionUpload.reloadData()
            case .failure:
                self.loadImage(url: url, index: index)
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
                                
                                if self.editAd{
                                    self.setUpCategoryData()
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
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
        })
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
                                
                                if self.editAd{
                                    self.setUpSubCategory()
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
    
    func setUpCategoryData(){
        
        
        for categoryData in  self.arrCategoryData{
            if let object = categoryData as? Category{
                if let id = object.id{
                    if id == self.categoryID{

                        self.txtCategory.text = object.title ?? ""
                        self.getSubCategory(categoryID: self.categoryID)
                    }
                }
            }
        }
    }
    
    func setUpSubCategory(){
        
        
        for subCategoryData in  self.arrSubCategoryData{
            if let object = subCategoryData as? SubCategory{
                if let id = object.id{
                    if id == self.subCategoryID{
                        self.txtSubCategory.text = object.title ?? ""
                    }
                }
            }
        }
    }

    
    func uploadPhotos(){
        self.view.endEditing(true)
        AppUtility.showProgress()
        var requestURL = URL(string: ADD_POST)!

        let headers = ["Content-Type": "application/json","X-Localization":"\(appLanguage)"]

//         let user:User = AppUtility.getSession()
        var user: User
        
        if let u = AppUtility.getSession() {
            user = u
        }else{
            return
        }

//        var minBid = "0"
//        let  minBidArr = txtStarterPrice.text!.components(separatedBy: " ")
//        if !minBidArr.isEmpty{
//            minBid = minBidArr[0]
//        }
        
//        var maxBid = ""
//        let maxBidArr = txtAddMinimumBid.text!.components(separatedBy: " ")
//        if !maxBidArr.isEmpty{
//            maxBid = maxBidArr[0]
//        }
        
        var hoursBid = "0"
        let hoursArr = txtHours.text!.components(separatedBy: " ")
        if !hoursArr.isEmpty{
            hoursBid = hoursArr[0]
        }
        
        var totalDays = "0"
        let totalDaysArr = txtTotalDays.text!.components(separatedBy: " ")
        if !totalDaysArr.isEmpty{
            totalDays = totalDaysArr[0]
        }
            
        
        var paramDict : [String: Any]
        if editAd{
            requestURL = URL(string: UPDATE_POST)!
            paramDict  = ["item_id":post?.id ?? "0",
                          "user_id": user.ID!,
                          "priority": 0,
                          "showComments": 0,
                          "city":txtAddLocation.text ?? "مكه",
                          "country": "المملكة العربية السعودية",
                          "itemTitle":txtAddAuctionTitle.text!,
                          "itemDesc":textviewAddDesc.text!,
                          "category":categoryID,
                          "subCategory":subCategoryID,
                          "auction":"1",
                          "min_bid": txtStarterPrice.text!,
                          "max_bid" : 0,
                          "hours" : hoursBid,
                          "days" : totalDays,
                          "age" : Int(ageTextField.text ?? "0") ?? 0,
                          "sex" : sexMaleSelectionBtn.tag == 1 ? "male":"female",
                          "passport" : passportYesBtn.tag == 1 ? "yes":"no",
                          "vaccine_detail" : vaccineDetailTextField.text ?? ""
            ]
        }else{
            requestURL = URL(string: ADD_POST)!
            paramDict  = [
                "user_id": user.ID!,
                "priority": 0,
                "showComments": 0,
                "city":txtAddLocation.text ?? "مكه",
                "country": "المملكة العربية السعودية",
                "itemTitle":txtAddAuctionTitle.text!,
                "itemDesc":textviewAddDesc.text!,
                "category":categoryID,
                "subCategory":subCategoryID,
                "auction":"1",
                "min_bid": txtStarterPrice.text!,
                "max_bid" : 0,
                "hours" : hoursBid,
                "days" : totalDays,
                "age" : Int(ageTextField.text ?? "0") ?? 0,
                "sex" : sexMaleSelectionBtn.tag == 1 ? "male":"female",
                "passport" : passportYesBtn.tag == 1 ? "yes":"no",
                "vaccine_detail" : vaccineDetailTextField.text ?? ""
            ]
        }
        
        print("paramDictss total count",paramDict, self.arrImages.count)
        print(requestURL)
        print("\(paramDict)")
        Alamofire.upload(
            multipartFormData: { [self] multipartFormData in
                
                if self.arrImages.count == 0 && self.arrVideo.count == 0 {
                    var Name = "placeholder.png"
                    let word = String(Date().timeIntervalSince1970)
                    if let index = word.range(of: ".")?.lowerBound {
                        let substring = word[..<index]                 // "ora"
                        let string = String(substring)
                        Name = string + ".png"// "ora"
                    }
                    
                    multipartFormData.append((UIImage(named: "placeholder")?.jpegData(compressionQuality: 0.5)!)!, withName: "imgUrl", fileName:Name , mimeType: "image/jpeg")
                }else{
                    for (index,image) in self.arrImagePost.enumerated(){
                        if editAd{
                            multipartFormData.append(image.jpegData(compressionQuality: 1)!, withName: "images[]", fileName: String(Date().timeIntervalSince1970)+".png", mimeType: "image/jpeg")
                        } else {
                            if index == 0 {
                                var Name = "NoName.png"
                                let word = String(Date().timeIntervalSince1970)
                                if let index = word.range(of: ".")?.lowerBound {
                                    let substring = word[..<index]                 // "ora"
                                    let string = String(substring)
                                    Name = string + ".png"// "ora"
                                }
                                multipartFormData.append(image.jpegData(compressionQuality: 0.5)!, withName: "imgUrl", fileName:Name , mimeType: "image/jpeg")
                            }else{
                                multipartFormData.append(image.jpegData(compressionQuality: 0.5)!, withName: "images[]", fileName: String(Date().timeIntervalSince1970)+".png", mimeType: "image/jpeg")
                            }
                        }
                    }
                }
                for i in self.arrVideo{
                    do{
                        if let i = i{
                            let data = try Data(contentsOf: i)
                            multipartFormData.append(data, withName: "videoUrl", fileName: String(Date().timeIntervalSince1970)+".mp4", mimeType: "video/mp4")
                        }
                    }catch{
                        
                    }
                    
                }
                if editAd{
                    if let data = arrVideoData.first{
                        multipartFormData.append(data, withName: "videoUrl", fileName: String(Date().timeIntervalSince1970)+".mp4", mimeType: "video/mp4")
                    }
                }
//                multipartFormData.append(image.jpegData(compressionQuality: 0.5)!, withName: "images[]", fileName: "photo.png", mimeType: "image/jpeg")

                for (key, value) in paramDict
                {
                    multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
                }
                
        },
            usingThreshold:UInt64.init(),
            to: requestURL ,
            method:.post,
            headers:headers,
            encodingCompletion: { encodingResult in

                switch encodingResult {
                case .success(let upload, _, _):

                    upload.responseJSON { response in

                        print("response JSONnnnnnnnn: '\(response)'")

                        if((response.result.value) != nil) {
                            let swiftyJsonVar = JSON(response.result.value!)
                            //print(swiftyJsonVar)

                            let dict:Dictionary<String, JSON> = swiftyJsonVar.dictionaryValue
                            let error = dict["error"]?.boolValue
                            let message = dict["message"]?.string

                            AppUtility.hideProgress()

                            print(dict)

                            if error == false
                            {
//                                let data = dict["data"]?.intValue
//                                let dataString = String(format:"%d",data!)
//                                self.arrPostImages.add(dataString)
                                let alert = UIAlertController(title:"Zoolife" , message:message, preferredStyle: UIAlertController.Style.alert)
                                
                                alert.addAction(UIAlertAction(title: Okey(), style: .default, handler: { (action: UIAlertAction!) in
   
                                    appDelegate.loadTabbar()
                                    
                                }))
                                self.present(alert, animated: true, completion: nil)
                                

                                //self.loadPhoto()

                            }
                            else
                            {
                                AppUtility.hideProgress()

                                let alert = UIAlertController(title:"Zoolife" , message:message, preferredStyle: UIAlertController.Style.alert)
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
        }
        )
    }
    
    func deleteAd (adId : String){
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
    let paramDict = ["user_id":user.ID!,
                         "id": adId] as [String : Any]
//      print(paramDict)
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
                if error == false
                {
                    var word = "تم حذف الإعلان بنجاح"
                    var ok = "حسنا"
                    if appLanguage == "en" {
                        word = "Ad has been removed successfully"
                        ok = "Okay"
                    }
                    self.deleteCallback?()
                    
                    let alert = UIAlertController(title: "Zoolife", message:word, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title:  Okey(), style: UIAlertAction.Style.default,handler: { (_) in
                        self.navigationController?.popViewController(animated: true)
                    }))
                    self.present(alert, animated: true, completion: nil)

                  return
                }
                else
                {
                    self.showAlert(message: message!)
                }
              }
              else
              {
                AppUtility.hideProgress()
                let result = response.result
                print("response JSON: ‘\(result)’")
                //let userInfo = response.error as? Error
                let error = "\(response.error)"
                self.showAlert(message: error)
              }
            }
          case .failure(let encodingError):
            AppUtility.hideProgress()
            print(encodingError)
            self.showAlert(message: "\(encodingError.localizedDescription)")
          }
      })
    }
    
    //MARK: - Button Action Methods
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnUpload(_ sender: Any) {
        
    }
    
    @IBAction func btnAddLocation(_ sender: Any) {
    }
    
    @IBAction func btnDelete(_ sender: Any) {
        
        var word = "هل أنت متأكد أنك تريد حذف هذا المزاد؟"
        var ok = "نعم"
        var no = "إلغاء"
        if appLanguage == "en" {
            word = "Are you sure you want to delete this auction?"
            ok = "Yes"
            no = "No"
        }
        let alert = UIAlertController(title: "Zoo Life", message: word, preferredStyle: .alert)
        
//        let confirmAction = UIAlertAction(title:  Okey(), style: .destructive) { (alert) in
//            self.deleteAd(adId: (self.post?.id)!)
//        }
        let confirmAction = UIAlertAction(title: Okey(), style: .default) { (_) in
            self.deleteAd(adId: "\(self.post?.id ?? 0)")
        }

        
        let cancelAction = UIAlertAction(title: no, style: .cancel,handler: nil)
        
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        
        present(alert, animated: true, completion: nil)
    }
    private func d(){
        
    }
    
    @IBAction func btnPost(_ sender: UIButton) {
        if self.categoryID == "" {
            self.showAlert(message: loc.selectCatFirst.localized())
            return
        }

        if txtAddAuctionTitle.text!.isEmpty{
            var word = "الرجاء إدخال عنوان المزاد."
            if appLanguage == "en" {
                word = "Please enter the title of the auction."
            }
            self.showAlert(message: word)
            return
        }
        
        if textviewAddDesc.text!.isEmpty{
            var word = "الرجاء إدخال وصف المزاد."
            if appLanguage == "en" {
                word = "Please enter the auction description."
            }
            self.showAlert(message: word)
            return
        }
        
        if self.cityName == "" {
            var word = "يرجى اختيار المدينة"
            if appLanguage == "en" {
                word = "Please select a city"
            }
            self.showAlert(message: word)
            return
        }
        
        if self.txtStarterPrice.text! == "" {
            var word = "الرجاء إدخال سعر بداية."
            if appLanguage == "en" {
                word = "Please enter a starter price."
            }
            self.showAlert(message: word)
            return
        }
        
//        if self.txtAddMinimumBid.text! == "" {
//            var word = "الرجاء تحديد الحد الأقصى للسعر."
//            if appLanguage == "en" {
//                word = "Please select a maximum price."
//            }
//            self.showAlert(message: word)
//            return
//        }
        
//        if self.txtHours.text! == "" {
//            var word = "الرجاء تحديد ساعة."
//            if appLanguage == "en" {
//                word = "Please select a hours."
//            }
//            self.showAlert(message: word)
//            return
//        }
//
//        if self.txtTotalDays.text! == "" {
//            var word = "الرجاء تحديد إجمالي الأيام."
//            if appLanguage == "en" {
//                word = "Please select a Total Days."
//            }
//            self.showAlert(message: word)
//            return
//        }
        if self.txtHours.text! == "" && self.txtTotalDays.text! == ""{
            var word = "الرجاء تحديد ساعات أو إجمالي الأيام."
            if appLanguage == "en" {
                word = "Please select a hours or total days."
            }
            self.showAlert(message: word)
            return
        }
        if sexMaleSelectionBtn.tag == 0 && sexFemaleSelectionBtn.tag == 0{
            var word = "يرجى اختيار الجنس"
            if appLanguage == "en" {
                word = "Please select Sex"
            }
            self.showAlert(message: word)
            return
        }
        if passportYesBtn.tag == 0 && passportNoBtn.tag == 0{
            var word = "يرجى اختيار جواز السفر"
            if appLanguage == "en" {
                word = "Please select Passport"
            }
            self.showAlert(message: word)
            return
        }
        
        txtStarterPrice.resignFirstResponder()
        txtAddAuctionTitle.resignFirstResponder()
        textviewAddDesc.resignFirstResponder()
        uploadPhotos()
    }
    
    
    
    @IBAction func buttonDeleteImagesAction(_ sender: UIButton) {
        var word = "هل أنت متأكد أنك تريد حذف جميع الصور"
                    if appLanguage == "en" {
                        word = "Are you sure you want to delete all pictures?"
                    }
        let alert = UIAlertController(title: "Zoo Life", message: word, preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title:  Okey(), style: .destructive) { (_) in
//            self.deletePostImage(adId: (self.post?.id)!)
            self.arrImagePost.removeAll()
            self.arrImages.removeAllObjects()
            self.imagesArray.removeAll()
            self.arrVideo.removeAll()
            self.arrVideoData.removeAll()
            self.collectionUpload.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "إلغاء", style: .cancel,handler: nil)
        
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    @objc func btnDeleteImage(_ sender : UIButton)
    {
        let indexPath = NSIndexPath(row: sender.tag, section: 0)
        let cell = self.collectionUpload .cellForItem(at: indexPath as IndexPath) as! UploadCell
        
        cell.imgProduct.image = nil
        
        arrImages.removeObject(at: indexPath.row-1)
        imagesArray.remove(at: indexPath.row-1)

        //arrImageS
        arrImagePost.remove(at: indexPath.row-1)
        collectionUpload.reloadData()
    }     
    @IBAction func femaleSexBtnTapped(_ sender: Any) {
        femaileContainerView.borderColor = UIColor.gray
        femaileContainerView.borderWidth = 2
        maleContainerView.borderColor = UIColor.clear
        maleContainerView.borderWidth = 0
        sexFemaleSelectionBtn.tag = 1
        sexMaleSelectionBtn.tag = 0
    }
    @IBAction func maleSexBtnTapped(_ sender: Any) {
        maleContainerView.borderColor = UIColor.gray
        maleContainerView.borderWidth = 2
        femaileContainerView.borderColor = UIColor.clear
        femaileContainerView.borderWidth = 0
        sexMaleSelectionBtn.tag = 1
        sexFemaleSelectionBtn.tag = 0
    }
    @IBAction func passportYesBtnTapped(_ sender: Any) {
        passportYesContainerView.borderColor = UIColor.gray
        passportYesContainerView.borderWidth = 2
        passportNoContainerView.borderColor = UIColor.clear
        passportNoContainerView.borderWidth = 0
        passportYesBtn.tag = 1
        passportNoBtn.tag = 0
    }
    @IBAction func passportNoBtnTapped(_ sender: Any) {
        passportNoContainerView.borderColor = UIColor.gray
        passportNoContainerView.borderWidth = 2
        passportYesContainerView.borderColor = UIColor.clear
        passportYesContainerView.borderWidth = 0
        passportNoBtn.tag = 1
        passportYesBtn.tag = 0
    }
    // MARK: - Collection Delegate
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return imagesArray.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if indexPath.row == 0
        {
            collectionView.register(UINib(nibName: "UploadCell", bundle: nil), forCellWithReuseIdentifier: "UploadCell")
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UploadCell", for: indexPath as IndexPath) as! UploadCell
            cell.imgProduct.contentMode = .center
            cell.imgProduct.image = UIImage(named:"add_placeholder")
            
            cell.btnDelete.isHidden = true
            
            return cell
        }
        else
        {
            collectionView.register(UINib(nibName: "UploadCell", bundle: nil), forCellWithReuseIdentifier: "UploadCell")
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UploadCell", for: indexPath as IndexPath) as! UploadCell
            
            
            
            cell.btnDelete.addTarget(self, action: #selector(AddAuctionViewController.btnDeleteImage(_:)), for: .touchUpInside)
            cell.btnDelete.tag = indexPath.row
            
            let image = self.imagesArray[indexPath.row-1]
            
            //arrImageS
            //let imageS = self.arrImageS.object(at: indexPath.row-1) as! UIImage
            
            cell.imgProduct.contentMode = .scaleToFill
            cell.imgProduct.image = image
            
            if editAd{
                cell.btnDelete.isHidden = true
            }else{
                cell.btnDelete.isHidden = false
            }
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        if indexPath.row == 0{
            var word = "تحديد صورة"
                        if appLanguage == "en" {
                            word = "Select Picture"
                        }
            let actionSheet = UIAlertController(title: nil, message: word, preferredStyle: .actionSheet)
            UIPicker.view.tag = indexPath.row;
            
//            let cameraAction = UIAlertAction(title: "Take Photo From Camera", style: .default, handler: {
//                (alert: UIAlertAction!) -> Void in
//
//                if UIImagePickerController.isSourceTypeAvailable(.camera){
//                    self.UIPicker.allowsEditing = false
//                    self.UIPicker.sourceType = UIImagePickerController.SourceType.camera
//                    self.UIPicker.cameraCaptureMode = .photo
//                    self.UIPicker.modalPresentationStyle = .fullScreen
//                    self.present(self.UIPicker, animated: true, completion: nil)
//                }
//            })
            
            var word1 = "اختيار صورة من المعرض"
                        if appLanguage == "en" {
                            word1 = "Choose a picture from the gallery"
                        }
            var word2 = "اختيار فيديو من المعرض"
                        if appLanguage == "en" {
                            word2 = "Choose a Video from the gallery"
                        }
            
            let libraryAction = UIAlertAction(title: word1, style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                
                self.picker = NohanaImagePickerController.init()
                self.picker.delegate = self
                // Set the maximum number of selectable images
                self.picker.maximumNumberOfSelection = 5
                
                // Set the cell size
                self.picker.numberOfColumnsInPortrait = 3
                self.picker.numberOfColumnsInLandscape = 3
                
                // Show Moment
                self.picker.shouldShowMoment = true
                
                // Hide toolbar
                self.picker.shouldShowEmptyAlbum = false
                
                self.present(self.picker, animated: true, completion: nil)
            })
            
            let uploadVideo = UIAlertAction(title: word2, style: .default) { _ in
                self.imagePickerController.delegate = self
                self.imagePickerController.sourceType = .savedPhotosAlbum
            
                self.imagePickerController.mediaTypes = [kUTTypeMovie as String]
                   
                self.present(self.imagePickerController, animated: true, completion: nil)
            }
            
            let cancelAction = UIAlertAction(title: Cancel(), style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                
            })
            
            //actionSheet.addAction(cameraAction)
            actionSheet.addAction(libraryAction)
            actionSheet.addAction(uploadVideo)
            actionSheet.addAction(cancelAction)
            
            self.present(actionSheet, animated: true, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let width:CGFloat = CGFloat (collectionView.frame.size.width/1.25)
        let height:CGFloat = CGFloat (collectionView.frame.size.height)
        
        return CGSize (width: width, height: height)
    }
    
    //MARK:- UITextField Delegate Methods
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtAddLocation{
            var word = "اختيار موقع"
            if appLanguage == "en" {
                word = "Choose a site"
            }
            ActionSheetStringPicker.show(withTitle: word, rows: arrCityNames, initialSelection: 0, doneBlock: {
                picker, indexes, values in
                
                self.cityName = values as! String
                self.txtAddLocation.text = values as? String
                
                return
            }, cancel: { ActionSheetStringPicker in return},origin: textField)
            return false
        }else if textField == txtCategory{
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
                    self.getSubCategory(categoryID: self.categoryID)
                    self.subCategoryID = ""
                    self.txtSubCategory.text =  ""
                    return
                }, cancel: { ActionSheetStringPicker in return},origin: textField)
                
                return false
            }
        }else if textField == txtSubCategory{
            if txtCategory.text == ""
            {
                var word = "الرجاء تحديد الفئة أولا"
                var ok = "خطأ!"
                if appLanguage == "en" {
                    word = "Please select the category first."
                    ok = "Okey"
                }
                let alert = UIAlertController(title: ok, message:word, preferredStyle: UIAlertController.Style.alert)
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
                        self.txtSubCategory.text = values as? String
                        return
                    }, cancel: { ActionSheetStringPicker in return},origin: textField)
                }
            }
            return false
        }else if textField == txtTotalDays{
            
            var word = "حدد إجمالي الأيام"
            if appLanguage == "en" {
                word = "Select Total Days"
            }
            ActionSheetStringPicker.show(withTitle: word, rows: arrDays, initialSelection: 0, doneBlock: {
                picker, indexes, values in
                self.txtTotalDays.text = values as? String
                return
            }, cancel: { ActionSheetStringPicker in return},origin: textField)
            
            return false
        }else if textField == txtHours{
            
            var word = "حدد ساعات"
            if appLanguage == "en" {
                word = "Select Hours"
            }
            ActionSheetStringPicker.show(withTitle: word, rows: arrTimes, initialSelection: 0, doneBlock: {
                picker, indexes, values in
                self.txtHours.text = values as? String
                return
            }, cancel: { ActionSheetStringPicker in return},origin: textField)
            
            return false
        }
//        else if textField == txtAddMinimumBid{
//
//            var word = "حدد الحد الأقصى لعرض التسعير"
//            if appLanguage == "en" {
//                word = "Select maximum bid"
//            }
//            ActionSheetStringPicker.show(withTitle: word, rows: arrBidPrices, initialSelection: 0, doneBlock: {
//                picker, indexes, values in
//                self.txtAddMinimumBid.text = values as? String
//                return
//            }, cancel: { ActionSheetStringPicker in return},origin: textField)
//
//            return false
//        }
//        else if textField == txtStarterPrice{
//
//            var word = "حدد عرض الأسعار المبدئي"
//            if appLanguage == "en" {
//                word = "Select Starter bid"
//            }
//            ActionSheetStringPicker.show(withTitle: word, rows: arrBidPrices, initialSelection: 0, doneBlock: {
//                picker, indexes, values in
//                self.txtStarterPrice.text = values as? String
//                return
//            }, cancel: { ActionSheetStringPicker in return},origin: textField)
//
//            return false
//        }
        
        return true
    }
    
    //MARK: -ImagePickerView Delegates
    /*
    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        
        
        
        let chosenImage = info[UIImagePickerController.InfoKey.originalImage.rawValue] as! UIImage
        
        arrImages.insert(chosenImage, at: 0)
        self.arrData.insert(chosenImage, at: 0)
        
        //arrImageS
        arrImageS.insert(chosenImage, at: 0)
        
        
        dismiss(animated: true, completion: nil)
        
        collectionUpload.reloadData()
        
    }
    */
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        dismiss(animated: true, completion: nil)
    }
    
    func nohanaImagePickerDidCancel(_ picker: NohanaImagePickerController)
    {
        print("🐷Canceled🙅")
        self.picker.dismiss(animated: true, completion: nil)
    }
    
    func nohanaImagePicker(_ picker: NohanaImagePickerController, didFinishPickingPhotoKitAssets pickedAssts :[PHAsset])
    {
        print("🐷Completed🙆\n\tpickedAssets = \(pickedAssts)")
        
        for asset in pickedAssts
        {
            let options = PHImageRequestOptions()
//            options.deliveryMode = .fastFormat
//
//            options.resizeMode   = PHImageRequestOptionsResizeMode.exact
//            options.deliveryMode = PHImageRequestOptionsDeliveryMode.highQualityFormat
            
            // this one is key
            options.isSynchronous = true
            
            
            PHImageManager.default().requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFill, options: options)
            { result, info in
                let img:UIImage = result!
                
                self.arrImages.insert(img, at: 0)
                self.imagesArray.append(img)
                //arrImageS
                self.arrImagePost.append(img)
                
                self.arrData.insert(img, at: 0)
            }
        }
        
        self.collectionUpload.reloadData()

        
        self.picker.dismiss(animated: true, completion: nil)
    }
}

extension AddAuctionViewController: UIImagePickerControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        videoURL = info[UIImagePickerController.InfoKey.mediaURL]as? URL
        arrVideo.append(videoURL)
        do {
            let asset = AVURLAsset(url: (videoURL as URL?)! , options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            
            imagesArray.insert(thumbnail, at: 0)
            self.arrData.insert(thumbnail, at: 0)
            
            self.collectionUpload.reloadData()
        } catch let error {
            print("*** Error generating thumbnail: \(error.localizedDescription)")
        }
        self.dismiss(animated: true, completion: nil)
    }
}

extension AddAuctionViewController{
    
    func showAlert(message:String){
        var word = "حسنا"
        if appLanguage == "en" {
            word = "Okay"
        } else {
            word = "حسنا"
        }
        let alert = UIAlertController(title: "Zoolife", message:message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: word, style: UIAlertAction.Style.default,handler: { (_) in
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
}
