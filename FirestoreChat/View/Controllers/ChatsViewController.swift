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
    
    //MARK: - outlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - internal methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Chats"
        viewModel?.fetchData{ error in
            if let error = error {
                self.viewModel?.showAlert(title: "Unable to fetch chats", message: error)
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
        viewModel?.showChat(index: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        viewModel?.showChatInfo(index: indexPath.row)
    }
}
