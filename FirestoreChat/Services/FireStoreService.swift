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
    
    init() {
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        
    }
    
    public func getUsers(finished: @escaping ([User]) -> Void){
        var users = [User]()
        Firestore.firestore().collection("users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                users = querySnapshot!.documents.flatMap({User(documentId: $0.documentID, dictionary: $0.data())})
                finished(users)
            }
        }
    }
    
    
    func addMessage(text: String, chatId: String) {
        var ref: DocumentReference?
        let documentName = UserDefaults.standard.string(forKey: "defaultUser") ?? "b91K10j8XLw4CYCCbkGE"
        
        let refUser: DocumentReference = Firestore.firestore().collection("users").document(documentName)
        ref = Firestore.firestore().collection("chats").document(chatId).collection("messages").addDocument(data:
            [ "created": Date(),
              "text": text,
              "user": refUser
        ]) {
            error in
            if let error = error {
                print("Error adding document: \(error.localizedDescription)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }
        
    func checkForChatUpdates(chatId:String, finished: @escaping (ChatMessage) -> Void) {
        Firestore.firestore().collection("chats").document(chatId).collection("messages").whereField("created", isGreaterThan: Date())
            .addSnapshotListener { querySnapshot, error in
                guard let snapshot = querySnapshot else {
                    return

                }
                snapshot.documentChanges.forEach({ difference in
                    if difference.type == .added {

                        let documentId = difference.document.documentID
                        let text = difference.document.data()["text"] as! String
                        let createdDate = difference.document.data()["created"] as! Date
                        let userRef = difference.document.data()["user"] as! DocumentReference

                        self.getUserByReference(userRef: userRef, completion: { user in
                            finished(ChatMessage(documentId: documentId, user: user, chatId: chatId, text: text, created: createdDate))
                        })



                    }
                })
        }
    }
    
    
    
    private func getUserByReference(userRef: DocumentReference, completion: @escaping (User)-> Void)
    {
        userRef.getDocument { (document, error) in
            guard let user = User.init(documentId: (document?.documentID)!, dictionary: (document?.data()!)!) else {
                print("Could not get user: \(error.debugDescription)")
                return
            }
            completion(user)
        }
    }
    
    public func getChatUsers(chatId:String, finished: @escaping ([User]) -> Void){
        var users = [User]()
        Firestore.firestore().collection("chats").document(chatId).collection("users").getDocuments()
        { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                //users = querySnapshot!.documents.flatMap({User(documentId: $0.documentID, dictionary: $0.data())})
                //print("users: \(querySnapshot!.documents.count)")
                for document in querySnapshot!.documents {
                    let userRef = document.data()["user"] as! DocumentReference
                    
                    self.getUserByReference(userRef: userRef, completion: { user in
                        //let message = ChatMessage(documentId:messageDocumentId, user: user, chatId: chatId, text: text, created: dateTime)
                        users.append(user)
                        if users.count == querySnapshot!.documents.count {
                            finished(users)
                        }
                    })
                }
            }
        }
    }
    
    public func getMessages(chatId:String, finished: @escaping ([ChatMessage]) -> Void)
    {
        var messages = [ChatMessage]()
        Firestore.firestore().collection("chats").document(chatId).collection("messages")
            .order(by: "created", descending: false)
            .getDocuments
        { (querySnapshot, err) in
            for document in querySnapshot!.documents {
                
                let messageDocumentId = document.documentID
                let messageData = document.data()
                let text = messageData["text"] as! String
                let dateTime = messageData["created"] as! Date
                let userRef = messageData["user"] as! DocumentReference
                
                self.getUserByReference(userRef: userRef, completion: { user in
                    let message = ChatMessage(documentId:messageDocumentId, user: user, chatId: chatId, text: text, created: dateTime)
                    messages.append(message)
                    if messages.count == querySnapshot!.documents.count {
                        finished(messages)
                    }
                })
            }
        }
    }
    
    public func getChats(finished: @escaping ([Chat]) -> Void) {
        var chats = [Chat]()
        Firestore.firestore().collection("chats").getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let chatDocumentId = document.documentID
                    let chatData = document.data()
                    let description = chatData["description"] as! String
                    let logoUrl = chatData["logoUrl"] as! String
                    self.getChatUsers(chatId: chatDocumentId, finished: { chatUsers in
                        let chat = Chat(chatId: chatDocumentId, description: description, logoUrl: logoUrl, users: chatUsers, messages: [ChatMessage]())
                        chats.append(chat)
                        
                        if chats.count == querySnapshot!.documents.count {
                            finished(chats)
                        }
                    })
                    
                }
                
            }
        }
    }
}
    

