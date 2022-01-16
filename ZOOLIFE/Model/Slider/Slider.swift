//
//  Slider.swift
//  ZOOLIFE
//
//  Created by Muhammad Yousaf on 05/01/2021.
//  Copyright © 2021 Hafiz Anser. All rights reserved.
//

import SwiftyJSON
import UIKit


class SliderModel: NSObject{

    var id: Int?
    var image1: String?
    //Done by Shahzaib
    var title: String?
    var sliderDescription: String?
    override init(){
        self.id = 0
        self.image1 = ""
        //Done by Shahzaib
        self.title = ""
        self.sliderDescription = ""
    }
    
    // assign value through dictionary
    init(withDictionary dictionary: [String: JSON])
    {
        //super.init()
        
        if let id = dictionary["id"]?.int{
            self.id = id
        }
        else{
            self.id = 0
        }
        if let image1 = dictionary["image1"]?.string{
            self.image1 = image1
        }
        else{
            self.image1 = ""
        }
        //Done by Shahzaib
        if let title = dictionary["title"]?.string{
            self.title = title
        }else{
            self.title = ""
        }
        
        if let articleDescription = dictionary["description"]?.string{
            self.sliderDescription = articleDescription
        }
        else{
            self.sliderDescription = ""
        }

    }
}
