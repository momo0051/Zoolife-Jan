//
//  SubCategory.swift
//  ZOOLIFE
//
//  Created by Hafiz Anser  on 11/29/20.
//  Copyright © 2020 Hafiz Anser. All rights reserved.
//

import Foundation
import SwiftyJSON
import UIKit

class SubCategory: NSObject{
    
    var id: String?
    var mainCategoryId: String?
    var title: String?
    
    override init()
    {
        //super.init()

        self.id = ""
        self.mainCategoryId = ""
        self.title = ""
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
    }
}




