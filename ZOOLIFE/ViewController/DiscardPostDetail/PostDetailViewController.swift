////
////  PostDetailViewController.swift
////  ZOOLIFE
////
////  Created by Hafiz Anser  on 11/26/20.
////  Copyright © 2020 Hafiz Anser. All rights reserved.
////
//
//import UIKit
//import SwiftyJSON
//import Alamofire
//import UPCarouselFlowLayout
//
//class PostDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
//   
//    
//    var postId = ""
//    var isRelatedAd = false
//    
//    
//    var cellEvent:EventCell?
//    @IBOutlet weak var relatedCollectionViewAds:UICollectionView!
//    
//    var parentViewHeight : CGFloat = 0.0
//    
//    var commentTableViewHeight: CGFloat {
//        tableViewComments.layoutIfNeeded()
//
//        return tableViewComments.contentSize.height
//    }
//    
//    
//    @IBOutlet weak var commentsViewHeight:NSLayoutConstraint!
//    
//    @IBOutlet weak var moreImagesColelctionViewHeight:NSLayoutConstraint!
//    @IBOutlet weak var overAllHeight:NSLayoutConstraint!
//    
//    var delegate:HomeDelegate?
//    var indexSelected : Int?
//    
//    @IBOutlet weak var adLiked: UIImageView!
//    @IBOutlet weak var imgItem: UIImageView!
//    @IBOutlet weak var imgUserProfile: UIImageView!
//    @IBOutlet weak var lblAddDescritption: UILabel!
//    @IBOutlet weak var lblAddTitle: UILabel!
//    @IBOutlet weak var lblCityName: UILabel!
//    @IBOutlet weak var lblDate: UILabel!
//    @IBOutlet weak var lblUserName: UILabel!
//    @IBOutlet weak var tableViewComments: UITableView!
//    @IBOutlet weak var collectionViewItems: UICollectionView!
//    
//    @IBOutlet weak var collectionViewSimilarPost: UICollectionView!
//    
//    
//    @IBOutlet weak var commentBox: UITextField!
//    
//    @IBOutlet weak var allowComments:UIView!
//    @IBOutlet weak var btnStartChat: UIButton!
//    @IBOutlet weak var btnCall: UIButton!
//    @IBOutlet weak var btnWhatsApp: UIButton!
//    
//    var isComingFromMyAds = false
//    
//    @IBOutlet weak var btnBottomLeft: UIButton!
//    @IBOutlet weak var btnBottomRight: UIButton!
//    
//    @IBOutlet weak var noCommentsLabel: UILabel!
//    
//    var post: Ad?
//    
//    
//    var commentsPost = [Comments]()
//    
//    
//    @IBAction func likeDislikeAction(){
//
//        var user: User
//        
//        if let u = AppUtility.getSession() {
//            user = u
//            self.likeAd()
//        }else{
//            
//            let alert = UIAlertController(title: "Error!", message:"only registered user can like", preferredStyle: UIAlertController.Style.alert)
//            alert.addAction(UIAlertAction(title: Okey(), style: UIAlertAction.Style.default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//            return
//        }
//  
//    }
//    
//    
//    
//    func startChatAcion(){
//
//        var user: User
//        
//        if let u = AppUtility.getSession() {
//            user = u
//            
//            startChat(user: user)
//            
////            if let post = post{
////                post.fromid()
////                post.id
////                user.ID
////            }
//            
//        }else{
//            
//            let alert = UIAlertController(title: "Error!", message:"only Logged in user can Chat. Please Login", preferredStyle: UIAlertController.Style.alert)
//            alert.addAction(UIAlertAction(title: Okey(), style: UIAlertAction.Style.default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//            return
//        }
//        
// 
//        
//        
//    }
//    
//    func startChat(user: User){
//        let receiver:User = User(ID: post?.fromUserId, fullname: post?.username, email: post?.email, phone: post?.phoneNumber, avatar: post?.itemImage)
//        
////        let sender = User(ID: user.ID, fullname: user.fullname, email: user.email, phone: user.phone, avatar: "")
//        
//        if let post = post{
//            AppUtility.showProgress()
//            FirebaseNotificationServices.checkUserCreate(sender: user, recipient: receiver, post: post) { (success) in
//                if let success = success
//                {
//                    
//                    let uiConfig = ChatUIConfiguration(primaryColor: UIColor.colorWithHex(hexString: "#5574F7"),
//                                                       secondaryColor: UIColor.colorWithHex(hexString: "#5574F7"),
//                                                       inputTextViewBgColor: message_textfield_background_color,
//                                                       inputTextViewTextColor: message_textfield_text_color,
//                                                       inputPlaceholderTextColor: message_textfield_placeholder_color)
//                    
//                    
//                    
//                    
//                    FirebaseNotificationServices.fetchChannel(channelId: success) { (channel) in
//                        
//                        print("channel ye ",channel)
//                        
//                        if let channel = channel{
//
//                            let cv = ChatViewController()
//
//
//                            cv.channel = channel
//                            cv.user = user
//                            cv.recipients = [receiver]
//                            cv.uiConfig = uiConfig
//                            cv.deviceToken = post.deviceToken
//                            DispatchQueue.main.async {
//                                AppUtility.hideProgress()
//                            }
//
//                            //                            cv.callBack = { changed in
//                            //                                if changed
//                            //                                {
//                            //                                    self.friendsList.remove(at: self.selectedIndex!)
//                            //                                    self.friendTB.reloadData()
//                            //                                }
//                            //
//                            //                            }
//                            self.navigationController?.pushViewController(cv, animated: true)
//                        }else{
//                            //
//                            print("not  found")
//                            DispatchQueue.main.async {
//                                AppUtility.hideProgress()
//                            }
//
//                        }
//
//                    }
//
//                }
//            }
//        }
//
//    }
//    
//    
//    @IBAction func postCommentAction(){
//
//        
//        
//        
//       // var user: User
//        
//        if AppUtility.getSession() != nil {
//            //user = u
//            
//            if let comment = commentBox.text {
//                if comment == "" {
//                    
//                    let alert = UIAlertController(title: "Error!", message:"Please Add Comment", preferredStyle: UIAlertController.Style.alert)
//                    alert.addAction(UIAlertAction(title: Okey(), style: UIAlertAction.Style.default, handler: nil))
//                    self.present(alert, animated: true, completion: nil)
//                    return
//                }
//                self.postComment(comment: comment)
//            }
//            
//            
//        }else{
//            
//            let alert = UIAlertController(title: "Error!", message:"Only registered user can add comments", preferredStyle: UIAlertController.Style.alert)
//            alert.addAction(UIAlertAction(title: Okey(), style: UIAlertAction.Style.default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//            return
//        }
//        
// 
//        
//        
//    }
//    
//    
//    
// 
//    
//    override func viewDidLoad(){
//        super.viewDidLoad()
//        
//        self.navigationController?.isNavigationBarHidden = true
//        UIView.appearance().semanticContentAttribute = .forceRightToLeft
////        self.commentsViewHeight.constant = 40
//        
//        self.tableViewComments.rowHeight = UITableView.automaticDimension
//        tableViewComments.estimatedRowHeight = 105
//        tableViewComments.tableFooterView = UIView()
//    
// 
//        if self.isRelatedAd{
//            getSinglePost()
//            self.relatedCollectionViewAds.isHidden = true
//        }else{
//            
//            if isComingFromMyAds{
//                getSinglePost()
//            }else{
//                setUpData()
//            }
//        }
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.tabBarController?.tabBar.isHidden = true
//        
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        
//        if !self.isRelatedAd{
//            self.tabBarController?.tabBar.isHidden = false
//        }
//        
//    }
//    
//    func setUpData(){
//        
//        getComments()
//        
//        if let user = AppUtility.getSession(){
//            if user.ID == post?.fromUserId{
//                btnBottomLeft.isHidden = true
//                btnBottomRight.isHidden = true
//                btnWhatsApp.isHidden = true
//                btnCall.isHidden = true
//                btnStartChat.isHidden = true
//            }
//        }
//        
//        
//        if let showComments = self.post?.showComments{
//            if showComments == "0"{
//                allowComments.isHidden = true
//            }else{
//                allowComments.isHidden = false
//            }
//        }
//        
//        if let show = self.post?.showPhoneNumber{
//            if show == "0"{
//                btnWhatsApp.isHidden = true
//                btnCall.isHidden = true
//            }else{
//                btnWhatsApp.isHidden = false
//                btnCall.isHidden = false
//            }
//        }
//        
//        if let show = self.post?.showMessage{
//            if show == "0"{
//                btnStartChat.isHidden = true
//            }else{
//                btnStartChat.isHidden = false
//            }
//        }
//        
//      
// 
//        if isComingFromMyAds == true{
//            btnBottomLeft.setTitle("حذف الإعلان", for: .normal)
//            btnBottomRight.setTitle("تحرير الإعلان", for: .normal)
//        }
//        if let name = post?.username{
//            lblUserName.text = name
//        }
//        
//        if let cityName = post?.city{
//            lblCityName.text = cityName
//        }
//        if let postTitle = post?.itemTitle{
//            lblAddTitle.text = postTitle
//        }
//        if let postDes = post?.itemDesc{
//            lblAddDescritption.text = postDes
//        }
//     
//        if let imgUrl = post?.imgUrl{
//            
//            AppUtility.setImage(url:(ITEMIMAGEURL + imgUrl), image: imgItem)
//        }
//   
//        
//        if let createdAt = post?.created_at{
//            lblDate.text = AppUtility.getFormattedDate(dateString: createdAt)
//        }
//        
//        if let favrtitem_status = post?.favrtitem_status{
//            if favrtitem_status == "0"{
//                self.adLiked.image = UIImage(named: "ic_disLike")
//            }else{
//                self.adLiked.image = UIImage(named: "ic_like_selected")
//            }
//        }
//        
//        if let images = post?.images{
//            if images.count == 0 {
//                moreImagesColelctionViewHeight.constant = 0
//                overAllHeight.constant = 1000
//                parentViewHeight = 1000
//            }else{
//                
//                if images.count == 3 {
//                    moreImagesColelctionViewHeight.constant = 150
//                    overAllHeight.constant = 1150
//                    parentViewHeight = 1150
//                }else{
//                    parentViewHeight = overAllHeight.constant
//                }
//                collectionViewSimilarPost.reloadData()
//                relatedCollectionViewAds.reloadData()
//            }
//        }else{
//            moreImagesColelctionViewHeight.constant = 0
//            overAllHeight.constant = 1000
//            parentViewHeight = 1000
//        }
//        
//        if !isRelatedAd{
//            if let relatedPosts = post?.related_add{
//                
//                if relatedPosts.count == 0 {
//                    //
//                }else if relatedPosts.count <= 3 {
//                    overAllHeight.constant += 150
//                    parentViewHeight += 150
//                }else{
//                    overAllHeight.constant += 300
//                    parentViewHeight += 300
//                }
//                
//                
//            }
//        }
//        
//        
//    }
//    
//    // MARK: - Button Actions
//    
//    @IBAction func backTapped(_ sender: Any){
//        _ = self.navigationController?.popViewController(animated: true)
//    }
//    @IBAction func bottomRightTapped(_ sender: Any) {
//    }
//    @IBAction func botttomLeftTapped(_ sender: Any) {
//        
//        startChatAcion()
//    }
//
//    
//    @IBAction func btnWhatsAppTapped(_ sender: Any){
//        
//        if let phone = post?.phone{
//            whatsAppCallAction(number: phone)
//        }
//        
//    }
//    
//    
//
//    @IBAction func btnCallTapped(_ sender: Any) {
//        if let phone = post?.phone{
//            let phoneNumber =  "+966\(phone)"
//            dialNumber(number: phoneNumber)
//        }
//        
//    }
//    @IBAction func btnChatTappedTapped(_ sender: Any) {
//        startChatAcion()
//    }
//
//    
//
//
//
//    // MARK: - functions
//    func setupUI(){
//        collectionViewItems.register(UINib.init(nibName: "DetialCell", bundle: nil), forCellWithReuseIdentifier: "DetialCell")
//        let flowLayout = UPCarouselFlowLayout()
//        flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.size.width - 150, height: collectionViewItems.frame.size.height)
//        flowLayout.scrollDirection = .horizontal
//        flowLayout.sideItemScale = 0.8
//        flowLayout.sideItemAlpha = 1.0
//        flowLayout.spacingMode = .fixed(spacing:5.0)
//        collectionViewItems.collectionViewLayout = flowLayout
//    }
//    
//    
//    @IBAction func showImageLarge(){
//        let imageInfo   = GSImageInfo(image: (self.imgItem.image!), imageMode: .aspectFit)
//        let imageViewer = GSImageViewerController(imageInfo: imageInfo)
//        present(imageViewer, animated: true, completion: nil)
//    }
//    
//    @objc func buttonHeartTapped(sender:UIButton){
////        let indexPathT = NSIndexPath(row: sender.tag, section: 0)
////        let cell = self.tableView.cellForRow(at: indexPathT as IndexPath) as! HomeCell
////        cell.btnHeart.setImage(UIImage(named : "ic_post_liked_selected"), for: UIControl.State.normal)
//    }
//
//}
//
//
//
//extension PostDetailViewController{
//    
//    // MARK: - Collection Delegate
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
//        
//        if collectionView == relatedCollectionViewAds{
//            if let relatedAds = post?.related_add{
//                return relatedAds.count
//            }
//            return 0
//        }
//        
//        if collectionView == collectionViewItems{
//            return 2
//        }
//        else{
//            return post?.images.count ?? 0
//            return 6
//        }
//    }
//    
//    
//
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        
//        if collectionView == relatedCollectionViewAds{
//            
//            if let postid = self.post?.related_add[indexPath.item].id{
//                let viewController = PostDetailViewController()//RelatedAdViewController()
//                viewController.isRelatedAd = true
//                viewController.postId = postid
//                self.navigationController?.pushViewController(viewController, animated: true)
//            }
//        }else if collectionView != collectionViewItems{
//            var cell = collectionView.cellForItem(at: indexPath) as! EventCell
//            
//            let imageInfo   = GSImageInfo(image: (cell.imgPost.image!), imageMode: .aspectFit)
//            let imageViewer = GSImageViewerController(imageInfo: imageInfo)
//            present(imageViewer, animated: true, completion: nil)
//        }
//        
//        
//        
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
//        if collectionView == relatedCollectionViewAds{
//            collectionView.register(UINib(nibName: "RelatedAdCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RelatedAdCollectionViewCell")
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RelatedAdCollectionViewCell", for: indexPath as IndexPath) as! RelatedAdCollectionViewCell
//            if let relatedAds = post?.related_add{
//                
//                cell.shadowDecorate()
//                if let imgUrl = relatedAds[indexPath.item].imgUrl{
//                    
//                    AppUtility.setImage(url:(ITEMIMAGEURL + imgUrl), image: cell.relatedImageView)
//                }
//            }
//            return cell
//        }
//        if collectionView == collectionViewItems{
//            
//           collectionView.register(UINib(nibName: "DetialCell", bundle: nil), forCellWithReuseIdentifier: "DetialCell")
//           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetialCell", for: indexPath as IndexPath) as! DetialCell
//            return cell
//        }
//        else
//        {
//            collectionView.register(UINib(nibName: "EventCell", bundle: nil), forCellWithReuseIdentifier: "EventCell")
//            cellEvent = collectionView.dequeueReusableCell(withReuseIdentifier: "EventCell", for: indexPath as IndexPath) as? EventCell
//            AppUtility.setImage(url:(post?.images[indexPath.item].addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!, image: cellEvent!.imgPost)
//            return cellEvent!
//        }
//    }
//    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
//        if collectionView == relatedCollectionViewAds{
//            let width = (relatedCollectionViewAds.frame.size.width-54)/3
//            return CGSize(width: width, height: 150)
//        }
//        
//        else if collectionView == collectionViewItems{
//            let width = (collectionViewItems.frame.size.width)
//            return CGSize(width: width, height: 170)
//        }
//        else
//        {
//            let width = CGFloat (collectionViewSimilarPost.frame.size.width)/3 - 30
//            return CGSize (width: width, height: 140)
//        }
//    }
//    
//}
//
//
//// MARK: - TableView Delegate
//extension PostDetailViewController{
//    
//
//    func numberOfSections(in tableView: UITableView) -> Int{
//        return 1
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
//    {
//        return self.commentsPost.count
//        return 4
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
//        tableView.register(UINib(nibName: "CommentsCell", bundle: nil), forCellReuseIdentifier: "CommentsCell")
//        var cell: CommentsCell! = tableView.dequeueReusableCell(withIdentifier: "CommentsCell") as? CommentsCell
//        if (cell == nil)
//        {
//            cell = CommentsCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: "CommentsCell")
//        }
//        
//        let comment = self.commentsPost[indexPath.row]
//        
//        cell.lblName.text = comment.userFullname
//        cell.lblEventInfromation.text = comment.message
//        cell.lblDate.text = comment.co
//        cell.lblEventInfromation.numberOfLines = 0
//        cell.lblEventInfromation.lineBreakMode = .byWordWrapping
//        cell.lblEventInfromation.sizeToFit()
//        
//        return cell
//    }
//}
//
//
//
//extension PostDetailViewController {
//    
//    
//    
//    
//    func likeAd (){
//        AppUtility.showProgress()
//        let requestURL = URL(string: SERVER_BASE_URL + FAVOURTIE)!
//
//        
//        print(requestURL)
//        
////        let user:User = AppUtility.getSession()
//        
//        
//        var user: User
//        
//        if let u = AppUtility.getSession() {
//            user = u
//        }else{
//            return
//        }
//        
//        let headers = ["Content-Type": "application/json"]
//        
//        
//        var liked = "1"
//        
//        if let favrtitem_status = self.post?.favrtitem_status{
//            if favrtitem_status == "0"{
//                liked = "1"
//            }else{
//                liked = "0"
//            }
//        }
//        
//        let  paramDict = ["itemId":self.post?.id ?? "",
//                          "userId":user.ID!,
//                          "status": liked,
//                          "pass":"toggle"] as [String : Any]
//
//        
//        print(paramDict)
//        
//        
//        
//        Alamofire.upload(multipartFormData: { (multipartFormData) in
//            for (key, value) in paramDict
//            {
//                multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
//            }
//        },            usingThreshold:UInt64.init(),
//            to: requestURL ,
//            method:.post,
//            headers:headers,
//            encodingCompletion: { encodingResult in
//
//                switch encodingResult {
//                case .success(let upload, _, _):
//
//                    upload.responseJSON { response in
//
//                        print("response JSON: '\(response)'")
//
//                        if((response.result.value) != nil)
//                        {
//                            let swiftyJsonVar = JSON(response.result.value!)
//                            print(swiftyJsonVar)
//
//                            let dict = swiftyJsonVar.dictionaryValue
//                            let message = dict["message"]?.string
//                            let error = dict["error"]?.bool
//
//                            AppUtility.hideProgress()
//
//                            if error == false{
//                                
//                                
//                                if let favrtitem_status = self.post?.favrtitem_status{
//                                    if favrtitem_status == "0"{
//                                        self.adLiked.image = UIImage(named: "ic_like_selected")
//                                        self.setUpPost(status: "1")
//                                    }else{
//                                        self.adLiked.image = UIImage(named: "ic_disLike")
//                                        self.setUpPost(status: "0")
//                                    }
//                                }
//                                
//                                
//                                
//
//
//                                let alert = UIAlertController(title:"مبروك" , message:message, preferredStyle: UIAlertController.Style.alert)
//
//                                alert.addAction(UIAlertAction(title: Okey(), style: .default, handler: { (action: UIAlertAction!) in
//                                }))
//                                self.present(alert, animated: true, completion: nil)
//
//
//                                return
//                            }
//                            else
//                            {
//                                let alert = UIAlertController(title: "Error!", message:message, preferredStyle: UIAlertController.Style.alert)
//                                alert.addAction(UIAlertAction(title: Okey(), style: UIAlertAction.Style.default, handler: nil))
//                                self.present(alert, animated: true, completion: nil)
//                            }
//                        }
//                        else
//                        {
//                            AppUtility.hideProgress()
//                            let result = response.result
//                            print("response JSON: '\(result)'")
//                            //let userInfo = response.error as? Error
//                            let error = response.error
//
//                            let alert = UIAlertController(title: "Error!", message:error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
//                            alert.addAction(UIAlertAction(title: Okey(), style: UIAlertAction.Style.default, handler: nil))
//                            self.present(alert, animated: true, completion: nil)
//                        }
//                    }
//
//                case .failure(let encodingError):
//                    AppUtility.hideProgress()
//
//                    print(encodingError)
//                    let alert = UIAlertController(title: "Error!", message:encodingError.localizedDescription, preferredStyle: UIAlertController.Style.alert)
//                    alert.addAction(UIAlertAction(title: Okey(), style: UIAlertAction.Style.default, handler: nil))
//                    self.present(alert, animated: true, completion: nil)
//                }
//        })
//    }
//    
//    
//}
//
//
//
//extension PostDetailViewController {
//
//    func postComment (comment : String){
//        AppUtility.showProgress()
//        let requestURL = URL(string: SERVER_BASE_URL + COMMENT)!
//
//        var user: User
//        
//        if let u = AppUtility.getSession() {
//            user = u
//        }else{
//            return
//        }
//        
//        let headers = ["Content-Type": "application/json"]
//        
//        let  paramDict = ["itemId":self.post?.id ?? "",
//                          "userId":user.ID!,
//                          "message": comment,
//                          "pass":"add"] as [String : Any]
//
//        
//        Alamofire.upload(multipartFormData: { (multipartFormData) in
//            for (key, value) in paramDict
//            {
//                multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
//            }
//        },            usingThreshold:UInt64.init(),
//            to: requestURL ,
//            method:.post,
//            headers:headers,
//            encodingCompletion: { encodingResult in
//
//                switch encodingResult {
//                case .success(let upload, _, _):
//
//                    upload.responseJSON { response in
//
//                        print("response JSON: '\(response)'")
//
//                        if((response.result.value) != nil)
//                        {
//                            let swiftyJsonVar = JSON(response.result.value!)
//                            print(swiftyJsonVar)
//
//                            let dict = swiftyJsonVar.dictionaryValue
//                            let message = dict["message"]?.string
//                            let error = dict["error"]?.bool
//
//                            AppUtility.hideProgress()
//
//                            if error == false{
//
//                                self.commentBox.text = ""
//                                self.getComments()
//                                let alert = UIAlertController(title:"مبروك" , message:message, preferredStyle: UIAlertController.Style.alert)
//
//                                alert.addAction(UIAlertAction(title: Okey(), style: .default, handler: { (action: UIAlertAction!) in
//                                }))
//                                self.present(alert, animated: true, completion: nil)
//
//
//                                return
//                            }
//                            else
//                            {
//                                let alert = UIAlertController(title: "Error!", message:message, preferredStyle: UIAlertController.Style.alert)
//                                alert.addAction(UIAlertAction(title: Okey(), style: UIAlertAction.Style.default, handler: nil))
//                                self.present(alert, animated: true, completion: nil)
//                            }
//                        }
//                        else
//                        {
//                            AppUtility.hideProgress()
//                            let result = response.result
//                            print("response JSON: '\(result)'")
//                            //let userInfo = response.error as? Error
//                            let error = response.error
//
//                            let alert = UIAlertController(title: "Error!", message:error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
//                            alert.addAction(UIAlertAction(title: Okey(), style: UIAlertAction.Style.default, handler: nil))
//                            self.present(alert, animated: true, completion: nil)
//                        }
//                    }
//
//                case .failure(let encodingError):
//                    AppUtility.hideProgress()
//
//                    print(encodingError)
//                    let alert = UIAlertController(title: "Error!", message:encodingError.localizedDescription, preferredStyle: UIAlertController.Style.alert)
//                    alert.addAction(UIAlertAction(title: Okey(), style: UIAlertAction.Style.default, handler: nil))
//                    self.present(alert, animated: true, completion: nil)
//                }
//        })
//    }
//    
//    
//}
//
//extension PostDetailViewController{
//    
//    
//    func getComments (){
//        AppUtility.showProgress()
//        let requestURL = URL(string: SERVER_BASE_URL + COMMENT)!
//        print(requestURL)
//        
//
////        let user:User = AppUtility.getSession()
////        var user: User
////
////        if let u = AppUtility.getSession() {
////            user = u
////        }else{
////            return
////        }
//        
//        let headers = ["Content-Type": "application/json"]
//        
//        let  paramDict = ["pass":"list-by-item",
//                          "itemId":post?.id ?? ""] as [String : Any]
//
//        
//        print(paramDict)
//        
//        self.commentsPost.removeAll()
//        
//        Alamofire.upload(multipartFormData: { (multipartFormData) in
//            for (key, value) in paramDict
//            {
//                multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
//            }
//        },            usingThreshold:UInt64.init(),
//            to: requestURL ,
//            method:.post,
//            headers:headers,
//            encodingCompletion: { encodingResult in
//
//                switch encodingResult {
//                case .success(let upload, _, _):
//
//                    upload.responseJSON { response in
//
//                        print("response JSON: '\(response)'")
//
//                        if((response.result.value) != nil)
//                        {
//                            let swiftyJsonVar = JSON(response.result.value!)
//                            print(swiftyJsonVar)
//
//                            let dict = swiftyJsonVar.dictionaryValue
//                            let message = dict["msg"]?.string
//                            let error = dict["error"]?.bool
//                            
//                            AppUtility.hideProgress()
//                            
//                            if error == false
//                            {
//                                //let result: Dictionary<String, JSON> = swiftyJsonVar["data"].dictionaryValue
//                                let dataArray : [JSON] = (dict["data"]?.arrayValue)!
//                                self.noCommentsLabel.isHidden = false
//                                for dic in dataArray
//                                {
//                                    let dicts: Dictionary<String, JSON> = dic.dictionaryValue
//                                    let objD = Comments.init(withDictionary:dicts)
//                                
//                                    self.commentsPost.append(objD)//.add(objD)
//                                    self.noCommentsLabel.isHidden = true
//                                    
//                                }
//                      
//                                self.commentsViewHeight.constant = 340
//                                self.overAllHeight.constant = self.parentViewHeight + 340
//                                self.parentViewHeight = self.overAllHeight.constant
//                                
//                                self.tableViewComments.reloadData()
//                                
//                                
//                                
//                                
//                                
////                                if self.commentTableViewHeight < 340 {
////                                    self.commentsViewHeight.constant = self.commentTableViewHeight
////                                    let heightDifference = 340 - self.commentTableViewHeight
////                                    self.overAllHeight.constant = self.parentViewHeight - heightDifference
////
////                                    self.parentViewHeight = self.overAllHeight.constant
////                                }
//                                
//                                print("Its height ",self.commentTableViewHeight)
//    
//                                return
//                            }
//                            else
//                            {
//                                
//                                if let dataArray : [JSON] = (dict["data"]?.arrayValue){
//                                    if dataArray.count == 0 {
//                                        self.commentsViewHeight.constant = 40
//                                        self.overAllHeight.constant = self.parentViewHeight - 300
//                                        self.noCommentsLabel.isHidden = false
//                                        
//                                        self.parentViewHeight = self.overAllHeight.constant
//                                    }
//                                    return
//                                }
//                                
//                                let alert = UIAlertController(title: "Error!", message:message, preferredStyle: UIAlertController.Style.alert)
//                                alert.addAction(UIAlertAction(title: Okey(), style: UIAlertAction.Style.default, handler: nil))
//                                self.present(alert, animated: true, completion: nil)
//                            }
//                        }
//                        else
//                        {
//                            AppUtility.hideProgress()
//                            let result = response.result
//                            print("response JSON: '\(result)'")
//                            //let userInfo = response.error as? Error
//                            let error = response.error
//
//                            let alert = UIAlertController(title: "Error!", message:error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
//                            alert.addAction(UIAlertAction(title: Okey(), style: UIAlertAction.Style.default, handler: nil))
//                            self.present(alert, animated: true, completion: nil)
//                        }
//                    }
//                case .failure(let encodingError):
//                    AppUtility.hideProgress()
//                    
//                    print(encodingError)
//                    let alert = UIAlertController(title: "Error!", message:encodingError.localizedDescription, preferredStyle: UIAlertController.Style.alert)
//                    alert.addAction(UIAlertAction(title: Okey(), style: UIAlertAction.Style.default, handler: nil))
//                    self.present(alert, animated: true, completion: nil)
//                }
//        })
//    }
//    
//    
//    func setUpPost(status:String){
//        
//        self.post?.favrtitem_status = status
//        
//        guard let index = indexSelected, let post = self.post, delegate != nil else{
//            return
//        }
//        self.delegate?.updatePost(post: post, index: index)
//    }
//    
//    
//    
//    func getSinglePost(){
//        AppUtility.showProgress()
//        let requestURL = URL(string: SERVER_BASE_URL + AD)!
//        print(requestURL)
//
//        let headers = ["Content-Type": "application/json"]
//        
//        var paramDict : [String : Any]
//     
//        
//        var postid = ""
//        
//        if isRelatedAd{
//            postid = self.postId
//        }else{
//            postid = post?.itemId ?? ""
//        }
//        
//        
//        if let u = AppUtility.getSession() {
//            paramDict = [
//                        "pass":"get-item",
//                        "id":postid,
//                        "username":u.email ?? ""
//                        ] as [String : Any]
//        }else{
//            paramDict = [
//                        "pass":"get-item",
//                        "id":postid
//                        ] as [String : Any]
//        }
//        
//        Alamofire.upload(multipartFormData: { (multipartFormData) in
//            for (key, value) in paramDict{
//                multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
//            }
//        },            usingThreshold:UInt64.init(),
//            to: requestURL ,
//            method:.post,
//            headers:headers,
//            encodingCompletion: { encodingResult in
//
//                switch encodingResult {
//                case .success(let upload, _, _):
//
//                    upload.responseJSON { response in
//
//                        print("response JSON: '\(response)'")
//
//                        if((response.result.value) != nil){
//                            let swiftyJsonVar = JSON(response.result.value!)
//                            print(swiftyJsonVar)
//                            
//                            let dict = swiftyJsonVar.dictionaryValue
//                            let message = dict["msg"]?.string
//                            let error = dict["error"]?.bool
//                            
//                            AppUtility.hideProgress()
//                            
//                            if error == false{
//                                if let data : Dictionary<String, JSON> = (dict["data"]?.dictionaryValue){
//                                    let adDetail = Ad.init(withDictionary:data)
//                                    self.post = adDetail
//                                    self.setUpData()
//                                }
//                                return
//                            }
//                            else{
//                                
//                                let alert = UIAlertController(title: "Error!", message:message, preferredStyle: UIAlertController.Style.alert)
//                                alert.addAction(UIAlertAction(title: Okey(), style: UIAlertAction.Style.default, handler: nil))
//                                self.present(alert, animated: true, completion: nil)
//                            }
//                        }
//                        else
//                        {
//                            AppUtility.hideProgress()
//                            let result = response.result
//                            print("response JSON: '\(result)'")
//                            //let userInfo = response.error as? Error
//                            let error = response.error
//
//                            let alert = UIAlertController(title: "Error!", message:error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
//                            alert.addAction(UIAlertAction(title: Okey(), style: UIAlertAction.Style.default, handler: nil))
//                            self.present(alert, animated: true, completion: nil)
//                        }
//                    }
//                case .failure(let encodingError):
//                    AppUtility.hideProgress()
//                    
//                    print(encodingError)
//                    let alert = UIAlertController(title: "Error!", message:encodingError.localizedDescription, preferredStyle: UIAlertController.Style.alert)
//                    alert.addAction(UIAlertAction(title: Okey(), style: UIAlertAction.Style.default, handler: nil))
//                    self.present(alert, animated: true, completion: nil)
//                }
//        })
//    }
//}
