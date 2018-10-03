//
//  UsersViewModel.swift
//  FirestoreChat
//
//  Created by Admin on 9/28/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

class UsersViewModel: ViewModel {
    private(set) var items = [UserViewModel]()
    
    func fetchData(completion: @escaping () -> Void)
    {
        FireStoreService.shared.getUsers{ users in
            self.items = users.flatMap{UserViewModel(userId: $0.userId, userName: $0.userName, avatarUrl: $0.avatarUrl, online: $0.online)}
            completion()
        }
    }
    
    init(users: [User]) {
        self.items = users.flatMap{UserViewModel(userId: $0.userId, userName: $0.userName, avatarUrl: $0.avatarUrl, online: $0.online)}
    }
    
    override init() {
        super.init()
    }
    
}
