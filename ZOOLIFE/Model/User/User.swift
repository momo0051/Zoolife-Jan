//
//  User.swift
//  ClientOnBoarding
//
//  Created by Hafiz Anser on 10/9/19.
//  Copyright © 2019 com.JoeSingh. All rights reserved.
//

import Foundation
import SwiftyJSON
import UIKit

class User: NSObject, NSCoding{
    
    var ID: String? = ""
    var fullname: String = ""
    var email: String?
    var phone: String?
    var avatar: String?
    var deviceToken : String?
    
    
    var msg_badge : String?
    var noti_badge : String?

    var disclaimer : String? //"0","1"
    
    override init()
    {
        super.init()
        self.ID = ""
        self.fullname = ""
        self.email = ""
        self.phone = ""
        self.avatar = ""
        
        self.msg_badge = ""
        self.noti_badge = ""
        self.disclaimer = "0"
    }
    
    // Memberwise initializer
    init(ID: String?,
         fullname: String?,
         email: String?,
         phone: String?,
         avatar: String?,msg_badge : String?,noti_badge : String?
        )
    {
        
        self.ID = ID
        self.fullname = fullname ?? ""
        self.email = email
        self.phone = phone
        self.avatar = avatar
        
        self.msg_badge = msg_badge
        self.noti_badge = noti_badge
    }
    
    // NSCoding
    public required convenience init?(coder aDecoder: NSCoder)
    {
        let integerID = aDecoder.decodeObject(forKey: "id") as? String
        let email = aDecoder.decodeObject(forKey: "username") as? String
        let phone = aDecoder.decodeObject(forKey: "phone") as? String
            
        self.init(
            ID: integerID,
            fullname: aDecoder.decodeObject(forKey: "fullname") as? String,
            email: aDecoder.decodeObject(forKey: "username") as? String,
            phone: aDecoder.decodeObject(forKey: "phone") as? String,
            avatar: aDecoder.decodeObject(forKey: "avatar") as? String,
            msg_badge: aDecoder.decodeObject(forKey: "msg_badge") as? String,
            noti_badge: aDecoder.decodeObject(forKey: "noti_badge") as? String
        )
    }
    
    func encode(with aCoder: NSCoder)
    {
        aCoder.encode(self.ID, forKey: "id")
        aCoder.encode(self.fullname, forKey: "fullname")
        aCoder.encode(self.email, forKey: "username")
        aCoder.encode(self.phone, forKey: "phone")
        aCoder.encode(self.avatar, forKey: "avatar")
        
        aCoder.encode(self.noti_badge, forKey: "noti_badge")
        aCoder.encode(self.msg_badge, forKey: "msg_badge")
        
        aCoder.encode(self.disclaimer, forKey: "disclaimer")
    }
    
    // assign value through dictionary
    init(withDictionary dictionary: [String: JSON])
    {
        super.init()
        print(dictionary)
//        if let auth_token = dictionary["token"]?.string
//        {
//            self.auth_token = auth_token
//        }
//        if let dictValue: Dictionary<String, JSON> = dictionary["user"]?.dictionaryValue
//        {
//            if let id = dictValue["id"]?.int
//            {
//                self.ID = id
//            }
//            else
//            {
//                ID = 0
//            }
//            if let firstName = dictValue["first_name"]?.string
//            {
//                self.firstName = firstName
//            }
//            else
//            {
//                self.firstName = ""
//            }
//            if let lastName = dictValue["last_name"]?.string
//            {
//                self.lastName = lastName
//            }
//            else
//            {
//                self.lastName = ""
//            }
//            if let phone = dictValue["phone"]?.string
//            {
//                self.phone = phone
//            }
//            else
//            {
//                self.phone = ""
//            }
//
//            if let email = dictValue["email"]?.string
//            {
//                self.email = email
//            }
//            else
//            {
//                email = ""
//            }
//            if let status = dictValue["status"]?.int
//            {
//                self.status = status
//            }
//            else
//            {
//                status = 0
//            }
//        }
        if let id = dictionary["id"]?.int
        {
            self.ID = String(id)
        }
        else
        {
            self.ID = String(0)
        }
        if let fullname = dictionary["fullname"]?.string
        {
            self.fullname = fullname
        }
        else
        {
            self.fullname = ""
        }
        
        if let email = dictionary["username"]?.string
        {
            self.email = email
        }
        else
        {
            email = ""
        }

        if let phone = dictionary["phone"]?.string
        {
            self.phone = phone
        }
        else
        {
            phone = ""
        }
        
        if let avatar = dictionary["avatar"]?.string
        {
            self.avatar = avatar
        }
        else
        {
            self.avatar = ""
        }
        
        if let deviceToken = dictionary["device_token"]?.string
        {
            self.deviceToken = deviceToken
        }
        else
        {
            self.deviceToken = ""
        }
        
        
        
        if let noti_badge = dictionary["noti_badge"]?.string{
            self.noti_badge = noti_badge
        }
        else{
            self.noti_badge = ""
        }
        
        if let msg_badge = dictionary["msg_badge"]?.string{
            self.msg_badge = msg_badge
        }
        else{
            self.msg_badge = ""
        }
        
        if let disclaimer = dictionary["disclaimer"]?.string{
            self.disclaimer = disclaimer
        }
        else{
            self.disclaimer = ""
        }
//        self.msg_badge = "2"
    }
}


