//
//  ViewController.swift
//  FirestoreChat
//
//  Created by Admin on 9/27/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class ChatsViewController: UIViewController {
    
    //MARK: - internal properties
    var viewModel: ChatsViewModel?
    weak var coordinator: MainCoordinator?
    
    //MARK: - outlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - internal methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Chats"
        viewModel?.fetchData{ error in
            if let error = error {
                self.coordinator?.showAlert(title: "Unable to fetch chats", message: error, controller: self)
            }
            else {
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
}

//MARK: - extension UITableViewDataSource, UITableViewDelegate
extension ChatsViewController: UITableViewDataSource, UITableViewDelegate {
    
    //MARK: - internal methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let viewModel = viewModel {
            return viewModel.items.count
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatsItemCell", for: indexPath)
        
        if let viewModel = viewModel {
            cell.textLabel?.text = viewModel.items[indexPath.row].description
            viewModel.loadImage(imgString:viewModel.items[indexPath.row].logoUrl){ [weak cell]
                ( imageData: Data ) -> Void in
                DispatchQueue.main.async {
                    let img = UIImage(data: imageData as Data)
                    cell?.imageView?.image = img?.scaleToSize(targetSize: CGSize(width: 30, height: 30))
                    cell?.imageView?.roundedImage()
                }
            }
        }
        return cell

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let viewModel = viewModel {
            let chatViewModel = ChatViewModel(chatId: viewModel.items[indexPath.row].chatId, chatDescription: viewModel.items[indexPath.row].description)
            coordinator?.showChat(viewModel: chatViewModel, controller: self)
        }
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        if let viewModel = viewModel {
            let chatInfoViewModel = ChatInfoViewModel(chatId: viewModel.items[indexPath.row].chatId, description: viewModel.items[indexPath.row].description, logoUrl: viewModel.items[indexPath.row].logoUrl)
            coordinator?.showChatInfo(viewModel: chatInfoViewModel)
        }
    }
}
