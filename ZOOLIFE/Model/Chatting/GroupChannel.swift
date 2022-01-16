//
//  GroupChannel.swift
//  World Guide
//
//  Created by Yousaf Shafiq on 02/09/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseDatabase

class GroupChatChannel: NSObject, GenericBaseModel, NSCoding{
    
   override init() {
       
   }
    required  init(coder aDecoder: NSCoder) {
        id = aDecoder.decodeObject(forKey: "id") as? String ?? ""
        name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        lastMessageDate = aDecoder.decodeObject(forKey: "lastMessageDate") as? Date ?? Date()
        participants = aDecoder.decodeObject(forKey: "participants") as? [UserFirebase] ?? []
        
        groupParticipent = aDecoder.decodeObject(forKey: "groupParticipent") as? [GroupParticipent] ?? []
        
        
        
        lastMessage = aDecoder.decodeObject(forKey: "lastMessage") as? String ?? ""
        groupImage = aDecoder.decodeObject(forKey: "groupImage") as? String ?? ""
        creator_id = aDecoder.decodeObject(forKey: "creator_id") as? String ?? ""
        addedAdmin = aDecoder.decodeObject(forKey: "addedAdmin") as? String ?? ""
        
        longitude = aDecoder.decodeDouble(forKey: "longitude")
        latitude = aDecoder.decodeDouble(forKey: "latitude")
        
        
    }

        func encode(with aCoder: NSCoder) {
          
            aCoder.encode(groupParticipent, forKey: "groupParticipent")
            aCoder.encode(name, forKey: "name")
            aCoder.encode(id, forKey: "id")
            aCoder.encode(lastMessageDate, forKey: "lastMessageDate")
            aCoder.encode(participants, forKey: "participants")
            aCoder.encode(lastMessage, forKey: "lastMessage")
            aCoder.encode(adminBadges, forKey: "adminBadges")
            
            aCoder.encode(groupImage, forKey: "groupImage")
            aCoder.encode(creator_id, forKey: "creator_id")
            aCoder.encode(addedAdmin, forKey: "addedAdmin")
            aCoder.encode(latitude, forKey: "latitude")
            aCoder.encode(longitude, forKey: "longitude")
               
        }
    
    
    var groupParticipent = [GroupParticipent]()
    var participants = [UserFirebase]()

    var id = String()
    var name = String()
    var lastMessageDate: Date = Date().oneYearAgo
   
    var lastMessage = String()
    var adminBadges = Int()
    
    var groupImage = String()
    
    var creator_id = String()
    
    
    var addedAdmin = String()
    
    
    var latitude = Double()
    var longitude = Double()
    
    
    var friendsModel = [String]()
    
    var groupID = String()
    
    var adId : String?
    
    var adTitle : String?
    
    var adImage : String?
    
    var senderEmail : String?
    
    var recipientEmail : String?
    
    
    var senderPhone : String?
    var recipientPhone : String?
    
    var adCreatedUser : String?
    
    var badges : [String: Int]?
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
        self.participants = []
        self.groupParticipent = []
        self.lastMessageDate = Date().oneYearAgo
        self.lastMessage = ""
        self.adminBadges = 0
        self.groupImage = ""
//        self.orderPlace = false
//        self.orderID = ""
        self.creator_id = ""
        self.addedAdmin = ""
        self.latitude = 0.0
        self.longitude = 0.0
        self.friendsModel = []
        self.groupID = ""
        self.adId = ""
        self.adTitle = ""
        self.adImage = ""
        self.senderEmail = ""
        self.recipientEmail = ""
        self.adCreatedUser = ""
        
        self.senderPhone = ""
        self.recipientPhone = ""

    }
    
    init?(document: DocumentSnapshot) {
        guard let data = document.data() else { return nil }
        
        
        var image = ""
        
        if let img = data["groupImage"] as? String{
            image = img
        }
        self.groupImage = image
        
        var badge = 0
        
        if let badges = data["adminBadges"] as? Int{
            badge = badges
        }
        self.adminBadges = badge
        
//        var orderCreated = false
//
//        if let order = data["orderPlace"] as? Bool{
//            orderCreated = order
//        }
//        self.orderPlace = orderCreated
//
//        var oid = ""
//
//        if let orderID = data["orderID"] as? String{
//            oid = orderID
//        }
//        self.orderID = oid
        
        
        var name: String = ""
        if let tmp = data["name"] as? String {
            name = tmp
        }
        self.id = document.documentID
        self.name = name
        self.participants = []
        self.groupParticipent = []
        
        var date = Date().oneYearAgo
        
        
        
        
        if let timestamp = data["lastMessageDate"] as? Timestamp  {
            date = timestamp.dateValue()
        }

        self.lastMessageDate = date
        var lastMessage = ""
        if let m = data["lastMessage"] as? String {
            lastMessage = m
        }
        self.lastMessage = lastMessage
        
        
        
        var creatorID = ""
        if let creator = data["creator_id"] as? String{
            creatorID = creator
        }
        creator_id = creatorID
        
        
        var ADDED = ""
        
        if let addeds  = data["addedAdmin"] as? String{
            ADDED = addeds
        }
        
        self.addedAdmin = ADDED
        
        if let lati = data["latitude"] as? NSNumber{
            
            if let doubleLatitude = Double(exactly: lati){
                self.latitude = doubleLatitude
            }else{
                self.latitude = 0.0
            }
        }else{
            self.latitude = 0.0
        }
    
        if let longi = data["longitude"] as? NSNumber{
            
            if let doubleLongitude = Double(exactly: longi){
                self.longitude = doubleLongitude
            }else{
                self.longitude = 0.0
            }
        }else{
            self.longitude = 0.0
        }
        
        if let friendsModel = data["friendModel"] as? [String]{
            self.friendsModel = friendsModel
        }
        
        if let groupID = data["groupID"] as? String
        {
            self.groupID = groupID
        }
        
        if let adId = data["adId"] as? String
        {
            self.adId = adId
        }
        
        if let badges = data["badges"] as? [String: Int]
        {
            self.badges = badges
        }
        
        if let adTitle = data["adTitle"] as? String
        {
            self.adTitle = adTitle
        }
        
        if let adImage = data["adImage"] as? String
        {
            self.adImage = adImage
        }
        
        if let senderEmail = data["senderEmail"] as? String
        {
            self.senderEmail = senderEmail
        }
        
        if let recipientEmail = data["recipientEmail"] as? String
        {
            self.recipientEmail = recipientEmail
        }
        
        if let adCreatedUser = data["adCreatedUser"] as? String
        {
            self.adCreatedUser = adCreatedUser
        }
        
        
        
        if let senderPhone = data["senderPhone"] as? String
        {
            self.senderPhone = senderPhone
        }
        
        
        if let recipientPhone = data["recipientPhone"] as? String
        {
            self.recipientPhone = recipientPhone
        }
        
       
    }
    
    required init(jsonDict: [String: Any]) {
        fatalError()
    }
}

extension GroupChatChannel: DatabaseRepresentation {
    var representation: [String : Any] {
        var rep = ["name": name]
        rep["id"] = id
        return rep
    }
}

extension GroupChatChannel: Comparable {
    
    static func == (lhs: GroupChatChannel, rhs: GroupChatChannel) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func < (lhs: GroupChatChannel, rhs: GroupChatChannel) -> Bool {
        return lhs.name < rhs.name
    }
    
}

protocol DatabaseRepresentation {
    var representation: [String: Any] { get }
}
