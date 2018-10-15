//
//  FireStoreService.swift
//  FirestoreChat
//
//  Created by Admin on 9/28/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import Firebase


class FireStoreService {
    static let shared = FireStoreService()
    var usersArray = [User]()
    
    init() {
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
    }
    
    public func getUsers(finished: @escaping (String?, [User]) -> Void){
        if usersArray.count == 0 {
            Firestore.firestore().collection("users").getDocuments() {[weak self] (querySnapshot, err) in
                if let err = err {
                    finished("Error getting documents: \(err.localizedDescription)", [])
                } else {
                    if let querySnapshot = querySnapshot {
                        let users = querySnapshot.documents.flatMap({User(documentId: $0.documentID, dictionary: $0.data())})
                        self?.usersArray = users
                        finished(nil, users)
                    }
                    else {
                        finished(nil, [])
                    }
                }
            }
        }
        else {
            finished(nil, usersArray)
        }
    }
    
    
    func addMessage(text: String, chatId: String, finished: @escaping (String?) -> Void) {
        if let defaultUser = UserDefaults.standard.dictionary(forKey: "defaultUser"), let userId = defaultUser["userId"] as? String, let userName = defaultUser["name"] as? String {
            Firestore.firestore().collection("chats").document(chatId).collection("messages").addDocument(data:
                [ "created": Date(),
                  "text": text,
                  "userId": userId,
                  "name": userName
            ]) {
                error in
                if let error = error {
                    finished("Error adding document: \(error.localizedDescription)")
                }
                else {
                    finished(nil)
                }
            }
        }
        else {
            finished("Default user profile not found")
        }
    }
    
    public func getMessages(chatId:String, finished: @escaping (String?, [ChatMessage]) -> Void)
    {
        Firestore.firestore().collection("chats").document(chatId).collection("messages")
            .order(by: "created", descending: false)
            .getDocuments
            { (querySnapshot, err) in
                if let err = err {
                    finished("Error getting documents: \(err.localizedDescription)", [])
                } else {
                    var messages = [ChatMessage]()
                    if let querySnapshot = querySnapshot {
                        for document in querySnapshot.documents {
                            if let message = ChatMessage.init(documentId: document.documentID, dictionary: document.data()) {
                                messages.append(message)
                            }
                            else {
                                finished("Error init message", messages)
                            }
                            
                        }
                    }
                    finished(nil, messages)
                }
        }
    }
        
    func checkForChatUpdates(chatId:String, finished: @escaping (String?, [ChatMessage]) -> Void) {
        Firestore.firestore().collection("chats").document(chatId).collection("messages").whereField("created", isGreaterThan: Date())
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    finished("Error getting updates: \(error.localizedDescription)", [])
                }
                else {
                    var messages = [ChatMessage]()
                    if let snapshot = querySnapshot {
                        snapshot.documentChanges.forEach({ difference in
                            if difference.type == .added {
                                if let message = ChatMessage.init(documentId: difference.document.documentID, dictionary: difference.document.data()) {
                                    messages.append(message)
                                }
                                else {
                                    finished("Error init message", messages)
                                }
                            }
                        })
                        finished(nil, messages)
                    }
                }
                
                
        }
    }
    
    func getAvatarUrl(userId: String) -> String {
        
        if let user = self.usersArray.first(where: {$0.userId == userId}) {
            return user.avatarUrl
        } else {
            return ""
        }
    }
    
    func getChatUsers(chatId:String, finished: @escaping (String?, [User]) -> Void){
        Firestore.firestore().collection("chats").document(chatId).collection("users").getDocuments()
        { (querySnapshot, err) in
            if let err = err {
                finished("Error getting documents: \(err.localizedDescription)", [])
            } else {
                var users = [User]()
                if let querySnapshot = querySnapshot {
                    for document in querySnapshot.documents {
                        if let userId = document.data()["userId"] as? String, let user = self.usersArray.first(where: {$0.userId == userId}) {
                            users.append(user)
                        } else {
                            finished("User was not found in chat", users)
                        }
                    }
                }
                finished(nil, users)
            }
        }
    }
    
    public func getChats(finished: @escaping (String?, [Chat]) -> Void) {
        Firestore.firestore().collection("chats").getDocuments { (querySnapshot, err) in
            if let err = err {
                finished("Error getting documents: \(err.localizedDescription)", [])
            } else {
                var chats = [Chat]()
                if let querySnapshot = querySnapshot {
                    for document in querySnapshot.documents {
                        if let chat = Chat(documentId: document.documentID, dictionary: document.data()) {
                            chats.append(chat)
                        }
                    }
                    finished(nil, chats)
                }
                else {
                    finished(nil, chats)
                }
                
            }
        }
    }
}
    

