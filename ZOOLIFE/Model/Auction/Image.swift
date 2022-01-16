//
//  Image.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on December 1, 2021

import Foundation


class Image : NSObject, NSCoding{

    var fileName : String!
    var id : Int!
    var itemId : Int!
    var status : String!
    var uploadedOn : String!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        fileName = dictionary["file_name"] as? String
        id = dictionary["id"] as? Int
        itemId = dictionary["item_id"] as? Int
        status = dictionary["status"] as? String
        uploadedOn = dictionary["uploaded_on"] as? String
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if fileName != nil{
            dictionary["file_name"] = fileName
        }
        if id != nil{
            dictionary["id"] = id
        }
        if itemId != nil{
            dictionary["item_id"] = itemId
        }
        if status != nil{
            dictionary["status"] = status
        }
        if uploadedOn != nil{
            dictionary["uploaded_on"] = uploadedOn
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        fileName = aDecoder.decodeObject(forKey: "file_name") as? String
        id = aDecoder.decodeObject(forKey: "id") as? Int
        itemId = aDecoder.decodeObject(forKey: "item_id") as? Int
        status = aDecoder.decodeObject(forKey: "status") as? String
        uploadedOn = aDecoder.decodeObject(forKey: "uploaded_on") as? String
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if fileName != nil{
            aCoder.encode(fileName, forKey: "file_name")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if itemId != nil{
            aCoder.encode(itemId, forKey: "item_id")
        }
        if status != nil{
            aCoder.encode(status, forKey: "status")
        }
        if uploadedOn != nil{
            aCoder.encode(uploadedOn, forKey: "uploaded_on")
        }
    }
}