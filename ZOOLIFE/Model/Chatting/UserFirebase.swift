//
//  UserFirebase.swift
//  World Guide
//
//  Created by Yousaf Shafiq on 02/09/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

open class UserFirebase: NSObject, GenericBaseModel, NSCoding {
    
    var uid: String?
    var username: String?
    var email: String?
    var firstName: String?
    var lastName: String?
    var profilePictureURL: String?
    var pushToken: String?
    var isOnline: Bool

    var badgesChat : Int?
    
    
    var isNotification:Bool

    public init(uid: String = "", firstName: String, lastName: String, avatarURL: String = "", email: String = "", pushToken: String? = nil, isOnline: Bool = false, badgesChat: Int? = nil, isNotification: Bool = true) {
        self.firstName = firstName
        self.lastName = lastName
        self.uid = uid
        self.email = email
        self.profilePictureURL = avatarURL
        self.pushToken = pushToken
        self.isOnline = isOnline
        self.badgesChat = badgesChat
        self.isNotification = isNotification
    }
    
    public init(representation: [String: Any]) {
        self.firstName = representation["firstName"] as? String
        self.lastName = representation["lastName"] as? String
        self.profilePictureURL = representation["profilePictureURL"] as? String
        self.username = representation["username"] as? String
        self.email = representation["email"] as? String
        self.uid = representation["userID"] as? String
        self.pushToken = representation["pushToken"] as? String
        self.isOnline = false
        self.badgesChat = representation["badgesChat"] as? Int
        
        self.isNotification = representation["isNotification"] as? Bool ?? true
    }
    
    required public init(jsonDict: [String: Any]) {
        fatalError()
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(uid, forKey: "uid")
        aCoder.encode(username, forKey: "username")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(firstName, forKey: "firstName")
        aCoder.encode(lastName, forKey: "lastName")
        aCoder.encode(profilePictureURL, forKey: "profilePictureURL")
        aCoder.encode(pushToken, forKey: "pushToken")
        aCoder.encode(isOnline, forKey: "isOnline")
        aCoder.encode(badgesChat, forKey: "badgesChat")
        aCoder.encode(isNotification, forKey: "isNotification")
   
    }
    
    public convenience required init?(coder aDecoder: NSCoder) {
        self.init(uid: aDecoder.decodeObject(forKey: "uid") as? String ?? "unknown",
                  firstName: aDecoder.decodeObject(forKey: "firstName") as? String ?? "",
                  lastName: aDecoder.decodeObject(forKey: "lastName") as? String ?? "",
                  avatarURL: aDecoder.decodeObject(forKey: "profilePictureURL") as? String ?? "",
                  email: aDecoder.decodeObject(forKey: "email") as? String ?? "",
                  pushToken: aDecoder.decodeObject(forKey: "pushToken") as? String ?? "",
                
                  isOnline: aDecoder.decodeBool(forKey: "isOnline"),
                  badgesChat: aDecoder.decodeObject(forKey: "badgesChat") as? Int ?? 0,
                  isNotification: aDecoder.decodeBool(forKey: "isNotification")
        )
    }

    public func fullName() -> String {
        guard let firstName = firstName, let lastName = lastName else { return self.firstName ?? "" }
        
        
        
        return "\(firstName.prefix(1)) \(lastName.prefix(1))"
    }
    
    public func firstWordFromName() -> String {
        if let firstName = firstName, let first = firstName.components(separatedBy: " ").first {
            return first
        }
        return "No name"
    }
    
    var initials: String {
        if let f = firstName?.first, let l = lastName?.first {
            return String(f) + String(l)
        }
        return "?"
    }
    
    var representation: [String : Any] {
        let rep: [String : Any] = [
            "userID": uid!,
            "profilePictureURL": profilePictureURL ?? "",
            "username": username ?? "",
            "email": email ?? "",
            "firstName": firstName ?? "",
            "lastName": lastName ?? "",
            "pushToken": pushToken ?? "",
            "badgesChat": badgesChat ?? 0,
            "isNotification": isNotification ,
            
            ]
        return rep
    }
}


protocol GenericFirebaseParsable {
    init(key: String, jsonDict: [String: Any])
}

protocol GenericJSONParsable {
    init(jsonDict: [String: Any])
}

protocol GenericBaseModel: GenericJSONParsable, CustomStringConvertible {
}
