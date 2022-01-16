//
//  auctionList.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on November 30, 2021

import Foundation


class auctionList : NSObject, NSCoding{
    
    var allowComments : Int!
    var area : String!
    var auctionExpiryTime : String!
    var category : Int!
    var city : String!
    var country : String!
    var createdAt : String!
    var expiryDays : Int!
    var expiryHours : Int!
    var fromUserId : Int!
    var id : Int!
    var imgUrl : String!
    var videoUrl : String!
    var itemDesc : String!
    var itemTitle : String!
    var latestBid : String!
    var likesCount : Int!
    var maxBid : Int!
    var minBid : Int!
    var modifyAt : Int!
    var phoneViewsCount : Int!
    var postType : String!
    var priority : String!
    var remainingTime : String!
    var removeAt : Int!
    var showComments : Int!
    var showMessage : Int!
    var showPhoneNumber : Int!
    var showWhatsapp : Int!
    var subCategory : Int!
    var updatedAt : String!
    var userName: String!
    var images : [Image]!
    var sex:String?
    var age: Int?
    var passport : String?
    var vaccine_detail : String?
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        allowComments = dictionary["allowComments"] as? Int
        area = dictionary["area"] as? String
        auctionExpiryTime = dictionary["auction_expiry_time"] as? String
        category = dictionary["category"] as? Int
        city = dictionary["city"] as? String
        country = dictionary["country"] as? String
        createdAt = dictionary["created_at"] as? String
        expiryDays = dictionary["expiry_days"] as? Int
        expiryHours = dictionary["expiry_hours"] as? Int
        fromUserId = dictionary["fromUserId"] as? Int
        id = dictionary["id"] as? Int
        imgUrl = dictionary["imgUrl"] as? String
        videoUrl = dictionary["videoUrl"] as? String
        itemDesc = dictionary["itemDesc"] as? String
        itemTitle = dictionary["itemTitle"] as? String
        latestBid = dictionary["latest_bid"] as? String
        likesCount = dictionary["likesCount"] as? Int
        maxBid = dictionary["max_bid"] as? Int
        minBid = dictionary["min_bid"] as? Int
        modifyAt = dictionary["modifyAt"] as? Int
        phoneViewsCount = dictionary["phoneViewsCount"] as? Int
        postType = dictionary["post_type"] as? String
        priority = dictionary["priority"] as? String
        remainingTime = dictionary["remaining_time"] as? String
        removeAt = dictionary["removeAt"] as? Int
        showComments = dictionary["showComments"] as? Int
        showMessage = dictionary["showMessage"] as? Int
        showPhoneNumber = dictionary["showPhoneNumber"] as? Int
        showWhatsapp = dictionary["showWhatsapp"] as? Int
        subCategory = dictionary["subCategory"] as? Int
        updatedAt = dictionary["updated_at"] as? String
        userName = dictionary["username"] as? String
        sex = dictionary["sex"] as? String
        age = dictionary["age"] as? Int
        vaccine_detail = dictionary["vaccine_detail"] as? String
        passport = dictionary["passport"] as? String
        images = [Image]()
        if let imagesArray = dictionary["images"] as? [[String:Any]]{
            for dic in imagesArray{
                let value = Image(fromDictionary: dic)
                images.append(value)
            }
        }
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if allowComments != nil{
            dictionary["allowComments"] = allowComments
        }
        if area != nil{
            dictionary["area"] = area
        }
        if auctionExpiryTime != nil{
            dictionary["auction_expiry_time"] = auctionExpiryTime
        }
        if category != nil{
            dictionary["category"] = category
        }
        if city != nil{
            dictionary["city"] = city
        }
        if country != nil{
            dictionary["country"] = country
        }
        if createdAt != nil{
            dictionary["created_at"] = createdAt
        }
        if expiryDays != nil{
            dictionary["expiry_days"] = expiryDays
        }
        if expiryHours != nil{
            dictionary["expiry_hours"] = expiryHours
        }
        if fromUserId != nil{
            dictionary["fromUserId"] = fromUserId
        }
        if id != nil{
            dictionary["id"] = id
        }
        if imgUrl != nil{
            dictionary["imgUrl"] = imgUrl
        }
        if videoUrl != nil{
            dictionary["videoUrl"] = videoUrl
        }
        if itemDesc != nil{
            dictionary["itemDesc"] = itemDesc
        }
        if itemTitle != nil{
            dictionary["itemTitle"] = itemTitle
        }
        if latestBid != nil{
            dictionary["latest_bid"] = latestBid
        }
        if likesCount != nil{
            dictionary["likesCount"] = likesCount
        }
        if maxBid != nil{
            dictionary["max_bid"] = maxBid
        }
        if minBid != nil{
            dictionary["min_bid"] = minBid
        }
        if modifyAt != nil{
            dictionary["modifyAt"] = modifyAt
        }
        if phoneViewsCount != nil{
            dictionary["phoneViewsCount"] = phoneViewsCount
        }
        if postType != nil{
            dictionary["post_type"] = postType
        }
        if priority != nil{
            dictionary["priority"] = priority
        }
        if remainingTime != nil{
            dictionary["remaining_time"] = remainingTime
        }
        if removeAt != nil{
            dictionary["removeAt"] = removeAt
        }
        if showComments != nil{
            dictionary["showComments"] = showComments
        }
        if showMessage != nil{
            dictionary["showMessage"] = showMessage
        }
        if showPhoneNumber != nil{
            dictionary["showPhoneNumber"] = showPhoneNumber
        }
        if showWhatsapp != nil{
            dictionary["showWhatsapp"] = showWhatsapp
        }
        if subCategory != nil{
            dictionary["subCategory"] = subCategory
        }
        if updatedAt != nil{
            dictionary["updated_at"] = updatedAt
        }
        if userName != nil {
            dictionary["userName"] = userName
        }
        if sex != nil {
            dictionary["sex"] = sex
        }
        if age != nil {
            dictionary["age"] = age
        }
        if vaccine_detail != nil {
            dictionary["vaccine_detail"] = vaccine_detail
        }
        if passport != nil {
            dictionary["passport"] = passport
        }
        if images != nil{
            var dictionaryElements = [[String:Any]]()
            for imagesElement in images {
                dictionaryElements.append(imagesElement.toDictionary())
            }
            dictionary["images"] = dictionaryElements
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        allowComments = aDecoder.decodeObject(forKey: "allowComments") as? Int
        area = aDecoder.decodeObject(forKey: "area") as? String
        auctionExpiryTime = aDecoder.decodeObject(forKey: "auction_expiry_time") as? String
        category = aDecoder.decodeObject(forKey: "category") as? Int
        city = aDecoder.decodeObject(forKey: "city") as? String
        country = aDecoder.decodeObject(forKey: "country") as? String
        createdAt = aDecoder.decodeObject(forKey: "created_at") as? String
        expiryDays = aDecoder.decodeObject(forKey: "expiry_days") as? Int
        expiryHours = aDecoder.decodeObject(forKey: "expiry_hours") as? Int
        fromUserId = aDecoder.decodeObject(forKey: "fromUserId") as? Int
        id = aDecoder.decodeObject(forKey: "id") as? Int
        imgUrl = aDecoder.decodeObject(forKey: "imgUrl") as? String
        videoUrl = aDecoder.decodeObject(forKey: "videoUrl") as? String
        itemDesc = aDecoder.decodeObject(forKey: "itemDesc") as? String
        itemTitle = aDecoder.decodeObject(forKey: "itemTitle") as? String
        latestBid = aDecoder.decodeObject(forKey: "latest_bid") as? String
        likesCount = aDecoder.decodeObject(forKey: "likesCount") as? Int
        maxBid = aDecoder.decodeObject(forKey: "max_bid") as? Int
        minBid = aDecoder.decodeObject(forKey: "min_bid") as? Int
        modifyAt = aDecoder.decodeObject(forKey: "modifyAt") as? Int
        phoneViewsCount = aDecoder.decodeObject(forKey: "phoneViewsCount") as? Int
        postType = aDecoder.decodeObject(forKey: "post_type") as? String
        priority = aDecoder.decodeObject(forKey: "priority") as? String
        remainingTime = aDecoder.decodeObject(forKey: "remaining_time") as? String
        removeAt = aDecoder.decodeObject(forKey: "removeAt") as? Int
        showComments = aDecoder.decodeObject(forKey: "showComments") as? Int
        showMessage = aDecoder.decodeObject(forKey: "showMessage") as? Int
        showPhoneNumber = aDecoder.decodeObject(forKey: "showPhoneNumber") as? Int
        showWhatsapp = aDecoder.decodeObject(forKey: "showWhatsapp") as? Int
        subCategory = aDecoder.decodeObject(forKey: "subCategory") as? Int
        updatedAt = aDecoder.decodeObject(forKey: "updated_at") as? String
        userName = aDecoder.decodeObject(forKey: "userName") as? String
        sex = aDecoder.decodeObject(forKey: "sex") as? String
        age = aDecoder.decodeObject(forKey: "age") as? Int
        vaccine_detail = aDecoder.decodeObject(forKey: "vaccine_detail") as? String
        passport = aDecoder.decodeObject(forKey: "passport") as? String
        images = aDecoder.decodeObject(forKey: "images") as? [Image]
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if allowComments != nil{
            aCoder.encode(allowComments, forKey: "allowComments")
        }
        if area != nil{
            aCoder.encode(area, forKey: "area")
        }
        if auctionExpiryTime != nil{
            aCoder.encode(auctionExpiryTime, forKey: "auction_expiry_time")
        }
        if category != nil{
            aCoder.encode(category, forKey: "category")
        }
        if city != nil{
            aCoder.encode(city, forKey: "city")
        }
        if country != nil{
            aCoder.encode(country, forKey: "country")
        }
        if createdAt != nil{
            aCoder.encode(createdAt, forKey: "created_at")
        }
        if expiryDays != nil{
            aCoder.encode(expiryDays, forKey: "expiry_days")
        }
        if expiryHours != nil{
            aCoder.encode(expiryHours, forKey: "expiry_hours")
        }
        if fromUserId != nil{
            aCoder.encode(fromUserId, forKey: "fromUserId")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if imgUrl != nil{
            aCoder.encode(imgUrl, forKey: "imgUrl")
        }
        if videoUrl != nil{
            aCoder.encode(videoUrl, forKey: "videoUrl")
        }
        if itemDesc != nil{
            aCoder.encode(itemDesc, forKey: "itemDesc")
        }
        if itemTitle != nil{
            aCoder.encode(itemTitle, forKey: "itemTitle")
        }
        if latestBid != nil{
            aCoder.encode(latestBid, forKey: "latest_bid")
        }
        if likesCount != nil{
            aCoder.encode(likesCount, forKey: "likesCount")
        }
        if maxBid != nil{
            aCoder.encode(maxBid, forKey: "max_bid")
        }
        if minBid != nil{
            aCoder.encode(minBid, forKey: "min_bid")
        }
        if modifyAt != nil{
            aCoder.encode(modifyAt, forKey: "modifyAt")
        }
        if phoneViewsCount != nil{
            aCoder.encode(phoneViewsCount, forKey: "phoneViewsCount")
        }
        if postType != nil{
            aCoder.encode(postType, forKey: "post_type")
        }
        if priority != nil{
            aCoder.encode(priority, forKey: "priority")
        }
        if remainingTime != nil{
            aCoder.encode(remainingTime, forKey: "remaining_time")
        }
        if removeAt != nil{
            aCoder.encode(removeAt, forKey: "removeAt")
        }
        if showComments != nil{
            aCoder.encode(showComments, forKey: "showComments")
        }
        if showMessage != nil{
            aCoder.encode(showMessage, forKey: "showMessage")
        }
        if showPhoneNumber != nil{
            aCoder.encode(showPhoneNumber, forKey: "showPhoneNumber")
        }
        if showWhatsapp != nil{
            aCoder.encode(showWhatsapp, forKey: "showWhatsapp")
        }
        if subCategory != nil{
            aCoder.encode(subCategory, forKey: "subCategory")
        }
        if updatedAt != nil{
            aCoder.encode(updatedAt, forKey: "updated_at")
        }
        if userName != nil{
            aCoder.encode(userName, forKey: "userName")
        }
        if sex != nil{
            aCoder.encode(sex, forKey: "sex")
        }
        if age != nil{
            aCoder.encode(age, forKey: "age")
        }
        if vaccine_detail != nil{
            aCoder.encode(vaccine_detail, forKey: "vaccine_detail")
        }
        if passport != nil{
            aCoder.encode(passport, forKey: "passport")
        }
        if images != nil{
            aCoder.encode(images, forKey: "images")
        }
    }
}
