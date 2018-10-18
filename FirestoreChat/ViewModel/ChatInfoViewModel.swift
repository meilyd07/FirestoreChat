//
//  ChatInfoViewModel.swift
//  FirestoreChat
//
//  Created by Admin on 10/2/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
class ChatInfoViewModel : ViewModel {
    
    //MARK: - private properties
    private(set) var chatId: String
    private(set) var description: String
    private(set) var logoUrl: String
    private(set) var items: [UserViewModel]
    
    //MARK: - initializer
    init (chatId: String, description: String, logoUrl: String) {
        self.chatId = chatId
        self.description = description
        self.logoUrl = logoUrl
        self.items = []
    }
    
    //MARK: - internal methods
    
    func loadLogo(completionHandler: @escaping (_ imageData: Data ) -> Void)
    {
        super.loadImage(imgString: logoUrl, completionHandler: completionHandler)
    }
    
    func fetchData(completion: @escaping (String?) -> Void)
    {
        FireStoreService.shared.getChatUsers(chatId: self.chatId) { (error, chatUsers) in
            if error != nil {
                completion(error)
            } else {
                self.items = chatUsers.flatMap{UserViewModel(userId: $0.userId, userName: $0.userName, avatarUrl: $0.avatarUrl, online: $0.online)}
                completion(nil)
            }
        }
    }
    
    func showUserDetail(index: Int) {
        Router.shared.showUserDetail(viewModel: self.items[index])
    }
}
