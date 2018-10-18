//
//  ProfileViewController.swift
//  FirestoreChat
//
//  Created by Admin on 10/1/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    //MARK: - private properties
    private var indexPathOfDefaultUser: IndexPath?
    
    //MARK: - internal properties
    var viewModel: UsersViewModel?
    
    //MARK: - outlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - internal methods
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.fetchData{ error in
            
            if let error = error {
                self.viewModel?.showAlert(title: "Unable to fetch users", message: error)
            }
            else {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
}

//MARK: - extensions
extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    //MARK: - internal methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        if let viewModel = viewModel {
            viewModel.setDefaultProfileId(userId: viewModel.items[indexPath.row].userId, name: viewModel.items[indexPath.row].userName)
            if let indexPathOfDefaultUser = indexPathOfDefaultUser {
                tableView.cellForRow(at: indexPathOfDefaultUser)?.accessoryType = .none
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let viewModel = viewModel {return viewModel.items.count}
        else {return 0}
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileItemCell", for: indexPath)
        
        if let viewModel = viewModel {
            cell.textLabel?.text = viewModel.items[indexPath.row].userName
            if (viewModel.items[indexPath.row].userId == viewModel.getDefaultProfileId())
            {
                cell.accessoryType = .checkmark
                indexPathOfDefaultUser = indexPath
            }
            else {
                cell.accessoryType = .none
            }
            viewModel.loadImage(imgString:viewModel.items[indexPath.row].avatarUrl){ [weak cell]
                imageData in
                DispatchQueue.main.async {
                    let img = UIImage(data: imageData as Data)
                    cell?.imageView?.image = img?.scaleToSize(targetSize: CGSize(width: 43, height: 43))
                    cell?.imageView?.roundedImage()
                }
            }
        }
        return cell
    }
}

