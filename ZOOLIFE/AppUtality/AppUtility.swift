//
//  AppUtility.swift
//  Transition

import Foundation
import UIKit
import SVProgressHUD
import SDWebImage

func Okey()->String {    
    if appLanguage == "en" {
        return "Okey"
    } else {
        return "حسنا"
    }
}
func Cancel()->String {
    if appLanguage == "en" {
        return "Cancel"
    } else {
        return "الغاء"
    }
}
class AppUtility: NSObject
{
    
 
    class func isValidEmail(testStr:String) -> Bool
    {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }

    class func saveUserSession(u :User?){
        
//        if let data = userDefaults.value(forKey: key) as? Data {
//            do {
//                let array = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data)
//                if let savedPrices = array as? [BitCointList] {
//                    return savedPrices
//                }
//
//            } catch { }
//        }
        
        let defaults = UserDefaults.standard
        let data = NSKeyedArchiver.archivedData(withRootObject: u as Any)
        defaults.set(data, forKey: USER_LOGIN)
        defaults.synchronize()
        
//        do {
//
//            let data = try NSKeyedArchiver.archivedData(withRootObject: u as Any, requiringSecureCoding: true)//NSKeyedArchiver.archivedData(withRootObject:)
//            UserDefaults.standard.set(data, forKey: USER_LOGIN)
//            UserDefaults.standard.synchronize()
//
//        } catch  { }
        
        
    }
    
//    static func currentUser() -> userModel? {
//        var user: userModel?
//        let defaults = UserDefaults.standard
//        if let data = defaults.object(forKey: "hmh.provider") {
//            user = NSKeyedUnarchiver.unarchiveObject(with: data as! Data) as? userModel
//        }
//        return user
//    }
//
//    func save() {
//        let defaults = UserDefaults.standard
//        let data = NSKeyedArchiver.archivedData(withRootObject: self)
//        defaults.set(data, forKey: "hmh.provider")
//        defaults.synchronize()
//    }

    class func getSession() ->User?
    {
        
        var user: User?
        let defaults = UserDefaults.standard
        if let data = defaults.object(forKey: USER_LOGIN) {
            user = NSKeyedUnarchiver.unarchiveObject(with: data as! Data) as? User
        }
        
        return user
        
//        if let data = UserDefaults.standard.data(forKey:USER_LOGIN){
//            do {
//
//                let decodedObj = try NSKeyedUnarchiver.unarchivedObject(ofClass: User.self, from: data) as? User
//
//                if let user = decodedObj {
//                    return user
//                }
//            } catch { }
//
//
//        }
//
//        return nil
    }

    class func setImage(url:String, image:UIImageView) {
        print("image url ---- \(url)")
        image.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "placeholder"))
    }
    
//
//    class func showErrorMessage(message:String)
//    {
//        let error = MessageView.viewFromNib(layout: .tabView)
//        error.configureTheme(.error)
//        error.configureContent(title: "Error", body: message)
//        error.button?.isHidden = true
//        SwiftMessages.show(view: error)
//    }
//
//    class func showSuccessMessage(message:String)
//    {
//        let success = MessageView.viewFromNib(layout: .tabView)
//        success.configureTheme(.success)
//        success.configureContent(title: "Success", body: message)
//        success.button?.isHidden = true
//        SwiftMessages.show(view: success)
//    }
//
//    class func showInfoMessage(message:String)
//    {
//        let info = MessageView.viewFromNib(layout: .tabView)
//        info.configureTheme(.warning)
//        info.configureContent(title: "Info", body: message)
//        info.button?.isHidden = true
//        SwiftMessages.show(view: info)
//    }
    
    class func convertDateToString(date :NSDate) ->String
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd h:mm a"
        let myString = formatter.string(from: date as Date)
        let yourDate: Date? = formatter.date(from: myString)
        formatter.dateFormat = "dd-MM-yyyy"
        let updatedString = formatter.string(from: yourDate!)
        
        return updatedString
    }
    
    class func convertDateToStringForMKT(date :NSDate) ->String
    {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        //formatter.dateFormat = "yyyy-MM-dd h:mm a"
        formatter.dateFormat = "h:mm a 'on' MMMM dd, yyyy"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        let myString = formatter.string(from: date as Date)
        let yourDate: Date? = formatter.date(from: myString)
        formatter.dateFormat = "dd.MM.yyyy h:mm a"
        let updatedString = formatter.string(from: yourDate!)
        
        return updatedString
    }
    
    class func stringToDate(_ str: String)->Date
    {
        let datefrmter = DateFormatter()
        datefrmter.dateFormat = "yyyy-MM-dd h:mm a"
        if let date = datefrmter.date(from: str)
        {
            return date
        }
        else
        {
            return Date()
        }
    }
    class func showProgress()
    {
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.setDefaultMaskType(.gradient)
        SVProgressHUD.setForegroundColor(UIColor.darkGray)
        SVProgressHUD.setBackgroundColor(UIColor.white)
        SVProgressHUD.show()
        //SVProgressHUD.show(withStatus: "Loading")
    }
    
    class func hideProgress()
    {
        SVProgressHUD.dismiss()
    }
    func SVProgressHUDCustom()
    {
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.setForegroundColor(UIColor.red)           //Ring Color
        SVProgressHUD.setBackgroundColor(UIColor.yellow)        //HUD Color
        SVProgressHUD.setBackgroundLayerColor(UIColor.green)
    }
    
    
    class func getFormattedDate(dateString: String) -> String?{
        
        //"2020-12-04 14:05:45" from server
        
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'" //"yyyy-MM-dd HH:mm:ss"//
        
        if let date = dateFormatter.date(from: dateString){
            dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
            let newDate = dateFormatter.string(from: date)
            print("new Date is: ",newDate)
            return newDate
        }
        
        return nil
        
    }
    
    class func convertDateToStringTime(dateString: String) ->String?
    {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'" //"yyyy-MM-dd HH:mm:ss"//
        if let date = dateFormatter.date(from: dateString){
            dateFormatter.dateFormat = "HH 'h' mm 'm'"
//            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            let newDate = dateFormatter.string(from: date)
            print("new Date is: ",newDate)
            return newDate
        }
        
        return nil
    }
    
    class func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    
    
    
    class func adFormattedDate(dateString: String) -> Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"//"yyyy-MM-dd HH:mm:ss"

//        utcToLocal
        if let date = dateFormatter.date(from:dateString) {
            //return date
            if let localTimeAd = utcToLocal(dateStr:dateString){// self.UTCtoLocalConvert(date: date)
                return dateFormatter.date(from: localTimeAd)
            }
        }
        return nil
    }
    
    
    class func localToUTC(dateStr: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.calendar = Calendar.current
        dateFormatter.timeZone = TimeZone.current
        
        if let date = dateFormatter.date(from: dateStr) {
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            dateFormatter.dateFormat = "H:mm:ss"
        
            return dateFormatter.string(from: date)
        }
        return nil
    }

    class func utcToLocal(dateStr: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = appDateFormat
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        if let date = dateFormatter.date(from: dateStr) {
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = appDateFormat
            let newDate = dateFormatter.string(from: date)
            return dateFormatter.string(from: date)
        }
        return nil
    }
    
    
    //MARK:- Time converter
    class func UTCtoLocalConvert(date:Date) -> String {
        
        /** change to a readable time format and change to local time zone*/
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = appDateFormat
        
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        dateFormatter.timeZone = TimeZone.current//(secondsFromGMT: 0)//(abbreviation: "UTC")
        let newDate = dateFormatter.string(from: date)
        return newDate
        
        dateFormatter.timeZone = TimeZone(identifier: "en_US_POSIX")
        
        let stringDate = dateFormatter.string(from: date)
        
        if let utcDate = dateFormatter.date(from: stringDate){
            
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            
            dateFormatter.timeZone = TimeZone.current//(secondsFromGMT: 0)//(abbreviation: "UTC")
            let newDate = dateFormatter.string(from: utcDate)
            return newDate
        }
        
        return ""
    
    }

    class func LocalToUTCConvert(date:Date) -> String {
      
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = appDateFormat
        dateFormatter.timeZone = TimeZone(identifier: "")
        let stringDate = dateFormatter.string(from: date)
        let dateFromString = dateFormatter.date(from: stringDate)
        
        
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
       // dateFormatter.dateFormat = "HH:mm:ss"
        
        return dateFormatter.string(from: dateFromString!)
        
        
            return stringDate
        
        
        
        
    //
    //    let dateFormatter = DateFormatter()
    //    dateFormatter.dateFormat = "hh:mm a"
    //    dateFormatter.timeZone = TimeZone(identifier: "")
        
    //    let date = dateFormatter.date(from: strDate)
    //
    //    dateFormatter.timeZone = TimeZone(identifier: "UTC")
    //    dateFormatter.dateFormat = "HH:mm:ss"
    //
    //    return dateFormatter.string(from: date!)
    }
}

extension UIViewController {
  var TopViewController: UIViewController? {
    return self.TopViewController(currentViewController: self)
  }
  private func TopViewController(currentViewController: UIViewController) -> UIViewController {
    if let tabBarController = currentViewController as? UITabBarController,
      let selectedViewController = tabBarController.selectedViewController {
      return self.TopViewController(currentViewController: selectedViewController)
    } else if let navigationController = currentViewController as? UINavigationController,
      let visibleViewController = navigationController.visibleViewController {
      return self.TopViewController(currentViewController: visibleViewController)
    } else if let presentedViewController = currentViewController.presentedViewController {
      return self.TopViewController(currentViewController: presentedViewController)
    } else {
      return currentViewController
    }
  }
}
