//
//  ChatInfoViewController.swift
//  FirestoreChat
//
//  Created by Admin on 10/2/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class ChatInfoViewController: UIViewController {
    var viewModel: ChatInfoViewModel?
    
    
    @IBOutlet weak var logoUrl: UIImageView!
    @IBOutlet weak var chatDescription: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chatDescription.text = viewModel?.description
        let imageCompletionClosure = { ( imageData: Data ) -> Void in
            DispatchQueue.main.async {
                self.logoUrl.image = UIImage(data: imageData as Data)
                
                /*self.logoUrl.layer.cornerRadius = 30
                self.logoUrl.contentMode = .scaleAspectFill
                self.logoUrl.layer.masksToBounds = true*/
                self.logoUrl.roundedImage()
            }
        }
        
        viewModel?.loadLogo(completionHandler: imageCompletionClosure)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "Show embedded":
                if let destinatonVC = segue.destination as? UsersViewController {
                    destinatonVC.viewModel = viewModel?.getUsersViewModel()
                }
            default: break
            }
        }
    }
 

}
