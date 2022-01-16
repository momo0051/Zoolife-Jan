//
//  GenericAPIS.swift
//  ZOOLIFE
//
//  Created by Muhammad Yousaf on 07/01/2021.
//  Copyright © 2021 Hafiz Anser. All rights reserved.
//

import Alamofire
import SwiftyJSON
import Firebase
import FirebaseFirestore


var chattingList : [GroupChatChannel] = []

var snapshotListener: ListenerRegistration?

var messageBadge : String?
func MessageCheck(_ firsttime : Bool = true)
{
    if let u = AppUtility.getSession() {
        
        chattingList.removeAll()
        FirebaseNotificationServices.fetchChannelsUser(user: u) { (channels) in
            
            if channels.count == 0 {
                AppUtility.getSession()?.msg_badge = "0"
                clearBadgesNotificationForcedMessageTab()
            }else{
                
                chattingList = channels
                var count = 0
                print("countcheck userid \(AppUtility.getSession()?.ID)")
                for chanel in chattingList
                {
                    if let user = AppUtility.getSession()
                    {
                        if let badges = chanel.badges
                        {
                            if let Badge = (badges[user.ID!])
                            {
                                count = Badge + count
                                print("countcheck \(count)")
                                print("\(Badge)")
                            }
                        }
                    }
//                    if let user = AppUtility.getSession()
//                    {
//                        if let badges = chanel.badges
//                        {
//                            if let Badge = (badges[user.ID!])
//                            {
//
//                            }
//                        }
//
//                    }
                }
                messageBadge = "\(count)"
                print("countcheck \(messageBadge)")
                
                setBadgeValues()
//                self.tableView.reloadData()
//                self.noChatFound.isHidden = true
//                DispatchQueue.main.async {
//                    AppUtility.hideProgress()
//                    clearBadgesNotificationForcedMessageTab()
//                }
            }
        }
    }
    if firsttime
    {
        addSnapshotListener()
    }
}
func addSnapshotListener()
{
    if let user = AppUtility.getSession()
    {
        let ref = Firestore.firestore().collection("groups")
            
        snapshotListener =  ref.whereField("friendModel", arrayContains: user.ID!).addSnapshotListener { (querySnapshot, error) in
            
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
                    
                    for (index,snap) in chattingList.enumerated()
                    {
                        
                        if let groupID = document.get("groupID") as? String
                        {
                            if groupID == snap.groupID
                            {
                                chattingList[index] = group
                                groupAdded = true
                            }
                        }
                    }
                    
                    if !groupAdded
                    {
                        chattingList.append(group)
                    }
                }
            }

            chattingList.sort{ $0.lastMessageDate > $1.lastMessageDate}
            MessageCheck(false)
//            self.tableView.reloadData()
//            clearBadgesNotificationForcedMessageTab()
        }
    }
}
func getCurrentProfile (viewController:UIViewController?){
    
    guard let user = AppUtility.getSession(),let id = user.ID else {
        return
    }
  
    AppUtility.showProgress()
    let requestURL = URL(string: GET_USER_PROFILE)!
    

    print(requestURL)
    let headers = ["Content-Type": "application/json","X-Localization":"\(appLanguage)"]
    let  paramDict = ["user_id": id] as [String : Any]
    
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
                            let result: Dictionary<String, JSON> = swiftyJsonVar["data"].dictionaryValue
                            //let userDict = result["data"]?.dictionaryValue

                            print(result)
                            let u = User.init(withDictionary: result)
                            AppUtility.saveUserSession(u: u)
                            UserDefaults.standard.set(true, forKey: "isLogin")
                            UserDefaults.standard.setValue(true, forKey: "isLogin")
                            MessageCheck()
                            setBadgeValues()
                            
                            if let disclaimer = u.disclaimer, let viewCont = viewController{
                                
                                if disclaimer == "0"{
                                   disclaimerPopUp(viewController: viewCont)
                                }
                            }
                            
                            
                            
                            return
                        }
                        else{
                            
                            if let viewCont = viewController{
                                let alert = UIAlertController(title: "Zoolife", message:message, preferredStyle: UIAlertController.Style.alert)
                                alert.addAction(UIAlertAction(title: Okey(), style: UIAlertAction.Style.default, handler: nil))
                                viewCont.present(alert, animated: true, completion: nil)
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
                        if let viewCont = viewController{
                            let alert = UIAlertController(title: "Zoolife", message:error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: Okey(), style: UIAlertAction.Style.default, handler: nil))
                            viewCont.present(alert, animated: true, completion: nil)
                        }
                    }
                }
            case .failure(let encodingError):
                AppUtility.hideProgress()
                print(encodingError)
                if let viewCont = viewController{
                    let alert = UIAlertController(title: "Zoolife", message:encodingError.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: Okey(), style: UIAlertAction.Style.default, handler: nil))
                    viewCont.present(alert, animated: true, completion: nil)
                }
            }
    })
}



func addMsgBadge (userId:String){

//    AppUtility.showProgress()
    let requestURL = URL(string: ADD_MSGS)!

    let headers = ["Content-Type": "application/json","X-Localization":"\(appLanguage)"]
    let  paramDict = ["user_id":userId] as [String : Any]

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
            upload.responseJSON { response in
                print("response JSON: '\(response)'")
            }
            case .failure(let encodingError):
                print(encodingError.localizedDescription)
            }
    })
}



func clearMsgBadge (userId:String,badges:String){

//    AppUtility.showProgress()
    let requestURL = URL(string: READ_MSGS)!

    let headers = ["Content-Type": "application/json","X-Localization":"\(appLanguage)"]
    let  paramDict = ["user_id":userId,"read_msg":badges] as [String : Any]

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
            upload.responseJSON { response in
                print("response JSON: '\(response)'")
                
                if let user = AppUtility.getSession(){
                    if let msg_badges = user.msg_badge{
                        
                        let remainigBadges = (Int(msg_badges) ?? 0) - (Int(badges) ?? 0)
                        
                        setUserMessageBadge(newMsgBadges: String(remainigBadges))
                    }
                }
            }
            case .failure(let encodingError):
                print(encodingError.localizedDescription)
            }
    })
}



func aceptDisclaimer(userId:String,viewController:UIViewController){

//    AppUtility.showProgress()
    let requestURL = URL(string: REAL_BASE_URL + DISCLAIMER)!

    let headers = ["Content-Type": "application/json","X-Localization":"\(appLanguage)"]
    let  paramDict = ["user_id":userId] as [String : Any]

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
            upload.responseJSON { response in
                print("response JSON: '\(response)'")
                viewController.dismiss(animated: true, completion: nil)
            }
            case .failure(let encodingError):
                print(encodingError.localizedDescription)
                viewController.dismiss(animated: true, completion: nil)
            }
    })
}
