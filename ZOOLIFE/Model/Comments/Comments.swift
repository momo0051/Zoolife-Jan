//
//  Comments.swift
//  ZOOLIFE
//
//  Created by Muhammad Yousaf on 01/12/2020.
//  Copyright © 2020 Hafiz Anser. All rights reserved.
//

import Foundation
import SwiftyJSON
import UIKit


class Comments: NSObject
{
    var id: String?
    var itemId: String?
    var userId: String?
    var message: String?
    var co: String?
    var uo: String?
    var username: String?
    var userEmail: String?
    var avatar : String?
    
    
    override init(){
        //super.init()

        self.id = ""
        self.itemId = ""
        self.userId = ""
        self.message = ""
        self.co = ""
        self.uo = ""
        self.username = ""
        self.userEmail = ""
        
        self.avatar = ""
    }
    
    // assign value through dictionary
    init(withDictionary dictionary: [String: JSON]){
        
        if let id = dictionary["id"]?.string{
            self.id = id
        }
        else{
            self.id = ""
        }
        if let itemId = dictionary["itemId"]?.string{
            self.itemId = itemId
        }
        else{
            self.itemId = ""
        }
        if let userId = dictionary["userId"]?.string{
            self.userId = userId
        }
        else{
            self.userId = ""
        }
        if let message = dictionary["message"]?.string{
            self.message = message
        }
        else{
            self.message = ""
        }
        if let co = dictionary["co"]?.string{
            self.co = co
        }
        else{
            self.co = ""
        }
        if let uo = dictionary["uo"]?.string{
            self.uo = uo
        }
        else{
            self.uo = ""
        }
        if let userFullname = dictionary["user_name"]?.string{
            self.username = userFullname
        }
        else{
            self.username = ""
        }
        if let userEmail = dictionary["userEmail"]?.string{
            self.userEmail = userEmail
        }
        else{
            self.userEmail = ""
        }
        if let avatar = dictionary["avatar"]?.string{
            self.avatar = avatar
        }
        else{
            self.avatar = ""
        }
    }
}


