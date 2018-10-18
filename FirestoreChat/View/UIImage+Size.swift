//
//  UIImage.swift
//  FirestoreChat
//
//  Created by Admin on 10/15/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

extension UIImage {
    
    //MARK: - internal methods
    func scaleToSize(targetSize: CGSize) -> UIImage? {
        let size = self.size
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        let newSize = widthRatio > heightRatio ?  CGSize(width: size.width * heightRatio, height: size.height * heightRatio) : CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        let renderFormat = UIGraphicsImageRendererFormat.default()
        renderFormat.opaque = false
        
        let renderer = UIGraphicsImageRenderer(size: newSize, format: renderFormat)
        let newImage = renderer.image {
            (context) in
            self.draw(in: rect)
        }
        return newImage
    }
}

