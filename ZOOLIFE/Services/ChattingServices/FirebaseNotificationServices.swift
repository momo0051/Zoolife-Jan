//
//  FirebaseNotificationServices.swift
//  World Guide
//
//  Created by Yousaf Shafiq on 02/09/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import Firebase
import FirebaseFirestore
import FirebaseDatabase

class FirebaseNotificationServices {
    
    static func fetchUser(userID: String, completion: @escaping (_ user: UserFirebase?) -> Void) {
        let usersRef = Firestore.firestore().collection("users").whereField("userID", isEqualTo: userID)
        usersRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                return
            }
            guard let querySnapshot = querySnapshot else {
                return
            }
            if let document = querySnapshot.documents.first {
                let data = document.data()
                let user = UserFirebase(representation: data)
                completion(user)
            } else {
                completion(nil)
            }
        }
    }
    
    
    
    static func notificationStatus(groupId:String,user: UserFirebase, completion: @escaping (_ success: Bool) -> Void) {
        
        let participentRef = Firestore.firestore().collection(group_participent).whereField("group", isEqualTo: groupId).whereField("user", isEqualTo: user.uid!)
        participentRef.getDocuments { (querySnapshot, error) in
            
            if let snapShot = querySnapshot {
                
                if let document = snapShot.documents.first{
                    
                    //print(document.documentID)
                    
                    var isNotify = false
                    
                    let data = document.data()
                    
                    if let isNotification = data["isNotification"] as? Bool {
                        
                        if isNotification{
                            isNotify = false
                        }else{
                            isNotify = true
                        }
                        
                    }else{
                        isNotify = false
                        //Just set it false currently false
                        
                    }
                    
                    
                    let newParticipentRef = Firestore.firestore().collection(group_participent).document(document.documentID)
                    
                    let updatesValue = ["isNotification":isNotify] as [String : Any]
                    
                    newParticipentRef.setData(updatesValue, merge: true)
                    
                    completion(true)
                }
            }else{
                completion(true)
            }
            
        }
        
        
        
        //
        //        let usersRef = Firestore.firestore().collection(users)
        //        usersRef.getDocuments { (querySnapshot, error) in
        //            if let error = error {
        //                return
        //            }
        //            guard let querySnapshot = querySnapshot else {
        //                return
        //            }
        //            var users: [User] = []
        //            let documents = querySnapshot.documents
        //            for document in documents {
        //                let data = document.data()
        //                let user = User(representation: data)
        //                if user.uid != viewer.uid {
        //                    users.append(user)
        //                }
        //            }
        //            completion(users)
        //        }
    }
    
    
    
    
    static func getGroupParticipent(groupId:String, completion: @escaping (_ groupParticipent: [GroupParticipent]) -> Void) {
        
        let participentRef = Firestore.firestore().collection(group_participent).whereField("group", isEqualTo: groupId)
        participentRef.getDocuments { (querySnapshot, error) in
            var groupParticipent:[GroupParticipent] = []
            if let snapShot = querySnapshot {
                
                
                
                for document in snapShot.documents{
                    
                    let data = document.data()
                    
                    groupParticipent.append(GroupParticipent(representation: data))
                    
                    
                }
                
                completion(groupParticipent)
                
            }else{
                completion(groupParticipent)
            }
        }
    }
    
    

    static func checkUserCreate(sender:User,recipient:User,post: Ad,completion: @escaping (String?) -> Void) {
      
        var senderFirebaseId = ""
        var reciepientFirebaseId = ""
//
//        var array = [String]()

        guard let senderId = sender.ID else {
            return
        }

        guard let recipientId = recipient.ID else {
            return
        }
//
//        if senderId > recipientId{
//            array.append(recipientId)
//            array.append(senderId)
//        }
//        else
//        {
//            array.append(senderId)
//            array.append(recipientId)
//        }
        
        var arrayInt:[Int] = []
        
        var adIdd = ""
        
        if let adIds = post.id{
            adIdd = adIds
        }else{
            completion(nil)
            return
        }
        
        
        if let userId:Int = Int(senderId){
            arrayInt.append(userId)
        }
        if let friendId:Int = Int(recipientId){
            arrayInt.append(friendId)
        }
        
        arrayInt = arrayInt.sorted()
        
        
        
        let stringArray = arrayInt.map { String($0) }
        
        
        
        
        let fcmToken = getFCMToken()
        
        let groupRef = Firestore.firestore().collection(groups)
        
        groupRef.whereField("friendModel", isEqualTo: stringArray).whereField("adId", isEqualTo: adIdd).getDocuments { (querySnapshot, error) in
            if error != nil {
                print("error",error?.localizedDescription)
                return
            }
            if let snapshot = querySnapshot
            {
                if snapshot.count > 0
                {
                    if let document = snapshot.documents.first
                    {
                       
                        print(document.documentID)
                        
                        completion(document.documentID)
                    }
//                    let data = ["adId": adId]
//
//                    document?.reference.updateData(data)
                    
//                    completion(true)
                }
                else
                {
                    
                    let userRef = Firestore.firestore().collection(users)
                    
                    
                    userRef.whereField("databaseID", isEqualTo:senderId).getDocuments(completion: { (querySnapshot, error) in
                        if error != nil {
                            print("error",error?.localizedDescription)
                            return
                        }
                        if let snapShot = querySnapshot {
                            
                            if snapShot.count == 0{
                                //createUser
                                
                                
                                let usersReference = Firestore.firestore().collection(users)
                                let newusersReference = usersReference.document()
                                let data = ["databaseID":senderId,
                                            "email":sender.email!,
                                            "fullName":sender.fullname,
                                            "online":true,
                                            "token":fcmToken,
                                            "lastActive":Date(),
                                            "userID":newusersReference.documentID
                                    ] as [String : Any]
                                newusersReference.setData(data) { (error) in
                                    
                                    senderFirebaseId = newusersReference.documentID
                                    
                                    if error != nil {
                                        return
                                    }
                                    userRef.whereField("databaseID", isEqualTo: recipientId).getDocuments(completion: { (querySnapshot, error) in
                                        if error != nil {
                                            print("error",error?.localizedDescription)
                                            return
                                        }
                                        if let snapShot = querySnapshot {
                                            if snapShot.count == 0{
                                                //createUser
                                                let usersReference = Firestore.firestore().collection(users)
                                                let newusersReference = usersReference.document()
                                                let data = ["databaseID":recipientId,
                                                            "email":recipient.email,
                                                            "fullName":recipient.fullname,
                                                            "online":true,
                                                            "token":"My Token",
                                                            "lastActive":Date(),
                                                            "userID":newusersReference.documentID
                                                    ] as [String : Any]
                                                
                                                newusersReference.setData(data) { (error) in
                                                    reciepientFirebaseId = newusersReference.documentID
                                                    
                                                    if error != nil {
                                                        return
                                                    }
                                                    
                                                    
                                                    //
                                                    //Here we will send request to create groups with all ids
                                                    
                                                    FirebaseNotificationServices.createGroup(sender: sender, recipient: recipient, senderFirebaseId: senderFirebaseId, receipientFirebaseId: reciepientFirebaseId, post: post) { (success) in
                                                        
                                                        if let success = success{
                                                            
                                                            print("documnt id after creating group", success)
                                                            
                                                            completion(success)
                                                            
//                                                            if success{
//
//                                                                completion(true)
//
//                                                            }else{
//                                                                //showalert
//                                                            }
                                                            
                                                        }
                                                        else
                                                        {
                                                            completion(nil)
                                                        }
                                                    }
                                                    
                                                    
                                                }
                                                
                                                
                                            }else{
                                                //No Need just create participent in groupparticiept and make chatting
                                                if let document = snapShot.documents.first{
                                                    let data = document.data()
                                                    if let senderFireId = data["userID"] as? String {
                                                        reciepientFirebaseId = senderFireId
                                                    }
                                                }
                                                
                                                
                                                
                                                
                                                //Here we will send request to create groupswith all ids
                                                
                                                FirebaseNotificationServices.createGroup(sender: sender, recipient: recipient, senderFirebaseId: senderFirebaseId, receipientFirebaseId: reciepientFirebaseId, post: post) { (success) in
                                                    
                                                    
                                                    if let success = success{
                                                        
                                                        print("documnt id after creating group", success)
                                                        
                                                        completion(success)
                                                        
//                                                            if success{
//
//                                                                completion(true)
//
//                                                            }else{
//                                                                //showalert
//                                                            }
                                                        
                                                    }
                                                    else
                                                    {
                                                        completion(nil)
                                                    }
                                                }
                                            }
                                            
                                        }
                                        
                                        
                                    })
                                    
                                }
                            }else{
                                //No Need just create participent in groupparticiept and make chatting
                                
                                if let document = snapShot.documents.first{
                                    let data = document.data()
                                    if let senderFireId = data["userID"] as? String {
                                        senderFirebaseId = senderFireId
                                    }
                                }
                                
                                userRef.whereField("databaseID", isEqualTo: recipientId).getDocuments(completion: { (querySnapshot, error) in
                                    if error != nil {
                                        print("error",error?.localizedDescription)
                                        return
                                    }
                                    if let snapShot = querySnapshot {
                                        if snapShot.count == 0{
                                            //createUser
                                            let usersReference = Firestore.firestore().collection(users)
                                            let newusersReference = usersReference.document()
                                            let data = ["databaseID":recipientId,
                                                        "email":recipient.email!,
                                                        "fullName":recipient.fullname,
                                                        "online":true,
                                                        "token":"My Token",
                                                        "lastActive":Date(),
                                                        "userID":newusersReference.documentID
                                                ] as [String : Any]
                                            
                                            newusersReference.setData(data) { (error) in
                                                reciepientFirebaseId = newusersReference.documentID
                                                if error != nil {
                                                    return
                                                }
                                                
                                                
                                                //
                                                //Here we will send request to create groups with all ids
                                                
                                                FirebaseNotificationServices.createGroup(sender: sender, recipient: recipient, senderFirebaseId: senderFirebaseId, receipientFirebaseId: reciepientFirebaseId, post: post) { (success) in
                                                    
                                                    
                                                    if let success = success{
                                                        
                                                        print("documnt id after creating group", success)
                                                        
                                                        completion(success)
                                                        
//                                                            if success{
//
//                                                                completion(true)
//
//                                                            }else{
//                                                                //showalert
//                                                            }
                                                        
                                                    }
                                                    else
                                                    {
                                                        completion(nil)
                                                    }
                                                }
                                            }
                                            
                                            
                                        }else{
                                            //No Need just create participent in groupparticiept and make chatting
                                            
                                            
                                            
                                            if let document = snapShot.documents.first{
                                                let data = document.data()
                                                if let senderFireId = data["userID"] as? String {
                                                    reciepientFirebaseId = senderFireId
                                                }
                                            }
                                            
                                            
                                            
                                            //Here we will send request to create groups
                                            
                                            FirebaseNotificationServices.createGroup(sender: sender, recipient: recipient, senderFirebaseId: senderFirebaseId, receipientFirebaseId: reciepientFirebaseId, post: post) { (success) in
                                                
                                                
                                                if let success = success{
                                                    
                                                    
                                                    print("documnt id after creating group", success)
                                                    
                                                    completion(success)
                                                    
//                                                            if success{
//
//                                                                completion(true)
//
//                                                            }else{
//                                                                //showalert
//                                                            }
                                                    
                                                }
                                                else
                                                {
                                                    completion(nil)
                                                }
                                            }
                                        }
                                        
                                    }
                                    
                                    
                                })
                                
                                
                            }
                        }
                    })

                }
            }
            
        }

        
    }
    
    
    
    static func createGroup(sender:User,recipient:User,senderFirebaseId:String,receipientFirebaseId:String,post: Ad, completion: @escaping (String?) -> Void) {
       // let channelParticipationRef = Firestore.firestore().collection(group_participent)
        let channelsRef = Firestore.firestore().collection(groups)

        
        var arrayInt:[Int] = []
        
       
        
        
        if let userId:Int = Int(sender.ID!){
            arrayInt.append(userId)
        }
        if let friendId:Int = Int(recipient.ID!){
            arrayInt.append(friendId)
        }
        
        arrayInt = arrayInt.sorted()
        
        let stringArray = arrayInt.map { String($0) }
        
        
        
        let newChannelRef = channelsRef.document()
        let channelDict: [String: Any] = [
            "lastMessage": "No message",
            "groupID": newChannelRef.documentID,
            "groupImage": "no image",
            "senderName":sender.fullname,
            "recipientName":recipient.fullname,
            "senderEmail": sender.email!,
            "recipientEmail": recipient.email!,
            
            "senderPhone": sender.phone!,
            "recipientPhone": recipient.phone!,
           
            "lastMessageDate":Date(),
            "friendModel":stringArray,
            "badges" : [
                sender.ID: 1,
                recipient.ID : 1],
            "adId": post.id!,
            "adTitle": post.itemTitle ?? "",
            "adImage": post.imgUrl ?? "",
            "adCreatedUser": post.username!
        ]

        newChannelRef.setData(channelDict) { (error) in
            
            if error != nil {
                completion(nil)
//                completion(newChannelRef.documentID)
//                completion(true)
            }else{
                completion(newChannelRef.documentID)
//                completion(nil)
            }
            
//            if error != nil {
//
//                completion(newChannelRef.documentID)
////                completion(true)
//            }else{
//                completion(nil)
//            }
        }
        
 
    }
    
    static func fetchChannel(channelId: String, completion: @escaping (_ channel: GroupChatChannel?) -> Void) {
        let channelsRef = Firestore.firestore().collection(groups).document(channelId)
        channelsRef.getDocument { (snapshotDocument, error) in
          if error != nil {
            return
          }
          guard let document = snapshotDocument else { return }
          if let channel = GroupChatChannel(document: document){
            completion(channel)
          }
          else {
            completion(nil)
            return
          }
        }
      }
    
    
    
    static func fetchChannelsUser(user: User, completion: @escaping (_ channels: [GroupChatChannel]) -> Void) {
        
        guard let userId = user.ID else{
            completion([])
            return
        }
        
        let ref = Firestore.firestore().collection(groups).whereField("friendModel",arrayContains: userId)

        let channelsRef = Firestore.firestore().collection(groups)
        let usersRef = Firestore.firestore().collection(users)
        
        ref.getDocuments { (querySnapshot, error) in
            if error != nil {
                return
            }
            guard let querySnapshot = querySnapshot else { return }
            var channels: [GroupChatChannel] = []
            let documents = querySnapshot.documents
            if (documents.count == 0) {
                completion([])
                return
            }
            for document in documents {
              //  let data = document.data()
                
                
                if let channel = GroupChatChannel(document: document){
                    
                    
                    channels.append(channel)
                    
                    if channels.count == documents.count {
                        
                        completion(self.sort(channels: channels))
                    }
                }
                
                
//                if let channelID = data[group] as? String {
//                    channelsRef
//                        .document(channelID)
//                        .getDocument(completion: { (document, error) in
//
//                            if let document = document, let channel = GroupChatChannel(document: document) {
//                                let otherUsers = Firestore.firestore().collection(group_participent).whereField(group, isEqualTo: channel.id)
//                                otherUsers.getDocuments(completion: { (snapshot, error) in
//                                    guard let snapshot = snapshot else { return }
//                                    let docs = snapshot.documents
//                                    var participants: [UserFirebase] = []
//                                    var channelParticiants : [GroupParticipent] = []
//                                    if docs.count == 0 {
//                                        completion([])
//                                        return
//                                    }
//                                    for doc in docs {
//                                        let data = doc.data()
//                                        channelParticiants.append(GroupParticipent(representation: data))
//
//                                        if let userID = data["user"] as? String {
//                                            usersRef
//                                                .document(userID)
//                                                .getDocument(completion: { (document, error) in
//                                                    if let document = document,
//                                                        let rep = document.data() {
//                                                        participants.append(UserFirebase(representation: rep))
//                                                        if participants.count == docs.count {
//                                                            channel.participants = participants
//                                                            channel.groupParticipent = channelParticiants
//                                                            print(channel.name)
//
//                                                            channels.append(channel)
//
//                                                            if channels.count == documents.count {
//
//                                                                completion(self.sort(channels: channels))
//                                                            }
//                                                        }
//                                                    }
//                                                })
//                                        }
//                                    }
//                                })
//                            } else {
//                                completion([])
//                                return
//                            }
//                        })
//                }
                
                else {
                    completion([])
                    return
                }
            }
        }
    }
    
    
    
//
//    static func fetchChannelsUser(user: User, completion: @escaping (_ channels: [GroupChatChannel]) -> Void) {
//        let ref = Firestore.firestore().collection(group_participent).whereField("userDatabaseID", isEqualTo: String(user.ID!))
//
////        usersRef
////            .whereField("followers", arrayContains: "l47GVBdjsabjdjds")
//        let channelsRef = Firestore.firestore().collection(groups)
//        let usersRef = Firestore.firestore().collection(users)
//
//        ref.getDocuments { (querySnapshot, error) in
//            if error != nil {
//                return
//            }
//            guard let querySnapshot = querySnapshot else { return }
//            var channels: [GroupChatChannel] = []
//            let documents = querySnapshot.documents
//            if (documents.count == 0) {
//                completion([])
//                return
//            }
//            for document in documents {
//                let data = document.data()
//                if let channelID = data[group] as? String {
//                    channelsRef
//                        .document(channelID)
//                        .getDocument(completion: { (document, error) in
//
//                            if let document = document, let channel = GroupChatChannel(document: document) {
//                                let otherUsers = Firestore.firestore().collection(group_participent).whereField(group, isEqualTo: channel.id)
//                                otherUsers.getDocuments(completion: { (snapshot, error) in
//                                    guard let snapshot = snapshot else { return }
//                                    let docs = snapshot.documents
//                                    var participants: [UserFirebase] = []
//                                    var channelParticiants : [GroupParticipent] = []
//                                    if docs.count == 0 {
//                                        completion([])
//                                        return
//                                    }
//                                    for doc in docs {
//                                        let data = doc.data()
//                                        channelParticiants.append(GroupParticipent(representation: data))
//
//                                        if let userID = data["user"] as? String {
//                                            usersRef
//                                                .document(userID)
//                                                .getDocument(completion: { (document, error) in
//                                                    if let document = document,
//                                                        let rep = document.data() {
//                                                        participants.append(UserFirebase(representation: rep))
//                                                        if participants.count == docs.count {
//                                                            channel.participants = participants
//                                                            channel.groupParticipent = channelParticiants
//                                                            print(channel.name)
//
//                                                            channels.append(channel)
//
//                                                            if channels.count == documents.count {
//
//                                                                completion(self.sort(channels: channels))
//                                                            }
//                                                        }
//                                                    }
//                                                })
//                                        }
//                                    }
//                                })
//                            } else {
//                                completion([])
//                                return
//                            }
//                        })
//                } else {
//                    completion([])
//                    return
//                }
//            }
//        }
//    }
    
    
    static func sort(channels: [GroupChatChannel]) -> [GroupChatChannel] {
          return channels.sorted(by: {$0.lastMessageDate > $1.lastMessageDate})
      }
    
    
    
    
    
    static func fetchUserChannel(user: User,friend:User, adId: String?, completion: @escaping (_ channels: GroupChatChannel?) -> Void) {
        
        var arrayInt:[Int] = []
        
        var adIdd = ""
        
        if let adIds = adId{
            adIdd = adIds
        }else{
            completion(nil)
            return
        }
        
        
        if let userId:Int = Int(user.ID!){
            arrayInt.append(userId)
        }
        if let friendId:Int = Int(friend.ID!){
            arrayInt.append(friendId)
        }
        
        arrayInt = arrayInt.sorted()
        
        
        
        let stringArray = arrayInt.map { String($0) }
        
      
        
        let channelsRef = Firestore.firestore().collection(groups).whereField("friendModel", isEqualTo: stringArray).whereField("adId", isEqualTo: adIdd)
        
        
        
        
        
        //let usersRef = Firestore.firestore().collection(users)
        
        channelsRef.getDocuments { (snapShots, error) in
            
            if let document = snapShots?.documents.first{
                if let channel = GroupChatChannel(document: document) {
                    completion(channel)
                    return
                }else{
                    completion(nil)
                    return
                }
            }else{
                completion(nil)
                return
            }
            
            
        }
        
        
        
        
        
//        ref.getDocuments { (querySnapshot, error) in
//            if error != nil {
//                return
//            }
//            guard let querySnapshot = querySnapshot else { return }
//            var channels: [GroupChatChannel] = []
//            let documents = querySnapshot.documents
//            if (documents.count == 0) {
//                completion([])
//                return
//            }
//            for document in documents {
//                let data = document.data()
//                if let channelID = data[group] as? String {
//                    channelsRef
//                        .document(channelID)
//                        .getDocument(completion: { (document, error) in
//
//                            if let document = document, let channel = GroupChatChannel(document: document) {
//                                let otherUsers = Firestore.firestore().collection(group_participent).whereField(group, isEqualTo: channel.id)
//                                otherUsers.getDocuments(completion: { (snapshot, error) in
//                                    guard let snapshot = snapshot else { return }
//                                    let docs = snapshot.documents
//                                    var participants: [User] = []
//                                    var channelParticiants : [GroupParticipent] = []
//                                    if docs.count == 0 {
//                                        completion([])
//                                        return
//                                    }
//                                    for doc in docs {
//                                        let data = doc.data()
//                                        channelParticiants.append(GroupParticipent(representation: data))
//
//                                        if let userID = data["user"] as? String {
//                                            usersRef
//                                                .document(userID)
//                                                .getDocument(completion: { (document, error) in
//                                                    if let document = document,
//                                                        let rep = document.data() {
//                                                        participants.append(User(representation: rep))
//                                                        if participants.count == docs.count {
//                                                            channel.participants = participants
//                                                            channel.groupParticipent = channelParticiants
//                                                            print(channel.name)
//
//                                                            channels.append(channel)
//
//                                                            if channels.count == documents.count {
//
//                                                                completion(self.sort(channels: channels))
//                                                            }
//                                                        }
//                                                    }
//                                                })
//                                        }
//                                    }
//                                })
//                            } else {
//                                completion([])
//                                return
//                            }
//                        })
//                } else {
//                    completion([])
//                    return
//                }
//            }
//        }
    }
        
}


//
//
//public static void createGroup(final FriendRequest friendRequest) {
//    // Create a new group to be stored in Group Collection
//    Group group = new Group("", "", "",
//                            new Timestamp(new Date()),
//                            Data.getInstance().getCurrentCurrentUserLoginRes().firstName + " " + Data.getInstance().getCurrentCurrentUserLoginRes().lastName,
//                            friendRequest.senderUser.firstName + " " + friendRequest.senderUser.lastName
//    );
//    // Add it
//    Collections.groupsRef.add(group)
//        .addOnCompleteListener(new OnCompleteListener<DocumentReference>() {
//            @Override
//            public void onComplete(@NonNull Task<DocumentReference> task) {
//                if (task.isSuccessful()) {
//                    final String groupId = task.getResult().getId();
//
//                    task.getResult().update(Group.GROUP_ID, groupId);
//
//                    // Get the ID of the current user or create a new user
//                    getUserId(Data.getInstance().getCurrentCurrentUserLoginRes().toUser(), new OnCompleteWithDataCallback<String>() {
//                        @Override
//                        public void onComplete(String s) {
//                            // And create a new group participation
//                            GroupParticipation groupParticipation1 = new GroupParticipation(groupId, s, Integer.toString(Data.getInstance().getCurrentCurrentUserLoginRes().id));
//                            Collections.groupParticipationRef.add(groupParticipation1);
//                        }
//                    });
//
//                    // Repeat for other user
//                    getUserId(friendRequest.senderUser, new OnCompleteWithDataCallback<String>() {
//                        @Override
//                        public void onComplete(String s) {
//                            GroupParticipation groupParticipation2 = new GroupParticipation(groupId, s, Integer.toString(friendRequest.senderUser.id));
//                            Collections.groupParticipationRef.add(groupParticipation2);
//                        }
//                    });
//                }
//            }
//        });
//}
//
//public static void getUserId(final org.worldguide.worldguide.models.User user, final OnCompleteWithDataCallback<String> onCompleteWithDataCallback) {
//    // Run the query for the database ID
//    Collections.usersRef.whereEqualTo(User.DATABASE_ID, Integer.toString(user.id)).get()
//        .addOnCompleteListener(new OnCompleteListener<QuerySnapshot>() {
//            @Override
//            public void onComplete(@NonNull Task<QuerySnapshot> task) {
//                if (task.isSuccessful()) {
//                    // If no document exists,
//                    if (task.getResult().getDocuments().size() == 0) {
//                        // Save a new user
//                        // TODO: Profile Pic
//                        saveCurrentUser(Integer.toString(user.id), user.email, user.firstName, user.lastName, "", new OnCompleteWithDataCallback<String>() {
//                            @Override
//                            public void onComplete(String s) {
//                                if (onCompleteWithDataCallback != null)
//                                onCompleteWithDataCallback.onComplete(s);
//                            }
//                        });
//                    }
//                    else {
//                        // Else return the existing one
//                        DocumentSnapshot document = task.getResult().getDocuments().get(0);
//
//                        if (onCompleteWithDataCallback != null)
//                        onCompleteWithDataCallback.onComplete(document.getString(User.USER_ID));
//                    }
//                }
//            }
//        });
//}
//public static void saveCurrentUser(final String databaseId, final String email, final String firstName, final String lastName, final String profilePictureUrl, final OnCompleteWithDataCallback<String> onCompleteWithDataCallback) {
//    FirebaseInstanceId.getInstance().getInstanceId()
//        .addOnCompleteListener(new OnCompleteListener<InstanceIdResult>() {
//            @Override
//            public void onComplete(@NonNull Task<InstanceIdResult> task) {
//                if (task.isSuccessful()) {
//                    String token = task.getResult().getToken();
//
//                    User user = new User(databaseId, email, firstName, lastName, profilePictureUrl, "", false, new Timestamp(new Date()), token);
//                    Collections.usersRef.add(user)
//                        .addOnCompleteListener(new OnCompleteListener<DocumentReference>() {
//                            @Override
//                            public void onComplete(@NonNull Task<DocumentReference> task) {
//                                if (task.isSuccessful()) {
//                                    task.getResult().update(User.USER_ID, task.getResult().getId());
//
//                                    if (onCompleteWithDataCallback != null)
//                                    onCompleteWithDataCallback.onComplete(task.getResult().getId());
//                                }
//                            }
//                        });
//                }
//            }
//        });
//}

