//
//  Articles.swift
//  ZOOLIFE
//
//  Created by Muhammad Yousaf on 21/12/2020.
//  Copyright © 2020 Hafiz Anser. All rights reserved.
//

import Foundation
import SwiftyJSON
import UIKit


class Articles: NSObject{

    var id: Int?
    var title: String?
    var articleDescription: String?
    var image1: String?
    var image2: String?
    var image3: String?
    var date: String?
    var status: String?
    
    
    override init(){
        //super.init()

        self.id = 0
        self.title = ""
        self.articleDescription = ""
        self.image1 = ""
        self.image2 = ""
        self.image3 = ""
        self.date = ""
        self.status = ""
    }
    
    // assign value through dictionary
    init(withDictionary dictionary: [String: JSON]){
        
        if let id = dictionary["id"]?.int{
            self.id = id
        }else{
            self.id = 0
        }
        
        if let title = dictionary["title"]?.string{
            self.title = title
        }else{
            self.title = ""
        }
        
        if let articleDescription = dictionary["description"]?.string{
            self.articleDescription = articleDescription
        }
        else{
            self.articleDescription = ""
        }
        
        if let image1 = dictionary["image1"]?.string{
            self.image1 = image1
        }else{
            self.image1 = ""
        }
        if let image2 = dictionary["image2"]?.string{
            self.image2 = image2
        }else{
            self.image2 = ""
        }
        if let image3 = dictionary["image3"]?.string{
            self.image3 = image3
        }else{
            self.image3 = ""
        }
        
        if let date = dictionary["date"]?.string{
            self.date = date
        }else{
            self.date = ""
        }
        if let status = dictionary["status"]?.string{
            self.status = status
        }else{
            self.status = ""
        }
    }
}


