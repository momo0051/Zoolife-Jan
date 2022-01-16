//
//  Ad.swift
//  ZOOLIFE
//
//  Created by Hafiz Anser  on 11/29/20.
//  Copyright © 2020 Hafiz Anser. All rights reserved.
//

import Foundation
import SwiftyJSON
import UIKit

class Ad: NSObject{
    
    
    
    var priority = ""// "priority": "4",
    var related_add :[RelatedAds] = []
        
    var report_status:String?

    
    var id: String?
    
    var username:String?
    var email: String?
    var phone: String?
    var category: String?
    var subCategory: String?
    var phoneNumber: String?
    var likesCount: String?
    var viewsCount: String?
    var commentsCount: String?
    var rating: String?
    var itemTitle: String?
    var itemDesc: String?
    var itemContent: String?
    var previewImgUrl: String?
    var imgUrl: String?
    var country: String?
    var city: String?
    var showPhoneNumber: String?
    var showMessage: String?
    var showWhatsapp: String?
    var createAt: String?

    var arrImages:NSMutableArray?
    
    var userId: String?
    var itemId: String?
    var itemImage: String?
    var co: String?
    var uo: String?
    var fromUserId : String?
    var deviceToken : String?
    var created_at : String?
    var images : [String] = []
    var favrtitem_status : String?
    
    var likeitem_status : String?
    var showComments:String?
    
    var sex:String?
    var age: Int?
    var passport : String?
    var vaccine_detail : String?

    override init()
    {
        //super.init()

        self.report_status = "0"
        self.favrtitem_status = "0"
        self.id = ""
        self.username = "N/A"
        self.email = "N/A"
        self.phone = "N/A"
        self.category = ""
        self.subCategory = ""
        self.phoneNumber = ""
        
        self.likesCount = ""
        self.viewsCount = ""
        self.commentsCount = ""
        self.rating = ""
        
        
        self.itemTitle = ""
        self.itemDesc = ""
        self.itemContent = ""
        self.previewImgUrl = ""
        
        self.imgUrl = ""
        self.country = ""
        self.city = ""
        self.showPhoneNumber = ""
        
        self.showMessage = ""
        self.showWhatsapp = ""
        self.showComments = ""
        self.createAt = ""
        
        self.arrImages = NSMutableArray()
        
        
        
        self.userId = ""
        
        self.itemId = ""
        self.itemImage = ""
        self.co = ""
        self.uo = ""
        
        self.fromUserId = ""
        self.deviceToken = ""
   
        created_at = ""
        
        self.likeitem_status = ""
        
        self.images = []
        self.related_add = []
        self.sex = ""
        self.age = 0
        self.passport = ""
        self.vaccine_detail = ""
    }
    
    // assign value through dictionary
    init(withDictionary dictionary: [String: JSON])
    {
        //super.init()
        
        
        
        if let priority = dictionary["priority"]?.string{
            self.priority = priority
        }
        else{
            self.priority = ""
        }
        
        
        if let id = dictionary["id"]?.int //Ad ID
        {
            self.id = String(id)
        }
        else
        {
            self.id = ""
        }
        
        if let username = dictionary["userName"]?.string
        {
            self.username = username
        }
        else if let username = dictionary["username"]?.string
        {
            self.username = username
        }
        else
        {
            self.username = "N/A"
        }
        
        if let email = dictionary["email"]?.string
        {
            self.email = email
        }
        else
        {
            self.email = "N/A"
        }
        
        if let phone = dictionary["phone"]?.string
        {
            self.phone = phone
        }
        else
        {
            self.phone = "N/A"
        }
        
        if let category = dictionary["category"]?.int
        {
            self.category = String(category)
        }
        else
        {
            self.category = ""
        }

        if let subCategory = dictionary["subCategory"]?.int
        {
            self.subCategory = String(subCategory)
        }
        else
        {
            self.subCategory = ""
        }
        if let phoneNumber = dictionary["phoneNumber"]?.string
        {
            self.phoneNumber = phoneNumber
        }
        else
        {
            self.phoneNumber = ""
        }
    

        if let likesCount = dictionary["likesCount"]?.int
        {
            self.likesCount = String(likesCount)
        }
        else
        {
            self.likesCount = ""
        }
        if let viewsCount = dictionary["viewsCount"]?.string
        {
            self.viewsCount = viewsCount
        }
        else
        {
            self.viewsCount = ""
        }

        if let commentsCount = dictionary["commentsCount"]?.string
        {
            self.commentsCount = commentsCount
        }
        else
        {
            self.commentsCount = ""
        }

        
        if let rating = dictionary["rating"]?.string
        {
            self.rating = rating
        }
        else
        {
            self.rating = ""
        }


        if let itemTitle = dictionary["itemTitle"]?.string
        {
            self.itemTitle = itemTitle
        }
        else
        {
            self.itemTitle = ""
        }
        if let itemDesc = dictionary["itemDesc"]?.string
        {
            self.itemDesc = itemDesc
        }
        else
        {
            self.itemDesc = ""
        }

        if let itemContent = dictionary["itemContent"]?.string
        {
            self.itemContent = itemContent
        }
        else
        {
            self.itemContent = ""
        }
        if let previewImgUrl = dictionary["previewImgUrl"]?.string
        {
            self.previewImgUrl = previewImgUrl
        }
        else
        {
            self.previewImgUrl = ""
        }
    

        if let imgUrl = dictionary["imgUrl"]?.string
        {
            self.imgUrl = imgUrl
        }
        else
        {
            self.imgUrl = ""
        }
        if let country = dictionary["country"]?.string
        {
            self.country = country
        }
        else
        {
            self.country = ""
        }

        if let city = dictionary["city"]?.string
        {
            self.city = city
        }
        else
        {
            self.city = ""
        }
        if let showPhoneNumber = dictionary["showPhoneNumber"]?.int
        {
            self.showPhoneNumber = String(showPhoneNumber)
        }
        else
        {
            self.showPhoneNumber = ""
        }
        if let showMessage = dictionary["showMessage"]?.int
        {
            self.showMessage = String(showMessage)
        }
        else
        {
            self.showMessage = ""
        }
//        print("showWhatsapp ----  dictionary \(dictionary["showWhatsapp"])")
        if let showWhatsapp = dictionary["showWhatsapp"]?.int
        {
            self.showWhatsapp = String(showWhatsapp)
        }
        else
        {
            self.showWhatsapp = "0"
        }

        if let showComments = dictionary["showComments"]?.int{
            self.showComments = String(showComments)
        }
        else{
            self.showComments = ""
        }
        if let sex = dictionary["sex"]?.string{
            self.sex = sex
        }
        else{
            self.sex = ""
        }
        if let age = dictionary["age"]?.int{
            self.age = age
        }
        else{
            self.age = 0
        }
        if let passport = dictionary["passport"]?.string{
            self.passport = passport
        }
        else{
            self.passport = ""
        }
        if let vaccineDetail = dictionary["vaccine_detail"]?.string{
            self.vaccine_detail = vaccineDetail
        }
        else{
            self.vaccine_detail = ""
        }
        
        if let createAt = dictionary["createAt"]?.string
        {
            self.createAt = createAt
        }
        else
        {
            self.createAt = ""
        }
        
        
        
        if let userId = dictionary["userId"]?.int
        {
            self.userId = String(userId)
        }
        else
        {
            self.userId = ""
        }
        
        if let itemId = dictionary["itemId"]?.int
        {
            self.itemId = String(itemId)
        }
        else
        {
            self.itemId = ""
        }
        
        if let fromUserId = dictionary["fromUserId"]?.int
        {
            self.fromUserId = String(fromUserId)
        }
        else
        {
            self.fromUserId = ""
        }
        
        
        if let itemImage = dictionary["itemImage"]?.string
        {
            self.itemImage = itemImage
        }
        else
        {
            self.itemImage = ""
        }
        
        
        if let co = dictionary["co"]?.string
        {
            self.co = co
        }
        else
        {
            self.co = ""
        }
        
        
        if let uo = dictionary["uo"]?.string
        {
            self.uo = uo
        }
        else
        {
            self.uo = ""
        }
        
        if let deviceToken = dictionary["device_token"]?.string
        {
            self.deviceToken = deviceToken
        }
        else
        {
            self.deviceToken = ""
        }
        
        if let created_at = dictionary["created_at"]?.string
        {
            self.created_at = created_at
        }
        else
        {
            self.created_at = ""
        }
        print(dictionary)
        if dictionary["favrtitem_status"] != nil {
            self.favrtitem_status = "\(dictionary["favrtitem_status"]!)"
        }
        if dictionary["report_status"] != nil {
            self.report_status = "\(dictionary["report_status"]!)"
        }
        
        if dictionary["likeitem_status"] != nil {
            self.likeitem_status = "\(dictionary["likeitem_status"]!)"
        }
        
        if let images = dictionary["images"]?.arrayObject as? [String]{
              self.images = images
            }
            else{
              self.images = []
            }
        
        if let related_ads = dictionary["related_add"]{
 
            if let dictionary = related_ads.array{
                
//                if let jsonResponse = dictionary as? [[String:JSON]]{
//                    print("json is ",jsonResponse)
//                }
                
                print("dictionary is",dictionary)
                
                for dict in dictionary{
                    
                    if let objectDictionary = dict.dictionary {
                        self.related_add.append(RelatedAds.init(withDictionary: objectDictionary))
                    }
                    
//                 //   dic
//                    if let object = dict as? [String:JSON]{
//
//
//                        print("object is ",object)
//                    }
                    
                }
                
            }
            
          
        
            
//
////            related_ads.dictionary
//            if let dictionaruy = related_ads.dictionaryValue{
//                print("done")
//                print(dictionaruy)
////                self.related_add = dictionaruy
//
//
//
//
//
//
//                RelatedAds(withDictionary: <#T##[String : JSON]#>)
//                var relatedADD = [RelatedAds]()
//                for dict in dictionaruy{
//
//
//                   // let id = dict["id"] as? String
//
//                    let relatedPost = RelatedAds()
//
////                    if let id = dict["id"].
//
////                    //if let id = dict["id"].
////                    relatedPost.id = dict["id"].string
////                    relatedPost.imgUrl = dict["imgUrl"].string
////                    relatedADD.append(relatedPost)
//
//                    print(relatedPost)
//                }
//
//                print(relatedADD)
//
//                self.related_add = relatedADD
//
////
////                [["imgUrl": 1607371501.png, "id": 163], ["imgUrl": 1607648296.png, "id": 214]]
////
////                if let objexts = dic
////
////
//
//            }
//

             // self.related_add = related_ads
            }
            else{
              self.related_add = []
            }
        
//        if let related_ads = dictionary["related-add"]?.arrayObject as? [RelatedAds]{
//         self.related_add = related_ads
//       }
//       else{
//         self.related_add = []
//       }
//
    
        print("nameprint ---- \(self.itemTitle) ---- \(self.id)")
        if let lId = self.id
        {
            if lId.compare("811").rawValue == 0
            {
                
            }
            
        }
        print(imgUrl)
        if (imgUrl == nil )
        {
            if self.images.count > 0
            {
                self.imgUrl = self.images[0]
            }
        }//||
        
        
        if (imgUrl!.compare("").rawValue == 0)
        {
            if self.images.count > 0
            {
                self.imgUrl = self.images[0]
            }
        }
        
        
    }
}






class RelatedAds: NSObject{
    
    var id: String?
    var imgUrl: String?
    var itemTitle: String?
    var createdAt: String?
    var city: String?

    override init(){
        self.imgUrl = ""
        self.id = ""
        self.itemTitle = ""
        self.createdAt = ""
        self.city = ""
    }
    
    // assign value through dictionary
    init(withDictionary dictionary: [String: JSON]){
        
        
        if let id = dictionary["id"]?.int{
            self.id = String(id)
        }
        else{
            self.id = ""
        }
        
        if let itemTitle = dictionary["itemTitle"]?.string{
            self.itemTitle = itemTitle
        }
        else{
            self.itemTitle = ""
        }
        
        if let createdAt = dictionary["created_at"]?.string{
            self.createdAt = createdAt
        }
        else{
            self.createdAt = ""
        }
        
        if let city = dictionary["city"]?.string{
            self.city = city
        }
        else{
            self.city = ""
        }
        
        if let imgUrl = dictionary["imgUrl"]?.string{
            self.imgUrl = imgUrl
        }
        else{
            self.imgUrl = ""
        }
    }
}
