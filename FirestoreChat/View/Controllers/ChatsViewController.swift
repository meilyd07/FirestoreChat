//
//  ViewController.swift
//  FirestoreChat
//
//  Created by Admin on 9/27/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class ChatsViewController: UIViewController {

    
    
    var viewModel: ChatsViewModel = ChatsViewModel()
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Chats"
        viewModel.fetchData{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        /*viewModel.updateData {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }*/
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "Show chat":
                if let cell = sender as? ChatsTableViewCell,
                    let indexPath = tableView.indexPath(for: cell),
                    let seguedToVC =
                    (segue.destination as? UINavigationController)
                {
                    if let destinationVC = seguedToVC.visibleViewController as? ChatViewController {
                        destinationVC.viewModel = ChatViewModel(chatId: viewModel.items[indexPath.row].chatId, chatDescription: viewModel.items[indexPath.row].description)
                    }
                }
            case "Show chat info":
                if let cell = sender as? ChatsTableViewCell,
                    let indexPath = tableView.indexPath(for: cell),
                    let seguedToVC =
                    (segue.destination as? ChatInfoViewController)
                {
                    seguedToVC.viewModel = ChatInfoViewModel(chatId: viewModel.items[indexPath.row].chatId, description: viewModel.items[indexPath.row].description, logoUrl: viewModel.items[indexPath.row].logoUrl, users: viewModel.items[indexPath.row].users)
                }
            default: break
            }
        }
    }

}

extension ChatsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Chats item cell", for: indexPath)
        
        if let chatsCell = cell as? ChatsTableViewCell {
            chatsCell.chatName.text = viewModel.items[indexPath.row].description
            
            let imageCompletionClosure = { ( imageData: Data ) -> Void in
                DispatchQueue.main.async {
                    //self.activitySpinner.stopAnimating()
                    chatsCell.logoImage.image = UIImage(data: imageData as Data)
                }
            }
            viewModel.loadImage(imgString:viewModel.items[indexPath.row].logoUrl, completionHandler: imageCompletionClosure)
        }
        
        return cell

    }
}

