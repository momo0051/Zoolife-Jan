//
//  ChatFirebaseManager.swift
//  World Guide
//
//  Created by Yousaf Shafiq on 02/09/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import Firebase
import FirebaseFirestore

class ChatFirebaseManager {

    static func fetchAllChannels( completion: @escaping (_ channels: [GroupChatChannel]) -> Void) {

        var allGroups = [GroupChatChannel]()
        
        let channelsRef = Firestore.firestore().collection(groups)
        
        channelsRef.getDocuments { (querySnapShot, error) in
            
            guard let documents = querySnapShot?.documents else {
                completion([])
                return
            }
        
            if (documents.count == 0) {
                completion([])
                return
            }
        
            for (index,document) in documents.enumerated(){
                allGroups.append(GroupChatChannel(document: document)!)
                if index == documents.count - 1{
                    completion(allGroups)
                }
            }
        }
    }
    
    
    
    
    
    static func addUserInGroup(groupID:String,user: UserFirebase, completion: @escaping (_ added: Bool) -> Void) {
        
        
        let checkRef = Firestore.firestore().collection(group_participent).whereField(group, isEqualTo: groupID).whereField("user", isEqualTo: user.uid!)
        
        
        
        checkRef.getDocuments { (snapShots,error) in
            
            if let document = snapShots?.documents{
            
                if document.count == 0 {
                    let channelParticipationRef = Firestore.firestore().collection(group_participent)
                         
                             let doc: [String: Any] = [
                                 "group": groupID,
                                 "user": user.uid ?? "",
                                 "userAddedTime": Date(),
                                 "isNotification":true
                             ]
                             channelParticipationRef.addDocument(data: doc, completion: { (error) in
                                
                                 if error == nil {
                                      completion(true)
                                    return
                                 }else{
                                      completion(false)
                                    return
                                 }
                            })
                }else{
                    completion(true)
                    return
                }
            }
            
        }
        
     
        
    }
    
    
    
    
    static func addUserInGroupLocation(groupID:String,user: UserFirebase, completion: @escaping (_ added: Bool) -> Void) {
        
        let checkRef = Firestore.firestore().collection(group_participent).whereField(group, isEqualTo: groupID).whereField("user", isEqualTo: user.uid!)
        checkRef.getDocuments { (snapShots,error) in
            
            if let document = snapShots?.documents{
            
                if document.count == 0 {
                    let channelParticipationRef = Firestore.firestore().collection(group_participent)
                         
                             let doc: [String: Any] = [
                                 "group": groupID,
                                 "user": user.uid ?? "",
                                 "userAddedTime": Date(),
                                 "isNotification":true
                             ]
                             channelParticipationRef.addDocument(data: doc, completion: { (error) in
                                
                                 if error == nil {
                                      completion(true)
                                    return
                                 }else{
                                      completion(false)
                                    return
                                 }
                            })
                }else{
                    completion(false)
                    return
                }
            }
            
        }
        
     
        
    }
    
    

    
    static func fetchChannels(user: UserFirebase, completion: @escaping (_ channels: [GroupChatChannel]) -> Void) {
        guard let uid = user.uid else { return }
        let ref = Firestore.firestore().collection(group_participent).whereField("user", isEqualTo: uid)
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
                let data = document.data()
                if let channelID = data[group] as? String {
                    channelsRef
                        .document(channelID)
                        .getDocument(completion: { (document, error) in
                            
                            if let document = document, let channel = GroupChatChannel(document: document) {
                                let otherUsers = Firestore.firestore().collection(group_participent).whereField(group, isEqualTo: channel.id)
                                otherUsers.getDocuments(completion: { (snapshot, error) in
                                    guard let snapshot = snapshot else { return }
                                    let docs = snapshot.documents
                                    var participants: [UserFirebase] = []
                                    var channelParticiants : [GroupParticipent] = []
                                    if docs.count == 0 {
                                        completion([])
                                        return
                                    }
                                    for doc in docs {
                                        let data = doc.data()
                                        channelParticiants.append(GroupParticipent(representation: data))
                                                                              
                                        if let userID = data["user"] as? String {
                                            usersRef
                                                .document(userID)
                                                .getDocument(completion: { (document, error) in
                                                    if let document = document,
                                                        let rep = document.data() {
                                                        participants.append(UserFirebase(representation: rep))
                                                        if participants.count == docs.count {
                                                            channel.participants = participants
                                                            channel.groupParticipent = channelParticiants
                                                            print(channel.name)
                                                            
                                                            channels.append(channel)
                                                            
                                                            if channels.count == documents.count {
                                                                
                                                                completion(self.sort(channels: channels))
                                                            }
                                                        }
                                                    }
                                                })
                                        }
                                    }
                                })
                            } else {
                                completion([])
                                return
                            }
                        })
                } else {
                    completion([])
                    return
                }
            }
        }
    }
    
    static func fetchChannelsUsers(user: UserFirebase, completion: @escaping (_ channels: [GroupChatChannel]) -> Void) {
        guard let uid = user.uid else { return }
        let ref = Firestore.firestore().collection("channel_userchat_participation").whereField("user", isEqualTo: uid)
        let channelsRef = Firestore.firestore().collection("channels_userchat")
        let usersRef = Firestore.firestore().collection("users")
        
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
                let data = document.data()
                if let channelID = data["channel"] as? String {
                    channelsRef
                        .document(channelID)
                        .getDocument(completion: { (document, error) in
                            if let document = document, var channel = GroupChatChannel(document: document) {
                                let otherUsers = Firestore.firestore().collection("channel_userchat_participation").whereField("channel", isEqualTo: channel.id)
                                otherUsers.getDocuments(completion: { (snapshot, error) in
                                    guard let snapshot = snapshot else { return }
                                    let docs = snapshot.documents
                                    var participants: [UserFirebase] = []
                                    var channelParticiants : [GroupParticipent] = []
                                    
                                    if docs.count == 0 {
                                        completion([])
                                        return
                                    }
                                    for doc in docs {
                                        let data = doc.data()
                                        
                                        channelParticiants.append(GroupParticipent(representation: data))
                                        
                                        
                                        if let userID = data["user"] as? String {
                                            
                                            
                                            usersRef
                                                .document(userID)
                                                .getDocument(completion: { (document, error) in
                                                    if let document = document,
                                                        let rep = document.data() {
                                                        participants.append(UserFirebase(representation: rep))
                                                        
                                                        
                                                        if participants.count == docs.count {
                                                            channel.participants = participants
                                                            
                                                            channel.groupParticipent = channelParticiants
                                                            //print(channel.name)
                                                            
//                                                            if let adminBadges = UserDefaults.standard.object(forKey: "badgecount") as? Int {
//                                                                UserDefaults.standard.set(channel.adminBadges+adminBadges, forKey: "badgecount")
//                                                            }
//                                                            else {
//                                                                UserDefaults.standard.set(channel.adminBadges, forKey: "badgecount")
//                                                            }
                                                            //
                                                            
                                                            print("count Badge",channel.adminBadges)
                                                            
                                                            channels.append(channel)
                                                            
                                                            if channels.count == documents.count {
                                                                completion(self.sort(channels: channels))
                                                            }
                                                        }
                                                    }
                                                })
                                        }
                                    }
                                })
                            } else {
                                completion([])
                                return
                            }
                        })
                } else {
                    completion([])
                    return
                }
            }
        }
    }
        
    static func leaveGroup(channel: GroupChatChannel, user: UserFirebase, completion: @escaping (_ success: Bool) -> Void) {
        guard let uid = user.uid else {
            return
        }
        let ref = Firestore.firestore().collection(group_participent).whereField("user", isEqualTo: uid).whereField("group", isEqualTo: channel.id)
        ref.getDocuments { (snapshot, error) in
            if let snapshot = snapshot {
                snapshot.documents.forEach({ (document) in
                    Firestore.firestore().collection(group_participent).document(document.documentID).delete { (e) in
                        
                        if e == nil{
                          //  NotificationCenter.default.post(Notification.init(name: Notification.Name.init("reloadChats")))
                            completion(true)
                            return
                        }else{
                            completion(true)
                            return
                        }
                    }
                })
            }else {
                completion(true)
                return
            }
        }
    }
    
    
    static func updateChannelParticipationIfNeeded(channel: GroupChatChannel) {
        if channel.participants.count != 2 {
            return
        }
        guard let uid1 = channel.participants.first?.uid, let uid2 = channel.participants[1].uid else { return }
        self.updateChannelParticipationIfNeeded(channel: channel, uID: uid1)
        self.updateChannelParticipationIfNeeded(channel: channel, uID: uid2)
    }
    
    static func updateChannelParticipationIfNeeded(channel: GroupChatChannel, uID: String) {
        let ref1 = Firestore.firestore().collection(group_participent).whereField("user", isEqualTo: uID).whereField("group", isEqualTo: channel.id)
        ref1.getDocuments { (querySnapshot, error) in
            if (querySnapshot?.documents.count == 0) {
                let data: [String: Any] = [
                    "user": uID,
                    "group": channel.id
                ]
                Firestore.firestore().collection(group_participent).addDocument(data: data) { (e) in
                    if e == nil{
                        NotificationCenter.default.post(Notification.init(name: Notification.Name.init("reloadChats")))
                        
                        NotificationCenter.default.post(Notification.init(name: Notification.Name.init("reloadChats")))
                    }
                }
            }
        }
    }

    
    
    static func sort(channels: [GroupChatChannel]) -> [GroupChatChannel] {
        return channels.sorted(by: {$0.lastMessageDate > $1.lastMessageDate})
    }
    
    
    
    
    
    
    
    static func createGroup(channelImage:String,groupName:String,creator: UserFirebase, friends: Set<UserFirebase>, completion: @escaping (_ channel: GroupChatChannel?) -> Void) {
        guard let uid = creator.uid else { return }
        let channelParticipationRef = Firestore.firestore().collection(group_participent)
        let channelsRef = Firestore.firestore().collection(groups)
        

        
        let newChannelRef = channelsRef.document()
        let channelDict: [String: Any] = [
            "lastMessage": "No message",
            "name": groupName,
            "creator_id": uid,
            "groupID": newChannelRef.documentID,
            "groupImage": channelImage,
            "senderName":"",
            "recipientName":"",
            "lastMessageDate":""
        ]
        newChannelRef.setData(channelDict)
        
        let allFriends = [creator] + Array(friends)
        var count = 0
        allFriends.forEach { (friend) in
            let doc: [String: Any] = [
                "group": newChannelRef.documentID,
                "user": friend.uid ?? "",
                "userDatabaseID":""
            ]
            channelParticipationRef.addDocument(data: doc, completion: { (error) in
                count += 1
                if count == allFriends.count {
                    newChannelRef.getDocument(completion: { (snapshot, error) in
                        guard let snapshot = snapshot else { return }
                        completion(GroupChatChannel(document: snapshot))
                    })
                }
            })
        }
    }
    
}




