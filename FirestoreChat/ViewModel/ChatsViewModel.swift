//
//  ChatsViewModel.swift
//  FirestoreChat
//
//  Created by Admin on 9/27/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

class ChatsViewModel: ViewModel {
    
    //MARK: - private properties
    private(set) var items = [Chat]()
    
    //MARK: - internal methods
    func fetchData(completion: @escaping (String?) -> Void)
    {
        FireStoreService.shared.getChats{ (error, chats) in
            if error != nil {
                completion(error)
            }
            else {
                self.items = chats
                completion(nil)
            }
        }
    }
    
    func showChat(index: Int)
    {
        let chatViewModel = ChatViewModel(chatId: self.items[index].chatId, chatDescription: self.items[index].description)
        Router.shared.showChat(viewModel: chatViewModel)
    }
    
    func showChatInfo(index: Int)
    {
        let chatInfoViewModel = ChatInfoViewModel(chatId: self.items[index].chatId, description: self.items[index].description, logoUrl: self.items[index].logoUrl)
        Router.shared.showChatInfo(viewModel: chatInfoViewModel)
    }
    
}




