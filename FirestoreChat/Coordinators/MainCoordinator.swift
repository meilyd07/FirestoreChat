//
//  MainCoordinator.swift
//  FirestoreChat
//
//  Created by Admin on 10/12/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import UIKit

class MainCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        //verify if userSettings exists
        if UserDefaults.standard.dictionary(forKey: "defaultUser") == nil {
            let dict = ["name": "Marusya", "userId": "b91K10j8XLw4CYCCbkGE"]
            UserDefaults.standard.setValue(dict, forKeyPath: "defaultUser")
        }
        
        //start tab bar controller
        showTabBar()
        
    }
    
    func showTabBar() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        //get users tab
        let usersViewController = storyboard.instantiateViewController(withIdentifier: "UsersViewController") as! UsersViewController
        let usersViewModel = UsersViewModel()
        usersViewController.viewModel = usersViewModel
        usersViewController.coordinator = self
        usersViewController.tabBarItem = UITabBarItem(title: "Users", image: UIImage(named: "users"), selectedImage: nil)
        
        //get chats
        let chatsViewController = storyboard.instantiateViewController(withIdentifier: "ChatsViewController") as! ChatsViewController
        chatsViewController.viewModel = ChatsViewModel()
        chatsViewController.coordinator = self
        chatsViewController.tabBarItem = UITabBarItem(title: "Chats", image: UIImage(named: "chats"), selectedImage: nil)
        
        //get profile
        let profileViewController = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        profileViewController.viewModel = usersViewModel
        profileViewController.coordinator = self
        profileViewController.tabBarItem.title = "Profile"
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [usersViewController, chatsViewController, profileViewController]
        
        tabBarController.selectedViewController = usersViewController
        navigationController.pushViewController(tabBarController, animated: false)
    }
    
    //////
    
    func showUsers(viewModel: UsersViewModel) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "UsersViewController") as! UsersViewController
        vc.viewModel = viewModel
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    func showUserDetail(viewModel: UserViewModel) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "UserDetailViewController") as! UserDetailViewController
        vc.coordinator = self
        vc.viewModel = viewModel
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showChats(viewModel: ChatsViewModel) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "ChatsViewController") as! ChatsViewController
        vc.coordinator = self
        vc.viewModel = viewModel
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showChat(viewModel: ChatViewModel, controller: UIViewController) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "MessagesViewController") as! MessagesViewController
        vc.coordinator = self
        vc.viewModel = viewModel
        controller.present(vc, animated: true)
    }
    
    func closeChat(controller: UIViewController) {
        controller.presentingViewController?.dismiss(animated: true)
    }
    
    func showChatInfo(viewModel: ChatInfoViewModel) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "ChatInfoViewController") as! ChatInfoViewController
        vc.coordinator = self
        vc.viewModel = viewModel
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showProfile(viewModel: UsersViewModel) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        vc.coordinator = self
        vc.viewModel = viewModel
        navigationController.pushViewController(vc, animated: true)
    }
}
