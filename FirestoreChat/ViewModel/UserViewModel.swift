//
//  UserViewModel.swift
//  FirestoreChat
//
//  Created by Admin on 10/1/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
class UserViewModel : ViewModel {
    
    //MARK: - internal properties
    var userId: String
    var userName: String
    var avatarUrl: String
    var status: String
    
    //MARK: - initializer
    init (userId: String, userName: String, avatarUrl: String, online: Bool) {
        self.userId = userId
        self.userName = userName
        self.avatarUrl = avatarUrl
        self.status = online ? "Online" : "Offline"
    }
    
    //MARK: - internal methods
    func loadAvatar(completionHandler: @escaping (_ imageData: Data ) -> Void)
    {
        super.loadImage(imgString: avatarUrl, completionHandler: completionHandler)
    }
}
