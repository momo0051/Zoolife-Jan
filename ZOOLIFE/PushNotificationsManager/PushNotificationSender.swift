//
//  PushNotificationSender.swift
//  HenaFi
//
//  Created by Yousaf Shafiq on 26/02/2020.
//  Copyright © 2020 Hexa IT Solutions. All rights reserved.
//

import Foundation
import UIKit

class PushNotificationSender {
    
    func sendPushNotification(to token: String, title: String, body: String,badges:Int,identifier:String,groupId: String) {
        
        print("da token de",token)
        let urlString = "https://fcm.googleapis.com/fcm/send"
        let url = NSURL(string: urlString)!
        
        guard let user = AppUtility.getSession()
        else
        {
            return
        }

        let paramString: [String: Any] = [
            "to": token,
            "notification": [
                "body": body,
                "title": title,
                "sound": "default"
            ],
            "data": [
                "data": [
                    "user_email":user.email!,
                    "group_id":groupId,
                    "identifier": identifier
                ]
            ]
        ]
        
        print("notification params",paramString)
                
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject:paramString, options: [.prettyPrinted])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=\(FirebasePushServerKey)", forHTTPHeaderField: "Authorization")
        
        let task =  URLSession.shared.dataTask(with: request as URLRequest)  { (data, response, error) in
            do {
                if let jsonData = data {
                    if let jsonDataDict  = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
                        NSLog("Received data:\n\(jsonDataDict))")
                    }
                }
            } catch let err as NSError {
                print(err.debugDescription)
            }
        }
        task.resume()
    }
}
