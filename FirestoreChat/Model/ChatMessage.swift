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
    private(set) var user: User
    private(set) var chatId: String
    private(set) var text: String
    private(set) var created: Date
}
