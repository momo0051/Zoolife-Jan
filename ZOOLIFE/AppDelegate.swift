//
//  AppDelegate.swift
//  ZOOLIFE
//
//  Created by Hafiz Anser  on 11/20/20.
//  Copyright © 2020 Hafiz Anser. All rights reserved.
//
//0550655213
//1234

import UIKit
import CoreData
import IQKeyboardManagerSwift
import Firebase
import Alamofire
import FirebaseMessaging
import SwiftyJSON
import Localize_Swift
import GoogleMobileAds
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{
//app.ios.family.of
    //com.zoolife.app
    var window: UIWindow?
    var tabsViewController = UITabBarController()
    var menuButton = UIButton()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool{
        
        let frame = UIScreen.main.bounds
        window = UIWindow(frame: frame)
        IQKeyboardManager.shared.enable = true
        
        //loadTest()
        loadTabbar()
        FirebaseApp.configure()
        registerForRemoteNotification()
        setDefaultLang()
//        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self
      //  Messaging.messaging().esta  .shouldEstablishDirectChannel = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadTabbar(_:)), name: NSNotification.Name(rawValue: "reloadTabbar"), object: nil)
       // Thread.sleep(forTimeInterval: 7)
        
//        UIApplication.shared.applicationIconBadgeNumber = 1
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        return true
    }
    @objc func reloadTabbar(_ notification: NSNotification) {
        loadTabbar()
    }
    func setDefaultLang(){
        if let lang = UserDefaults.standard.object(forKey: "appLang") as? String {
            if lang == "" {
                Localize.setCurrentLanguage("ar")
                UserDefaults.standard.setValue("ar", forKey: "appLang")
                UserDefaults.standard.synchronize()
                appLanguage = "ar"
            }
        }
    }
    func registerForRemoteNotification()
    {
        let center = UNUserNotificationCenter.current()
        center.delegate = self

        center.requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            // Enable or disable features based on authorization.
            if granted {
                self.getNotificationSettings()
            }
        }
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                 UIApplication.shared.registerForRemoteNotifications()
            }
           
        }
    }
    
    func loadTest(){
        
        let viewControlller = MobileVerificationViewController(nibName: "MobileVerificationViewController", bundle: nil)
        let navigationController = UINavigationController.init(rootViewController: viewControlller)
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
    }
    
    func loadLogin(){
        
        let viewControlller = LoginViewController(nibName: "LoginViewController", bundle: nil)
        let navigationController = UINavigationController.init(rootViewController: viewControlller)
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
    }
 
    func UpdateLang_UI(){
        if let lang = UserDefaults.standard.object(forKey: "appLang") as? String {
            if lang == "en" {
                
                UIView.appearance().semanticContentAttribute = .forceLeftToRight

                UILabel.appearance().semanticContentAttribute = .forceLeftToRight
                UITextView.appearance().semanticContentAttribute = .forceLeftToRight
            } else {
                UIView.appearance().semanticContentAttribute = .forceRightToLeft

                UILabel.appearance().semanticContentAttribute = .forceRightToLeft
                UITextView.appearance().semanticContentAttribute = .forceRightToLeft
            }
        } else {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft

            UILabel.appearance().semanticContentAttribute = .forceRightToLeft
            UITextView.appearance().semanticContentAttribute = .forceRightToLeft
        }
        
    }
    static var homeVC : HomeViewController?
    func loadTabbar(){
        tabsViewController = CustomTabBarController()
        
        
        
        let homeVC = HomeViewController(nibName:String(describing: HomeViewController.self), bundle:nil)
        let searchVC = CategoriesViewController(nibName:String(describing: CategoriesViewController.self), bundle:nil)
        let notificationVC = NotificatioViewController(nibName:"NotificatioViewController", bundle:nil)
        let messageVC = MessageViewController(nibName:"MessageViewController", bundle:nil)
        let auctionVC = AuctionListViewController(nibName:"AuctionListViewController", bundle:nil)
        
        AppDelegate.homeVC = homeVC
        let homeNavigationController = UINavigationController.init(rootViewController: homeVC)
        let searchNavigationController = UINavigationController.init(rootViewController: searchVC)
        let notificationNavController = UINavigationController.init(rootViewController: notificationVC)
        let messageNavController = UINavigationController.init(rootViewController: messageVC)
        let settingsNavController = UINavigationController.init(rootViewController: auctionVC)
        var TabHome = "الرئيسية"
        var TabSearch = "بحث"
        var TabNotification = "اشعارات"
        var TabChat = "الرسائل"
        var TabSetting = "المزاد"

        
        if let lang = UserDefaults.standard.object(forKey: "appLang") as? String {
            if lang == "en" {
                TabHome = "Home"
                TabSearch = "Search"
                TabNotification = "Notification"
                TabChat = "Message"
                TabSetting = "Auction"
                
                appLanguage = "en"
            } else {
                TabHome = "الرئيسية"
                TabSearch = "بحث"
                TabNotification = "اشعارات"
                TabChat = "الرسائل"
                TabSetting = "المزاد"
                
                appLanguage = "ar"
            }
        } else {
            TabHome = "الرئيسية"
            TabSearch = "بحث"
            TabNotification = "اشعارات"
            TabChat = "الرسائل"
            TabSetting = "المزاد"
            appLanguage = "ar"
            Localize.setCurrentLanguage("ar")
            UserDefaults.standard.setValue("ar", forKey: "appLang")
            UserDefaults.standard.synchronize()
        }
        homeNavigationController.tabBarItem = UITabBarItem.init(title: TabHome, image: UIImage(named: "ic_home"), selectedImage: UIImage(named: "ic_home_selected"))
        
        searchNavigationController.tabBarItem = UITabBarItem.init(title: TabSearch, image: UIImage(named: "ic_explor_selected"), selectedImage: UIImage(named: "ic_explore"))
        
        notificationNavController.tabBarItem = UITabBarItem.init(title: TabNotification, image: UIImage(named: "ic_notifications"), selectedImage: UIImage(named: "ic_notification_selected"))
        
        messageNavController.tabBarItem = UITabBarItem.init(title: TabChat, image: UIImage(named: "ic_message_selected"), selectedImage: UIImage(named: "ic_message"))

        settingsNavController.tabBarItem = UITabBarItem.init(title: TabSetting, image: UIImage(named: "icn_Auction_TabBar"), selectedImage: UIImage(named: "icn_Auction_TabBar"))
        
        getCurrentProfile(viewController: homeVC)
        
        let array: NSArray? = NSArray(objects:homeNavigationController, searchNavigationController, notificationNavController, messageNavController, settingsNavController)
        
        self.tabsViewController.viewControllers = array as! [UIViewController]?
        homeNavigationController.navigationBar.isHidden = true
        searchNavigationController.navigationBar.isHidden = true
        notificationNavController.navigationBar.isHidden = true
        messageNavController.navigationBar.isHidden = true
        settingsNavController.navigationBar.isHidden = true

        
//        UITabBar.appearance().backgroundImage = UIImage(named: "")
        self.tabsViewController.selectedIndex = 0
//        self.tabsViewController.tabBar.backgroundColor = .darkGray
        self.tabsViewController.delegate = self as? UITabBarControllerDelegate
        UITabBar.appearance().isTranslucent = true
        UITabBar.appearance().tintColor = UIColor(red: 29/255, green: 67/255, blue: 84/255, alpha: 1.0)
        //UITabBar.appearance().tintColor = UIColor(red: 253/255, green: 237/255, blue: 80/255, alpha: 1.0)
        //UITabBar.appearance().barTintColor = UIColor.white
        //UITabBar.appearance().barTintColor = UIColor(red: 120/255, green: 188/255, blue: 185/255, alpha: 1.0)
        UITabBar.appearance().barTintColor = UIColor(red: 227/255, green: 227/255, blue: 227/255, alpha: 1.0)
        UITabBar.appearance().unselectedItemTintColor = UIColor(red: 159/255, green: 159/255, blue: 159/255, alpha: 1.0)
        
        UpdateLang_UI()
        // remove default border
        UITabBar.appearance().frame.size.width = UIScreen.main.bounds.size.width + 4
        UITabBar.appearance().frame.origin.x = -2
        
        tabsViewController.tabBar.cornerRadius = tabsViewController.tabBar.frame.size.height / 2
        self.window!.rootViewController = self.tabsViewController
        self.window!.makeKeyAndVisible()
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
        print("application inactive ho gai hy active se")
        
        
        
    }

    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
        print("Aplication is entering background")
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
        print("Aplication is entering foreground")
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "ZOOLIFE")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
//                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}


extension AppDelegate:MessagingDelegate,UNUserNotificationCenterDelegate{
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
      
        if let token = Messaging.messaging().fcmToken{
            print("New FCM Token",token)
            UserDefaults.standard.setValue(token, forKey: "DEVICE_TOKEN")
            if let u = AppUtility.getSession() {
               
                let requestURL = URL(string: UPDATE_USER_DEVICE_TOKEN)!
                print(requestURL)
                
                let headers = ["Content-Type": "application/json","X-Localization":"\(appLanguage)"]
                
                let  paramDict = ["device_token" : token,
                                  "device_type" : "iOS",
                                  "user_id":u.ID!] as [String : Any]

                
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
                             //   print(response)
                                
                            }
                        case .failure(_): break
                        }
                })
 
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("application active notification")

        if (self.window?.rootViewController?.TopViewController is ChatViewController) || (self.window?.rootViewController?.TopViewController is MessageViewController) {
            completionHandler([])
        } else {
            completionHandler(.alert)
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("did tap on notification")
        
        let userInfo = response.notification.request.content.userInfo
        let info : NSDictionary! = userInfo as NSDictionary
        
        print("info le lo", info as Any)
        
        if info != nil
        {
            if let data = info["data"] as? NSDictionary
            {

                print("data is in dictionary Format ", data)


            }
            else if let dataString = info["data"] as? String
            {
                print("data to string hy", dataString)

                if let data = AppUtility.convertToDictionary(text: dataString)
                {
                    print("data le lo ", data)

                    if let id = data["identifier"] as? String, let email = data["user_email"] as? String,let groupId = data["group_id"] as? String
                    {

                            if (UIApplication.shared.applicationState == .inactive) 
                            {
                                print("application inactive and background hy")

                                moveToScreen(id: id,userEmail: email,groupId: groupId)

                            }
                            else
                            {
                                print("application Active hy")

                                moveToScreenFromActive(id: id,userEmail: email,groupId: groupId)
                            }
                    }
                }
            }
        }
    }
    
}

extension AppDelegate{
    
    func moveToScreen(id: String,userEmail: String,groupId: String){
        if id == "NC"{
            
            UserDefaults.standard.setValue(true, forKey: FROM_NOTIFICATION)
            
            notificationEmail = userEmail
            notificationGroupId = groupId
            
            print("New Chat")
            
            
            //To fix bug where viewDidAppear wasn't being called in MessageViewController if selected index was 3 when app resigned active
            (window?.rootViewController as? UITabBarController)?.selectedIndex = 4
            
            
            // Assigning MessageViewController as selected when app opens on nitification tap
            (window?.rootViewController as? UITabBarController)?.selectedIndex = 3
            
        }
    }
    
    func moveToScreenFromActive(id: String,userEmail: String,groupId: String)
    {
        UserDefaults.standard.setValue(true, forKey: FROM_NOTIFICATION)
        
        notificationEmail = userEmail
        notificationGroupId = groupId
        
        (window?.rootViewController as? UITabBarController)?.selectedIndex = 3
    }
    
}
//{
//
//    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
//
//    }
//    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
//
//        if let token = Messaging.messaging().fcmToken{
//            print("New FCM Token",token)
//            if UserStateHolder.isUserLoggedIn
//            {
//                apiServiceModal.updataDeviceTokenApi(token: token) {
//                    success in
//                    if success
//                    {
//                        print("device token updated succesfully")
//                    }
//                    else
//                    {
//                        print("failed in updating device token")
//                    }
//                }
//            }
//        }
//    }
//
//
//
//
//
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        let userInfo = notification.request.content.userInfo
//        Messaging.messaging().appDidReceiveMessage(userInfo)
//        self.notification.notificationOccurred(.success)
//        completionHandler(.alert)
//        if (self.window?.rootViewController?.TopViewController is ChatViewController)  {
//            completionHandler([])
//        } else {
//            completionHandler(.alert)
//        }
//    }
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//        print("I got notifications")
//        let userInfo = response.notification.request.content.userInfo
//        let info : NSDictionary! = userInfo as NSDictionary
//
//        print("info le lo", info as Any)
//
//
//        if info != nil
//        {
//            if let data = info["data"] as? NSDictionary
//            {
//
//                print("data le lo ", data)
//
//                if let id = data["identifier"] as? String
//                {
//                    print("id le lo", id)
//                    if id == "NR"
//                    {
//                        print("New Request Ai hy")
//                    }
//                }
//            }
//            else if let dataString = info["data"] as? String
//            {
//                print("data to string hy", dataString)
//
//                if let data = convertToDictionary(text: dataString)
//                {
//                    print("data le lo ", data)
//
//                    if let id = data["identifier"] as? String
//                    {
//                        if id == "AP"
//                        {
//                            if UIApplication.shared.applicationState == .inactive
//                            {
//                                print("application inactive hy")
//
//                                moveToScreen(id: id,userId: Int())
//
//                            }
//                            else
//                            {
//                                print("application Active hy")
//
//                                moveToScreenFromActive(id: id, userId: Int())
//                            }
//                        }
//                    }
//
//                    if let id = data["identifier"] as? String,let userId = data["user_id"] as? Int
//                    {
//                        print("id le lo", id)
//                        if id == "NR"
//                        {
//                            print("New Request Ai hy")
//                        }
//
//                        if UIApplication.shared.applicationState == .inactive
//                        {
//                            print("application inactive hy")
//
//                            moveToScreen(id: id,userId: userId)
//
//                        }
//                        else
//                        {
//                            print("application Active hy")
//
//                            moveToScreenFromActive(id: id, userId: userId)
//                        }
//                    }
//                }
//            }
//        }
//
//
//        Messaging.messaging().appDidReceiveMessage(userInfo)
//
//        completionHandler()
//    }
//
//    func moveToScreen(id: String,userId: Int){
//        objUser.token = Utilities.sharedInstance.getAutoToken() as? String ?? ""
//        objUser.user_id = Utilities.sharedInstance.getUserId() as? Int ?? 0
//
//        if id == "NR"
//        {
//             print("Request New")
//
//            let homeController = mainStroyBoard.instantiateViewController(withIdentifier: "SelectTypeVC") as! UINavigationController
//
//            self.window?.rootViewController = homeController
//
//            let requestsController = mainStroyBoard.instantiateViewController(withIdentifier: "FriendRequestVC") as! FriendRequestVC
////            profileController.fromNotification = true
////            profileController.userId = userId
//
//            homeController.pushViewController(requestsController, animated: true)
//
//        }
//        else if id == "RA"
//        {
//            print("Request Accepted")
//
//            let homeController = mainStroyBoard.instantiateViewController(withIdentifier: "SelectTypeVC") as! UINavigationController
//
//            self.window?.rootViewController = homeController
//
//            let friendListController = mainStroyBoard.instantiateViewController(withIdentifier: "FriendListVC") as! FriendListVC
//
////            profileController.fromNotification = true
////            profileController.userId = userId
//
//
//            homeController.pushViewController(friendListController, animated: true)
//
//
//        }
//        else if id == "NC"
//        {
//            print("New Chat")
//
//            let uiConfig = ChatUIConfiguration(primaryColor: UIColor.colorWithHex(hexString: "#5574F7"),
//                                               secondaryColor: UIColor.colorWithHex(hexString: "#5574F7"),
//                                               inputTextViewBgColor: message_textfield_background_color,
//                                               inputTextViewTextColor: message_textfield_text_color,
//                                               inputPlaceholderTextColor: message_textfield_placeholder_color)
//
//            apiServiceModal.getChatUserProfileApi(id: userId, currentController: nil) { (request) in
//
//                let friend = request.user
//                FirebaseNotificationServices.fetchUserChannel(user: objUser, friend: friend) { (channel) in
//
//                                if let channel = channel{
//
//                                    let homeController = mainStroyBoard.instantiateViewController(withIdentifier: "SelectTypeVC") as! UINavigationController
//
//                                    self.window?.rootViewController = homeController
//
//                                    let cv = mainStroyBoard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
//
//
//                                    cv.channel = channel
//                                    cv.user = objUser
//                                    cv.request = request
//                                    cv.recipients = [friend]
//                                    cv.uiConfig = uiConfig
//                                    DispatchQueue.main.async {
//                                        ActivityLoadViewClass.hideOverlayView()
//                                    }
//                                    homeController.pushViewController(cv, animated: true)
//                                }else{
//                                    //
//                                    print("not  founbds")
//                                    DispatchQueue.main.async {
//                                        ActivityLoadViewClass.hideOverlayView()
//                                    }
//                                }
//
//                            }
//            }
//
//
//        }
//        else if id == "RR"
//        {
//            print("Request Rejected")
//        }
//        else if id == "AP"
//        {
//            print("New Admin Notification")
//
//            let homeController = mainStroyBoard.instantiateViewController(withIdentifier: "SelectTypeVC") as! UINavigationController
//
//            self.window?.rootViewController = homeController
//
//            let notificationController = mainStroyBoard.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
//
//
//            homeController.pushViewController(notificationController, animated: true)
//
//
//        }
//    }
//
//    func moveToScreenFromActive(id: String,userId: Int){
//        objUser.token = Utilities.sharedInstance.getAutoToken() as? String ?? ""
//        objUser.user_id = Utilities.sharedInstance.getUserId() as? Int ?? 0
//
//        if id == "NR"
//        {
//            print("Request New")
//
//            if self.window?.rootViewController?.TopViewController is FriendRequestVC
//            {
//                NotificationCenter.default.post(name: .init("NewRequest"), object: nil)
//            }
//            else
//            {
//
//                let requestsController = mainStroyBoard.instantiateViewController(withIdentifier: "FriendRequestVC") as! FriendRequestVC
//
//                let topViewController = self.window?.rootViewController?.TopViewController
//
//                topViewController?.navigationController?.pushViewController(requestsController, animated: true)
//            }
//
//        }
//        else if id == "RA"
//        {
//            print("Request Accepted")
//
//
//            if self.window?.rootViewController?.TopViewController is FriendListVC
//            {
//                NotificationCenter.default.post(name: .init("RequestAccepted"), object: nil)
//            }
//            else
//            {
//                let friendListController = mainStroyBoard.instantiateViewController(withIdentifier: "FriendListVC") as! FriendListVC
//
//                let topViewController = self.window?.rootViewController?.TopViewController
//
//                topViewController?.navigationController?.pushViewController(friendListController, animated: true)
//            }
//
//        }
//        else if id == "NC"
//        {
//            print("New Chat")
//
//            let uiConfig = ChatUIConfiguration(primaryColor: UIColor.colorWithHex(hexString: "#5574F7"),
//                                               secondaryColor: UIColor.colorWithHex(hexString: "#5574F7"),
//                                               inputTextViewBgColor: message_textfield_background_color,
//                                               inputTextViewTextColor: message_textfield_text_color,
//                                               inputPlaceholderTextColor: message_textfield_placeholder_color)
//
//            apiServiceModal.getChatUserProfileApi(id: userId, currentController: nil) { (request) in
//
//                let friend = request.user
//                FirebaseNotificationServices.fetchUserChannel(user: objUser, friend: friend) { (channel) in
//
//                    if let channel = channel{
//
//
//                        let cv = mainStroyBoard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
//
//
//                        cv.channel = channel
//                        cv.user = objUser
//                        cv.request = request
//                        cv.recipients = [friend]
//                        cv.uiConfig = uiConfig
//                        DispatchQueue.main.async {
//                            ActivityLoadViewClass.hideOverlayView()
//                        }
//
//                        let topViewController = self.window?.rootViewController?.TopViewController
//
//                        topViewController?.navigationController?.pushViewController(cv, animated: true)
//                    }else{
//                        //
//                        print("not  founbds")
//                        DispatchQueue.main.async {
//                            ActivityLoadViewClass.hideOverlayView()
//                        }
//
//                        //                                    FirebaseNotificationServices.checkUserCreate(sender: friend, recipient: objUser)
//
//                    }
//
//                }
//            }
//
//
//        }
//        else if id == "RR"
//        {
//            print("Request Rejected")
//        }
//        else if id == "AP"
//        {
//            print("Request New")
//
//            if self.window?.rootViewController?.TopViewController is NotificationVC
//            {
//                NotificationCenter.default.post(name: .init("NewAdminNotification"), object: nil)
//            }
//            else
//            {
//
//                let requestsController = mainStroyBoard.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
//
//                let topViewController = self.window?.rootViewController?.TopViewController
//
//                topViewController?.navigationController?.pushViewController(requestsController, animated: true)
//            }
//
//        }
//    }
//
//}
