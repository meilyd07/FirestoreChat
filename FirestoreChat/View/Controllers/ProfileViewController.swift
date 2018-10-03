//
//  ProfileViewController.swift
//  FirestoreChat
//
//  Created by Admin on 10/1/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    var viewModel: UsersViewModel = UsersViewModel()
    var indexPathOfDefaultUser: IndexPath?
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchData{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }        // Do any additional setup after loading the view.
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

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        //UserDefaults.standard.set(viewModel.items[indexPath.row].userId, forKey: "defaultUser")
        viewModel.setDefaultProfileId(userId: viewModel.items[indexPath.row].userId)
        if let indexPathOfDefaultUser = indexPathOfDefaultUser {
            tableView.cellForRow(at: indexPathOfDefaultUser)?.accessoryType = .none
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "User item cell", for: indexPath)
        
        if let userCell = cell as? UsersTableViewCell {
            userCell.userName.text = viewModel.items[indexPath.row].userName
            if (viewModel.items[indexPath.row].userId == viewModel.getDefaultProfileId())
            {
                userCell.accessoryType = .checkmark
                indexPathOfDefaultUser = indexPath
            }
            else {
                userCell.accessoryType = .none
            }
            let imageCompletionClosure = { ( imageData: Data ) -> Void in
                DispatchQueue.main.async {
                    userCell.userImage.image = UIImage(data: imageData as Data)
                }
            }
            viewModel.loadImage(imgString:viewModel.items[indexPath.row].avatarUrl, completionHandler: imageCompletionClosure)
            
        }
        
        return cell
    }
}

