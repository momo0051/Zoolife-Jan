
//
//  AddAdViewController.swift
//  ZOOLIFE
//
//  Created by Hafiz Anser  on 11/25/20.
//  Copyright © 2020 Hafiz Anser. All rights reserved.
//

import UIKit
import Alamofire
import Photos
import NohanaImagePicker
import ActionSheetPicker_3_0
import SwiftyJSON
import SDWebImage
import Kingfisher

class AddAdViewController: UIViewController, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, NohanaImagePickerControllerDelegate, UITextViewDelegate, UICollectionViewDelegateFlowLayout
{
    var cityName = ""
    
    @IBOutlet weak var lblWhatsApp: UILabel!
    @IBOutlet weak var lblChat: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblCall: UILabel!
    @IBOutlet weak var btnDeletePost: UIButton!
    @IBOutlet weak var btnPost: UIButton!
    @IBOutlet weak var lblShowPhone: UILabel!
    @IBOutlet weak var lblComunicationOption: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblPostTitle: UILabel!
    @IBOutlet weak var lblSubCat: UILabel!
    @IBOutlet weak var lblChooseCat: UILabel!
    @IBOutlet weak var lblUpoadImage: UILabel!
    @IBOutlet weak var lblAddLocation: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var lblUserPhoneNumber: UILabel!
    @IBOutlet weak var tfDescription: UITextView!
    @IBOutlet weak var textViewDescription: UITextView!
    @IBOutlet weak var btnShowHidePhoneNo: UIButton!
    @IBOutlet weak var btnPhoneNumber: UIButton!
    @IBOutlet weak var btnMessage: UIButton!
    @IBOutlet weak var btnComments: UIButton!
    @IBOutlet weak var tfAddTitle: UITextField!
    @IBOutlet weak var btnLocation: UIButton!
    @IBOutlet weak var btnSubCategory: UIButton!
    @IBOutlet weak var btnCategory: UIButton!
    @IBOutlet weak var collectionUpload: UICollectionView!
    @IBOutlet weak var buttonDelete: UIButton!
    @IBOutlet weak var heightDeleteImagesButton: NSLayoutConstraint!
    @IBOutlet weak var buttonDeleteImages: UIButton!
    
    @IBOutlet weak var whatsappppButton: UIButton!
    
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
    //    @IBOutlet weak var coverImageView: UIImageView!
    var imageCover:UIImage? = UIImage.init(named: "logo")//add_placeholder
    
    var deleteCallback : (() -> ())?
    
    var arrImages = NSMutableArray()
    var arrImageS = [UIImage]()
    {
        didSet
        {
            if editAd
            {
                print("array Images Count = ",arrImageS.count)
                if arrImageS.count > 0
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
    var arrPostImages = NSMutableArray()
    var arrData = NSMutableArray()
    var arrCategories = NSMutableArray()
    
    var UIPicker = UIImagePickerController()
    var picker = NohanaImagePickerController()
    
    //    var arrCategory = [Any]()
    //    var arrSubCategory = [Any]()
    
    var arrCategoryData = NSMutableArray()
    var arrSubCategoryData = NSMutableArray()
    var arrCityData = NSMutableArray()
    var categoryID = ""
    var subCategoryID = ""
    
    
    var arrCategory = [Any]()
    var arrSubCategory = [Any]()
    
    var imageD = UIImage.init(named: "myImage")
    var imgData:Data?
    
    
    var editAd = false
    var post:Ad?
    
    @IBAction func buttonDeleteImagesAction(_ sender: UIButton) {
        var word = "هل أنت متأكد أنك تريد حذف جميع الصور"
        if appLanguage == "en" {
            word = "Are you sure you want to delete all pictures?"
        }
        let alert = UIAlertController(title: "Zoo Life", message: word, preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title:  Okey(), style: .destructive) { (_) in
            self.deletePostImage(adId: (self.post?.id)!)
        }
        
        let cancelAction = UIAlertAction(title: "إلغاء", style: .cancel,handler: nil)
        
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    
    //var arrCityNames = ["الرياض","الشرقية","جدة","مكة","ينبع","حفر الباطن","المدينة","الطائف","تبوك","القصيم","حائل","ابها","الباحة","جيزان","نجران","الجوف","عرعر","الكويت","الأمارات","البحرين"]
    var arrCityNames:[String] = []
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        // self.coverImageView.image = imageCover
        
        collectionUpload.delegate = self
        collectionUpload.dataSource = self
        
        
        if let post = post
        {
            print("post id = ", post.id)
        }
        
        if self.editAd{
            self.btnCategory.setTitle("", for: .normal)
            self.btnSubCategory.setTitle("", for: .normal)
            buttonDelete.isHidden = false
            
            if arrImageS.count > 0
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
            buttonDelete.isHidden = true
            buttonDeleteImages.isHidden = true
            heightDeleteImagesButton.constant = 0
        }
        
        self.navigationController?.isNavigationBarHidden = true
        UIView.appearance().semanticContentAttribute = .forceRightToLeft
        getCategory()
        getCity()
        arrImages = NSMutableArray.init()
        arrPostImages = NSMutableArray.init()
        arrData = NSMutableArray.init()
        arrCategories = NSMutableArray.init()
        
        UIPicker = UIImagePickerController.init()
        UIPicker.delegate = self
        
        
        //        btnCategory.titleLabel?.textAlignment = NSTextAlignment.left
        //        btnSubCategory.titleLabel?.textAlignment = NSTextAlignment.right
        
        btnCategory.contentHorizontalAlignment = .right
        btnSubCategory.contentHorizontalAlignment = .right
        btnLocation.contentHorizontalAlignment = .right
        tfAddTitle.textAlignment = NSTextAlignment.right
        tfDescription.textAlignment = NSTextAlignment.right
        
        if !editAd{
            // tfDescription.text = "اكتب وصفك هنا ..."
        }
        
        tfDescription.delegate = self
        //        tfDescription.textColor = UIColor.init(red: 134/255, green: 137/255, blue: 141/255, alpha: 1.0)
        
        //        let user:User = AppUtility.getSession()
        var user: User
        
        if let u = AppUtility.getSession() {
            user = u
        }else{
            return
        }
        if let phoneNumber = user.phone
        {
            lblUserPhoneNumber.text = phoneNumber
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        UpdateLang_UI()
    }
    func UpdateLang_UI(){
        if let lang = UserDefaults.standard.object(forKey: "appLang") as? String {
            if lang == "en" {
                lblTitle.localizeKey = "Add New Post"
                lblWhatsApp.localizeKey = "WhatsApp"
                lblChat.localizeKey = "Comments"
                lblMessage.localizeKey = "Messages"
                lblCall.localizeKey = "Phone"
                btnDeletePost.localizeKey = "Delete Post"
                btnPost.localizeKey = "POST"
                lblShowPhone.localizeKey = "Show my phone number"
                lblComunicationOption.localizeKey = "Select communications options:"
                lblDesc.localizeKey = "Add Post Description"
                lblPostTitle.localizeKey = "Add Post Tittle"
                lblSubCat.localizeKey = "Choose Subcategory"
                lblChooseCat.localizeKey = "Choose Category"
                lblUpoadImage.localizeKey = "Upload Image"
                lblAddLocation.localizeKey = "Add location"
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
                
                btnCategory.contentHorizontalAlignment = .left
                btnSubCategory.contentHorizontalAlignment = .left
                btnLocation.contentHorizontalAlignment = .left
                tfAddTitle.textAlignment = NSTextAlignment.left
                tfDescription.textAlignment = NSTextAlignment.left
                
                UIView.appearance().semanticContentAttribute = .forceLeftToRight
            } else {
                btnCategory.contentHorizontalAlignment = .right
                btnSubCategory.contentHorizontalAlignment = .right
                btnLocation.contentHorizontalAlignment = .right
                tfAddTitle.textAlignment = NSTextAlignment.right
                tfDescription.textAlignment = NSTextAlignment.right
                
                lblTitle.localizeKey = "اضافة اعلان"
                lblWhatsApp.localizeKey = "واتس اب"
                lblChat.localizeKey = "تعليقات"
                lblMessage.localizeKey = "رسالة"
                lblCall.localizeKey = "رقم الهاتف"
                btnDeletePost.localizeKey = "حذف الاعلان"
                btnPost.localizeKey = "اضف الاعلان"
                lblShowPhone.localizeKey = "أظهر رقم هاتفي"
                lblComunicationOption.localizeKey = "التواصل مع البائع"
                lblDesc.localizeKey = "وصف إعلان"
                lblPostTitle.localizeKey = "عنوان إعلان"
                lblSubCat.localizeKey = "تصنيف فرعي"
                lblChooseCat.localizeKey = "الفئة"
                lblUpoadImage.localizeKey = "تحميل الصور"
                lblAddLocation.localizeKey = "موقعك"
                
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
            
            
            if let imgUrl = post.imgUrl {
                if let url = URL(string: imgUrl){
                    KingfisherManager.shared.retrieveImage(with: url, options: nil, progressBlock: nil, completionHandler: { result in
                        
                        switch result {
                        case .success(let value):
                            
                            self.imageCover = value.image
                            
                            let img = value.image
                            self.arrImageS.append(img)
                            self.arrImages.insert(img, at: 0)
                            
                            
                            if self.arrImageS.count == (post.images.count + 1){
                                self.collectionUpload.reloadData()
                            }
                            
                        case .failure:
                            
                            self.arrImageS.append(UIImage.init(named: "logo") ?? UIImage())
                            
                            self.arrImages.insert((UIImage.init(named: "logo") ?? UIImage()), at: 0)
                            
                            if self.arrImageS.count == (post.images.count + 1){
                                self.collectionUpload.reloadData()
                            }
                        }
                    })
                }
            }
            
            for image in post.images{
                
                if let url = URL(string: image){
                    KingfisherManager.shared.retrieveImage(with: url, options: nil, progressBlock: nil, completionHandler: { result in
                        
                        switch result {
                            
                        case .success(let value):
                            
                            self.imageCover = value.image
                            self.arrImageS.append(value.image )
                            
                            self.arrImages.insert((value.image ), at: 0)
                            
                            if self.arrImageS.count == (post.images.count + 1){
                                self.collectionUpload.reloadData()
                            }
                        case .failure:
                            self.arrImageS.append(UIImage.init(named: "logo") ?? UIImage())
                            
                            self.arrImages.insert((UIImage.init(named: "logo") ?? UIImage()), at: 0)
                            
                            if self.arrImageS.count == (post.images.count + 1){
                                self.collectionUpload.reloadData()
                            }
                        }
                    })
                }
            }
            
            
            self.categoryID = post.category ?? ""
            self.subCategoryID = post.subCategory ?? ""
            
            self.cityName = post.city ?? ""
            btnLocation.setTitle(post.city, for: .normal)
            tfAddTitle.text = post.itemTitle
            tfDescription.text = post.itemDesc
            
            
            
            if let message = post.showMessage{
                if let intTag = Int(message){
                    btnMessage.tag = intTag
                    if intTag == 1{
                        btnMessage.setImage(UIImage(named: "ic_check"), for: .normal)
                    }
                    else{
                        btnMessage.setImage(UIImage(named: "ic_uncheck"), for: .normal)
                    }
                }
            }
            
            if let whatsapp = post.showWhatsapp{
                if let intTag = Int(whatsapp){
                    whatsappppButton.tag = intTag
                    if intTag == 1{
                        whatsappppButton.setImage(UIImage(named: "ic_check"), for: .normal)
                    }
                    else{
                        whatsappppButton.setImage(UIImage(named: "ic_uncheck"), for: .normal)
                    }
                }
            }
            
            if let phone = post.showPhoneNumber{
                if let intTag = Int(phone){
                    btnPhoneNumber.tag = intTag
                    if intTag == 1{
                        btnPhoneNumber.setImage(UIImage(named: "ic_check"), for: .normal)
                    }
                    else{
                        btnPhoneNumber.setImage(UIImage(named: "ic_uncheck"), for: .normal)
                    }
                }
            }
            if let comments = post.showComments{
                if let intTag = Int(comments){
                    btnComments.tag = intTag
                    if intTag == 1{
                        btnComments.setImage(UIImage(named: "ic_check"), for: .normal)
                    }
                    else{
                        btnComments.setImage(UIImage(named: "ic_uncheck"), for: .normal)
                    }
                }
            }
        }
    }
    
    
    
    //MARK: - Button Actions
    @IBAction
    func whatsaAppButtonTapped(_ sender: UIButton) {
        if whatsappppButton.tag == 0
        {
            whatsappppButton.tag = 1
            whatsappppButton.setImage(UIImage(named: "ic_check"), for: .normal)
        }
        else
        {
            whatsappppButton.tag = 0
            whatsappppButton.setImage(UIImage(named: "ic_uncheck"), for: .normal)
        }
    }
    
    @IBAction func categoryTapped(_ sender: Any){
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
                
                self.btnCategory.setTitle(values as! String?, for: .normal)
                self.btnCategory.setTitleColor(UIColor.black, for: .normal)
                self.getSubCategory(categoryID: self.categoryID)
                
                return
            }, cancel: { ActionSheetStringPicker in return},origin: sender)
            
        }
    }
    @IBAction func subCategoryTapped(_ sender: Any)
    {
        if btnCategory.titleLabel?.text == ""
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
                    
                    self.btnSubCategory.setTitleColor(UIColor.black, for: .normal)
                    self.btnSubCategory.setTitle(values as! String?, for: .normal)
                    
                    return
                }, cancel: { ActionSheetStringPicker in return},origin: sender)
            }
        }
    }
    
    @IBAction func buttonDeleteAction(_ sender: UIButton) {
        var word = "هل أنت متأكد أنك تريد حذف هذا الإعلان"
        var ok = "نعم"
        var no = "إلغاء"
        if appLanguage == "en" {
            word = "Are you sure you want to delete this ad?"
            ok = "Yes"
            no = "No"
        }
        let alert = UIAlertController(title: "Zoo Life", message: word, preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title:  Okey(), style: .destructive) { (_) in
            self.deleteAd(adId: (self.post?.id)!)
        }
        
        let cancelAction = UIAlertAction(title: no, style: .cancel,handler: nil)
        
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        
        present(alert, animated: true, completion: nil)
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
    //MARK: - Functions
    
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
        
        var paramDict : [String: Any]
        if editAd{
            requestURL = URL(string: UPDATE_POST)!
            paramDict  = ["item_id":post?.id ?? "0",
                          "priority": 0,
                          "city":btnLocation.titleLabel?.text! ?? "مكه",
                          "country": "المملكة العربية السعودية",
                          "user_id":user.ID!,
                          "location":btnLocation.titleLabel?.text! ?? "as",
                          "itemTitle":tfAddTitle.text!,
                          "itemDesc":tfDescription.text!,
                          "category":categoryID,
                          "subCategory":subCategoryID,
                          "showComments":btnComments.tag,
                          "showPhoneNumber":btnPhoneNumber.tag,
                          "showMessage":btnMessage.tag,
                          "showWhatsapp":whatsappppButton.tag,
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
                "city":btnLocation.titleLabel?.text! ?? "مكه",
                "country": "المملكة العربية السعودية",
                "location":btnLocation.titleLabel?.text! ?? "as",
                "itemTitle":tfAddTitle.text!,
                "itemDesc":tfDescription.text!,
                "category":categoryID,
                "subCategory":subCategoryID,
                "showComments":btnComments.tag,
                "showPhoneNumber":btnPhoneNumber.tag,
                "showMessage":btnMessage.tag,
                "showWhatsapp":whatsappppButton.tag,
                "age" : Int(ageTextField.text ?? "0") ?? 0,
                "sex" : sexMaleSelectionBtn.tag == 1 ? "male":"female",
                "passport" : passportYesBtn.tag == 1 ? "yes":"no",
                "vaccine_detail" : vaccineDetailTextField.text ?? ""]
        }
        
        
        
        print("paramDictss total count",paramDict, self.arrImages.count)
        print(requestURL)
        print("\(paramDict)")
        Alamofire.upload(
            multipartFormData: { [self] multipartFormData in
                
                if self.arrImages.count == 0 {
                    var Name = "placeholder.png"
                    let word = String(Date().timeIntervalSince1970)
                    if let index = word.range(of: ".")?.lowerBound {
                        let substring = word[..<index]                 // "ora"
                        let string = String(substring)
                        Name = string + ".png"// "ora"
                    }
                    
                    multipartFormData.append((UIImage(named: "placeholder")?.jpegData(compressionQuality: 0.5)!)!, withName: "imgUrl", fileName:Name , mimeType: "image/jpeg")
                }else{
                    for (index,image) in self.arrImageS.enumerated(){
                        
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
    
    func getSubCategory(categoryID: String){
        
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
    func getCategory()
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
                alert.addAction(UIAlertAction(title:  Okey(), style: UIAlertAction.Style.default, handler: nil))
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
    func loadPhoto()
    {
        for i in (0..<arrData.count)
        {
            let image:UIImage = arrData.object(at: i) as! UIImage
            
            self.arrData.removeObject(at: i)
            
            
            
            
            
            //self.imgFront.image = chosenImage
            imgData = image.jpegData(compressionQuality: 0.2)!
            imageD = image
            
            break
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        if tfDescription.text == "اكتب وصفك هنا ..."
        {
            tfDescription.text = ""
            tfDescription.textColor = UIColor.black
        }
        textView.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView)
    {
        if tfDescription.text == ""
        {
            tfDescription.text = "اكتب وصفك هنا ..."
            tfDescription.textColor = UIColor.black
        }
        textView.resignFirstResponder()
    }
    
    
    // MARK: - Collection Delegate
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return arrImages.count + 1
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
            
            
            
            cell.btnDelete.addTarget(self, action: #selector(AddAdViewController.btnDeleteImage(_:)), for: .touchUpInside)
            cell.btnDelete.tag = indexPath.row
            
            let image = self.arrImages.object(at: indexPath.row-1) as! UIImage
            
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
            
            let cancelAction = UIAlertAction(title: Cancel(), style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                
            })
            
            //actionSheet.addAction(cameraAction)
            actionSheet.addAction(libraryAction)
            actionSheet.addAction(cancelAction)
            
            self.present(actionSheet, animated: true, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let width:CGFloat = CGFloat (collectionView.frame.size.width/1.65)
        let height:CGFloat = CGFloat (collectionView.frame.size.height)
        
        return CGSize (width: width, height: height)
    }
    
    
    //    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    //        if self.coverImageItIs{
    //            self.coverImageItIs = false
    //
    //            if let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
    ////            info.ima
    ////            let chosenImage = info[UIImagePickerController.InfoKey.originalImage.rawValue] as! UIImage
    //            self.imageCover = chosenImage
    //                self.coverImageView.image = self.imageCover
    //
    //            }
    //            dismiss(animated: true, completion: nil)
    //            return
    //        }
    //    }
    //MARK: -ImagePickerView Delegates
    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        
        
        
        let chosenImage = info[UIImagePickerController.InfoKey.originalImage.rawValue] as! UIImage
        
        arrImages.insert(chosenImage, at: 0)
        self.arrData.insert(chosenImage, at: 0)
        
        //arrImageS
        arrImageS.insert(chosenImage, at: 0)
        
        
        dismiss(animated: true, completion: nil)
        
        collectionUpload.reloadData()
        
    }
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
                
                //arrImageS
                self.arrImageS.insert(img, at: 0)
                
                self.arrData.insert(img, at: 0)
            }
        }
        
        self.collectionUpload.reloadData()
        
        
        
        
        
        //
        //self.loadPhoto()
        //
        
        //CMMetadataFormatDescriptionCreateWithMetadataSpecifications(allocator: <#T##CFAllocator?#>, metadataType: <#T##CMMetadataFormatType#>, metadataSpecifications: <#T##CFArray#>, formatDescriptionOut: <#T##UnsafeMutablePointer<CMMetadataFormatDescription?>#>)
        
        
        
        
        
        
        
        
        
        self.picker.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Buttons Action
    @IBAction func backTapped(_ sender: Any)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    //    @IBAction func addPostTapped(_ sender: UIButton)
    //    {
    //        if arrImageS.count < 2{
    //            let alert = UIAlertController(title: "Information", message:"Select atleast 2 Images", preferredStyle: UIAlertController.Style.alert)
    //            alert.addAction(UIAlertAction(title: Okey(), style: UIAlertAction.Style.default, handler: nil))
    //            self.present(alert, animated: true, completion: nil)
    //
    //            return
    //        }
    ////
    ////        let viewController = AddPostFirstViewController(nibName:"AddPostFirstViewController", bundle:nil)
    ////
    ////        viewController.arrCategories = NSMutableArray.init()
    ////        viewController.arrImages = NSMutableArray.init()
    ////        viewController.arrImagesName = NSMutableArray.init()
    ////        viewController.arrCategories = arrCategories
    ////        viewController.arrImages = arrImages
    ////        viewController.arrImagesName = arrPostImages
    ////
    ////        viewController.hidesBottomBarWhenPushed = true
    ////        appDelegate.menuButton.isHidden = true
    ////        appDelegate.menuButton.removeFromSuperview()
    ////
    ////        self.navigationController?.pushViewController(viewController, animated:true)
    //    }
    
    @IBAction func locationTapped(_ sender: Any)
    {
        var word = "اختيار موقع"
        if appLanguage == "en" {
            word = "Choose a site"
        }
        ActionSheetStringPicker.show(withTitle: word, rows: arrCityNames, initialSelection: 0, doneBlock: {
            picker, indexes, values in
            
            self.cityName = values as! String
            self.btnLocation.setTitle(values as! String?, for: .normal)
            self.btnLocation.setTitleColor(UIColor.black, for: .normal)
            //self.getSubCategory()
            
            return
        }, cancel: { ActionSheetStringPicker in return},origin: sender)
    }
    @IBAction func phoneTapped(_ sender: Any)
    {
        if btnPhoneNumber.tag == 0
        {
            btnPhoneNumber.tag = 1
            btnPhoneNumber.setImage(UIImage(named: "ic_check"), for: .normal)
        }
        else
        {
            btnPhoneNumber.tag = 0
            btnPhoneNumber.setImage(UIImage(named: "ic_uncheck"), for: .normal)
        }
    }
    @IBAction func messageTapped(_ sender: Any)
    {
        if btnMessage.tag == 0
        {
            btnMessage.tag = 1
            btnMessage.setImage(UIImage(named: "ic_check"), for: .normal)
        }
        else
        {
            btnMessage.tag = 0
            btnMessage.setImage(UIImage(named: "ic_uncheck"), for: .normal)
        }
    }
    @IBAction func commentTapped(_ sender: Any)
    {
        if btnComments.tag == 0{
            btnComments.tag = 1
            btnComments.setImage(UIImage(named: "ic_check"), for: .normal)
        }
        else{
            btnComments.tag = 0
            btnComments.setImage(UIImage(named: "ic_uncheck"), for: .normal)
        }
    }
    @IBAction func showHidePhoneNumber(_ sender: Any)
    {
        
        if btnShowHidePhoneNo.tag == 0
        {
            btnShowHidePhoneNo.tag = 1
            btnShowHidePhoneNo.setImage(UIImage(named: "on"), for: .normal)
        }
        else
        {
            btnShowHidePhoneNo.tag = 0
            btnShowHidePhoneNo.setImage(UIImage(named: "off"), for: .normal)
        }
    }
    
    @IBAction func continueTapped(_ sender: Any){
        
        
        //        "pass":"update-item",
        //                       "id":post?.id ?? "0",
        //                       "city":btnLocation.titleLabel?.text! ?? "مكه",
        //                       "country": "المملكة العربية السعودية",
        //                       "username":user.phone!,
        //                       "location":btnLocation.titleLabel?.text! ?? "as",
        //                       "title":tfAddTitle.text!,
        //                       "description":tfDescription.text!,
        //                       "category":categoryID,
        //                       "sub_category":subCategoryID,
        //                       "showComments":btnComments.tag,
        //                       "showPhone":btnPhoneNumber.tag,
        //                       "showMessage":btnMessage.tag]
        
        
        if self.categoryID == "" {
            self.showAlert(message: loc.selectCatFirst.localized())
            return
        }
        
        //        if self.subCategoryID == "" {
        //            self.showAlert(message: "يرجى اختيار الفئة الفرعية")
        //            return
        //        }
        if tfAddTitle.text!.isEmpty{
            var word = "يرجى اختيار عنوان الاعلان"
            if appLanguage == "en" {
                word = "Please enter the title of the ad."
            }
            self.showAlert(message: word)
            return
        }
        
        if tfDescription.text!.isEmpty{
            var word = "يرجى اختيار وصف الاعلان"
            if appLanguage == "en" {
                word = "Please enter the ad description."
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
        uploadPhotos()
        
    }
    
    
    @objc func btnDeleteImage(_ sender : UIButton)
    {
        let indexPath = NSIndexPath(row: sender.tag, section: 0)
        let cell = self.collectionUpload .cellForItem(at: indexPath as IndexPath) as! UploadCell
        
        cell.imgProduct.image = nil
        
        arrImages.removeObject(at: indexPath.row-1)
        
        //arrImageS
        arrImageS.remove(at: indexPath.row-1)
        collectionUpload.reloadData()
    }
    
    
    
    func setUpCategoryData(){
        
        
        for categoryData in  self.arrCategoryData{
            if let object = categoryData as? Category{
                if let id = object.id{
                    if id == self.categoryID{
                        self.btnCategory.setTitle(object.title , for: .normal)
                        self.btnCategory.setTitleColor(UIColor.black, for: .normal)
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
                        self.btnSubCategory.setTitle(object.title , for: .normal)
                        self.btnSubCategory.setTitleColor(UIColor.black, for: .normal)
                    }
                }
            }
        }
    }
    
    
    
}
//extension TimeInterval {
//    // builds string in app's labels format 00:00.0
//    func stringFormatted() -> String {
//        var miliseconds = self.roundTo(places: 1) * 10
//        miliseconds = miliseconds.truncatingRemainder(dividingBy: 10)
//        let interval = Int(self)
//        let seconds = interval % 60
//        let minutes = (interval / 60) % 60
//        return String(format: "%02d:%02d.%.f", minutes, seconds, miliseconds)
//    }
//}
extension AddAdViewController{
    
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
    
    func deletePostImage (adId : String){
        AppUtility.showProgress()
        let requestURL = URL(string: DELETE_ITEM_IMAGE)!
        print(requestURL)
        //    let user:User = AppUtility.getSession()
        var user: User
        if let u = AppUtility.getSession() {
            user = u
        }else{
            return
        }
        print("deletePostImage id",user.ID!)
        let headers = ["Content-Type": "application/json","X-Localization":"\(appLanguage)"]
        let paramDict = ["id": adId] as [String : Any]
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
                    print("response JSONdeletePostImage: ‘\(response)‘")
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
                            var word = "تم حذف الصور بنجاح"
                            if appLanguage == "en" {
                                word = "The photos have been successfully deleted"
                            }
                            self.arrImageS.removeAll()
                            self.arrImages.removeAllObjects()
                            self.collectionUpload.reloadData()
                            let alert = UIAlertController(title: "ZOO LIFE", message:word, preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: Okey(), style: UIAlertAction.Style.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
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
                        print("response JSON: ‘\(result)’")
                        //let userInfo = response.error as? Error
                        let error = response.error
                        let alert = UIAlertController(title: "Zoolife", message:error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: Okey(), style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            case .failure(let encodingError):            AppUtility.hideProgress()
                print(encodingError)
                let alert = UIAlertController(title: "Zoolife", message:encodingError.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: Okey(), style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
}

extension AddAdViewController{
    
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
