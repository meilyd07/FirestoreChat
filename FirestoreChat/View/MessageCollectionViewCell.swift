//
//  MessageCollectionViewCell.swift
//  FirestoreChat
//
//  Created by Admin on 10/8/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class MessageCollectionViewCell: UICollectionViewCell {
    
    enum Alignment: Int
    {
        case left
        case right
    }
    
    //MARK: - outlets
    @IBOutlet weak var leadingMargin: NSLayoutConstraint!
    @IBOutlet weak var trailingMargin: NSLayoutConstraint!
    @IBOutlet weak var createdLabel: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var bubbleView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    
    //MARK: - private properties
    private lazy var width: NSLayoutConstraint = {
        let c = contentView.widthAnchor.constraint(equalToConstant: contentView.bounds.width)
        c.isActive = true
        return c
    }()
    
    //MARK: - internal methods
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        avatarImage.roundedImage()
        contentView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        messageLabel.text = nil
        avatarImage.image = nil
        avatarImage.isHidden = true
        createdLabel.text = nil
    }
    
    func set(width: CGFloat)
    {
        self.width.constant = width
    }
    
    func set(alignment: Alignment)
    {
        switch alignment {
        case .left:
            contentView.layoutMargins.left = 8
            contentView.layoutMargins.right = 150
        case .right:
            contentView.layoutMargins.left = 150
            contentView.layoutMargins.right = 8
        }
    }
}


