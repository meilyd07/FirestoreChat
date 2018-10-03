//
//  User.swift
//  FirestoreChat
//
//  Created by Admin on 9/28/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
/*struct User {
    private(set) var userId: String
    private(set) var userName: String
    private(set) var avatarUrl: String
    
    init(userId: String, userName: String, avatarUrl: String)
    {
        self.userId = userId
        self.userName = userName
        self.avatarUrl = avatarUrl
    }
}*/

protocol DocumentSerializable {
    init?(documentId: String, dictionary:[String:Any])
}

struct User {
    private(set) var userId: String
    private(set) var userName: String
    private(set) var avatarUrl: String
    private(set) var online: Bool
    
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
