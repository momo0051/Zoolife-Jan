//
//  MessageViewController.swift
//  ZOOLIFE
//
//  Created by Hafiz Anser  on 11/20/20.
//  Copyright © 2020 Hafiz Anser. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Firebase
import FirebaseFirestore


class MessageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var lblCenterMessage: UILabel!
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var noChatFound:UILabel!
    var chattingList : [GroupChatChannel] = []
    
    var snapshotListener: ListenerRegistration?
    
    var otherUser = User()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
        if UserDefaults.standard.bool(forKey: "isLogin") == false{
            appDelegate.loadLogin()
        }
 
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
      
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.isUserInteractionEnabled = true
        UpdateLang_UI()
        MessageCheck(false)
        if let u = AppUtility.getSession() {
            AppUtility.showProgress()
            
            self.chattingList.removeAll()
            FirebaseNotificationServices.fetchChannelsUser(user: u) { (channels) in
                
                if channels.count == 0 {
                    self.noChatFound.isHidden = false
//                    clearBadgesNotificationForcedMessageTab()
                    DispatchQueue.main.async {
                        AppUtility.hideProgress()
                    }
                }else{
                    
                    self.chattingList = channels
                    self.tableView.reloadData()
                    self.noChatFound.isHidden = true
                    DispatchQueue.main.async {
                        AppUtility.hideProgress()
//                        clearBadgesNotificationForcedMessageTab()
                    }
                }
            }
        }
        
        addSnapshotListener()
//        clearBadgesNotificationForcedMessageTab()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        let fromNotification = UserDefaults.standard.bool(forKey: FROM_NOTIFICATION)
        
        
        print("from notification", fromNotification)
        if fromNotification
        {
            if notificationEmail != "" && notificationGroupId != ""
            {
                startChatFromNotifictionTap(userEmail: notificationEmail,grouId: notificationGroupId)
            }

        }
//        clearBadgesNotificationForcedMessageTab()

    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        snapshotListener?.remove()
//        clearBadgesNotificationForcedMessageTab()
    }
    //MARK: - Bution Actions
    func UpdateLang_UI(){
        if let lang = UserDefaults.standard.object(forKey: "appLang") as? String {
            if lang == "en" {
                lblTitle.localizeKey = "Inbox"
                lblCenterMessage.localizeKey = "No Chat found!"
                UIView.appearance().semanticContentAttribute = .forceLeftToRight
            } else {
                lblTitle.localizeKey = "المحادثات"
                lblCenterMessage.localizeKey = "لايوجد محادثات"
                UIView.appearance().semanticContentAttribute = .forceRightToLeft
            }
        } else {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }
    }
    
    func addSnapshotListener()
    {
        if let user = AppUtility.getSession()
        {
            let ref = Firestore.firestore().collection("groups")
                
            self.snapshotListener =  ref.whereField("friendModel", arrayContains: user.ID!).addSnapshotListener { (querySnapshot, error) in
                
                guard let snapshot = querySnapshot else {
                    print("Error listening for friend list messages updates: \(error?.localizedDescription ?? "No error")")
                    return
                }
                    
                let documentChanges  = snapshot.documentChanges
                
                for documentChange in documentChanges
                {
                    let document = documentChange.document
                    
                    if let group = GroupChatChannel(document: document)
                    {
                        var groupAdded = false
                        
                        for (index,snap) in self.chattingList.enumerated()
                        {
                            
                            if let groupID = document.get("groupID") as? String
                            {
                                if groupID == snap.groupID
                                {
                                    self.chattingList[index] = group
                                    groupAdded = true
                                }
                            }
                        }
                        
                        if !groupAdded
                        {
                            self.chattingList.append(group)
                        }
                    }
                }

                self.chattingList.sort{ $0.lastMessageDate > $1.lastMessageDate}
                self.tableView.reloadData()
//                clearBadgesNotificationForcedMessageTab()
            }
        }
    }

}


// MARK: - TableView Delegate
extension MessageViewController{
    
     func numberOfSections(in tableView: UITableView) -> Int{
        return 1
     }
     
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.chattingList.count
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        tableView.register(UINib(nibName: "ChatCell", bundle: nil), forCellReuseIdentifier: "ChatCell")
        var cell: ChatCell! = tableView.dequeueReusableCell(withIdentifier: "ChatCell") as? ChatCell
        if (cell == nil)
        {
            cell = ChatCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: "ChatCell")
        }
        
        let chat = self.chattingList[indexPath.row]
        cell.lastMessageLabel.text = chat.lastMessage
       
        
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let newDate = df.string(from: chat.lastMessageDate)
        print(newDate)
        cell.lastMessageTime.text = AppUtility.getFormattedDate(dateString: newDate )

        if let localDateAd = AppUtility.adFormattedDate(dateString: (newDate)){
            let localTimeAdString = TimeFormatHelper.timeAgoString(date: localDateAd)
            print(localTimeAdString)
            cell.lastMessageTime.text = localTimeAdString
        }
        
        //cell.lastMessageTime.text =  TimeFormatHelper.chatString(for: chat.lastMessageDate)
        cell.adTitle.text = chat.adTitle
        cell.senderName.text = chat.adCreatedUser
        if let user = AppUtility.getSession()
        {
            if let badges = chattingList[indexPath.row].badges
            {
                cell.unreadMessage.isHidden = false
                if let Badge = (badges[user.ID!])
                {
                    let myBadge = Badge
                    if myBadge > 0
                    {
                        cell.lastMessageLabel.font = UIFont.boldSystemFont(ofSize: 15)
                        
                        cell.unreadMessage.text = String(myBadge)
                    }
                    else
                    {
                        cell.lastMessageLabel.font = UIFont.systemFont(ofSize: 13)
                        cell.unreadMessage.isHidden = true
                    }
                }
            }
            else
            {
                cell.lastMessageLabel.font = UIFont.systemFont(ofSize: 13)
                cell.unreadMessage.isHidden = true
            }

        }
        
//        cell.adImage =
       
//        let obj = arrDataObjects[indexPath.row]
//        cell.lblName.text = obj.kidName
        cell.selectionStyle = .none

        return cell
     }
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 80
     }
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
     {
//        let viewController = EditProfileViewController()
//        self.navigationController?.pushViewController(viewController, animated: true)
        self.tableView.isUserInteractionEnabled = false
        if let user = AppUtility.getSession()
        {
            let chat = chattingList[indexPath.row]
            
            
            let senderEmail = chat.senderPhone// chat.senderEmail
            let reciEmail = chat.recipientPhone//chat.recipientEmail
            var requestEmail = String()
            
            print("sender Email", senderEmail)
            print("recipient Email", reciEmail)
            
            if senderEmail == user.phone{
                requestEmail = reciEmail!
            }
            else{
                requestEmail = senderEmail!
            }
            
            let url = URL(string: GET_USER_PROFILE)!
            
            let headers = ["Content-Type": "application/json","X-Localization":"\(appLanguage)"]
            
            
            let userIds = chat.friendsModel.filter { $0 != user.ID }
            let paramDict = ["user_id": userIds.first ?? ""] as [String : Any]
            
            print(paramDict)
            
            AppUtility.showProgress()
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                for (key, value) in paramDict
                {
                    multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
                }
            },            usingThreshold:UInt64.init(),
                to: url,
                method:.post,
                headers:headers,
                encodingCompletion: { encodingResult in
                    
//                    clearBadgesNotificationForcedMessageTab()
                    AppUtility.hideProgress()
                    
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

                                

                                if error == false
                                {
                                    
                                   if  let data = dict["data"]?.dictionaryValue
                                   {
                                    print(data)
                                    
                                    self.otherUser = User(withDictionary: data)
                                    
                                    FirebaseNotificationServices.fetchUserChannel(user: user, friend: self.otherUser, adId:chat.adId) { (channel) in
                                        
                                        if let channel = channel{
                                            
                                            let uiConfig = ChatUIConfiguration(primaryColor: UIColor.colorWithHex(hexString: "#5574F7"),
                                                                               secondaryColor: UIColor.colorWithHex(hexString: "#5574F7"),
                                                                               inputTextViewBgColor: message_textfield_background_color,
                                                                               inputTextViewTextColor: message_textfield_text_color,
                                                                               inputPlaceholderTextColor: message_textfield_placeholder_color)
                                            
                                            let cv = ChatViewController()
                                            
                                            
                                            cv.channel = channel
                                            cv.user = user
                                            cv.recipients = [self.otherUser]
                                            cv.uiConfig = uiConfig
                                            cv.deviceToken = self.otherUser.deviceToken
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


                                    return
                                }
                                else
                                {
                                    self.tableView.isUserInteractionEnabled = true
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
                                self.tableView.isUserInteractionEnabled = true
                                let alert = UIAlertController(title: "Zoolife", message:error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                                alert.addAction(UIAlertAction(title:  Okey(), style: UIAlertAction.Style.default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                    case .failure(let encodingError):
                        AppUtility.hideProgress()
                        self.tableView.isUserInteractionEnabled = true
                        print(encodingError)
                        let alert = UIAlertController(title: "Zoolife", message:encodingError.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title:  Okey(), style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
            })
            
        }
        
     }
}

//func getAds ()
//{
//    AppUtility.showProgress()
//    arrAdsData.removeAllObjects()
//    let requestURL = URL(string: SERVER_BASE_URL + AD)!
//    print(requestURL)
//
//
//    let headers = ["Content-Type": "application/json"]
//
//    var  paramDict = [:] as [String : Any]
//    if categoryID == ""
//    {
//        paramDict = ["pass":"get-all-item"]
//    }
//    else if categoryID != "" && subCategoryID == ""
//    {
//        paramDict = ["pass":"get-all-item-by-category",
//                     "category_id": categoryID]
//    }
//    else
//    {
//        paramDict = ["pass":"get-all-item-by-category",
//                     "category_id": categoryID,
//                     "sub_category_id": subCategoryID]
//    }
//
//    print("params",paramDict)
//
//    Alamofire.upload(multipartFormData: { (multipartFormData) in
//        for (key, value) in paramDict
//        {
//            multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
//        }
//    },            usingThreshold:UInt64.init(),
//        to: requestURL ,
//        method:.post,
//        headers:headers,
//        encodingCompletion: { encodingResult in
//
//            switch encodingResult {
//            case .success(let upload, _, _):
//
//                upload.responseJSON { response in
//
//                    print("response JSON: '\(response)'")
//
//                    if((response.result.value) != nil)
//                    {
//                        let swiftyJsonVar = JSON(response.result.value!)
//                        print(swiftyJsonVar)
//
//                        let dict = swiftyJsonVar.dictionaryValue
//                        let message = dict["msg"]?.string
//                        let error = dict["error"]?.bool
//
//                        AppUtility.hideProgress()
//
//                        if error == false
//                        {
//                            //let result: Dictionary<String, JSON> = swiftyJsonVar["data"].dictionaryValue
//                            let dataArray : [JSON] = (dict["data"]?.arrayValue)!
//                            self.lblNoAds.isHidden = false
//                            for dic in dataArray
//                            {
//                                let dicts: Dictionary<String, JSON> = dic.dictionaryValue
//                                let objD = Ad.init(withDictionary:dicts)
//
//                                self.arrAdsData.add(objD)
//                                self.lblNoAds.isHidden = true
//
//                            }
//                            self.viewMainHeightConstraint.constant = CGFloat((400 + (self.arrAdsData.count*162)))
//                            self.tableViewhegihtConstraint.constant = CGFloat(self.arrAdsData.count*162)
//                            self.tableView.reloadData()
//
//
//                            return
//                        }
//                        else
//                        {
//                            let alert = UIAlertController(title: "Zoolife", message:message, preferredStyle: UIAlertController.Style.alert)
//                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
//                            self.present(alert, animated: true, completion: nil)
//                        }
//                    }
//                    else
//                    {
//                        AppUtility.hideProgress()
//                        let result = response.result
//                        print("response JSON: '\(result)'")
//                        //let userInfo = response.error as? Error
//                        let error = response.error
//
//                        let alert = UIAlertController(title: "Zoolife", message:error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
//                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
//                        self.present(alert, animated: true, completion: nil)
//                    }
//                }
//            case .failure(let encodingError):
//                AppUtility.hideProgress()
//
//                print(encodingError)
//                let alert = UIAlertController(title: "Zoolife", message:encodingError.localizedDescription, preferredStyle: UIAlertController.Style.alert)
//                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
//                self.present(alert, animated: true, completion: nil)
//            }
//    })
//}

extension MessageViewController
{
    func startChatFromNotifictionTap(userEmail: String,grouId: String)
    {
        
        UserDefaults.standard.setValue(false, forKey: FROM_NOTIFICATION)
        notificationEmail = ""
        notificationGroupId = ""
        
        if let user = AppUtility.getSession()
        {
            var requestEmail = userEmail
            
            let url = URL(string: GET_USER_PROFILE)!
            
            let headers = ["Content-Type": "application/json","X-Localization":"\(appLanguage)"]
            
            let  paramDict = ["user_id": requestEmail] as [String : Any]
            
            print(paramDict)
            
            AppUtility.showProgress()
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                for (key, value) in paramDict
                {
                    multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
                }
            },            usingThreshold:UInt64.init(),
                to: url,
                method:.post,
                headers:headers,
                encodingCompletion: { encodingResult in
//                    clearBadgesNotificationForcedMessageTab()

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

//                                AppUtility.hideProgress()

                                if error == false
                                {
                                    
                                   if  let data = dict["data"]?.dictionaryValue
                                   {
                                    print(data)
                                    
                                    let otherUser = User(withDictionary: data)
                                    
                                    print(otherUser.email)
                                    

                                    
                                    
                                    
                                    
                                    FirebaseNotificationServices.fetchChannel(channelId: grouId) { (channel) in

                                        print("channel ye ",channel)

                                        let uiConfig = ChatUIConfiguration(primaryColor: UIColor.colorWithHex(hexString: "#5574F7"),
                                                                           secondaryColor: UIColor.colorWithHex(hexString: "#5574F7"),
                                                                           inputTextViewBgColor: message_textfield_background_color,
                                                                           inputTextViewTextColor: message_textfield_text_color,
                                                                           inputPlaceholderTextColor: message_textfield_placeholder_color)

                                        if let channel = channel{

                                            let cv = ChatViewController()


                                            cv.channel = channel
                                            cv.user = user
                                            cv.recipients = [otherUser]
                                            cv.uiConfig = uiConfig
                                            cv.deviceToken = otherUser.deviceToken
                                            DispatchQueue.main.async {
                                                AppUtility.hideProgress()
                                            }

                                            //                            cv.callBack = { changed in
                                            //                                if changed
                                            //                                {
                                            //                                    self.friendsList.remove(at: self.selectedIndex!)
                                            //                                    self.friendTB.reloadData()
                                            //                                }
                                            //
                                            //                            }
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
    }
}
