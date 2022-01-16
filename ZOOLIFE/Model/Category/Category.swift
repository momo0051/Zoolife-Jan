//
//  Category.swift
//  ZOOLIFE
//
//  Created by Hafiz Anser  on 11/29/20.
//  Copyright © 2020 Hafiz Anser. All rights reserved.
//

import Foundation
import SwiftyJSON
import UIKit


class Category: NSObject
{
    var id: String?
    var mainCategoryId: String?
    var title: String?
    var img_selected: String?
    var img_unSelected: String?
    
    override init()
    {
        //super.init()

        self.id = ""
        self.mainCategoryId = ""
        self.title = ""
        self.img_selected = ""
        self.img_unSelected = ""
    }
    
    // assign value through dictionary
    init(withDictionary dictionary: [String: JSON])
    {
        //super.init()
        
        if let id = dictionary["id"]?.int
        {
            
            self.id = String(id)
        }
        else
        {
            self.id = ""
        }
        if let mainCategoryId = dictionary["mainCategoryId"]?.string
        {
            self.mainCategoryId = mainCategoryId
        }
        else
        {
            self.mainCategoryId = ""
        }

        if let title = dictionary["title"]?.string
        {
            self.title = title
        }
        else
        {
            self.title = ""
        }
        

        if let img_selected = dictionary["img_selected"]?.string
        {
            self.img_selected = img_selected
        }
        else
        {
            self.img_selected = ""
        }

        if let img_unSelected = dictionary["img_unSelected"]?.string
        {
            self.img_unSelected = img_unSelected
        }
        else
        {
            self.img_unSelected = ""
        }
    }
}





