//
//  UsersViewController.swift
//  FirestoreChat
//
//  Created by Admin on 9/28/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class UsersViewController: UIViewController {
    
    //MARK: - internal properties
    var viewModel: UsersViewModel?
    
    //MARK: - outlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - internal methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let viewModel = viewModel {
            viewModel.fetchData{ error in
                
                if let error = error {
                    Router.shared.showAlert(title: "Unable to fetch users", message: error)
                }
                else {
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
}

//MARK: - extension
extension UsersViewController: UITableViewDataSource, UITableViewDelegate {
    
    //MARK: - internal methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (viewModel?.items.count) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserItemCell", for: indexPath)
        
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
            Router.shared.showUserDetail(viewModel: viewModel.items[indexPath.row])
        }
    }
}
