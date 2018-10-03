//
//  ChatsTableViewCell.swift
//  FirestoreChat
//
//  Created by Admin on 9/28/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class ChatsTableViewCell: UITableViewCell {

    @IBOutlet weak var logoImage: UIImageView!
    
    @IBOutlet weak var chatName: UILabel!
    
    @IBOutlet weak var unreadMessagesCount: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        /*logoImage.layer.cornerRadius = 30
        logoImage.contentMode = .scaleAspectFill
        logoImage.layer.masksToBounds = true*/
        logoImage.roundedImage()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
