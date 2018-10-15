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
    var created: String
    var userId: String
    
    init(userName: String, text: String, created: Date, userId: String)
    {
        self.userName = userName
        self.text = text
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        self.created = dateFormatter.string(from: created)
        self.userId = userId
    }
}
