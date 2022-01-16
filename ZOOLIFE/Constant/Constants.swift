//
//  Constants.swift
//  Transition


import UIKit
import Foundation
import AVFoundation
import CoreData

/**********************  Singleton  ***********************f*/

var notificationEmail = ""
var notificationGroupId = ""
var appLanguage = "ar"

/**********************  Size Constants  ************************/

let DEVICE_VERSION = UIDevice .current.systemVersion
let SCREEN_WIDTH:Float = Float(UIScreen.main.bounds.width)
let SCREEN_HEIGHT:Float = Float(UIScreen.main.bounds.height)
let appDelegate = UIApplication.shared.delegate as! AppDelegate

let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && SCREEN_HEIGHT < 568.0
let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && SCREEN_HEIGHT == 568.0
let IS_IPHONE_6_7          = UIDevice.current.userInterfaceIdiom == .phone && SCREEN_HEIGHT == 667.0
let IS_IPHONE_6P_7P_8P         = UIDevice.current.userInterfaceIdiom == .phone && SCREEN_HEIGHT == 736.0
let IS_IPHONE_X            = UIDevice.current.userInterfaceIdiom == .phone && SCREEN_HEIGHT == 812.0
let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && SCREEN_HEIGHT == 1024.0
let IS_IPAD_PRO          = UIDevice.current.userInterfaceIdiom == .pad && SCREEN_HEIGHT == 1366.0
let IS_IPAD_AIR          = UIDevice.current.userInterfaceIdiom == .pad && SCREEN_HEIGHT == 768.0

let IS_SANDBOX = false

/*-------------------------------------------------------------------------------*/
let AUTHKEY  = ""

/**********************  Constant  ************************/
let SUCESS_CODE:String = "1"
let DEFAULT_ERROR = "Something went wrong."
let NETWORK_ERROR = "Network connection lost."
let TIMEOUT_ERROR = "Request timed out."
let INVALID_RESPONSE_ERROR = "Response format is invalid."

//*------------------------------------------------------------------------------*/

/**********************  URLS  ************************/

//let SERVER_BASE_URL_API = "http://zoolife.manage.zoolifeshop.com/api/"

//let SERVER_BASE_URL = "http://api.zoolifeshop.com/api/public/"
//let Image_PROFILE_BASE_URL = "https://low-tels.com/survey/public/uploads/"
//let IMAGE_BASE_URL = "https://api.zoolifeshop.com/api/assets/images/items/"
//let CONGRESS_BASE_URL = "https://api.propublica.org/congress/v1/"
//let COMPAIGN_BASE_URL = "https://api.propublica.org/campaign-finance/v1/"

//let ITEMIMAGEURL = "http://newzoolifeapi.zoolifeshop.com/uploads/ad/"


let REAL_BASE_URL = "http://newzoolifeapi.zoolifeshop.com/public/api/"

//*------------------------------------------------------------------------------*/

/**********************  UserDefaults  ************************/

let DISCLAIMER = "disclaimer"
let USER_LOGIN = "userLogin"
let FROM_NOTIFICATION = "fromNotification"

/**********************  APIS  ************************/


let RESEND_OTP = REAL_BASE_URL + "resend_otp"
let LOGIN_URL = REAL_BASE_URL + "loginapi"
let SIGNUP_URL = REAL_BASE_URL + "registerapi"
let PINVRIFICATION = REAL_BASE_URL + "verify_otp"
let RESET_PASSWORD = REAL_BASE_URL + "reset_password"
let CHANGE_PASSWORD = REAL_BASE_URL + "update_password"
let ADD_COMMENT = REAL_BASE_URL + "add_comments"
let GET_COMMENTS = REAL_BASE_URL + "list_comments_by_item"
let FAVOURITE_ITEM_BY_USER = REAL_BASE_URL + "fav_item_by_user"
let ADD_FAVOURITE_ITEM = REAL_BASE_URL + "favoruit_item"
let DELETE_FAVOURITE_ITEM = REAL_BASE_URL + "delete_favorites"
let GET_ALL_CATEGORIES = REAL_BASE_URL + "category"
let GET_ALL_CITY = REAL_BASE_URL + "cities"
let GET_SUB_CATEGORIES = REAL_BASE_URL + "get_sub_category"
let GET_ALL_ITEMS_BY_CATEGORY = REAL_BASE_URL + "get_all_item_by_category"
let GET_ALL_ITEMS_BY_SUB_CATEGORY = REAL_BASE_URL + "get_items_by_subcategory"
let GET_ITEMS_BY_CITY = REAL_BASE_URL + "get_items_by_city"
let ITEM_SEARCH = REAL_BASE_URL + "item_search"
let GET_ALL_ITEMS = REAL_BASE_URL + "itemsapi"
let GET_POST_BY_USER = REAL_BASE_URL + "get_post_by_user"
let GET_ALL_ARTICLES = REAL_BASE_URL + "articles"
let DELETE_ITEM = REAL_BASE_URL + "delete_item"
let DELETE_ITEM_IMAGE = REAL_BASE_URL + "delete_item_images"
let GET_ITEM = REAL_BASE_URL + "get_item"
let UPDATE_USER_DEVICE_TOKEN = REAL_BASE_URL + "update_user_device_token"
let GET_ALL_NOTIFICATIONS_BY_USERID = REAL_BASE_URL + "get_all_notify"
let ADD_MSGS = REAL_BASE_URL + "add_msgs"
let READ_MSGS = REAL_BASE_URL + "read_msg"
let GET_ALL_SLIDERS = REAL_BASE_URL + "sliders"
let GET_USER_PROFILE = REAL_BASE_URL + "get_user_profile"
let GET_ALL_DELIVERIES = REAL_BASE_URL + "deliveries"
let ADD_DELIVERY = REAL_BASE_URL + "add_delivery"
let DELETE_DELIVERY = REAL_BASE_URL + "delete_deliver"
let ABUSE_ITEM = REAL_BASE_URL + "abuse_item"
let LIKE_ITEM = REAL_BASE_URL + "like_item"
let DISLIKE_ITEM = REAL_BASE_URL + "delete_like_item"
let ADD_POST = REAL_BASE_URL + "add_post"
let UPDATE_POST = REAL_BASE_URL + "update_post"
let GET_ALL_AUCTION_ITEMS = REAL_BASE_URL + "auction_items"
let GET_POST_BIDS = REAL_BASE_URL + "bids"
let ADD_BID = REAL_BASE_URL + "add_bid"

//let UPLOADAD = "item"
//let AD = "home"
//let DATA_TYPE_CONGRESS_BILLS = "bills/"
//let APPARTMENT_LOGIN_URL          = "complex-login"
//let ORDER_URL                     = "order"
//let GENERATE_CLIENT_TOKEN_URL     = "generate-client-token"
//let PAYMENT_DETECTION_URL         = "charge"
//let STRIPE_URL                    = "stripe-payment"
//let ADDMSG = "add_msgs"
//let READMSG = "read_msg"
//let GET_PRofile_URL = "profile"
//let NOTIFICATION = "get_all_notify"
//let CATEGORIES_URL                = "categories"
//let FAVOURTIE = "favorites"
//let MYAD = "item"
//let CATEGORY = "category"
//let ITEMS_URL                     = "items"
//let COMMENT = "comments"
//let USER = "user"

//let REPORTAD = "reportapi"
//let SLIDER = "sliders"


let USER_DEAULTS = UserDefaults.standard

let appDateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"//"yyyy-MM-dd HH:mm:ss"

/**********************  SetColors  ************************/
let ACTIVE_COLOR = UIColor(red: 254/255, green: 220/255, blue: 0/255, alpha: 1)
let GRAY_COLOR = UIColor(red: 138.0/255.0, green: 138.0/255.0, blue: 138.0/255.0, alpha: 1.0)
let DARK_GRAY_COLOR = UIColor.darkGray

public extension UIDevice {

    static let modelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }

        func mapToDevice(identifier: String) -> String { // swiftlint:disable:this cyclomatic_complexity
            #if os(iOS)
            switch identifier {
            case "iPod5,1":                                 return "iPod touch (5th generation)"
            case "iPod7,1":                                 return "iPod touch (6th generation)"
            case "iPod9,1":                                 return "iPod touch (7th generation)"
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
            case "iPhone4,1":                               return "iPhone 4s"
            case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
            case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
            case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
            case "iPhone7,2":                               return "iPhone 6"
            case "iPhone7,1":                               return "iPhone 6 Plus"
            case "iPhone8,1":                               return "iPhone 6s"
            case "iPhone8,2":                               return "iPhone 6s Plus"
            case "iPhone8,4":                               return "iPhone SE"
            case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
            case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
            case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
            case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
            case "iPhone10,3", "iPhone10,6":                return "iPhone X"
            case "iPhone11,2":                              return "iPhone XS"
            case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
            case "iPhone11,8":                              return "iPhone XR"
            case "iPhone12,1":                              return "iPhone 11"
            case "iPhone12,3":                              return "iPhone 11 Pro"
            case "iPhone12,5":                              return "iPhone 11 Pro Max"
            case "iPhone12,8":                              return "iPhone SE (2nd generation)"
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
            case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad (3rd generation)"
            case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad (4th generation)"
            case "iPad6,11", "iPad6,12":                    return "iPad (5th generation)"
            case "iPad7,5", "iPad7,6":                      return "iPad (6th generation)"
            case "iPad7,11", "iPad7,12":                    return "iPad (7th generation)"
            case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
            case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
            case "iPad11,4", "iPad11,5":                    return "iPad Air (3rd generation)"
            case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad mini"
            case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad mini 3"
            case "iPad5,1", "iPad5,2":                      return "iPad mini 4"
            case "iPad11,1", "iPad11,2":                    return "iPad mini (5th generation)"
            case "iPad6,3", "iPad6,4":                      return "iPad Pro (9.7-inch)"
            case "iPad7,3", "iPad7,4":                      return "iPad Pro (10.5-inch)"
            case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro (11-inch) (1st generation)"
            case "iPad8,9", "iPad8,10":                     return "iPad Pro (11-inch) (2nd generation)"
            case "iPad6,7", "iPad6,8":                      return "iPad Pro (12.9-inch) (1st generation)"
            case "iPad7,1", "iPad7,2":                      return "iPad Pro (12.9-inch) (2nd generation)"
            case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "iPad Pro (12.9-inch) (3rd generation)"
            case "iPad8,11", "iPad8,12":                    return "iPad Pro (12.9-inch) (4th generation)"
            case "AppleTV5,3":                              return "Apple TV"
            case "AppleTV6,2":                              return "Apple TV 4K"
            case "AudioAccessory1,1":                       return "HomePod"
            case "i386", "x86_64":                          return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
            default:                                        return identifier
            }
            #elseif os(tvOS)
            switch identifier {
            case "AppleTV5,3": return "Apple TV 4"
            case "AppleTV6,2": return "Apple TV 4K"
            case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
            default: return identifier
            }
            #endif
        }

        return mapToDevice(identifier: identifier)
    }()

}

//Firebase CollectionsName
let groups = "groups"
let group = "group"
let users = "users"
let group_participent = "group_participation"


//Extension Date


extension Date {
    var yesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var twoDaysAgo: Date {
        return Calendar.current.date(byAdding: .day, value: -2, to: noon)!
    }
    var threeDaysAgo: Date {
        return Calendar.current.date(byAdding: .day, value: -2, to: noon)!
    }
    var fourDaysAgo: Date {
        return Calendar.current.date(byAdding: .day, value: -2, to: noon)!
    }
    var tomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var twoHoursAgo: Date {
        return Calendar.current.date(byAdding: .hour, value: -2, to: noon)!
    }
    var fiveHoursAgo: Date {
        return Calendar.current.date(byAdding: .hour, value: -5, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var oneYearAgo: Date {
        return Calendar.current.date(byAdding: .month, value: -12, to: noon)!
    }
    var isLastDayOfMonth: Bool {
        return tomorrow.month != month
    }
}


//AppColors

import Foundation
import UIKit


let app_theme_color = UIColor.colorWithHex(hexString: "#3a86c2") //Light Purple
let app_theme_color_dark = UIColor.colorWithHex(hexString: "#3a86c2") // Dark Purple

let group_title_color = UIColor.colorWithHex(hexString: "#000000")
let group_lastmessage_color = UIColor.colorWithHex(hexString: "#000000")
let group_onsite_color = UIColor.colorWithHex(hexString: "#000000")
let group_time_color = UIColor.colorWithHex(hexString: "#000000")

let sent_message_bubble_color = UIColor.colorWithHex(hexString: "#4D9CDF")
let sent_message_text_color = UIColor.colorWithHex(hexString: "#FFFFFF")

let receive_message_bubble_color = UIColor.colorWithHex(hexString: "#f0f0f0")
let receive_message_text_color = UIColor.colorWithHex(hexString: "#000000")

let login_textfield_text_color = UIColor.colorWithHex(hexString: "#FFFFFF")//
let login_textfield_placeholder_color = UIColor.colorWithHex(hexString: "#D8C7E8")

let message_textfield_background_color = UIColor.colorWithHex(hexString: "#3a86c2")//
let message_textfield_placeholder_color = UIColor.colorWithHex(hexString: "#f0f0f0")//
let message_textfield_text_color = UIColor.colorWithHex(hexString: "#000000")//

let message_sendtime_text_color = UIColor.colorWithHex(hexString: "#000000")
let message_sender_text_color = UIColor.colorWithHex(hexString: "#00000")


let profile_textfield_background_color = UIColor.colorWithHex(hexString: "#000000")
let profile_textfield_text_color = UIColor.colorWithHex(hexString: "#FFFFFF")
let profile_label_text_color = UIColor.colorWithHex(hexString: "#000000")



//MARK: - Individual Constants -

/// Screen Width
let kScreenWidth = UIScreen.main.bounds.size.width

/// Screen Height
let kScreenHeight = UIScreen.main.bounds.size.height

//Shared AppDelegate
@available(iOS 13.0, *)
let sharedAppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate

// UserDefault
//let userDefault = UserDefaults.standard

// Notification Center
let notificationCenter = NotificationCenter.default

// StoryBoard
let mainStroyBoard = UIStoryboard(name: "Main", bundle: nil)


extension String {
    
    var phoneClean: String {
        let okayChars = Set("0123456789")
        return self.filter {okayChars.contains($0) }
    }
    
    func validatePassword() -> Bool{
        if self.count == 6  {
            return true
        }
        return false
    }
    func validateName() -> Bool{
        if self.count < 1  {
            return false
        }
        return true
    }
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
}


extension Date {
    var daysFromNow: Int {
        return Calendar.current.dateComponents([.day], from: Date(), to: self).day!
    }
}


extension UIColor {
    
    /** Color with Red green and Blue */
    static func colorWithRGB(_ redValue: CGFloat, _ greenValue: CGFloat, _ blueValue: CGFloat, alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(red: redValue/255.0, green: greenValue/255.0, blue: blueValue/255.0, alpha: alpha)
    }
    
    /** Color with Hex value */
    static func colorWithHex(hexString: String, alpha:CGFloat? = 1.0) -> UIColor {
        // Convert hex string to an integer
        let hexint = Int(intFromHexString(hexString))
        let red = CGFloat((hexint & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hexint & 0xff00) >> 8) / 255.0
        let blue = CGFloat((hexint & 0xff) >> 0) / 255.0
        let alpha = alpha!
        // Create color object, specifying alpha as well
        let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        return color
    }
    
    static func intFromHexString(_ hexStr: String) -> UInt32 {
        var hexInt: UInt32 = 0
        // Create scanner
        let scanner: Scanner = Scanner(string: hexStr)
        // Tell scanner to skip the # character
        scanner.charactersToBeSkipped = NSCharacterSet(charactersIn: "#") as CharacterSet
        // Scan hex value
        scanner.scanHexInt32(&hexInt)
        return hexInt
    }
}

var GroupsAll = [GroupChatChannel]()

// Old server Key
//let FirebasePushServerKey = "AAAA1lt5E6I:APA91bG--Kl6iVoi4ZfIAyA45_OMFy1LM8OVQEEPlY39lxOclqgAmUr4LNLGDQMDvu409SOrZ1BOmjspC6AsCtGiKhYDv3NJqrvd7_Qia1Q0z0svAV196L-3nmequamJQkz9SyUkKBoi"

let FirebasePushServerKey = "AAAAde7kDHY:APA91bFx2pRMMhV4qmeMfpXr6Iaj2_1Ey5b3viuEcbB0fmoaPwcIl6l2YLQr9MUR2LsapY-5v47JA2bq3IuVynuq4_ST7IaZFNNwUGMmzxO8wCa3GvTH8wkWwCmaCkPqIl_r5Nbio3oq" //"AAAAarKgHyI:APA91bEucI6EaFo6UlFyLM7YMqdS1xiXVZYlX7ReH7wDQDUHhDx7NCmcnBu7ti3fDTzrk0TjfQ1Zo0wQyk_fgGBd3DOJ7CFM8VqanY1j6nNAXiFMzjvtjhAH3LWavPAovNMXY9c6z5X7"




import FirebaseMessaging
func getFCMToken() -> String{
    if let token = Messaging.messaging().fcmToken
    {
        return token
    }
    
    return ""
}


let messageLimit = 20



extension UIScrollView {

    var isAtBottom: Bool {
        return contentOffset.y >= verticalOffsetForBottom
    }

    var verticalOffsetForBottom: CGFloat {
        let scrollViewHeight = bounds.height
        let scrollContentSizeHeight = contentSize.height
        let bottomInset = contentInset.bottom
        let scrollViewBottomOffset = scrollContentSizeHeight + bottomInset - scrollViewHeight
        return scrollViewBottomOffset
    }

}



extension UIImage {
    class func colorForNavBar(_ color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    var scaledToSafeUploadSize: UIImage? {
        let maxImageSideLength: CGFloat = 480
        
        let largerSide: CGFloat = max(size.width, size.height)
        let ratioScale: CGFloat = largerSide > maxImageSideLength ? largerSide / maxImageSideLength : 1
        let newImageSize = CGSize(width: size.width / ratioScale, height: size.height / ratioScale)
        
        return image(scaledTo: newImageSize)
    }
    
    func image(scaledTo size: CGSize) -> UIImage? {
        defer {
            UIGraphicsEndImageContext()
        }
        
        UIGraphicsBeginImageContextWithOptions(size, true, 0)
        draw(in: CGRect(origin: .zero, size: size))
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    static func localImage(_ name: String, template: Bool = false) -> UIImage {
        var image = UIImage(named: name)!
        if template {
            image = image.withRenderingMode(.alwaysTemplate)
        }
        return image
    }
    
    
    public static func loadFrom(url: URL, completion: @escaping (_ image: UIImage?) -> ()) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    completion(UIImage(data: data))
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
    
}



struct AlertTitle {
    static let UNAUTHORISED_USER = "Unauthorized User"
    static let NETWORK_ERROR = "No internet connection."
    static let ALERT_WEBSERVICE_ERROR = "Something went wrong! Please try again"
    static let SIGNUP_LINK_MESSAGE = "Verification link has been sent to your account, please check your inbox and verify it."
}



func dialNumber(number : String) {

 if let url = URL(string: "tel://\(number)"),
   UIApplication.shared.canOpenURL(url) {
      if #available(iOS 10, *) {
        UIApplication.shared.open(url, options: [:], completionHandler:nil)
       } else {
           UIApplication.shared.openURL(url)
       }
   } else {
            // add error message here
   }
}

func whatsAppCallAction(number : String) {
    var phoneNumber =  "\(number)" // you need to change this number
    print(phoneNumber)
    if phoneNumber.first == "0" {
        phoneNumber = "+966" + phoneNumber.dropFirst()
    }
    print(phoneNumber)
    let appURL = URL(string: "https://api.whatsapp.com/send?phone=\(phoneNumber)")!
    if UIApplication.shared.canOpenURL(appURL) {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
        }
        else {
            UIApplication.shared.openURL(appURL)
        }
    } else {
        // WhatsApp is not installed
    }
}

func setBadgeValues(){
    
    let application = UIApplication.shared.delegate as! AppDelegate
    let tabbarController = application.window?.rootViewController as! UITabBarController
    
    
    guard let user = AppUtility.getSession() else{
        return
    }
    
    if let msg_badge = messageBadge {
        
        if let msg_tab = tabbarController.tabBar.items?[3]{
            if msg_badge == "0" || msg_badge == ""{
                msg_tab.badgeValue = nil
            }else{
                var badge = "\(msg_badge)"
                if "\(badge)".count > 3 {
                    badge = ""
                }
                badge = badge.replacingOccurrences(of: "-", with: "")
                msg_tab.badgeValue = badge
            }
        }
    }
    
    if let noti_badge = user.noti_badge {
        let num = UIApplication.shared.applicationIconBadgeNumber
        if let noti_tab = tabbarController.tabBar.items?[2]{
            if num > 0 {
                noti_tab.badgeValue = "\(num)"
            }else{
                noti_tab.badgeValue = nil
            }
           
        }
    }
  
}

func forcedsetBadgeValues(){
    
    let application = UIApplication.shared.delegate as! AppDelegate
    let tabbarController = application.window?.rootViewController as! UITabBarController
    
    
    guard let user = AppUtility.getSession() else{
        return
    }
    
    if let msg_badge = messageBadge {
        
        if let msg_tab = tabbarController.tabBar.items?[3]{
            messageBadge = "0"
//            if msg_badge == "0" || msg_badge == ""{
//                msg_tab.badgeValue = nil
//            }else{
//                var badge = "\(msg_badge)"
//                if "\(badge)".count > 3 {
//                    badge = ""
//                }
//                badge = badge.replacingOccurrences(of: "-", with: "")
//                msg_tab.badgeValue = badge
//            }
            msg_tab.badgeValue = nil
        }
    }
    
    if let noti_badge = user.noti_badge {
        if let noti_tab = tabbarController.tabBar.items?[2]{
            user.noti_badge = "0"
            if noti_badge == "0" || noti_badge == ""{
                noti_tab.badgeValue = nil
            }else{
                noti_tab.badgeValue = ""
            }
           
        }
    }
  
}

func forcedsetBadgeValuesNotification(){
    UIApplication.shared.applicationIconBadgeNumber = 0
    let application = UIApplication.shared.delegate as! AppDelegate
    let tabbarController = application.window?.rootViewController as! UITabBarController
    
    
    guard let user = AppUtility.getSession() else{
        return
    }
    user.noti_badge = "0"
    
//    if let msg_badge = user.msg_badge {
//
//        if let msg_tab = tabbarController.tabBar.items?[3]{
////            if msg_badge == "0" || msg_badge == ""{
////                msg_tab.badgeValue = nil
////            }else{
////                var badge = "\(msg_badge)"
////                if "\(badge)".count > 3 {
////                    badge = ""
////                }
////                badge = badge.replacingOccurrences(of: "-", with: "")
////                msg_tab.badgeValue = badge
////            }
//            msg_tab.badgeValue = nil
//        }
//    }
    
    if let noti_badge = user.noti_badge {
        if let noti_tab = tabbarController.tabBar.items?[2]{
            if noti_badge == "0" || noti_badge == ""{
                noti_tab.badgeValue = nil
            }else{
                noti_tab.badgeValue = ""
            }
           
        }
    }
  
}

func forcedsetBadgeValuesMessage(){
    
    let application = UIApplication.shared.delegate as! AppDelegate
    let tabbarController = application.window?.rootViewController as! UITabBarController
    
    
    guard let user = AppUtility.getSession() else{
        return
    }
    messageBadge = "0"
    
    if let msg_badge = messageBadge {

        if let msg_tab = tabbarController.tabBar.items?[3]{
//            if msg_badge == "0" || msg_badge == ""{
//                msg_tab.badgeValue = nil
//            }else{
//                var badge = "\(msg_badge)"
//                if "\(badge)".count > 3 {
//                    badge = ""
//                }
//                badge = badge.replacingOccurrences(of: "-", with: "")
//                msg_tab.badgeValue = badge
//            }
            msg_tab.badgeValue = nil
        }
    }
    
//    if let noti_badge = user.noti_badge {
//        if let noti_tab = tabbarController.tabBar.items?[2]{
//            if noti_badge == "0" || noti_badge == ""{
//                noti_tab.badgeValue = nil
//            }else{
//                noti_tab.badgeValue = ""
//            }
//
//        }
//    }
  
}





func setUserMessageBadge(newMsgBadges:String){
    if let user = AppUtility.getSession(){
        user.msg_badge = newMsgBadges
        messageBadge = newMsgBadges
        AppUtility.saveUserSession(u: user)
        setBadgeValues()
    }
}

func clearBadgesNotification(){
    if let user = AppUtility.getSession(){
        user.noti_badge = "0"
        AppUtility.saveUserSession(u: user)
        setBadgeValues()
    }
}

func clearBadgesNotificationForced(){
    if let user = AppUtility.getSession(){
        user.noti_badge = "0"
        AppUtility.saveUserSession(u: user)
        forcedsetBadgeValues()
    }
}


func clearBadgesNotificationForcedNotificationTab(){
    if let user = AppUtility.getSession(){
        user.noti_badge = "0"
        AppUtility.saveUserSession(u: user)
        forcedsetBadgeValuesNotification()
    }
}

func clearBadgesNotificationForcedMessageTab(){
    if let user = AppUtility.getSession(){
        user.noti_badge = "0"
        AppUtility.saveUserSession(u: user)
        forcedsetBadgeValuesMessage()
    }
}



import PopupDialog

func disclaimerPopUp(viewController:UIViewController){
    
    let datePicker = DisclaimerViewController(nibName: "DisclaimerViewController", bundle: nil)
    let popup = PopupDialog(viewController: datePicker, buttonAlignment: .horizontal, transitionStyle: .bounceUp, tapGestureDismissal: true)
  
   
    viewController.present(popup, animated: true, completion: nil)
}
