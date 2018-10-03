//
//  ChatsViewModel.swift
//  FirestoreChat
//
//  Created by Admin on 9/27/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation


class ChatsViewModel: ViewModel {
    private(set) var items = [Chat]()
    
    func fetchData(completion: @escaping () -> Void)
    {
        FireStoreService.shared.getChats{ chats in
            self.items = chats
            completion()
        }
    }
    
    /*func updateData(completion: @escaping () -> Void)
    {
        FireStoreService.shared.checkForChatUpdates{ newChats in
            self.items += newChats
            completion()
        }
    }*/
    
    
    /*func getChatInfoModel() -> ChatInfoViewModel {
        return ChatInfoViewModel(chatId: viewModel.items[indexPath.row].chatId, description: viewModel.items[indexPath.row].description, logoUrl: viewModel.items[indexPath.row].logoUrl, users: viewModel.items[indexPath.row].users)

    }*/
}




