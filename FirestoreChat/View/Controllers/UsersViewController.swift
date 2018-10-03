//
//  UsersViewController.swift
//  FirestoreChat
//
//  Created by Admin on 9/28/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class UsersViewController: UIViewController {

    var viewModel: UsersViewModel?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if viewModel == nil {
            viewModel = UsersViewModel()
            
            viewModel?.fetchData{
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        else {
            tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "Show user details":
                if let cell = sender as? UsersTableViewCell,
                    let indexPath = tableView.indexPath(for: cell),
                    let destinationVC = segue.destination as? UserDetailViewController,
                    let viewModel = viewModel
                {
                    destinationVC.viewModel = viewModel.items[indexPath.row]
                }
            default: break
            }
        }
    }
    

}

extension UsersViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (viewModel?.items.count) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "User item cell", for: indexPath)
        
        if let userCell = cell as? UsersTableViewCell {
            if let viewModel = viewModel {
                userCell.userName.text = viewModel.items[indexPath.row].userName
                
                let imageCompletionClosure = { ( imageData: Data ) -> Void in
                    DispatchQueue.main.async {
                        userCell.userImage.image = UIImage(data: imageData as Data)
                    }
                }
                viewModel.loadImage(imgString:viewModel.items[indexPath.row].avatarUrl, completionHandler: imageCompletionClosure)
            }
        }
        
        return cell
    }
}
