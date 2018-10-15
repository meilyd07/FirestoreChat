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
    
    func fetchData(completion: @escaping (String?) -> Void)
    {
        FireStoreService.shared.getUsers{ (error, users) in
            if error != nil {
                completion(error)
            }
            else{
                self.items = users.flatMap{UserViewModel(userId: $0.userId, userName: $0.userName, avatarUrl: $0.avatarUrl, online: $0.online)}
                completion(nil)
            }
        }
    }
    
    /*init(items: [UserViewModel])
    {
        self.items = items
    }*/
    
    /*override init() {
        super.init()
    }*/
    
}
