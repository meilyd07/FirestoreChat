//
//  ViewModel.swift
//  FirestoreChat
//
//  Created by Admin on 9/30/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

public typealias ImageDownloadCompletionClosure = (_ imageData: Data ) -> Void

class ViewModel {
    
    func loadImage(imgString: String, completionHandler: @escaping ImageDownloadCompletionClosure) {
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
        return UserDefaults.standard.string(forKey: "defaultUser") ?? "b91K10j8XLw4CYCCbkGE"
    }
    
    func setDefaultProfileId(userId: String) {
        UserDefaults.standard.set(userId, forKey: "defaultUser")
    }
}
