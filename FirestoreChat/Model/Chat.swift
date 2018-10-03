//
//  Chat.swift
//  FirestoreChat
//
//  Created by Admin on 9/27/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

struct Chat {
    private(set) var chatId: String
    private(set) var description: String
    private(set) var logoUrl: String
    private(set) var users: [User]
    private(set) var messages:[ChatMessage]
}
