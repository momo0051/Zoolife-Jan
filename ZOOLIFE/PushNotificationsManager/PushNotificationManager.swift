//
//  PushNotificationManager.swift
//  HenaFi
//
//  Created by Yousaf Shafiq on 26/02/2020.
//  Copyright © 2020 Hexa IT Solutions. All rights reserved.
//

import Firebase
import FirebaseFirestore
import FirebaseMessaging
import UIKit
import UserNotifications

class PushNotificationManager: NSObject, MessagingDelegate, UNUserNotificationCenterDelegate {
    let user: UserFirebase
    init(user: UserFirebase) {
        self.user = user
        super.init()
    }
    
    
    func updateFirestorePushTokenIfNeeded() {
        if let token = Messaging.messaging().fcmToken, let uid = user.uid {
            let usersRef = Firestore.firestore().collection("users").document(uid)
            usersRef.setData(["pushToken": token], merge: true)
        }
    }
    
    
    
//    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
//
//
//    }
//
    
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        updateFirestorePushTokenIfNeeded()
    }
    
}




extension PushNotificationManager{
    
    
    
    
    func registerForPushNotifications(){

        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: { granted, error in
        })
        Messaging.messaging().delegate = self
//        Messaging.messaging().shouldEstablishDirectChannel = true

        updateFirestorePushTokenIfNeeded()
        
    }
 
}




