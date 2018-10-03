//
//  ChatViewModel.swift
//  FirestoreChat
//
//  Created by Admin on 9/28/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
class ChatViewModel: ViewModel {
    private var chatId: String
    private var chatDescription: String
    private(set) var items: [MessageViewModel]
    
    init(chatId: String, chatDescription: String)
    {
        self.chatDescription = chatDescription
        self.chatId = chatId
        self.items = []
    }
    
    func getChatDescription() -> String{
        return self.chatDescription
    }
    
    func fetchData(completion: @escaping () -> Void)
    {
        FireStoreService.shared.getMessages(chatId: self.chatId){ messages in
            self.items = messages.flatMap{MessageViewModel(userName: $0.user.userName, text: $0.text, avatar: $0.user.avatarUrl, created: $0.created)}
            completion()
        }
    }

    func addItem(messageText: String) {
        FireStoreService.shared.addMessage(text: messageText, chatId: chatId)
    }

    func checkForUpdates (completion: @escaping () -> Void) {
        FireStoreService.shared.checkForChatUpdates(chatId: chatId) { message in
            self.items.append(MessageViewModel(userName: message.user.userName, text: message.text, avatar: message.user.avatarUrl, created: message.created))
            completion()
        }
    }
    
}
