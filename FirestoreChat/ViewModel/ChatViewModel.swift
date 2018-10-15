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
    
    func getAvatar(userId: String)->String
    {
        return FireStoreService.shared.getAvatarUrl(userId: userId)
    }
    
    
    func fetchData(completion: @escaping (String?) -> Void)
    {
        FireStoreService.shared.getMessages(chatId: self.chatId){ (error, messages)   in
            if error != nil {
                completion(error)
            } else {
                self.items = messages.flatMap{MessageViewModel(userName: $0.userName, text: $0.text, created: $0.created, userId: $0.userId)}
                completion(nil)
            }
        }
    }

    
    func addItem(messageText: String, completion: @escaping (String?) -> Void) {
        FireStoreService.shared.addMessage(text: messageText, chatId: chatId) {
            error in
            if error != nil {
                completion(error)
            }
            else {
                completion(nil)
            }
        }
    }

    func checkForUpdates (completion: @escaping (String?) -> Void) {
        FireStoreService.shared.checkForChatUpdates(chatId: chatId) { (error, messages) in
            if error != nil {
                completion(error)
            }
            else {
                for message in messages {
                    self.items.append(MessageViewModel(userName: message.userName, text: message.text, created: message.created, userId: message.userId))
                }
                completion(nil)
            }
        }
    }
    
}
