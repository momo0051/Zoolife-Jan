//
//  MessageModel.swift
//  World Guide
//
//  Created by Yousaf Shafiq on 02/09/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import Firebase
import FirebaseFirestore
import MessageKit

class MessageMediaItem: MediaItem {
    var url: URL? = nil
    var image: UIImage? = nil
    var placeholderImage: UIImage
    var size: CGSize
    init(url: URL?, image: UIImage? = nil) {
        self.url = url
        self.image = image
        self.placeholderImage = UIImage(named:"camera-icon") ?? UIImage()
        self.size = CGSize(width:  UIScreen.main.bounds.width - 100, height:  UIScreen.main.bounds.width - 100)
    }
}



class ChatMessage: GenericBaseModel, MessageType {

    var sender: SenderType {
        
        
        let name = "\(atcSender.fullname.prefix(1) ) \(atcSender.fullname.prefix(1) )"
        
        
        
        
        
        return Sender(senderId: String(atcSender.ID! ), displayName: name)
    }

   
    var id: String?
    
    var sentDate: Date
    
    var kind: MessageKind

//    var atcSender: User
//    var recipient: User
  
    var atcSender = User()
    var recipient =  User() //NewFriendModel?
    
    
    var seenByRecipient: Bool?

    var isPinned : Bool?
    
    var messageId: String {
        return id ?? UUID().uuidString
    }
    
    var image: UIImage? = nil {
        didSet {
            self.kind = .photo(MessageMediaItem(url: downloadURL, image: self.image))
        }
    }
    var downloadURL: URL? = nil
    let content: String
    
    
    var isDoc : Bool?

    init(messageId: String, messageKind: MessageKind, createdAt: Date, atcSender: User, recipient: User, seenByRecipient: Bool?,isPinned:Bool,isDoc:Bool) {
        self.id = messageId
        self.kind = messageKind
        self.sentDate = createdAt
        self.atcSender = atcSender
        self.recipient = recipient
        self.seenByRecipient = seenByRecipient
        self.isPinned = isPinned
        self.isDoc = isDoc
 
        switch messageKind {
        case .text(let text):
            self.content = text
    
        default:
            self.content = ""
        }
        
      
    }
    init(user: User,recipient:User, image: UIImage, url: URL,seenByRecipient:Bool,isPinned:Bool,isDoc:Bool) {
        self.image = image
        content = ""
        sentDate = Date()
        id = nil
        let mediaItem = MessageMediaItem(url: url, image: nil)
        self.kind = MessageKind.photo(mediaItem)
        self.atcSender = user
        self.recipient = recipient
        self.seenByRecipient = seenByRecipient
        self.isPinned = isPinned
        self.isDoc = isDoc
    }

    init?(document: QueryDocumentSnapshot,sender:User,reciepient:User) {
        
        let data = document.data()

        guard let timestamp = data["created"] as? Timestamp else {
                   return nil
        }
        
        
        let sentDate = timestamp.dateValue()
        
        guard (data["senderID"] as? String) != nil else {
            return nil
        }
        guard (data["senderDatabaseID"] as? String) != nil else {
            return nil
        }
        guard (data["senderUsername"] as? String) != nil else {
            return nil
        }
//        guard (data["senderLastName"] as? String) != nil else {
//            return nil
//        }
        guard (data["senderProfilePictureURL"] as? String) != nil else {
            return nil
        }
        guard (data["recipientID"] as? String) != nil else {
            return nil
        }
//        guard (data["recipientUsername"] as? String) != nil else {
//            return nil
//        }
//        guard (data["recipientLastName"] as? String) != nil else {
//            return nil
//        }
        guard (data["recipientProfilePictureURL"] as? String) != nil else {
            return nil
        }
        
        
        
        id = document.documentID
        
        if let isDoc = data["isDoc"] as? Bool{
            self.isDoc = isDoc
        }
        else {
            self.isDoc = false
        }
        
        self.sentDate = sentDate
        
        self.atcSender = sender
        self.recipient = reciepient
//        self.atcSender = User(uid: senderID, firstName: senderFirstName, lastName: senderLastName, avatarURL: senderProfilePictureURL)
//        self.recipient = User(uid: recipientID, firstName: recipientFirstName, lastName: recipientLastName, avatarURL: recipientProfilePictureURL)
        
      
        
        
//
        if let content = data["content"] as? String {
  
            if content == "" {
                if let urlString = data["url"] as? String, let url = URL(string: urlString) {
                    downloadURL = url
                    self.content = ""
                    let mediaItem = MessageMediaItem(url: url, image: nil)
                    self.kind = MessageKind.photo(mediaItem)
                }else {
                    return nil
                }
                
            }else{
                self.content = content
                downloadURL = nil
                self.kind = MessageKind.text(content)
            }
            
    
            
        } else if let urlString = data["url"] as? String, let url = URL(string: urlString) {
            downloadURL = url
            self.content = ""
            let mediaItem = MessageMediaItem(url: url, image: nil)
            self.kind = MessageKind.photo(mediaItem)
        } else {
            return nil
        }
        
        if let seenByRecipient = data["seenByRecipient"] as? Bool{
            
            self.seenByRecipient = seenByRecipient
        }
        else {
            
            self.seenByRecipient = true
        }
        
        if let isPin = data["isPinned"] as? Bool{
            self.isPinned = isPin
        }
        else {
            self.isPinned = false
        }
    }
    
    
    required init(jsonDict: [String: Any]) {
        fatalError()
    }
    
    var description: String {
        return self.messageText
    }
    
    var messageText: String {
        switch kind {
        case .text(let text):
            return text
        default:
            return ""
        }
    }
    
    var channelId: String {
        let id1 = "\(recipient.ID!)"
        let id2 = "\(atcSender.ID!)"
        return id1 < id2 ? id1 + id2 : id2 + id1
    }
    
    
   
    
    
    
}

extension ChatMessage: DatabaseRepresentation {
    
    var representation: [String : Any] {
        var rep: [String : Any] = [
            "created": sentDate,
            "senderID":  atcSender.ID!,
            "senderDatabaseID": atcSender.ID!,
            "senderUsername": atcSender.fullname,
            "senderProfilePictureURL": "",
            "recipientID": recipient.ID!,
            "recipientUsername": recipient.fullname,
            "recipientProfilePictureURL":  "",
            "seenByRecipient" : self.seenByRecipient ?? true,
            "isPinned" : self.isPinned ?? false,
            "isDoc" : self.isDoc ?? false
        ]
        
        if let url = downloadURL {
            rep["url"] = url.absoluteString
            rep["content"] = ""
        } else {
            rep["content"] = content
            rep["url"] = ""
        }
        
        return rep
    }
    
}

extension ChatMessage: Comparable {
    
    static func == (lhs: ChatMessage, rhs: ChatMessage) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func < (lhs: ChatMessage, rhs: ChatMessage) -> Bool {
        return lhs.sentDate < rhs.sentDate
    }
}


