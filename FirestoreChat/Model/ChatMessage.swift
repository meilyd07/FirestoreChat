//
//  ChatMessage.swift
//  FirestoreChat
//
//  Created by Admin on 9/28/18.
//  Copyright © 2018 Admin. All rights reserved.
//
import Foundation

struct ChatMessage {
    private(set) var documentId: String
    private(set) var text: String
    private(set) var created: Date
    private(set) var userName: String
    private(set) var userId: String
    
    
    var dictionary:[String:Any] {
        return [
            "name": userName,
            "userId": userId,
            "created": created,
            "text": text
        ]
    }
}

extension ChatMessage: DocumentSerializable {
    
    init?(documentId: String, dictionary: [String : Any]) {
        guard let userName = dictionary["name"] as? String,
        let userId = dictionary["userId"] as? String,
        let created = dictionary["created"] as? Date,
        let text = dictionary["text"] as? String
            else {
                return nil
        }
        
        self.init(documentId: documentId, text: text, created: created, userName: userName, userId: userId)
    }
}


