//
//  Notification.swift
//  ZOOLIFE
//
//  Created by Hafiz Anser  on 11/29/20.
//  Copyright © 2020 Hafiz Anser. All rights reserved.
//

import Foundation

import SwiftyJSON
import UIKit

class NotificationModel: NSObject{
  
    var user_id: Int?
    var ads_id: Int?
    var sender_id: Int?
    var isread: Int?

    var content: String?
    var created_at: String?
    
    override init(){

        self.user_id = 0
        self.ads_id = 0
        self.sender_id = 0
        self.isread = 0
        self.content = ""
        self.created_at = ""
    }
    
    // assign value through dictionary
    init(withDictionary dictionary: [String: JSON]){

        if let content = dictionary["content"]?.string{
            self.content = content
        }
        else{
            self.content = ""
        }
        if let created_at = dictionary["created_at"]?.string{
            self.created_at = created_at
        }
        else{
            self.created_at = ""
        }
        if let user_id = dictionary["user_id"]?.int{
            self.user_id = user_id
        }
        else{
            self.user_id = 0
        }
        
        if let ads_id = dictionary["ads_id"]?.int{
            self.ads_id = ads_id
        }
        else{
            self.ads_id = 0
        }
        if let sender_id = dictionary["sender_id"]?.int{
            self.sender_id = sender_id
        }
        else{
            self.sender_id = 0
        }
        
        if let isread = dictionary["isread"]?.int{
            self.isread = isread
        }
        else{
            self.isread = 0
        }
    }
}
