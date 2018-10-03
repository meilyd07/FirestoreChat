//
//  ChatViewController.swift
//  FirestoreChat
//
//  Created by Admin on 9/28/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {

    
    var viewModel: ChatViewModel?
    
    @IBAction func close(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBAction func sendMessage(_ sender: UIButton) {
        view.endEditing(true)
        if let messageText = messageTextField.text {
            if messageText != "" {
                viewModel?.addItem(messageText: messageText)
                messageTextField.text = nil
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableAutomaticHeight()
        configureTextField()
        configureTapGesture()
        self.title = viewModel?.getChatDescription()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardNotification(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillChangeFrame,
                                               object: nil)
        viewModel?.fetchData{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        viewModel?.checkForUpdates {
            self.tableView.reloadData()
        }
        // Do any additional setup after loading the view.
    }
    
    deinit {
    NotificationCenter.default.removeObserver(self)
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
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
    
    private func setTableAutomaticHeight(){
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    private func configureTextField() {
        messageTextField.delegate = self
    }
    
    private func configureTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        tableView.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap() {
        view.endEditing(true)
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

extension ChatViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (viewModel?.items.count) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Chat message cell", for: indexPath)
        
        if let messageCell = cell as? ChatTableViewCell {
            messageCell.userName.text = viewModel?.items[indexPath.row].userName
            messageCell.messageText.layer.cornerRadius = 4
            messageCell.messageText.layer.masksToBounds = true
            messageCell.messageText.text = viewModel?.items[indexPath.row].text
            messageCell.messageTimeCreated.text = viewModel?.items[indexPath.row].created
            
            let imageCompletionClosure = { ( imageData: Data ) -> Void in
                DispatchQueue.main.async {
                    messageCell.userImage.image = UIImage(data: imageData as Data)
                }
            }
            if let viewModel = viewModel {
                viewModel.loadImage(imgString:viewModel.items[indexPath.row].avatar, completionHandler: imageCompletionClosure)
            }
        }
        
        return cell
    }
}

extension ChatViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
