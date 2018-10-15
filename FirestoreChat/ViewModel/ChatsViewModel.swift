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
    
}




