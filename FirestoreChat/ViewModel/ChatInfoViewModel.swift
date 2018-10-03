//
//  ChatInfoViewModel.swift
//  FirestoreChat
//
//  Created by Admin on 10/2/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
class ChatInfoViewModel : ViewModel {
    
    private(set) var chatId: String
    private(set) var description: String
    private(set) var logoUrl: String
    private(set) var users: [User]
    
    init (chatId: String, description: String, logoUrl: String, users: [User]) {
        self.chatId = chatId
        self.description = description
        self.logoUrl = logoUrl
        self.users = users
    }
    
    func loadLogo(completionHandler: @escaping ImageDownloadCompletionClosure)
    {
        super.loadImage(imgString: logoUrl, completionHandler: completionHandler)
    }
    
    func getUsersViewModel() -> UsersViewModel{
        return UsersViewModel(users: self.users)
    }
    
}
