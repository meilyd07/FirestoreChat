//
//  MessagesViewController.swift
//  FirestoreChat
//
//  Created by Admin on 10/4/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class MessagesViewController: UIViewController  {
    
    //MARK: - internal properties
    var viewModel: ChatViewModel?
    
    //MARK: - outlets
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var messageTextField: UITextField!
    
    //MARK: - deinitializers
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - internal methods
    @IBAction func close(_ sender: UIBarButtonItem) {
        viewModel?.closeChat()
    }
    
    @IBAction func sendMessage(_ sender: UIButton) {
        view.endEditing(true)
        if let messageText = messageTextField.text {
            viewModel?.addItem(messageText: messageText){ error in
                if let error = error {
                    Router.shared.showAlert(title: "Unable to add message to chat", message: error)
                }
            }
            messageTextField.text = nil
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.scrollCollectionView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView?.backgroundColor = UIColor.white
        collectionView?.alwaysBounceVertical = true
        navigationBar.topItem?.title = viewModel?.getChatDescription()
        //autoresizing collection view cell
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: collectionView.bounds.width, height: 1)
        }
        
        
        configureTextField()
        configureTapGesture()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardNotification(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillChangeFrame,
                                               object: nil)
        viewModel?.fetchData{ error in
            if let error = error {
                Router.shared.showAlert(title: "Unable to fetch messages", message: error)
            }
            else {
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                }
            }
        }
        viewModel?.checkForUpdates { error, messagesAdded in
            if let error = error {
                Router.shared.showAlert(title: "Unable to fetch chat updates", message: error)
            }
            else {
                if messagesAdded {
                    DispatchQueue.main.async {
                        self.collectionView?.reloadData()
                        self.collectionView?.layoutIfNeeded()
                        self.scrollCollectionView()
                    }
                }
            }
        }
        //autoresizing collection view cell
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayoutAutomaticSize
            flowLayout.scrollDirection = .vertical
        }
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let endFrameY = endFrame?.origin.y ?? 0
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            if endFrameY >= UIScreen.main.bounds.size.height {
                self.bottomConstraint?.constant = 0.0
            } else {
                self.bottomConstraint?.constant = endFrame?.size.height ?? 0.0
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded()},
                           completion: nil)
        }
    }
    
    //MARK: - private methods
    
    private func scrollCollectionView(){
        if let viewModel = self.viewModel {
            if viewModel.items.count > 0 {
                let indexPath = IndexPath(item: viewModel.items.count - 1, section: 0)
                collectionView?.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.bottom, animated: false)
            }
        }
    }
    
    private func configureTextField() {
        messageTextField.delegate = self
    }
    
    private func configureTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        collectionView.addGestureRecognizer(tapGesture)
    }
}

//MARK: - extensions
extension MessagesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    //MARK: - internal methods
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionMessageCell", for: indexPath) as? MessageCollectionViewCell
        
        if let cell = cell {
            
            cell.set(width: collectionView.bounds.width)
            
            if let viewModel = viewModel {
                
                cell.messageLabel.text = viewModel.items[indexPath.item].text
                cell.createdLabel.text = viewModel.items[indexPath.item].created
                if viewModel.getDefaultProfileId() == viewModel.items[indexPath.item].userId {
                    //current user
                    cell.set(alignment: .right)
                    cell.bubbleView.backgroundColor = UIColor(displayP3Red: 0, green: 137/255, blue: 249/255, alpha: 1)
                    cell.avatarImage.image = nil
                    cell.avatarImage.isHidden = true
                }
                else {
                    //other users
                    cell.set(alignment: .left)
                    cell.bubbleView.backgroundColor = UIColor(white: 0.95, alpha: 1)
                    let avatarUrl = viewModel.getAvatar(userId: viewModel.items[indexPath.row].userId)
                    
                    cell.avatarImage.isHidden = false
                    viewModel.loadImage(imgString:avatarUrl){[weak cell] imageData in
                        DispatchQueue.main.async { [weak cell] in
                            cell?.avatarImage.image = UIImage(data: imageData as Data)
                        }
                    }
                }
            }
        }
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = viewModel?.items.count {
            return count
        }
        else {
            return 0
        }
    }
}

// MARK: - extensions
extension MessagesViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


