//
//  Message.swift
//  FirestoreChat
//
//  Created by Admin on 10/1/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

struct MessageViewModel {
    var userName: String
    var text: String
    var avatar: String
    var created: String
    
    init(userName: String, text: String, avatar: String, created: Date)
    {
        self.userName = userName
        self.text = text
        self.avatar = avatar
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        self.created = dateFormatter.string(from: created)
    }
}
