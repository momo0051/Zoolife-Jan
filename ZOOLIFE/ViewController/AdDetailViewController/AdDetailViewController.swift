//
//  AdDetailViewController.swift
//  ZOOLIFE
//
//  Created by Yousaf Shafiq on 25/12/2020.
//  Copyright © 2020 Hafiz Anser. All rights reserved.
//

import UIKit

import SwiftyJSON
import Alamofire
import UPCarouselFlowLayout
import ImageSlideshow

class AdDetailViewController: UIViewController {
    
    @IBOutlet weak var userId: UILabel!
    @IBOutlet weak var btnPosComment: UIButton!
    @IBOutlet weak var lblNoComment: UILabel!
    @IBOutlet weak var lblWriteComment: UILabel!
    @IBOutlet weak var totalLikesLabel:UILabel!
    
    var missingPost = false
    
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var lblShare: UILabel!
    @IBOutlet weak var viewAllComments:UIButton!
    @IBOutlet weak var imageSlideShow: ImageSlideshow!
    
    @IBOutlet weak var parentView: UIView!
    
    @IBOutlet weak var imgUserProfile: UIImageView!
    @IBOutlet weak var lblAddDescritption: UILabel!
    @IBOutlet weak var lblAddTitle: UILabel!
    @IBOutlet weak var lblCityName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    
    @IBOutlet weak var lblUserNames: UILabel!
    @IBOutlet weak var btnStartChat: UIButton!
    @IBOutlet weak var btnCall: UIButton!
    @IBOutlet weak var btnWhatsApp: UIButton!
    
    @IBOutlet weak var commentBox: UITextField!
    @IBOutlet weak var allowComments:UIView!
    
    @IBOutlet weak var commetTableViewHeight:NSLayoutConstraint!
    @IBOutlet weak var relatedCollectionViewHeight:NSLayoutConstraint!
    @IBOutlet weak var adPhotosCollectionViewHeight:NSLayoutConstraint!
    
    @IBOutlet weak var postCollectionView:UICollectionView!
    @IBOutlet weak var relatedCollectionView:UICollectionView!
    @IBOutlet weak var commentTableView:UITableView!
    
    @IBOutlet weak var noCommentsLabel: UILabel!
    
    @IBOutlet weak var adReported: UIImageView!
    @IBOutlet weak var adFavourite: UIImageView!
    @IBOutlet weak var lblSimilarTitle: UILabel!
    
    
    @IBOutlet weak var alertMessageLabel: UILabel!
    @IBOutlet weak var likingAd: UIImageView!
    
    
    @IBOutlet weak var postIDValueLabel: UILabel!
    @IBOutlet weak var ageHeadingLabel: UILabel!
    @IBOutlet weak var ageValueLabel: UILabel!
    @IBOutlet weak var sexHeadingLabel: UILabel!
    @IBOutlet weak var sexValueLabel: UILabel!
    @IBOutlet weak var vaccineDetailsHeadingLabel: UILabel!
    @IBOutlet weak var vaccineDetailsValueLabel: UILabel!
    @IBOutlet weak var passportHeadingLabel: UILabel!
    @IBOutlet weak var passportValueLabel: UILabel!
    @IBOutlet weak var infoBackgroundView: UIView! {
        didSet {
            infoBackgroundView.backgroundColor = UIColor.white
        }
    }
    var imageArr:[String] = []
    var cellEvent:EventCell?
    
    var commentsPost = [Comments]()
    
    var postId = ""
    var isRelatedAd = false
    
    var post: Ad?
    var Related_Post: Ad?
    var isComingFromMyAds = false
    
    @IBOutlet weak var chatImage: UIImageView!
    
    @IBOutlet weak var phoneCallImage: UIImageView!
    @IBOutlet weak var whatsaAppImage: UIImageView!
    
    var delegate:HomeDelegate?
    var indexSelected : Int?
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    override func viewDidLoad(){
        super.viewDidLoad()

        relatedCollectionView.register(UINib(nibName: "RelatedAdCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RelatedAdCollectionViewCell")
        self.relatedCollectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        
        postCollectionView.register(UINib(nibName: "EventCell", bundle: nil), forCellWithReuseIdentifier: "EventCell")
        
        commentTableView.register(UINib(nibName: "CommentsCell", bundle: nil), forCellReuseIdentifier: "CommentsCell")
        
        self.navigationController?.isNavigationBarHidden = true
        
        
        self.commentTableView.rowHeight = UITableView.automaticDimension
        commentTableView.estimatedRowHeight = 150
        commentTableView.tableFooterView = UIView()

        getSinglePost()
        self.relatedCollectionView.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        UpdateLang_UI()
        setUpData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if missingPost{
            self.tabBarController?.tabBar.isHidden = true
            return
        }
        if !self.isRelatedAd {
            self.tabBarController?.tabBar.isHidden = false
        }
    }
    func UpdateLang_UI(){
        if let lang = UserDefaults.standard.object(forKey: "appLang") as? String {
            if lang == "en" {
                lblWriteComment.localizeKey = "Write a comment"
                commentBox.localizeKey = "Type here"
                lblShare.localizeKey = "Share"
                
                btnPosComment.localizeKey = "send"
                viewAllComments.localizeKey = "Show all"
                noCommentsLabel.localizeKey = "No Comments Available"
                commentBox.textAlignment = .left
                alertMessageLabel.localizeKey = "\"Zoolife\" warns against dealing outside the application and strongly advises to deal through private messages only, to deal hand in hand, to beware of agents, and to make sure that the bank account belongs to the same person who owns the goods."
                UIView.appearance().semanticContentAttribute = .forceLeftToRight
            } else {
                lblWriteComment.localizeKey = "التعليقات"
                commentBox.localizeKey = "أكتب تعليق "
                btnPosComment.localizeKey = "إرسال"
                viewAllComments.localizeKey = "عرض كل التعليقات"
                noCommentsLabel.localizeKey = "لا توجد تعليقات متاحة"
                lblShare.localizeKey = "مشاركة"
                commentBox.textAlignment = .right
                alertMessageLabel.localizeKey = "يحذر \" زوولايف \" من التعامل خارج التطبيق وينصح بشدة بالتعامل عبر الرسائل الخاصة فقط والتعامل يد بيد والحذر من الوسطاء والتأكد أن الحساب البنكي يعود لنفس الشخص صاحب السلعة ."
                UIView.appearance().semanticContentAttribute = .forceRightToLeft
            }
        } else {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }
    }
    
    @IBAction func btnFav_Click(){
        var user: User
        
        if let u = AppUtility.getSession() {
            user = u
            self.favouriteAd()
        }else{
            
            let alert = UIAlertController(title: "Zoolife", message:loc.mustLogin.localized(), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: Okey(), style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
    }
    @IBAction func btnLike_Click(){
        
        var user: User
        
        if let u = AppUtility.getSession() {
            user = u
            self.likeOfAd()
        }else{
            let alert = UIAlertController(title: "Zoolife", message:loc.mustLogin.localized(), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: Okey(), style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
    }
    
    @IBAction func didShareTapped(_ sender: UIButton) {
        guard let url = URL(string: "https://apps.apple.com/pk/app/zoolife/id1549373638") else { return }
        UIApplication.shared.open(url)
    }
    
    
    @IBAction func btnReport_Click(){
        
        var user: User
        
        if let u = AppUtility.getSession() {
            user = u
            self.reportAd(user: user)
        }else{
            let alert = UIAlertController(title: "Zoolife", message:loc.mustLogin.localized(), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: Okey(), style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
    }
    
    func reportAd(user: User){
        var reported = "0"
        
        if let report_status = self.post?.report_status{
            reported = report_status
        }
        
        if reported == "1"{
            let alert = UIAlertController(title: "Zoolife", message:loc.Reported.localized(), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: Okey(), style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        AppUtility.showProgress()
        let requestURL = URL(string: ABUSE_ITEM)!
        
        let headers = ["Content-Type": "application/json","X-Localization":"\(appLanguage)"]
        
        let  paramDict = ["id":self.post?.id ?? "",
                          "user_id":user.ID!,
                          "content": ""
        ] as [String : Any]
        
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
                        let message = dict["message"]?.string
                        let error = dict["error"]?.bool
                        
                        AppUtility.hideProgress()
                        
                        if error == false{
                            
                            
                            if let report_status = self.post?.report_status{
                                if report_status == "0"{
                                    self.adReported.image = UIImage(named: "ic_report_selected")
                                    self.setUpReportStatus(status: "1")
                                }else{
                                    self.adReported.image = UIImage(named: "ic_report_unselected")
                                    self.setUpReportStatus(status: "0")
                                    
                                }
                            }
                            let alert = UIAlertController(title:"Zoolife" , message:message, preferredStyle: UIAlertController.Style.alert)
                            
                            alert.addAction(UIAlertAction(title: Okey(), style: .default, handler: { (action: UIAlertAction!) in
                            }))
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
    
    
    
    func startChatAcion(){
        
        var user: User
        
        if let u = AppUtility.getSession() {
            user = u
            
            if user.ID == post?.fromUserId{
                return
            }
            
            startChat(user: user)
            
            //            if let post = post{
            //                post.fromid()
            //                post.id
            //                user.ID
            //            }
            
        }else{
            
            let alert = UIAlertController(title: "Zoolife", message:loc.mustLogin.localized(), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: Okey(), style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        
        
        
    }
    
    func startChat(user: User){
        let receiver:User = User(ID: post?.fromUserId, fullname: post?.username, email: post?.email, phone: post?.phone, avatar: post?.itemImage,msg_badge: "",noti_badge: "")
        
        //        let sender = User(ID: user.ID, fullname: user.fullname, email: user.email, phone: user.phone, avatar: "")
        
        if let post = post{
            AppUtility.showProgress()
            FirebaseNotificationServices.checkUserCreate(sender: user, recipient: receiver, post: post) { (success) in
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
    
    
    @IBAction func postCommentAction(){
        // var user: User
        
        if AppUtility.getSession() != nil {
            //user = u
            
            if let comment = commentBox.text {
                if comment == "" {
                    var word = "اضافة تعليق"
                                if appLanguage == "en" {
                                    word = "add a comment"
                                }
                    let alert = UIAlertController(title: "Zoolife", message:word, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: Okey(), style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                self.postComment(comment: comment)
            }
            
            
        }else{
            
            let alert = UIAlertController(title: "Zoolife", message:loc.mustLogin, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: Okey(), style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
    }
    
    // MARK: - Button Actions
    
    @IBAction func backTapped(_ sender: Any){
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnWhatsAppTapped(_ sender: Any){
        
        if let phone = post?.phone{
            whatsAppCallAction(number: phone)
        }
        
    }
    
    
    @IBAction func btnCallTapped(_ sender: Any) {
        if let phone = post?.phone{
            let phoneNumber =  "+966\(phone)"
            dialNumber(number: phoneNumber)
        }
        
    }
    @IBAction func btnChatTappedTapped(_ sender: Any) {
        startChatAcion()
    }
    
    
    @IBAction func viewAllCommentsAction(_ sender: Any) {
        
        let viewController = AllCommentsViewController()
        viewController.post = self.post
        self.navigationController?.pushViewController(viewController, animated: true)
        
        
    }
    
    func setUpData() {
        if appLanguage == "en" {
            lblSimilarTitle.localizeKey = "Similar Ads"
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
           // lblUserNames.localizeKey = "Username : \(post?.username ?? "")"
        } else {
            lblSimilarTitle.localizeKey = "اعلانات مشابهة:"
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
         //   lblUserNames.localizeKey = "المعلن:: \(post?.username ?? "")"
        }
//        if let user = AppUtility.getSession(), user.ID == post?.fromUserId {
//            if appLanguage == "en" {
//
//            } else {
//
//            }
//
//        }
        
        if let user = AppUtility.getSession(), user.ID == post?.fromUserId {
            btnWhatsApp.backgroundColor = #colorLiteral(red: 0.9204169512, green: 0.9502492547, blue: 0.9321002364, alpha: 1)
            btnCall.backgroundColor = #colorLiteral(red: 0.9204169512, green: 0.9502492547, blue: 0.9321002364, alpha: 1)
            btnStartChat.backgroundColor = #colorLiteral(red: 0.9204169512, green: 0.9502492547, blue: 0.9321002364, alpha: 1)
            
            btnCall.setImage(#imageLiteral(resourceName: "ic_call_new-brown"), for: .normal)
            btnStartChat.setImage(#imageLiteral(resourceName: "ic_chat_new-brown"), for: .normal)
            btnWhatsApp.setImage(#imageLiteral(resourceName: "ic_whatsapp-brown"), for: .normal)
            
            btnCall.isUserInteractionEnabled = false
            btnStartChat.isUserInteractionEnabled = false
            btnWhatsApp.isUserInteractionEnabled = false
        }
        else {
            btnWhatsApp.backgroundColor = #colorLiteral(red: 0.1951332688, green: 0.5047534108, blue: 0.6908060312, alpha: 1)
            btnCall.backgroundColor = #colorLiteral(red: 0.1951332688, green: 0.5047534108, blue: 0.6908060312, alpha: 1)
            btnStartChat.backgroundColor = #colorLiteral(red: 0.1951332688, green: 0.5047534108, blue: 0.6908060312, alpha: 1)
            
            btnCall.setImage(#imageLiteral(resourceName: "ic_call_new"), for: .normal)
            btnStartChat.setImage(#imageLiteral(resourceName: "ic_chat_new"), for: .normal)
            btnWhatsApp.setImage(#imageLiteral(resourceName: "ic_whatsapp"), for: .normal)
            
            btnCall.isUserInteractionEnabled = true
            btnStartChat.isUserInteractionEnabled = true
            btnWhatsApp.isUserInteractionEnabled = true
        }
        
        
        if let showComments = self.post?.showComments{
            if showComments == "0"{
                allowComments.isHidden = true
            }else{
                allowComments.isHidden = false
            }
        }
        
        
        if let show = self.post?.showWhatsapp, show == "0" {
            btnWhatsApp.backgroundColor = #colorLiteral(red: 0.9204169512, green: 0.9502492547, blue: 0.9321002364, alpha: 1)
            btnWhatsApp.setImage(#imageLiteral(resourceName: "ic_whatsapp-brown"), for: .normal)
            btnWhatsApp.isUserInteractionEnabled = false
        }
        else {
            btnWhatsApp.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            btnWhatsApp.setImage(#imageLiteral(resourceName: "ic_whatsapp"), for: .normal)
            btnWhatsApp.isUserInteractionEnabled = true
        }
        
        if let show = self.post?.showPhoneNumber, show == "0"{
            btnCall.backgroundColor = #colorLiteral(red: 0.9204169512, green: 0.9502492547, blue: 0.9321002364, alpha: 1)
            btnCall.setImage(#imageLiteral(resourceName: "ic_call_new-brown"), for: .normal)
            btnCall.isUserInteractionEnabled = false
        }
        else {
            btnCall.backgroundColor = #colorLiteral(red: 0.1951332688, green: 0.5047534108, blue: 0.6908060312, alpha: 1)
            btnCall.setImage(#imageLiteral(resourceName: "ic_call_new"), for: .normal)
            btnCall.isUserInteractionEnabled = true
        }
        
        
        if let show = self.post?.showMessage, show == "0"{
            btnStartChat.backgroundColor = #colorLiteral(red: 0.9204169512, green: 0.9502492547, blue: 0.9321002364, alpha: 1)
            btnStartChat.setImage(#imageLiteral(resourceName: "ic_chat_new-brown"), for: .normal)
            btnStartChat.isUserInteractionEnabled = false
        }
        else {
            btnStartChat.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            btnStartChat.setImage(#imageLiteral(resourceName: "ic_chat_new"), for: .normal)
            btnStartChat.isUserInteractionEnabled = true
        }
        
        
        if let name = post?.username{
            lblUserName.text = name
        }
        
        if let cityName = post?.city{
            lblCityName.text = cityName
        }
        if let postTitle = post?.itemTitle{
            lblAddTitle.text = postTitle
        }
        
        if let postDes = post?.itemDesc{
            lblAddDescritption.text = postDes
        }
        if let totalLikes = post?.likesCount{
            self.totalLikesLabel.text = totalLikes + ""
        }
        if let sex = post?.sex{
            self.sexValueLabel.text = sex
        }
        if let age = post?.age{
            self.ageValueLabel.text = "\(age)"
        }
        if let passport = post?.passport{
            self.passportValueLabel.text = passport
        }
        if let vaccineDetails = post?.vaccine_detail{
            self.vaccineDetailsValueLabel.text = vaccineDetails
        }
        if let postId = post?.id{
            self.postIDValueLabel.text = "\(postId)"
        }
        
        
        if let createdAt = post?.created_at{
            lblDate.text = AppUtility.getFormattedDate(dateString: createdAt)
            
            if let localDateAd = AppUtility.adFormattedDate(dateString: createdAt){
                let localTimeAdString = TimeFormatHelper.timeAgoString(date: localDateAd)
                lblDate.text = localTimeAdString
            }
        }
        
        if let favrtitem_status = post?.favrtitem_status{
            self.adFavourite.setTintColor(color: #colorLiteral(red: 0.1938137114, green: 0.5057060122, blue: 0.6949823499, alpha: 1))
            if favrtitem_status == "0"{
                self.adFavourite.image = UIImage(named: "ic_disLike")
            }else{
                self.adFavourite.image = UIImage(named: "ic_like_selected")
            }
        }
        
        
        if let likeitem_status = post?.likeitem_status{
            self.likingAd.setTintColor(color: #colorLiteral(red: 0.1938137114, green: 0.5057060122, blue: 0.6949823499, alpha: 1))
            if likeitem_status == "0"{
                self.likingAd.image = UIImage(named: "ic_thumbs_up")
            }else{
                self.likingAd.image = UIImage(named: "ic_thumbs_up_selected")
            }
        }
        
        if let report_status = post?.report_status{
            if report_status == "0"{
                self.adReported.setTintColor(color: #colorLiteral(red: 0.1938137114, green: 0.5057060122, blue: 0.6949823499, alpha: 1))
                self.adReported.image = UIImage(named: "ic_report_unselected.png")
            }else{
                self.adReported.setTintColor(color: #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1))
                self.adReported.image = UIImage(named: "ic_report_selected.png")
                
            }
        }
        
        
        self.postCollectionView.reloadData()
        self.relatedCollectionView.isHidden = false
        self.relatedCollectionView.reloadData()
        self.showSlider()
        //        self.view.layoutIfNeeded()
        self.setUpParentHeight()
        
        self.adPhotosCollectionViewHeight.constant = self.postCollectionView.contentSize.height
        
        self.relatedCollectionViewHeight.constant = 130//self.relatedCollectionView.contentSize.height
        
        self.postCollectionView.layoutIfNeeded()
        self.relatedCollectionView.layoutIfNeeded()
        
    }
    
    
    func showSlider() {
        var sdWebImageSource = [SDWebImageSource]()
        
        if let imgUrl = post?.imgUrl{
            if let imageSource = SDWebImageSource(urlString: imgUrl) {
                sdWebImageSource.append(imageSource)
            }

        }
        
//        if let imagesArray = post?.images {
//            for image in imagesArray {
//                if !image.isEmpty {
//                    if let url = image.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
//                        sdWebImageSource.append(SDWebImageSource(urlString: url)!)
//                    }
//                }
//            }
//        }
        for img in self.imageArr {
            if let url = img.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                sdWebImageSource.append(SDWebImageSource(urlString: url)!)
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
        let fullScreenController = imageSlideShow.presentFullScreenController(from: self)
        // set the activity indicator for full screen controller (skipping the line will show no activity indicator)
        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
    }
    
}



extension AdDetailViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if self.commentsPost.count > 4 {
            return 4
        }
        return self.commentsPost.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        var cell: CommentsCell! = tableView.dequeueReusableCell(withIdentifier: "CommentsCell") as? CommentsCell
        if (cell == nil)
        {
            cell = CommentsCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: "CommentsCell")
        }
        
        let comment = self.commentsPost[indexPath.row]
        
        cell.lblName.text = comment.username
        cell.lblEventInfromation.text = comment.message
        //cell.lblDate.text = comment.co
        
        if let created_at = comment.co{
            if let localDateAd = AppUtility.adFormattedDate(dateString: created_at){ 
                let localTimeAdString = TimeFormatHelper.timeAgoString(date: localDateAd)
                cell.lblDate.text = localTimeAdString
            }
        }
        cell.lblEventInfromation.numberOfLines = 0
        cell.lblEventInfromation.lineBreakMode = .byWordWrapping
        cell.lblEventInfromation.sizeToFit()
        
        return cell
    }
}


extension AdDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // MARK: - Collection Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        
        if collectionView == relatedCollectionView{
            if let relatedAds = self.Related_Post?.related_add{
                return relatedAds.count
            }
            return 0
        }else{
            if let images = post?.images{
                
                return 0// images.count
            }
            return 0
        }
    }
    
    

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == relatedCollectionView {
            
            if let postid = self.self.Related_Post?.related_add[indexPath.item].id{
                let viewController = AdDetailViewController()//RelatedAdViewController()
                viewController.isRelatedAd = true
                viewController.postId = postid
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
        else {
            let cell = collectionView.cellForItem(at: indexPath) as! EventCell
            
            let imageInfo   = GSImageInfo(image: (cell.imgPost.image!), imageMode: .aspectFit)
            let imageViewer = GSImageViewerController(imageInfo: imageInfo)
            present(imageViewer, animated: true, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        if collectionView == relatedCollectionView{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RelatedAdCollectionViewCell", for: indexPath as IndexPath) as! RelatedAdCollectionViewCell
            if let relatedAds = self.Related_Post?.related_add{
                
                cell.shadowDecorate()
                if let imgUrl = relatedAds[indexPath.item].imgUrl{
                    
                    AppUtility.setImage(url:(imgUrl), image: cell.relatedImageView)
                }
                cell.lblAdsCity.text = relatedAds[indexPath.item].city
//                cell.lblAdsDate.text = AppUtility.getFormattedDate(dateString: relatedAds[indexPath.item].createdAt ?? "")
                if let created_at = relatedAds[indexPath.item].createdAt{
                    if let localDateAd = AppUtility.adFormattedDate(dateString: created_at){
                        let localTimeAdString = TimeFormatHelper.timeAgoString(date: localDateAd)
                        print(localTimeAdString)
                        cell.lblAdsDate.text = localTimeAdString
                    }
                }
                cell.lblAdsTitle.text = relatedAds[indexPath.item].itemTitle
            }
            return cell
        }else {
            cellEvent = collectionView.dequeueReusableCell(withReuseIdentifier: "EventCell", for: indexPath as IndexPath) as? EventCell
            cellEvent?.shadowDecorate()
            AppUtility.setImage(url:(post?.images[indexPath.item].addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!, image: cellEvent!.imgPost)
//            if indexPath.item == 0 {
//                if let imgUrl = post?.imgUrl{
//                    AppUtility.setImage(url:(ITEMIMAGEURL + imgUrl), image: cellEvent!.imgPost)
//                }
//            }else{
//                AppUtility.setImage(url:(post?.images[indexPath.item - 1].addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!, image: cellEvent!.imgPost)
//
//            }
            return cellEvent!
            
        }
       
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        if collectionView == relatedCollectionView{
            let width = (relatedCollectionView.bounds.width) * 0.85 //- 40
            return CGSize(width: width, height: 120)
        }else {
            let width = CGFloat(postCollectionView.frame.size.width-120)/3 //- 40
            return CGSize (width: width, height: 150)
            
//
//            print(indexPath.item,"ItemCollection")
//            print(indexPath.row,"rowCollection")
//
//
//            if indexPath.item == 0 {
//                let width = (postCollectionView.frame.size.width) - 20
//                return CGSize(width: width, height: 250)
//            }else if indexPath.item > 0{
//                let width = CGFloat(postCollectionView.frame.size.width)/3 - 30
//                return CGSize (width: width, height: 140)
//
//            }
            
        }
        
        return CGSize.zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
      
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//
//
//        if kind == UICollectionView.elementKindSectionHeader && collectionView == relatedCollectionView {
//
//            if let relatedAds = Related_Post?.related_add{
//                if relatedAds.count == 0 {
//                    return UICollectionReusableView()
//                }
//            }
//            let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! SectionHeader
//            if appLanguage == "en" {
//                sectionHeader.label.localizeKey = "Similar Ads"
//            } else {
//                sectionHeader.label.localizeKey = "اعلانات مشابهة"
//            }
//            return sectionHeader
//        } else { //No footer in this case but can add option for that
//            return UICollectionReusableView()
//        }
//    }

//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        if collectionView == relatedCollectionView{
//            if let relatedAds = self.Related_Post?.related_add{
//                if relatedAds.count == 0 {
//                    return CGSize.zero
//                }
//            }
//            return CGSize(width: collectionView.frame.width, height: 40)
//        }
//        return CGSize.zero
//    }
    
}




extension AdDetailViewController {
    
    func postComment (comment : String){
    
        AppUtility.showProgress()
        let requestURL = URL(string: ADD_COMMENT)!

        var user: User
        
        if let u = AppUtility.getSession() {
            user = u
        }else{
            return
        }
        
        let headers = ["Content-Type": "application/json","X-Localization":"\(appLanguage)"]
        
        let  paramDict = ["id":self.post?.id ?? "",
                          "user_id":user.ID!,
                          "message": comment] as [String : Any]

        
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
                            let message = dict["message"]?.string
                            let error = dict["error"]?.bool

                            AppUtility.hideProgress()

                            if error == false{

                                self.commentBox.text = ""
                                self.getComments()
                                let alert = UIAlertController(title:"Zoolife" , message:message, preferredStyle: UIAlertController.Style.alert)

                                alert.addAction(UIAlertAction(title: Okey(), style: .default, handler: { (action: UIAlertAction!) in
                                }))
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
    
    
    
    
    func setUpParentHeight(){
        
        let relatedHeight = self.relatedCollectionView.contentSize.height
        let postHeight = self.postCollectionView.contentSize.height
        let commentHeight = self.commentTableView.contentSize.height
//        self. parentViewHei ght.constant = relatedHeight + postHeight + commentHeight + 715//  390+75+250
        
//        self.parentView.layoutIfNeeded()
        
    }
    
}



extension AdDetailViewController{
    
    
    func getComments() {
      
        AppUtility.showProgress()
        let requestURL = URL(string: GET_COMMENTS)!
        print(requestURL)
    
        let headers = ["Content-Type": "application/json","X-Localization":"\(appLanguage)"]
        
        let  paramDict = ["id":post?.id ?? ""] as [String : Any]

        
        print(paramDict)
        
        self.commentsPost.removeAll()
        
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
                            
                            if error == false{
                                
                                let dataArray : [JSON] = (dict["data"]?.arrayValue)!
                                self.noCommentsLabel.isHidden = false
                                for dic in dataArray
                                {
                                    let dicts: Dictionary<String, JSON> = dic.dictionaryValue
                                    let objD = Comments.init(withDictionary:dicts)
                                
                                    self.commentsPost.append(objD)//.add(objD)
                                    self.noCommentsLabel.isHidden = true
                                    
                                }
                                
//                                self.commentTableView.reloadData()
//                                self.commetTableViewHeight.constant = self.commentTableView.contentSize.height
//                                self.setUpParentHeight()
//
                                
                                print(self.commentTableView.contentSize.height)
                                
                                DispatchQueue.main.async {
                                    self.commentTableView.reloadData()
                                    self.showSlider()
                                    self.commetTableViewHeight.constant = self.commentTableView.contentSize.height
                                    self.commentTableView.isScrollEnabled = false
                                    self.view.layoutIfNeeded()
                                    self.setUpParentHeight()
                                    self.commetTableViewHeight.constant = self.commentTableView.contentSize.height
                                    print(self.commentTableView.contentSize.height)
                                    
                                    self.commentTableView.layoutIfNeeded()
                                }
                                 
                               
                                return
                            }
                            else
                            {
                                
                                if let dataArray : [JSON] = (dict["data"]?.arrayValue){
                                    if dataArray.count == 0 {
//                                        self.commetTableViewHeight.constant = self.commentTableView.contentSize.height
//                                        self.setUpParentHeight()
//
                                        
                                        DispatchQueue.main.async {
                                            self.commentTableView.reloadData()
                                            self.commetTableViewHeight.constant = self.commentTableView.contentSize.height
                                            self.commentTableView.isScrollEnabled = false
                                            self.view.layoutIfNeeded()
                                            self.commentTableView.layoutIfNeeded()
                                            self.setUpParentHeight()
                                        }
                                        
                                    }
                                    return
                                }
                                if message != nil {
                                    let alert = UIAlertController(title: "Zoolife", message:message, preferredStyle: UIAlertController.Style.alert)
                                    alert.addAction(UIAlertAction(title: Okey(), style: UIAlertAction.Style.default, handler: nil))
                                    self.present(alert, animated: true, completion: nil)
                                }
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
    
    
    func setUpPost(status:String){
        
        self.post?.favrtitem_status = status
        
        guard let index = indexSelected, let post = self.post, delegate != nil else{
            return
        }
        self.delegate?.updatePost(post: post, index: index)
    }
    
    
    
    func setUpLikePostStatus(status:String){
        
        self.post?.likeitem_status = status
        
        if status == "0"{
            
            if let totalLikes = self.post?.likesCount{
                if let intLikes = Int(totalLikes){
                    let totalLike = intLikes - 1
                    self.post?.likesCount = String(totalLike)
                }
            }
            
        }else{
            if let totalLikes = self.post?.likesCount{
                if let intLikes = Int(totalLikes){
                    let totalLike = intLikes + 1
                    self.post?.likesCount = String(totalLike)
                }
            }
        }
        
        
        
        
        
        
        
        guard let index = indexSelected, let post = self.post, delegate != nil else{
            return
        }
        self.delegate?.updatePost(post: post, index: index)
    }
    
    
    
    func setUpReportStatus(status:String){
        
        self.post?.report_status = status
        
        guard let index = indexSelected, let post = self.post, delegate != nil else{
            return
        }
        self.delegate?.updateReportStatus(post: post, index: index)
    }
    
    
    
    func getSinglePost(){
        AppUtility.showProgress()
        let requestURL = URL(string: GET_ITEM)!
        let headers = ["Content-Type": "application/json","X-Localization":"\(appLanguage)"]
        var paramDict : [String : Any]
        var postid = ""
        if isRelatedAd{
            postid = self.postId
        }else{
            if self.postId != ""{
                postid = self.postId
            }else{
                postid = post?.id ?? ""
            }
        }
        if postid == "" {
            postid = post?.itemId ?? ""
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
                            let imgsData = dict["data"]!["images"]
                    
                            let imgsLink = "\(imgsData[0]["file_name"])"
                            print(imgsLink)
                            if imgsLink != "null" {
                                let imgsLinkarr = imgsLink.split(separator: ",")
                                for link in imgsLinkarr {
                                    self.imageArr.append(String(link))
                                }
                            }
                           let message = dict["message"]?.string
                            let error = dict["error"]?.bool
                            
                            AppUtility.hideProgress()
                            
                            if error == false {
                                if let data : Dictionary<String, JSON> = (dict["data"]?.dictionaryValue){
                                    let adDetail = Ad.init(withDictionary:data)
                                    
                                    self.Related_Post = adDetail
                                    self.post = adDetail
                                    self.showSlider()
                                   // self.postCollectionView.layoutIfNeeded()
                                    //self.setUpParentHeight()
                                    self.relatedCollectionView.layoutIfNeeded()
                                    self.relatedCollectionView.isHidden = false
                                    self.relatedCollectionView.reloadData()
                                    self.view.layoutIfNeeded()
                                    self.setUpParentHeight()
                                    self.relatedCollectionViewHeight.constant = 130//self.relatedCollectionView.contentSize.height
                                    self.setUpData()
                                    self.setUpParentHeight()
                                    self.getComments()
                                    
                                }
                                
                                return
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
    
    
    
    func favouriteAd() {
        AppUtility.showProgress()
        let requestURL = URL(string: ADD_FAVOURITE_ITEM)!
        var user: User
        
        if let u = AppUtility.getSession() {
            user = u
        }else{
            return
        }
        let headers = ["Content-Type": "application/json","X-Localization":"\(appLanguage)"]
        let  paramDict = ["id":self.post?.id ?? "",
                          "user_id":user.ID!] as [String : Any]
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
                            let message = dict["message"]?.string
                            let error = dict["error"]?.bool

                            AppUtility.hideProgress()

                            if error == false {
                                
                                if let favrtitem_status = self.post?.favrtitem_status{
                                    if favrtitem_status == "0" {
                                        self.adFavourite.image = UIImage(named: "ic_like_selected")
                                        self.setUpPost(status: "1")
                                    }else{
                                        self.adFavourite.image = UIImage(named: "ic_disLike")
                                        self.setUpPost(status: "0")
                                    }
                                }
                                let alert = UIAlertController(title:"Zoolife" , message:message, preferredStyle: UIAlertController.Style.alert)

                                alert.addAction(UIAlertAction(title: Okey(), style: .default, handler: { (action: UIAlertAction!) in
                                }))
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
    
    
    
    
    
    func likeOfAd (){
        AppUtility.showProgress()
        var requestURL = URL(string: LIKE_ITEM)!
        var user: User
        
        if let u = AppUtility.getSession() {
            user = u
        }else{
            return
        }
        
        let headers = ["Content-Type": "application/json","X-Localization":"\(appLanguage)"]
        if let likeitem_status = self.post?.likeitem_status{
            if likeitem_status == "0"{
                requestURL = URL(string: LIKE_ITEM)!
            }else{
                requestURL = URL(string: DISLIKE_ITEM)!
            }
        }
        let  paramDict = ["id":self.post?.id ?? "",
                          "user_id":user.ID!
                          ] as [String : Any]

        
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
                            let message = dict["message"]?.string
                            let error = dict["error"]?.bool

                            AppUtility.hideProgress()

                            if error == false{
                                
                                
                                if let likeitem_status = self.post?.likeitem_status{
                                    if likeitem_status == "0"{
                                        self.likingAd.image = UIImage(named: "ic_thumbs_up_selected")
                                        
                                        if let totalLikes = self.post?.likesCount{
                                            if let intLikes = Int(totalLikes){
                                                let totalLike = intLikes + 1
                                                self.totalLikesLabel.text = "\(totalLike)"
                                            }
                                        }
                                        self.setUpLikePostStatus(status: "1")
                                        
                                        
                                        
                                        
                                    }else{
                                        self.likingAd.image = UIImage(named: "ic_thumbs_up")
                                        
                                        
                                        if let totalLikes = self.post?.likesCount{
                                            if let intLikes = Int(totalLikes){
                                                let totalLike = intLikes - 1
                                                self.totalLikesLabel.text = "\(totalLike)"
                                            }
                                        }
                                        
                                        self.setUpLikePostStatus(status: "0")
                                        
                                        
                                        
                                    }
                                }
                            
                                let alert = UIAlertController(title:"Zoolife" , message:message, preferredStyle: UIAlertController.Style.alert)

                                alert.addAction(UIAlertAction(title: Okey(), style: .default, handler: { (action: UIAlertAction!) in
                                }))
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

extension AdDetailViewController: ImageSlideshowDelegate {
    func imageSlideshow(_ imageSlideshow: ImageSlideshow, didChangeCurrentPageTo page: Int) {
//        print("current page:", page)
    }
    //Done by Shahzaib
    func imageSlideshowWillBeginDragging(_ imageSlideshow: ImageSlideshow) {
        print("dragging end:")
    }
    func imageSlideshowDidEndDecelerating(_ imageSlideshow: ImageSlideshow) {
//        print("Decelerating end:")
    }
}


extension UIImageView {
    
    func setTintColor(color:UIColor) {
        self.image = self.image?.withRenderingMode(.alwaysTemplate)
        self.tintColor = color
    }
}
