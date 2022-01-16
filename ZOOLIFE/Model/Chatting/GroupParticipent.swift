//
//  GroupParticipent.swift
//  World Guide
//
//  Created by Yousaf Shafiq on 02/09/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import Firebase

open class GroupParticipent: NSObject, GenericBaseModel, NSCoding{
    
    
    var userDatabseID:String?
    var user:String
    var group:String


//    public init(userAddedTime: Date , user: String, group: String, isNotification: Bool = true) {
//        self.userAddedTime = userAddedTime
//        self.user = user
//        self.isNotification = isNotification
//        self.group = group
//    }
    
    public init(representation: [String: Any]) {
    
        
     
        
        self.user = representation["user"] as! String
        self.group = representation["group"] as! String
        self.userDatabseID = representation["userDatabseID"] as? String
    }
    
    required public init(jsonDict: [String: Any]) {
        fatalError()
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(userDatabseID, forKey: "userDatabseID")
        aCoder.encode(user, forKey: "user")
        aCoder.encode(group, forKey: "group")
        
        
   
    }
    

     
    required  public init(coder aDecoder: NSCoder) {
    
//    public convenience required init?(coder aDecoder: NSCoder) {
    
        
//        self.init(userAddedTime: (aDecoder.decodeObject(forKey: "userAddedTime") as? Timestamp)?.dateValue() ?? Date(),
//                  user: (aDecoder.decodeObject(forKey: "user") as? String) ?? "",
//                  group: aDecoder.decodeObject(forKey: "group") as? String ?? "",
//                  isNotification: aDecoder.decodeBool(forKey: "isNotification")
        
//      userAddedTime = (aDecoder.decodeObject(forKey: "userAddedTime") as? Timestamp)?.dateValue() ?? Date()
        
        
            user = (aDecoder.decodeObject(forKey: "user") as? String) ?? ""
            group = aDecoder.decodeObject(forKey: "group") as? String ?? ""
        userDatabseID = aDecoder.decodeObject(forKey: "userDatabseID") as? String


            
        
    }

//    public func fullName() -> String {
//        guard let firstName = firstName, let lastName = lastName else { return self.firstName ?? "" }
//
//
//
//        return "\(firstName.prefix(1)) \(lastName.prefix(1))"
//    }
    
//    public func firstWordFromName() -> String {
//        if let firstName = firstName, let first = firstName.components(separatedBy: " ").first {
//            return first
//        }
//        return "No name"
//    }
//
//    var initials: String {
//        if let f = firstName?.first, let l = lastName?.first {
//            return String(f) + String(l)
//        }
//        return "?"
//    }
    
    var representation: [String : Any] {
        let rep: [String : Any] = [
            "user": user,
            "group": group,
            "userDatabseID": userDatabseID ,
            ]
        return rep
    }
}

