//
//  UserViewModel.swift
//  FirestoreChat
//
//  Created by Admin on 10/1/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
class UserViewModel : ViewModel {
    
    private(set) var userId: String
    private(set) var userName: String
    private(set) var avatarUrl: String
    private(set) var status: String
    
    init (userId: String, userName: String, avatarUrl: String, online: Bool) {
        self.userId = userId
        self.userName = userName
        self.avatarUrl = avatarUrl
        self.status = online ? "Online" : "Offline"
    }
    
    func loadAvatar(completionHandler: @escaping ImageDownloadCompletionClosure)
    {
        super.loadImage(imgString: avatarUrl, completionHandler: completionHandler)
    }
    
}
