//
//  LatestBids.swift
//  ZOOLIFE
//
//  Created by iMac on 01/12/21.
//  Copyright © 2021 Hafiz Anser. All rights reserved.
//

import Foundation

class LatestBids : NSObject, NSCoding{

    var id : Int!
    var createdAt : String!
    var bidAmount : Int!
    var isWinner : Int!
    var name : String!
    var deviceToken : String!
    var auctionExpiryTime : String!
    var phone : String!
    var email : String!
    var username : String!
    var readableTime : String!
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){

        id = dictionary["id"] as? Int
        createdAt = dictionary["created_at"] as? String
        bidAmount = dictionary["bid_amount"] as? Int
        isWinner = dictionary["is_winner"] as? Int
        name = dictionary["name"] as? String
        deviceToken = dictionary["device_token"] as? String
        auctionExpiryTime = dictionary["auction_expiry_time"] as? String
        phone = dictionary["phone"] as? String
        email = dictionary["email"] as? String
        username = dictionary["username"] as? String
        readableTime = dictionary["readable_time"] as? String
        
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if id != nil{
            dictionary["id"] = id
        }
        if createdAt != nil{
            dictionary["created_at"] = createdAt
        }
        if bidAmount != nil{
            dictionary["bid_amount"] = bidAmount
        }
        if isWinner != nil{
            dictionary["is_winner"] = isWinner
        }
        if name != nil{
            dictionary["name"] = name
        }
        if deviceToken != nil{
            dictionary["device_token"] = deviceToken
        }
        if auctionExpiryTime != nil{
            dictionary["auction_expiry_time"] = auctionExpiryTime
        }
        if phone != nil{
            dictionary["phone"] = phone
        }
        if email != nil{
            dictionary["email"] = email
        }
        if username != nil{
            dictionary["username"] = username
        }
        if readableTime != nil{
            dictionary["readable_time"] = readableTime
        }
       
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
    
        id = aDecoder.decodeObject(forKey: "id") as? Int
        createdAt = aDecoder.decodeObject(forKey: "created_at") as? String
        bidAmount = aDecoder.decodeObject(forKey: "bid_amount") as? Int
        isWinner = aDecoder.decodeObject(forKey: "is_winner") as? Int
        name = aDecoder.decodeObject(forKey: "name") as? String
        deviceToken = aDecoder.decodeObject(forKey: "device_token") as? String
        auctionExpiryTime = aDecoder.decodeObject(forKey: "auction_expiry_time") as? String
        phone = aDecoder.decodeObject(forKey: "phone") as? String
        email = aDecoder.decodeObject(forKey: "email") as? String
        username = aDecoder.decodeObject(forKey: "username") as? String
        readableTime = aDecoder.decodeObject(forKey: "readable_time") as? String
       
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if createdAt != nil{
            aCoder.encode(id, forKey: "created_at")
        }
        if bidAmount != nil{
            aCoder.encode(id, forKey: "bid_amount")
        }
        if isWinner != nil{
            aCoder.encode(id, forKey: "is_winner")
        }
        if name != nil{
            aCoder.encode(id, forKey: "name")
        }
        if deviceToken != nil{
            aCoder.encode(id, forKey: "device_token")
        }
        if auctionExpiryTime != nil{
            aCoder.encode(id, forKey: "auction_expiry_time")
        }
        if phone != nil{
            aCoder.encode(id, forKey: "phone")
        }
        if email != nil{
            aCoder.encode(id, forKey: "email")
        }
        if username != nil{
            aCoder.encode(username, forKey: "username")
        }
        if readableTime != nil{
            aCoder.encode(readableTime, forKey: "readable_time")
        }
       
    }
}
