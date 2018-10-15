//
//  User.swift
//  FirestoreChat
//
//  Created by Admin on 9/28/18.
//  Copyright © 2018 Admin. All rights reserved.
//

protocol DocumentSerializable {
    init?(documentId: String, dictionary:[String:Any])
}

struct User {
    var userId: String
    var userName: String
    var avatarUrl: String
    var online: Bool
    
    var dictionary:[String:Any] {
        return [
            "name": userName,
            "avatarUrl" : avatarUrl,
            "online": online
            ]
    }
}

extension User: DocumentSerializable {
    init?(documentId: String, dictionary: [String: Any]) {
        guard let userName = dictionary["name"] as? String,
            let avatarUrl = dictionary["avatarUrl"] as? String,
            let online = dictionary["online"] as? Bool
        else {
                return nil
        }
        
        self.init(userId: documentId, userName: userName, avatarUrl: avatarUrl, online: online)
    }
}
