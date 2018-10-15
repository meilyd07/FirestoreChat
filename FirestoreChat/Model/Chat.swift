//
//  Chat.swift
//  FirestoreChat
//
//  Created by Admin on 9/27/18.
//  Copyright © 2018 Admin. All rights reserved.
//

struct Chat {
    private(set) var chatId: String
    private(set) var description: String
    private(set) var logoUrl: String
    
    var dictionary:[String:Any] {
        return [
            "description": description,
            "logoUrl": logoUrl
        ]
    }
}

extension Chat: DocumentSerializable {
    
    init?(documentId: String, dictionary: [String : Any]) {
        guard let description = dictionary["description"] as? String,
            let logoUrl = dictionary["logoUrl"] as? String
            else {
                return nil
        }
        
        self.init(chatId: documentId, description: description, logoUrl: logoUrl)
    }
}
