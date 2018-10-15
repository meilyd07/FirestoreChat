//
//  UserDetailViewController.swift
//  FirestoreChat
//
//  Created by Admin on 10/1/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {
    var viewModel: UserViewModel?
    weak var coordinator: MainCoordinator?
    
    @IBOutlet weak var avatarImage: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userStatus: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userName.text = viewModel?.userName
        userStatus.text = viewModel?.status
        
        viewModel?.loadAvatar{ [weak self]
            ( imageData: Data ) -> Void in
            DispatchQueue.main.async {
                self?.avatarImage.image = UIImage(data: imageData as Data)
                self?.avatarImage.roundedImage()
            }
        }
    }
}
