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
    
    @IBOutlet weak var avatarImage: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userStatus: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userName.text = viewModel?.userName
        userStatus.text = viewModel?.status
        
        let imageCompletionClosure = { ( imageData: Data ) -> Void in
            DispatchQueue.main.async {
                self.avatarImage.image = UIImage(data: imageData as Data)
                
                /*self.avatarImage.layer.cornerRadius = 30
                self.avatarImage.contentMode = .scaleAspectFill
                self.avatarImage.layer.masksToBounds = true*/
                self.avatarImage.roundedImage()
            }
        }
        
        viewModel?.loadAvatar(completionHandler: imageCompletionClosure)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
