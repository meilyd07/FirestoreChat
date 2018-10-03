//
//  ChatTableViewCell.swift
//  FirestoreChat
//
//  Created by Admin on 9/28/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {

  
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var messageTimeCreated: UILabel!
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var messageText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        /*userImage.layer.cornerRadius = 30
        userImage.contentMode = .scaleAspectFill
        userImage.layer.masksToBounds = true*/
        userImage.roundedImage()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
