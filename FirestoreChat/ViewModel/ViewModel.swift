//
//  ViewModel.swift
//  FirestoreChat
//
//  Created by Admin on 9/30/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

//public typealias ImageDownloadCompletionClosure = (_ imageData: Data ) -> Void

class ViewModel {
    
    
    func loadImage(imgString: String, completionHandler: @escaping (_ imageData: Data ) -> Void) {
        if let imageUrl = URL(string: imgString) {
            URLSession.shared.dataTask(with: imageUrl) { data, urlResponse, error in
                guard let data = data, error == nil, urlResponse != nil else {
                    print("Error downloading avatar. Error description: \(String(describing: error?.localizedDescription))")
                    return
                }
                completionHandler(data)
                }.resume()
        }
    }
    
    func getDefaultProfileId() -> String{
        if let userDefault = UserDefaults.standard.dictionary(forKey: "defaultUser"), let userId = userDefault["userId"] as? String {
            return userId
        }
        else {
            return ""
        }
    }
    
    func setDefaultProfileId(userId: String, name: String) {
        let dict = ["name": name, "userId": userId]
        UserDefaults.standard.setValue(dict, forKeyPath: "defaultUser")
    }
}
