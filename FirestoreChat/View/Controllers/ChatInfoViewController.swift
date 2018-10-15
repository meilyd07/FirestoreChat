//
//  ChatInfoViewController.swift
//  FirestoreChat
//
//  Created by Admin on 10/2/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class ChatInfoViewController: UIViewController {
    weak var coordinator: MainCoordinator?
    var viewModel: ChatInfoViewModel?
    
    @IBOutlet weak var logoUrl: UIImageView!
    @IBOutlet weak var chatDescription: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chatDescription.text = viewModel?.description
        
        viewModel?.loadLogo { [weak self]
            ( imageData: Data ) -> Void in
            DispatchQueue.main.async {
                self?.logoUrl.image = UIImage(data: imageData as Data)
                self?.logoUrl.roundedImage()
            }
        }
        
        viewModel?.fetchData{ error in
            if let error = error {
                DispatchQueue.main.async {
                    let ac = UIAlertController(title: "Unable to fetch chat users", message: error, preferredStyle: .alert)
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
}

extension ChatInfoViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (viewModel?.items.count) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatInfoUserCell", for: indexPath)
        
        if let viewModel = viewModel {
            cell.textLabel?.text = viewModel.items[indexPath.row].userName
            viewModel.loadImage(imgString:viewModel.items[indexPath.row].avatarUrl){ [weak cell]
                imageData in
                DispatchQueue.main.async {
                    cell?.imageView?.image = UIImage(data: imageData as Data)
                    cell?.imageView?.roundedImage()
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        if let viewModel = viewModel {
            coordinator?.showUserDetail(viewModel: viewModel.items[indexPath.row])
        }
    }
}
