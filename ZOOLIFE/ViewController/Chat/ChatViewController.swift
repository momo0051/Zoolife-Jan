//
//  ChatViewController.swift
//  ZOOLIFE
//
//  Created by Muhammad Yousaf on 03/12/2020.
//  Copyright © 2020 Hafiz Anser. All rights reserved.
//


import UIKit
import Photos
import Firebase
import MessageKit
import FirebaseFirestore
import FirebaseStorage
import Kingfisher
import QuickLook
import SafariServices
import MobileCoreServices
import InputBarAccessoryView
import IQKeyboardManagerSwift

struct ChatUIConfiguration {
    let primaryColor: UIColor
    let secondaryColor: UIColor
    let inputTextViewBgColor: UIColor
    let inputTextViewTextColor: UIColor
    let inputPlaceholderTextColor: UIColor
}

class ChatViewController: MessagesViewController, MessagesDataSource{
    
    
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var headerLabel:UILabel!
    @IBOutlet weak var messagesLoading:UIActivityIndicatorView!
    
    
    var fetchOldCalled = false
    
    var callBack: ((Bool) -> ())?
    
    var lastMessageDate: Date?
    
    var isDateSet: Bool?
    
    var lastDocument:DocumentSnapshot?
    
    var mDocument: DocumentSnapshot?
    
    var post = Ad()
    
    var deviceToken : String?
    
    
    @IBOutlet weak var navigationHeader:UIView!
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        groupParticipentListener?.remove()
        groupParticipentUserListener?.remove()
        groupListener?.remove()
    }
    
    
    var groupParticipentListener: ListenerRegistration? = nil
    
    
    var groupParticipentUserListener: ListenerRegistration? = nil
    
    
//    var groupListDelegate:GroupListDelegate?

    var isSettingThumbnail:Bool = false
    //for the alert/vibration for the new chat messsage
    let notification = UINotificationFeedbackGenerator()
    
    let documentInteractionController = UIDocumentInteractionController()
    
    
    
    var isNewProject:Bool = false
    let formatter: DateFormatter = {

        let formatter = DateFormatter()
        //formatter.dateStyle = .medium
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()
    
    let dayFormatter: DateFormatter = {

        let formatter = DateFormatter()
        //formatter.dateStyle = .medium
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    var imagePicker = UIImagePickerController()
    
    var groupParticipent :[GroupParticipent] = []
//    var request = PendingRequestModel()
//    var currentFriend = FriendListModel()
    var recipients: [User] = []
    var user: User!
    
    var groupId : String?
    var currentGroup = GroupChatChannel()
    
    var channel: GroupChatChannel!
    var uiConfig: ChatUIConfiguration!
    private var messages: [ChatMessage] = []
    
    private var messageListener: ListenerRegistration?
    private var groupListener: ListenerRegistration?
    
    private let db = Firestore.firestore()
    private var reference: CollectionReference?
    private let storage = Storage.storage().reference()
    
    
    private var isSendingPhoto = false {
        didSet {
            DispatchQueue.main.async {
                self.messageInputBar.leftStackViewItems.forEach { item in
                    
                    item.inputBarAccessoryView?.sendButton.isEnabled = !self.isSendingPhoto
                }
            }
        }
    }

//    var collectionView:UICollectionView!
    let layout :UICollectionViewFlowLayout! = UICollectionViewFlowLayout()
    
    
    var toOpenImageMessage : UIImage!

    var orderImages:[UIImage]?
    
    
    
    deinit {
        messageListener?.remove()
        
    }
    
    var isLoaded: Bool = false
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        self.UpdateLang_UI()
           if #available(iOS 13.0, *) {
                    let app = UIApplication.shared
                    let statusBarHeight: CGFloat = app.statusBarFrame.size.height
                    
                    let statusbarView = UIView()
                    statusbarView.backgroundColor = app_theme_color//UIColor.black
                    view.addSubview(statusbarView)
                    
                    statusbarView.translatesAutoresizingMaskIntoConstraints = false
                    statusbarView.heightAnchor
                        .constraint(equalToConstant: statusBarHeight).isActive = true
                    statusbarView.widthAnchor
                        .constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
                    statusbarView.topAnchor
                        .constraint(equalTo: view.topAnchor).isActive = true
                    statusbarView.centerXAnchor
                        .constraint(equalTo: view.centerXAnchor).isActive = true
                    
                } else {
                    let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
                    statusBar?.backgroundColor = app_theme_color//UIColor.black
                }
           
        
        
        print("this is the view will appear")
        self.tabBarController?.tabBar.isHidden = true
        
        
        
        self.addGroupParticipentListener()
        self.addGroupParticipentUserListener()
        
        
        let ref = Firestore.firestore().collection(group_participent).whereField("userDatabseID", isEqualTo: String(user.ID!)).whereField(group, isEqualTo: channel.id)
        
        ref.getDocuments() { (querySnapshot, err) in
            if err != nil {
                // Some error occured
            } else if querySnapshot!.documents.count != 1 {
                // Perhaps this is an error for you?
            } else {
                let document = querySnapshot!.documents.first
                _ =  document?.data()

            }
        }
    }
    

    
    private var heightOfHeader: CGFloat!
    struct ConversationScreenHeader {
        
        private let superView: UIView
        private let height: CGFloat
        
        init(superView: UIView, height: CGFloat) {
            
            self.superView = superView
            self.height = height
        }
        
        func setup() {
            
            let header = UIView()
            header.backgroundColor = UIColor.lightGray.withAlphaComponent(0.25)
            header.translatesAutoresizingMaskIntoConstraints = false
            superView.addSubview(header)
            
            let topConstraint = NSLayoutConstraint(item: header, attribute: .top, relatedBy: .equal, toItem: superView, attribute: .top, multiplier: 1, constant: 0)
            let leadingConstraint = NSLayoutConstraint(item: header, attribute: .leading, relatedBy: .equal, toItem: superView, attribute: .leading, multiplier: 1, constant: 0)
            let trailingConstraint = NSLayoutConstraint(item: header, attribute: .trailing, relatedBy: .equal, toItem: superView, attribute: .trailing, multiplier: 1, constant: 0)
            let heightConstraint = NSLayoutConstraint(item: header, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: height)
            
            NSLayoutConstraint.activate([topConstraint, leadingConstraint, trailingConstraint, heightConstraint])
        }
    }

    struct AdaptedMessagesCollectionView {
        
        private let messagesCollectionView: MessagesCollectionView
        private let superView: UIView
        private let topIndent: CGFloat
        
        init(messagesCollectionView: MessagesCollectionView, superView: UIView, topIndent: CGFloat) {
            
            self.messagesCollectionView = messagesCollectionView
            self.superView = superView
            self.topIndent = topIndent
        }
        
        func adapt() {
            
            messagesCollectionView.removeFromSuperview()
            superView.addSubview(messagesCollectionView)
            
            messagesCollectionView.translatesAutoresizingMaskIntoConstraints = false
            let topConstraint = NSLayoutConstraint(item: messagesCollectionView, attribute: .top, relatedBy: .equal, toItem: superView, attribute: .top, multiplier: 1, constant: topIndent)
            let leadingConstraint = NSLayoutConstraint(item: messagesCollectionView, attribute: .leading, relatedBy: .equal, toItem: superView, attribute: .leading, multiplier: 1, constant: 0)
            let trailingConstraint = NSLayoutConstraint(item: messagesCollectionView, attribute: .trailing, relatedBy: .equal, toItem: superView, attribute: .trailing, multiplier: 1, constant: 0)
            let bottomConstraint = NSLayoutConstraint(item: messagesCollectionView, attribute: .bottom, relatedBy: .equal, toItem: superView, attribute: .bottom, multiplier: 1, constant: 0)
            
            NSLayoutConstraint.activate([topConstraint, leadingConstraint, trailingConstraint, bottomConstraint])
        }
    }
    
    
    func setUpHeader() {
            let viewWidth = self.view.frame.size.width
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: viewWidth, height: 75))
            let descLabel = UILabel(frame: CGRect(x: 5, y: 5, width: headerView.frame.size.width , height: headerView.frame.size.height - 10))
            descLabel.text = "Test Header"
            descLabel.textAlignment = .center
            headerView.backgroundColor = .lightGray
            headerView.addSubview(descLabel)
            self.view.addSubview(headerView)
    }

    
    override func viewDidLoad() {
        

        super.viewDidLoad()
        
        
        self.headerLabel.text = (self.recipients.first?.fullname)
        
        groupId = channel.groupID
        
        

     //   setUpHeader()
        
//        heightOfHeader = 75
//
//        ConversationScreenHeader(superView: view, height: heightOfHeader).setup()
//        AdaptedMessagesCollectionView(messagesCollectionView: messagesCollectionView, superView: view, topIndent: heightOfHeader).adapt()
//
//        self.messagesCollectionView.contentInset = UIEdgeInsets(top: 80, left: 0, bottom: 0, right: 0)
//
       
//        self.getParticiepent()
//
//             if channel.name == ""{
//                 let ref = Firestore.firestore().collection(groups).whereField("groupID", isEqualTo: channel.id)
//
//                 ref.getDocuments() { (querySnapshot, err) in
//                     if let err = err {
//                         // Some error occured
//                     } else if querySnapshot!.documents.count != 1 {
//                         // Perhaps this is an error for you?
//                     } else {
//                         let document = querySnapshot!.documents.first
//                         let documentData =  document?.data()
//
//                         if let channelName = documentData!["name"] as? String {
//                             self.title = channelName
//                         }
//                     }
//                 }
//             }
//             else {
//                 self.title = channel.name
//             }
        
        
        //StorageHelper.shared.numberOfSnapShot = 0
        
        
        
//        threadsRef.limit(messagesLimit).orderBy("created", Query.Direction.DESCENDING).startAfter(lastDocument).get().addOnSuccessListener(new OnSuccessListener<QuerySnapshot>() {
//                        @Override
//                        public void onSuccess(QuerySnapshot queryDocumentSnapshots) {
//                            for (QueryDocumentSnapshot documentSnapshot : queryDocumentSnapshots) {
//                                Message message = documentSnapshot.toObject(Message.class);
//                                messageList.add(0, message);
//
//                            }
//        //                    Parcelable scrollState = manager.onSaveInstanceState();
//                            messageAdapter.notifyDataSetChanged();
//                            manager.scrollToPositionWithOffset(queryDocumentSnapshots.size(), 0);
//        //                    messageAdapter.notifyItemRangeInserted(0, queryDocumentSnapshots.size());
//        //                    manager.onRestoreInstanceState(scrollState);
//
//                            if(queryDocumentSnapshots.size() > 0) {
//                                lastDocument = queryDocumentSnapshots.getDocuments().get(queryDocumentSnapshots.size()-1);
//                            }
//                            isLoading = false;
//                        }
//                    });
//
        
 
        
//        if let lastDocument = self.lastDocument{
//
//               reference = db.collection([groups, (channel.id ), "thread"].joined(separator: "/")).limit(to: 10).order(by: "created", descending: true).start(afterDocument: self.lastDocument)
//        }
//
        
               
        reference = db.collection([groups, (channel.id ), "thread"].joined(separator: "/"))

        let refNew = reference?.order(by: "created", descending: false).limit(toLast: messageLimit)
//         let refNew = reference?.order(by: "created").limit(toLast: 20)

        messageListener = refNew?.addSnapshotListener { querySnapshot, error in
       // messageListener = reference?.addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error listening for channel updates: \(error?.localizedDescription ?? "No error")")
                return
            }
            
            print(snapshot.documentChanges.count,"count change")
            
            
            
            self.lastDocument = snapshot.documentChanges.first?.document
            
            snapshot.documentChanges.forEach { change in
                self.handleDocumentChange(change)
                
            }
            
            self.lastMessageDate = self.messages.last?.sentDate
            self.isDateSet = false
            
            print("lasst message", self.messages.last?.content)
            print("first message", self.messages.first?.content)
            
            print(self.lastMessageDate)
            

        }
        
        let mRef = Firestore.firestore().collection(groups)
        
        print("group id ye hy",groupId)
        print("channel id ye hy",self.channel.id)
        print("channel group id ye hy",channel.groupID)
        
        if let groupId = groupId
        {
            if groupId != ""
            {
                groupListener = mRef.document(groupId).addSnapshotListener { (documentSnapshot, error) in
                    
                    guard let document = documentSnapshot else {
                                        print("Error listening for channel updates: \(error?.localizedDescription ?? "No error")")
                        return
                    }
                    
                    self.mDocument = document
                    if let group = GroupChatChannel(document: document){
                        self.currentGroup = group
                        self.clearMyBadges()
                    }
                }
            }
        }
        
        navigationItem.largeTitleDisplayMode = .never
        
        maintainPositionOnKeyboardFrameChanged = true
 
         
         
         let inputTextView = messageInputBar.inputTextView
         inputTextView.tintColor = uiConfig.primaryColor
         inputTextView.textColor = uiConfig.inputTextViewTextColor
         inputTextView.backgroundColor = uiConfig.inputTextViewBgColor
         inputTextView.layer.cornerRadius = 14.0
         inputTextView.layer.borderWidth = 0.0
         inputTextView.font = UIFont.boldSystemFont(ofSize: 16)// .systemFont(ofSize: 16.0)
         inputTextView.placeholderLabel.textColor = uiConfig.inputPlaceholderTextColor
         inputTextView.placeholderLabel.text = "Start typing..."
         inputTextView.textContainerInset = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)
         inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 6, left: 15, bottom: 6, right: 15)
         
         let sendButton = messageInputBar.sendButton
         sendButton.setTitleColor(uiConfig.primaryColor, for: .normal)
        // sendButton.setImage(UIImage.localImage("ic_send", template: true), for: .normal)
         sendButton.setImage(UIImage(named: "ICON_SEND_MESSAGE"), for: .normal)
         sendButton.title = ""
        
         sendButton.setSize(CGSize(width: 30, height: 30), animated: false)
        
        let hideKeyboardButton = InputBarButtonItem(type: .custom)
//        sendButton2.setTitleColor(uiConfig.primaryColor, for: .normal)
        hideKeyboardButton.backgroundColor = .clear
        hideKeyboardButton.setImage(UIImage(named: "icn_Hidden_Keyboard"), for: .normal)
        hideKeyboardButton.title = ""
        hideKeyboardButton.addTarget(
            self,
            action: #selector(hiddenKeyboardButtonPressed),
            for: .primaryActionTriggered
        )
        hideKeyboardButton.setSize(CGSize(width: 30, height: 30), animated: false)
        
         messageInputBar.delegate = self
         messagesCollectionView.messagesDataSource = self
         messagesCollectionView.messagesLayoutDelegate = self
         messagesCollectionView.messagesDisplayDelegate = self
         messagesCollectionView.messageCellDelegate = self
        
//        showMessageTimestampOnSwipeLeft = true
        
         
         // messagesCollectionView.transform = CGAffineTransform(rotationAngle: -(CGFloat)(Double.pi));
         
         messageInputBar.delegate = self
         
         let cameraItem = InputBarButtonItem(type: .system)
         cameraItem.tintColor = app_theme_color//uiConfig.inputTextViewBgColor
         cameraItem.image = UIImage(named: "ICON_CAMERA")//.localImage("ic_camera", template: true)
         
         
         cameraItem.addTarget(
             self,
             action: #selector(cameraButtonPressed),
             for: .primaryActionTriggered
         )
         cameraItem.setSize(CGSize(width: 30, height: 30), animated: false)
         
         messageInputBar.leftStackView.alignment = .center
         messageInputBar.setLeftStackViewWidthConstant(to: 50, animated: false)
         messageInputBar.setRightStackViewWidthConstant(to: 70, animated: false)
         
        messageInputBar.setStackViewItems([sendButton,hideKeyboardButton], forStack: .right, animated: false)
         messageInputBar.setStackViewItems([cameraItem], forStack: .left, animated: false)
         messageInputBar.backgroundColor = .white
         messageInputBar.backgroundView.backgroundColor = .white
         messageInputBar.separatorLine.isHidden = true
         

         self.messagesCollectionView.contentInset = UIEdgeInsets(top: 80, left: 0, bottom: 0, right: 0)
           //  self.messagesCollectionView.backgroundColor = .clear
         
         self.view.bringSubviewToFront(self.navigationHeader)
         self.view.bringSubviewToFront(self.messagesLoading)
        
        
       // collectionView.register(MessageReusableDate.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
        //updateNavigationBar()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
       //
    }

    func UpdateLang_UI(){
        if let lang = UserDefaults.standard.object(forKey: "appLang") as? String {
            if lang == "en" {
                lblTitle.localizeKey = "Chat"
                UIView.appearance().semanticContentAttribute = .forceLeftToRight
            } else {
                lblTitle.localizeKey = "المحادثات"
                
                UIView.appearance().semanticContentAttribute = .forceRightToLeft
            }
        } else {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }
    }

    func clearMyBadges(){
        if let badges = currentGroup.badges{
            let prevBadges = badges[self.recipients[0].ID!] ?? 0
            let myBadges = badges[self.user.ID!] ?? 0
            
            
            let newBadges = [
                self.user.ID!: 0,
                self.recipients[0].ID! : prevBadges]

            let data = ["badges": newBadges]

            mDocument?.reference.updateData(data)
            
            if let user = AppUtility.getSession(){
                if let id = user.ID{
                    clearMsgBadge(userId: id, badges: String(myBadges))
                }
            }
        }
    }
    
    func updateNavigationBar(){
        
          self.navigationItem.rightBarButtonItem =  UIBarButtonItem.init(image: UIImage(named: "ic_setting"), style: .done, target: self, action: #selector(settingButtonTapped))
        
        
    }
    
    @IBAction func backBtn(){
        
        self.navigationController?.popViewController(animated: true)
        
    }
    @IBAction func moreButtonAction(_ sender: UIButton) {
//        let alertView: UIAlertController = UIAlertController(title: appNAME as String, message: ("Select" as
//            String).localiz(), preferredStyle: .actionSheet)
//
//
//        let galleryAction: UIAlertAction = UIAlertAction(title: "Block User".localiz(), style: .default) { action -> Void in
//
//            apiServiceModal.blockUnblockFriendApi(id: "\(self.request.id )", status: self.request.status ,userId: String(objUser.ID), currentController: self) {
//                print("blocked")
//                DispatchQueue.main.async{
//                    self.callBack?(true)
//                    self.showAlert(title: "Block Friend", message: "This Friend Has Been Blocked", dismissTitle: "OK", animated: true) {
//                        UIView.animate(withDuration: 0, delay: 2, animations: {
//                            self.navigationController?.popViewController(animated: true)
//                        })
//
//                    }
//                }
//            }
//        }
//
//        let unfriendAction: UIAlertAction = UIAlertAction(title: "Unfriend User".localiz(), style: .default) { action -> Void in
//
//            apiServiceModal.cancelFriendRequestApi(id: "\(self.request.id )", status: self.request.status , currentController: self) {
//                DispatchQueue.main.async{
////                    self.sendRequest = true
////                    self.buttonSendRequest.setTitle("Send Request", for: .normal)
//                    print("Request Canceled")
//                    self.callBack?(true)
//                    self.showAlert(title: appNAME, message: "Unfriended", dismissTitle: "OK", animated: true) {
//                        UIView.animate(withDuration: 0, delay: 2, animations: {
//                            self.navigationController?.popViewController(animated: true)
//                        })
//                    }
//                }
//            }
//        }
//
//        let viewProfileAction: UIAlertAction = UIAlertAction(title: "View Profile".localiz(), style: .default) { action -> Void in
//
//            let vc = mainStroyBoard.instantiateViewController(withIdentifier: "SendFriendRequestViewController") as! SendFriendRequestViewController
//
//            vc.fromChat = true
//            vc.profile = self.recipients[0]
//            vc.friendStatus = "confirmed"
//
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
//
//        alertView.addAction(galleryAction)
//        alertView.addAction(unfriendAction)
//        alertView.addAction(viewProfileAction)
//
//        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel".localiz(), style: .destructive) { action -> Void in
//        }
//        alertView.addAction(cancelAction)
//
//        self.present(alertView, animated: true, completion: nil)
    }
    
    @IBAction func settingButtonTapped(){

    }

    
    
    override open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard messagesCollectionView.messagesDataSource != nil else {
            fatalError("Ouch. nil data source for messages")
        }
        
        if indexPath.section < 13 {   // Are we within 3 rows from the top?

//            DispatchQueue.main.async {
//                self.fetchOldMessages()
//            }

            
            
            
            if !self.fetchOldCalled{
                DispatchQueue.main.async {
                    self.fetchOldCalled = true
                    self.messagesLoading.startAnimating()
                    self.fetchOldMessages()
                }

            }
            
        }else{
            self.messagesLoading.stopAnimating()
        }
        
        
        
        return super.collectionView(collectionView, cellForItemAt: indexPath)
    }
    
    // MARK: - Helpers
    
    private func save(_ message: ChatMessage,user: User) {
        
        let strokeTextAttributes = [
            NSAttributedString.Key.strokeColor : UIColor.black,
            NSAttributedString.Key.foregroundColor : UIColor.white,
            NSAttributedString.Key.strokeWidth : -2.0,
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)
            ] as [NSAttributedString.Key : Any]
        
        let textAttributed = NSAttributedString(string: "Complete Profile", attributes: strokeTextAttributes)
        
        reference?.addDocument(data: message.representation) {[weak self] error in
            if let e = error {
                print("Error sending message: \(e.localizedDescription)")
                
                
                return
            }
            guard let `self` = self else { return }
            
            let channelRef = Firestore.firestore().collection(groups).document(self.channel.id )
            var lastMessage = ""
            var prevBadges = Int()
            var newBadges = [String: Int]()
            switch message.kind {
            case let .text(text):
                
                var doc = false
                
                if let isdoc = message.isDoc{
                    doc = isdoc
                }
                
                if doc{
                    lastMessage = "Someone Shared Document."
                }else{
                    if text == "Complete Profile"{
                        lastMessage = "Profile Page"
                    }
                    else{
                        lastMessage = text
                    }
                }

            case .photo(_):
                lastMessage = user.fullname + " sent a photo."
            case .attributedText(textAttributed):
                lastMessage = "Profile Page"
            default:
                break
            }
            
            if let badges = self.currentGroup.badges{
                prevBadges = badges[self.recipients[0].ID!] ?? 0
                newBadges = [
                    user.ID!: 0,
                    self.recipients[0].ID! : prevBadges + 1]
            }
            else{
                newBadges = [
                    user.ID!: 0,
                    self.recipients[0].ID! : 1]
            }
            
            
            if let id = self.recipients[0].ID{
                addMsgBadge(userId: id)
            }
            
            
            
            
            let newData: [String: Any] = [
                "lastMessageDate": Date(),
                "lastMessage": lastMessage,
                "badges": newBadges
            ]
            channelRef.setData(newData, merge: true)
            ChatFirebaseManager.updateChannelParticipationIfNeeded(channel: self.channel)
            self.sendOutPushNotificationsIfNeeded(message: message, user: user)
            self.messagesCollectionView.scrollToBottom()
        }
    }
    
    private func insertNewMessage(_ message: ChatMessage) {
        
        
        let data = lastDocument?.data()
        
        var iSend = false
        
        guard let senderIDData = data?["senderDatabaseID"] as? String else  {
            return
        }
        
        if senderIDData == String(user.ID!) {
            iSend = true
        }
        
        
        var recipeint : User?
        var sender:User?
        
        if iSend {
            sender = user
            recipeint = User()
            guard  let reci = self.recipients.first else {
                return
            }
            recipeint?.ID = reci.ID
            recipeint?.email = reci.email
//            recipeint?.token = reci.device_token
//            recipeint?.user_nicename = reci.user_nicename
//            recipeint?.user_display_name = reci.display_name
//            recipeint?.nationality = reci.nationality
//            recipeint?.language = reci.language
            recipeint?.fullname = reci.fullname
//            recipeint?.last_name = reci.last_name
            recipeint?.phone = reci.phone
            recipeint?.avatar = reci.avatar
//            recipeint?.country = reci.country
        }else{
            recipeint = user
            sender = User()
            guard  let reci = self.recipients.first else {
                return
            }
            sender?.ID = reci.ID
            sender?.email = reci.email
//            sender?.token = reci.device_token
//            sender?.user_nicename = reci.user_nicename
//            sender?.user_display_name = reci.display_name
//            sender?.nationality = reci.nationality
//            sender?.language = reci.language
            sender?.fullname = reci.fullname
//            sender?.last_name = reci.last_name
            sender?.phone = reci.phone
            sender?.avatar = reci.avatar
//            sender?.country = reci.country
        }
        
        
        
        
        let msg = ChatMessage(document: lastDocument as! QueryDocumentSnapshot,sender: sender!, reciepient: recipeint!)
        
       // print(msg?.content)
        
//
        print("Last message",msg?.content)
//
        guard !messages.contains(message) else {
            return
        }
        
        messages.append(message)
        messages.sort()
        
        let isLatestMessage = messages.firstIndex(of: message) == (messages.count - 1)
        let shouldScrollToBottom = messagesCollectionView.isAtBottom && isLatestMessage
        
        
        if self.isLoaded{
          //  self.messagesLoading.stopAnimating()
            messagesCollectionView.reloadData()
        }

        if shouldScrollToBottom {
            DispatchQueue.main.async {
                
                
                if self.isLoaded{
                    
               //     self.messagesLoading.stopAnimating()
                    
                    // self.messagesCollectionView.reloadData()
                    self.messagesCollectionView.scrollToBottom(animated: false)
                    
                }else{
                    self.messagesCollectionView.reloadData()
                    //     print("scroll to item")
                    self.isLoaded = true
                    let indexPath = IndexPath(item: 0, section: self.messages.count - 1)
                    self.messagesCollectionView.scrollToItem(at: indexPath, at: .bottom, animated: false)
                }
            }
        }
    }
    
    private func handleDocumentChange(_ change: DocumentChange) {
        
        let data = change.document.data()
        
        
        var iSend = false
        
        guard let senderIDData = data["senderDatabaseID"] as? String else  {
            return
        }
        
        if senderIDData == String(user.ID!) {
            iSend = true
        }
        
        
        var recipeint : User?
        var sender:User?
        
        if iSend {
            sender = user
            recipeint = User()
            guard  let reci = self.recipients.first else {
                return
            }
            recipeint?.ID = reci.ID
            recipeint?.email = reci.email
//            recipeint?.token = reci.device_token
//            recipeint?.user_nicename = reci.user_nicename
//            recipeint?.user_display_name = reci.display_name
//            recipeint?.nationality = reci.nationality
//            recipeint?.language = reci.language
            recipeint?.fullname = reci.fullname
//            recipeint?.last_name = reci.last_name
            recipeint?.phone = reci.phone
            recipeint?.avatar = reci.avatar
//            recipeint?.country = reci.country
        }else{
            recipeint = user
            sender = User()
            guard  let reci = self.recipients.first else {
                return
            }
            sender?.ID = reci.ID
            sender?.email = reci.email
//            sender?.token = reci.device_token
//            sender?.user_nicename = reci.user_nicename
//            sender?.user_display_name = reci.display_name
//            sender?.nationality = reci.nationality
//            sender?.language = reci.language
            sender?.fullname = reci.fullname
//            sender?.last_name = reci.last_name
            sender?.phone = reci.phone
            sender?.avatar = reci.avatar
//            sender?.country = reci.country
        }
        

        
        guard let message = ChatMessage(document: change.document,sender: sender!, reciepient: recipeint!) else {
            return
        }
        print("new id",message.id)
      
      
        
        switch change.type {
        case .added:
            if message.downloadURL != nil {
                
                message.image = UIImage(named: "thumbnail-placeholder")
                self.insertNewMessage(message)

            } else {
                insertNewMessage(message)
            }

        case .modified :
            print("some modifications are done")
            
            let indexOfUpdatedMessage = messages.firstIndex(of: message)
            
            if indexOfUpdatedMessage != nil {
                if let updatedMessage = indexOfUpdatedMessage{
                    print(updatedMessage,"is intergers value")
                    self.messages.remove(at: updatedMessage)
                    self.insertNewMessage(message)
                    //self.messages[updatedMessage] = message
                }
            }
            
            break
        default:
            break
        }
    }
    
    private func uploadImage(_ image: UIImage, to channel: GroupChatChannel, completion: @escaping (URL?) -> Void) {
        
        guard let scaledImage = image.scaledToSafeUploadSize, let data = scaledImage.jpegData(compressionQuality: 0.8) else {
            completion(nil)
            return
        }
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        let imageName = [UUID().uuidString, String(Date().timeIntervalSince1970)].joined()
        storage.child(channel.id ).child(imageName).putData(data, metadata: metadata) { meta, error in
            
            if error != nil{
                print(error?.localizedDescription)
            }
            
            if let name = meta?.path, let bucket = meta?.bucket {
                let path = "gs://" + bucket + "/" + name
                completion(URL(string: path))
            } else {
                completion(nil)
            }
        }
    }
    
    private func sendPhoto(_ image: UIImage) {
//
//        if Reachability()?.currentReachabilityStatus != Reachability.NetworkStatus.notReachable {
//
        if Reachability.isConnectedToNetwork() == true{
            
            isSendingPhoto = true
            
            AppUtility.showProgress()
            uploadImage(image, to: channel) { [weak self] url in
                guard let `self` = self else {
                    return
                }
                self.isSendingPhoto = false
                
                guard let url = url else {
                    AppUtility.hideProgress()
                    return
                }

                let ref = Storage.storage().reference(forURL: url.absoluteString)
                
                let recipeint = User()
                guard  let reci = self.recipients.first else {
                    AppUtility.hideProgress()
                    return
                }
                recipeint.ID = reci.ID
                recipeint.email = reci.email
//                recipeint.token = reci.device_token
//                recipeint.user_nicename = reci.user_nicename
//                recipeint.user_display_name = reci.display_name
//                recipeint.nationality = reci.nationality
//                recipeint.language = reci.language
                recipeint.fullname = reci.fullname
//                recipeint.last_name = reci.last_name
                recipeint.phone = reci.phone
                recipeint.avatar = reci.avatar
//                recipeint.country = reci.country
                
                let message = ChatMessage(user: self.user,recipient:recipeint, image: image, url: url,seenByRecipient:false,isPinned: false,isDoc: false)
                ref.downloadURL(completion: { (urlOrignal, error) in
                    message.downloadURL = urlOrignal
                    self.save(message,user: self.user)
                    self.messagesCollectionView.scrollToBottom()
                    AppUtility.hideProgress()

                })
            }
        }
        else {
            self.showErrorAlert(message: AlertTitle.NETWORK_ERROR)
        }
    }
    
    
    
    private func sendOutPushNotificationsIfNeeded(message: ChatMessage,user: User) {
        var lastMessage = ""
        switch message.kind {
        case let .text(text):
            let firstName = user.fullname
            lastMessage = firstName + ": " + text
           
        case .photo(_):
            lastMessage = user.fullname + " sent a photo."
        default:
            break
        }
        
        let notificationSender = PushNotificationSender()
        
//        if recipients.count > 0{
//            let recipient = recipients[0]
        
        
        if let deviceToken = deviceToken
        {
            notificationSender.sendPushNotification(to: deviceToken, title: "Zoo Life", body: lastMessage, badges: 1, identifier: "NC",groupId: channel.groupID)
        }
        
    
    }
    
    private func downloadImage(at url: URL, completion: @escaping (UIImage?) -> Void) {
        let ref = Storage.storage().reference(forURL: url.absoluteString)
        let megaByte = Int64(1 * 1024 * 1024)
        
        ref.getData(maxSize: megaByte) { data, error in
            guard let imageData = data else {
                completion(nil)
                return
            }
            
            completion(UIImage(data: imageData))
        }
    }


    
    
    // MARK: - MessagesDataSource
    func currentSender() -> SenderType {
        let idString = String(user.ID!)
        return Sender(id: idString , displayName: "You")
//        guard let senderEmail = UserStateHolder.loggedInUser else{
//
//        }
//
//        return Sender(id: senderEmail.uid ?? "noid", displayName: "You")
    }
    
//    func numberOfMessages(in messagesCollectionView: MessagesCollectionView) -> Int {
//        return messages.count
//    }
    
    

    func messageForItem(at indexPath: IndexPath,
                        in messagesCollectionView: MessagesCollectionView) -> MessageType {
        
        if indexPath.section < messages.count {
            
            return messages[indexPath.section]
        }
        fatalError()
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    
    
        
    func cellTopLabelAttributedText(for message: MessageType,
                                    at indexPath: IndexPath) -> NSAttributedString? {

        
            
            if indexPath.section == 0 {
             
                return NSAttributedString(
                     string: MessageKitDateFormatter.shared.string(from: message.sentDate),
                     attributes: [
                         .font: UIFont.preferredFont(forTextStyle: .caption1),
                         .foregroundColor: UIColor.blue
                     ]
                 )
            }
            
            // get previous message
            let previousIndexPath = IndexPath(row: 0, section: indexPath.section - 1)
            let previousMessage = messageForItem(at: previousIndexPath, in: messagesCollectionView)
            
            if message.sentDate.isInSameDayOf(date: previousMessage.sentDate){
                return nil
            }
            
      
        return NSAttributedString(
             string: MessageKitDateFormatter.shared.string(from: message.sentDate),
             attributes: [
                 .font: UIFont.preferredFont(forTextStyle: .caption1),
                 .foregroundColor: UIColor.blue
             ]
         )


//        if !isSameDay(date1: lastMessageDate ?? Date(), date2: message.sentDate)//lastMessageDate != message.sentDate
//        {
//            isDateSet = false
//
//            lastMessageDate = message.sentDate
//
//
//        }


//        if !(isDateSet ?? false)
//        {
//            isDateSet = true
//            return NSAttributedString(
//                string: MessageKitDateFormatter.shared.string(from: message.sentDate),
//                attributes: [
//                    .font: UIFont.preferredFont(forTextStyle: .caption1),
//                    .foregroundColor: UIColor.blue
//                ]
//            )
//        }

//        return nil



//
//        let name = message.sender.displayName
//        return NSAttributedString(
//            string: name,
//            attributes: [
//                .font: UIFont.preferredFont(forTextStyle: .caption1),
//                .foregroundColor: UIColor.blue
//            ]
//        )

//        UIColor(white: 0.3, alpha: 1)

    }

    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        
        if indexPath.section == 0 {
            return 20
        }
        
        // get previous message
        let previousIndexPath = IndexPath(row: 0, section: indexPath.section - 1)
        let previousMessage = messageForItem(at: previousIndexPath, in: messagesCollectionView)
        
        if message.sentDate.isInSameDayOf(date: previousMessage.sentDate){
            return 0
        }
        
        return 20
        
        
    }
    
    
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 20
    }
    
    
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
        return nil
        let name = message.sender.displayName
        
        let senderAttributes = [
        NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption2),
        NSAttributedString.Key.foregroundColor: message_sender_text_color] as [NSAttributedString.Key : Any]
        
        return NSAttributedString(string: name, attributes: senderAttributes)
        
        
        return NSAttributedString(string: name, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1)])
    }
    

    
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
        let dateString = formatter.string(from: message.sentDate)
        
        let senderAttributes = [
                       NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption2),
                       NSAttributedString.Key.foregroundColor: message_sendtime_text_color] as [NSAttributedString.Key : Any]
        return NSAttributedString(string: dateString, attributes: senderAttributes)
        
        
//
//        if isFromCurrentSender(message: message){
//
//            let senderAttributes = [
//                NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption2),
//                NSAttributedString.Key.foregroundColor: sent_message_time_text_color] as [NSAttributedString.Key : Any]
//            return NSAttributedString(string: dateString, attributes: senderAttributes)
//
//
//
////            return NSAttributedString(string: dateString, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption2)])
//        }
//        else {
//
//            let receiverAttributes = [
//                NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption2),
//                NSAttributedString.Key.foregroundColor: receive_message_time_text_color] as [NSAttributedString.Key : Any]
//
//            return NSAttributedString(string: dateString, attributes: receiverAttributes)
//
////            return NSAttributedString(string: dateString, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption2)])
//        }
    }
    
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 20
    }
    
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? sent_message_text_color : receive_message_text_color
    }
  
}

// MARK: - MessagesLayoutDelegate

extension ChatViewController: MessagesLayoutDelegate {
    
    func avatarSize(for message: MessageType, at indexPath: IndexPath,
                    in messagesCollectionView: MessagesCollectionView) -> CGSize {
        
        
        return .zero
    }
    
    func footerViewSize(for message: MessageType, at indexPath: IndexPath,
                        in messagesCollectionView: MessagesCollectionView) -> CGSize {
        
        return CGSize(width: 0, height: 8)
    }
    
    func heightForLocation(message: MessageType, at indexPath: IndexPath,
                           with maxWidth: CGFloat, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        
        return 0
    }
    
//    did
    
}

// MAR: - MessageInputBarDelegate

extension ChatViewController: InputBarAccessoryViewDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
        
//
//        if Reachability()?.currentReachabilityStatus != Reachability.NetworkStatus.notReachable {
         if Reachability.isConnectedToNetwork() == true{
            var message : ChatMessage
            
            let charset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789¬±¬ß!@#$%^&*()_-+=}]{[\\|?/>.,<;~`")
            if text.rangeOfCharacter(from: charset) != nil {
                //  print("yes")
            }else{
                //print("no")
                if let imageIfExists =  UIPasteboard.general.image{
                    self.sendPhoto(imageIfExists)
                    inputBar.inputTextView.text = ""
                    return
                }

            }
            
            
            
            let recipeint = User()
            guard  let reci = self.recipients.first else {
                return
            }
            recipeint.ID = reci.ID
            recipeint.email = reci.email
//            recipeint.token = reci.device_token
//            recipeint.user_nicename = reci.user_nicename
//            recipeint.user_display_name = reci.display_name
//            recipeint.nationality = reci.nationality
//            recipeint.language = reci.language
            recipeint.fullname = reci.fullname
//            recipeint.last_name = reci.last_name
            recipeint.phone = reci.phone
            recipeint.avatar = reci.avatar
//            recipeint.country = reci.country
            
    
            

            (message = ChatMessage(messageId: UUID().uuidString,messageKind: MessageKind.text(text),createdAt: Date(),atcSender: user,recipient: recipeint,seenByRecipient: false,isPinned: false,isDoc:false))

            save(message, user: self.user)
            inputBar.inputTextView.text = ""


        }
        else {
            self.showErrorAlert(message: AlertTitle.NETWORK_ERROR)
        }
    }
    
    
    
    
    
  //  func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String)
    //show alert
    public func showErrorAlert(message:String, Title:String = "Zoolife") {
        let AlertViewController = UIAlertController(title: Title, message: message, preferredStyle: .alert)
        let actionOkay = UIAlertAction.init(title:  Okey(), style: UIAlertAction.Style.default) { (action) in
            
        }
        
        AlertViewController.addAction(actionOkay)
        self.present(AlertViewController, animated: true, completion: nil)
    }
    
    
    
    func hasSpecialCharacters(_ text:String) -> Bool {
        
        do {
            let regex = try NSRegularExpression(pattern: ".*[^A-Za-z0-9].*", options: .caseInsensitive)
            if let _ = regex.firstMatch(in: text, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSMakeRange(0, text.count)) {
                return true
            }
            
        } catch {
            debugPrint(error.localizedDescription)
            return false
        }
        
        return false
    }
    
    
}

// MARK CHAT COLOR: - MessagesDisplayDelegate

extension ChatViewController: MessagesDisplayDelegate {
    
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath,
                         in messagesCollectionView: MessagesCollectionView) -> UIColor {
        
        
        
        return isFromCurrentSender(message: message) ? sent_message_bubble_color : receive_message_bubble_color
        
        
        return isFromCurrentSender(message: message) ? UIColor.colorWithHex(hexString: "##5574F7") : UIColor.colorWithHex(hexString: "#f0f0f0")
    }
    
    func shouldDisplayHeader(for message: MessageType, at indexPath: IndexPath,
                             in messagesCollectionView: MessagesCollectionView) -> Bool {
        return false
    }
    
//    func shouldDisplayHeader(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> Bool {
//
//            if indexPath.section == 0 {
//                return true
//            }
//
//            // get previous message
//            let previousIndexPath = IndexPath(row: 0, section: indexPath.section - 1)
//            let previousMessage = messageForItem(at: previousIndexPath, in: messagesCollectionView)
//
//            if message.sentDate.isInSameDayOf(date: previousMessage.sentDate){
//                return false
//            }
//
//            return true
//        }
    
    
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath,
                      in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        
        
        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        return .bubbleTail(corner, .curved)
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        if let message = message as? ChatMessage {

            if let urlString = message.atcSender.avatar
            {
                avatarView.kf.setImage(with: URL(string: urlString))
            }
        }
    }
    
    
    
    func configureMediaMessageImageView(_ imageView: UIImageView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        
        let imgView = imageView
        
        if let message = message as? ChatMessage {
            
            if let url = message.downloadURL {
                
                imgView.kf.indicatorType = .activity
                imgView.kf.setImage(
                    with: url,
                    placeholder: UIImage(named: "thumbnail-placeholder"),
                    options: [
                        .scaleFactor(UIScreen.main.scale),
                        .transition(.fade(1)),
                        .cacheOriginalImage
                    ], completionHandler:
                        {
                            result in
                            switch result {
                            case .success(let value):
                                
                                message.image = value.image
                                
                                print("Task done for: \(value.source.url?.absoluteString ?? "")")
                            case .failure(let error):
                                print("Job failed: \(error.localizedDescription)")
                            }
                        })

            }
        }
    }
}

// MARK: - UIImagePickerControllerDelegate

extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if isSettingThumbnail{
            if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                 print("from again gallery champ")
                sendPhoto(image)
            }
            return
        }
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            print("from again gallery champ")
            sendPhoto(image)
        }

    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

extension ChatViewController{
    @objc private func hiddenKeyboardButtonPressed() {
        print("Hiden keyboard")
        messageInputBar.inputTextView.resignFirstResponder()
        
    }
    
    @objc private func cameraButtonPressed() {

        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: loc.camera.localized(), style: .default, handler: { _ in
            self.openCamera()
        }))

        alert.addAction(UIAlertAction(title: loc.chooseFromGalary.localized(), style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: loc.No.localized(), style: .cancel, handler: nil))
        
        //If you want work actionsheet on ipad then you have to use popoverPresentationController to present the actionsheet, otherwise app will crash in iPad
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            //        alert.popoverPresentationController?.sourceView = sender
            //        alert.popoverPresentationController?.sourceRect = sender.bounds
            alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Open the camera
    func openCamera(){
        
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
            
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            //If you dont want to edit the photo then you can set allowsEditing to false
            imagePicker.allowsEditing = true
            imagePicker.isEditing = true
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
            
        }else{
            var word = "ليس لديك كاميرا"
                        if appLanguage == "en" {
                            word = "You don't have camera"
                        }
            let alert  = UIAlertController(title: "", message: word, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title:  Okey(), style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: - Choose image from camera roll
    func openGallary(){
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        //If you dont want to edit the photo then you can set allowsEditing to false
        imagePicker.allowsEditing = false
        imagePicker.isEditing = true
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
}

extension ChatViewController:MessageCellDelegate{

    //MARK: - Saving Image here
    func saveImageToGallery(_ image:UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    //MARK: - Add image to Library
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        var word = "تم حفظ صورتك في صورك"
                    if appLanguage == "en" {
                        word = "Your image has been saved to your photos."
                    }
        if let error = error {
            // we got back an error!
            showAlertWith(title: "Save error", message: error.localizedDescription)
        } else {
            showAlertWith(title: "", message: word)
        }
    }
    
    
    func showAlertWith(title: String, message: String){
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title:  Okey(), style: .default))
        present(ac, animated: true)
    }
    
    func didTapMessage(in cell: MessageCollectionViewCell) {
        print("Message Tapped")
        
        guard let index = messagesCollectionView.indexPath(for: cell) else { return }
        
        let dataSource = messagesCollectionView.messagesDataSource
        let message = dataSource?.messageForItem(at: index, in: messagesCollectionView)
        
        print(message?.kind as Any)
        
        switch message?.kind {
        case .photo(let image):
            print("message is image ",image.image as Any)
            if let image = image.image
            {
                self.imageTapped(image: image)
            }
        case .text(let text):
            print("message is text ", text)
        default:
            break
        }
    }
    
    
    func imageTapped(image: UIImage){
        print("Entered the imageTapped function.")
        let newImageView = UIImageView(image: image)
        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        newImageView.addGestureRecognizer(tap)
        UIView.animate(withDuration: 2.0) {
            self.view.addSubview(newImageView)
            self.view.layoutIfNeeded()
        }
        
    }
    
    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.5) {
            sender.view?.removeFromSuperview()
            self.view.layoutIfNeeded()
        }
    }
}






extension ChatViewController{
    
    func getParticiepent(){
        
        FirebaseNotificationServices.getGroupParticipent(groupId: channel.id ) { (participent) in
            
            self.groupParticipent = participent
            
        }
    }
    
}





extension ChatViewController{
    
    func addGroupParticipentListener (){
        
        self.groupParticipentListener = Firestore.firestore().collection(group_participent).whereField("group", isEqualTo: self.channel.id).addSnapshotListener({[weak self] (querySnapshot, error) in
            guard let snapshot = querySnapshot else {
                print("Error listening for channel participation updates: \(error?.localizedDescription ?? "No error")")
                return
            }
            
            snapshot.documentChanges.forEach { change in
                
                
                let data = change.document.data()
                
                if let userID = data["user"] as? String{
                    
                    let changedParticipent = GroupParticipent(representation: data)
                    
                    
                    
                    if let userFilter = self?.groupParticipent.firstIndex(where: {$0.user == userID}) {
                        
                        // if let index = userFilter as Int{
                        self?.groupParticipent[userFilter] = changedParticipent
                        //     }
                        
                    }
                    
                }
                
            }
        })
    }
    
    
    
    func addGroupParticipentUserListener (){
        
     
        self.groupParticipentUserListener = Firestore.firestore().collection(users).addSnapshotListener({[weak self] (querySnapshot, error) in
            guard let snapshot = querySnapshot else {
                print("Error listening for channel participation updates: \(error?.localizedDescription ?? "No error")")
                return
            }
            
            snapshot.documentChanges.forEach { change in
                
                
                let data = change.document.data()
                
                if let userID = data["userID"] as? String{
                    
                    let changedUser = UserFirebase(representation: data)
                    
              
                    if let userFilter = self?.channel.participants.firstIndex(where: {$0.uid == userID}) {
                        
                        self?.channel.participants[userFilter] = changedUser
                        
                        
                    }
                    
                }
                
            }
        })
    }

}


extension ChatViewController{
 
    
    func fetchOldMessages(){
        
        
        if let lastDocument = self.lastDocument{
            
            
            let refNew = reference?.order(by: "created", descending: false).limit(toLast: messageLimit).end(beforeDocument: lastDocument)

            let data = lastDocument.data()
            
            var iSend = false
            
            guard let senderIDData = data?["senderDatabaseID"] as? String else  {
                return
            }
            
            if senderIDData == String(user.ID!) {
                iSend = true
            }
            
            
            var recipeint : User?
            var sender:User?
            
            if iSend {
                sender = user
                recipeint = User()
                guard  let reci = self.recipients.first else {
                    return
                }
                recipeint?.ID = reci.ID
                recipeint?.email = reci.email
//                recipeint?.token = reci.device_token
//                recipeint?.user_nicename = reci.user_nicename
//                recipeint?.user_display_name = reci.display_name
//                recipeint?.nationality = reci.nationality
//                recipeint?.language = reci.language
                recipeint?.fullname = reci.fullname
//                recipeint?.last_name = reci.last_name
                recipeint?.phone = reci.phone
                recipeint?.avatar = reci.avatar
//                recipeint?.country = reci.country
            }else{
                recipeint = user
                sender = User()
                guard  let reci = self.recipients.first else {
                    return
                }
                sender?.ID = reci.ID
                sender?.email = reci.email
//                sender?.token = reci.device_token
//                sender?.user_nicename = reci.user_nicename
//                sender?.user_display_name = reci.display_name
//                sender?.nationality = reci.nationality
//                sender?.language = reci.language
                sender?.fullname = reci.fullname
//                sender?.last_name = reci.last_name
                sender?.phone = reci.phone
                sender?.avatar = reci.avatar
//                sender?.country = reci.country
            }
            
            
            
            
            let message = ChatMessage(document: lastDocument as! QueryDocumentSnapshot,sender: sender!, reciepient: recipeint!)
            
            print(message?.content)
            
            refNew?.getDocuments(completion: { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                    print("Error listening for channel updates: \(error?.localizedDescription ?? "No error")")
                    return
                }
                
                
                if snapshot.documents.count == 0{
                    self.messagesLoading.stopAnimating()
                }
                
                print(snapshot.documents.count,"count in Load previous")
                
                if let lastDocum = snapshot.documents.first{
                    self.lastDocument = lastDocum
                }
                
                
              //  self.lastDocument = snapshot.documentChanges.last?.document
                
                
                
                for (index,document ) in snapshot.documents.enumerated(){
                    
                    
                    if index == (snapshot.documents.count - 1){
                        self.fetchOldCalled = false
                        self.messagesLoading.stopAnimating()
                    }
                    
                    
                    self.handleNewDocument(document, index: index)
                    
                }
            })
        }
    }
    
    
    
    private func handleNewDocument(_ document: QueryDocumentSnapshot,index:Int) {
        
        let data = document.data()
        
        
        
        var iSend = false
        
        guard let senderIDData = data["senderDatabaseID"] as? String else  {
            return
        }
        
        if senderIDData == String(user.ID!) {
            iSend = true
        }
        
        
        var recipeint : User?
        var sender:User?
        
        if iSend {
            sender = user
            recipeint = User()
            guard  let reci = self.recipients.first else {
                return
            }
            recipeint?.ID = reci.ID
            recipeint?.email = reci.email
//            recipeint?.token = reci.device_token
//            recipeint?.user_nicename = reci.user_nicename
//            recipeint?.user_display_name = reci.display_name
//            recipeint?.nationality = reci.nationality
//            recipeint?.language = reci.language
            recipeint?.fullname = reci.fullname
//            recipeint?.last_name = reci.last_name
            recipeint?.phone = reci.phone
            recipeint?.avatar = reci.avatar
//            recipeint?.country = reci.country
        }else{
            recipeint = user
            sender = User()
            guard  let reci = self.recipients.first else {
                return
            }
            sender?.ID = reci.ID
            sender?.email = reci.email
//            sender?.token = reci.device_token
//            sender?.user_nicename = reci.user_nicename
//            sender?.user_display_name = reci.display_name
//            sender?.nationality = reci.nationality
//            sender?.language = reci.language
            sender?.fullname = reci.fullname
//            sender?.last_name = reci.last_name
            sender?.phone = reci.phone
            sender?.avatar = reci.avatar
//            sender?.country = reci.country
        }
        
        guard let message = ChatMessage(document: document,sender: sender!, reciepient: recipeint!) else {
            return
        }
        print("new id",message.id)
       
        print("new id",message.id)
        
        if message.downloadURL != nil {
            
            message.image = UIImage(named: "thumbnail-placeholder")
            self.insertNewLoadedMessage(message, index: index)
            
        } else {
            insertNewLoadedMessage(message, index: index)
        }
        
        
    }
    
    
    
    
    private func insertNewLoadedMessage(_ message: ChatMessage,index:Int) {
        guard !messages.contains(message) else {
            return
        }
        
        
        messages.append(message)
        messages.sort()
        
        
        let oldOffset = self.messagesCollectionView.contentSize.height - self.messagesCollectionView.contentOffset.y
        messagesCollectionView.reloadData()
        messagesCollectionView.layoutIfNeeded()
        messagesCollectionView.contentOffset = CGPoint(x: 0, y: messagesCollectionView.contentSize.height - oldOffset)
        self.messagesLoading.stopAnimating()
    }
    
    
    
    
    
 
}


extension Date {
    func isInSameDayOf(date: Date) -> Bool {
        return Calendar.current.isDate(self, inSameDayAs:date)
    }
}

//extension UITextView
//{
//    open override func awakeFromNib() {
//        self.autocapitalizationType = UITextAutocapitalizationType.none;
//        self.autocorrectionType = UITextAutocorrectionType.no;
//
//        let toolbar = UIToolbar.init()
//        toolbar.sizeToFit()
//        let barFlexible = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
//
//        let barBtnDone = UIBarButtonItem.init(image: nil, style: UIBarButtonItem.Style.plain, target: self, action: #selector(btnBarDoneAction))
//        barBtnDone.title = "Done"
//        barBtnDone.tintColor = UIColor().HexToColor(hexString: "#FF9500")
//        toolbar.tintColor = UIColor().HexToColor(hexString: "#1D1D1D")
//        //        barBtnDone.tintColor = UIColor.black
//        //        toolbar.barTintColor = UIColor.lightGray
//        toolbar.tintColor = UIColor.black
//        toolbar.items = [barFlexible,barBtnDone]
//        toolbar.alpha = 0.8
//        self.inputAccessoryView = toolbar
//    }
//
//    func viewClick() { self.becomeFirstResponder(); }
//    @objc func btnBarDoneAction() { self.resignFirstResponder() }
//
//    //
//    //    func rotate(degrees: CGFloat) {
//    //        rotate(radians: CGFloat.pi * degrees / 180.0)
//    //    }
//    //
//    //    func rotate(radians: CGFloat) {
//    //        self.transform = CGAffineTransform(rotationAngle: radians)
//    //    }
//    //
//}
//
////extension UITextField{
////    open override func awakeFromNib() {
////        super.awakeFromNib()
////        self.autocapitalizationType = UITextAutocapitalizationType.none;
////        self.autocorrectionType = UITextAutocorrectionType.no;
////        let toolbar = UIToolbar.init()
////        toolbar.sizeToFit()
////        let barFlexible = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
////
////        let barBtnDone = UIBarButtonItem.init(image: nil, style: UIBarButtonItem.Style.plain, target: self, action: #selector(btnBarDoneAction))
////        barBtnDone.title = "Done"
////        barBtnDone.tintColor = UIColor().HexToColor(hexString: "#FF9500")
////        toolbar.tintColor = UIColor().HexToColor(hexString: "#1D1D1D")
////        //        barBtnDone.tintColor = UIColor.black
////        //        toolbar.barTintColor = UIColor.darkGray
////        toolbar.tintColor = UIColor.black
////        toolbar.items = [barFlexible,barBtnDone]
////        toolbar.alpha = 0.8
////        self.inputAccessoryView = toolbar
////    }
////
////    func viewClick() { self.becomeFirstResponder(); }
////
////    @objc func btnBarDoneAction() { self.resignFirstResponder() }
////
////}
//extension UIColor{
//    func HexToColor(hexString: String, alpha:CGFloat? = 1.0) -> UIColor {
//        // Convert hex string to an integer
//        let hexint = Int(self.intFromHexString(hexStr: hexString))
//        let red = CGFloat((hexint & 0xff0000) >> 16) / 255.0
//        let green = CGFloat((hexint & 0xff00) >> 8) / 255.0
//        let blue = CGFloat((hexint & 0xff) >> 0) / 255.0
//        let alpha = alpha!
//        // Create color object, specifying alpha as well
//        let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
//        return color
//    }
//
//    func intFromHexString(hexStr: String) -> UInt32 {
//        var hexInt: UInt32 = 0
//        let scanner: Scanner = Scanner(string: hexStr)
//        scanner.charactersToBeSkipped = NSCharacterSet(charactersIn: "#") as CharacterSet
//        scanner.scanHexInt32(&hexInt)
//        return hexInt
//    }
//}
