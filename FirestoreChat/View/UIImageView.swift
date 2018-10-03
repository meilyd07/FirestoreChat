//
//  UIImageView.swift
//  FirestoreChat
//
//  Created by Admin on 10/2/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

extension UIImageView {
    func roundedImage()
    {
        self.layer.cornerRadius = self.frame.size.width/2
        self.clipsToBounds = true
        self.layer.borderColor = UIColor.blue.cgColor
        self.layer.borderWidth = 0.3
    }
}
