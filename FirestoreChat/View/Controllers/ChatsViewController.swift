//
//  ViewController.swift
//  FirestoreChat
//
//  Created by Admin on 9/27/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class ChatsViewController: UIViewController {
    var viewModel: ChatsViewModel?
    weak var coordinator: MainCoordinator?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Chats"
        viewModel?.fetchData{ error in
            if let error = error {
                DispatchQueue.main.async {
                    let ac = UIAlertController(title: "Unable to fetch chats", message: error, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(ac, animated:  true)
                }
            }
            else {
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }

    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "showChat":
                if let indexPath = sender as? IndexPath,
                    let seguedToVC =
                    (segue.destination as? UINavigationController)
                {
                    if let destinationVC = seguedToVC.visibleViewController as? MessagesViewController {
                        if let viewModel = viewModel {
                        destinationVC.viewModel = ChatViewModel(chatId: viewModel.items[indexPath.row].chatId, chatDescription: viewModel.items[indexPath.row].description)
                        }
                    }
                }
            case "showChatInfo":
                if let indexPath = sender as? IndexPath,
                    let seguedToVC =
                    (segue.destination as? ChatInfoViewController)
                {
                    if let viewModel = viewModel {
                    seguedToVC.viewModel = ChatInfoViewModel(chatId: viewModel.items[indexPath.row].chatId, description: viewModel.items[indexPath.row].description, logoUrl: viewModel.items[indexPath.row].logoUrl)
                    }
                }
            default: break
            }
        }
    }
*/
}

extension ChatsViewController: UITableViewDataSource, UITableViewDelegate {
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
                    cell?.imageView?.image = UIImage(data: imageData as Data)
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

