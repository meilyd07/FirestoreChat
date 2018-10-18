//
//  Router.swift
//  FirestoreChat
//
//  Created by Admin on 10/17/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class Router {
    static let shared = Router()
    
    enum ViewControllerPresentStyle{
        case root
        case push
        case modal
    }
    
    //MARK: - internal methods
    func show(viewController: UIViewController, inNavigationController: Bool = false, style:ViewControllerPresentStyle = .push ){
        var controller = viewController
        
        if inNavigationController{
            controller = UINavigationController(rootViewController: controller)
        }
        
        switch style {
        case .modal:
            topPresentedViewController()?.present(controller, animated: true, completion: nil)
        case .push:
            topPresentedViewController()?.navigationController?.pushViewController(controller, animated: true)
        case .root:
            changeRoot(to: controller)
        }
    }
    
    func dismiss()
    {
        topPresentedViewController()?.dismiss(animated: true)
    }
    
    private func changeRoot(to vc: UIViewController) {
        guard
            let window = UIApplication.shared.windows.first,
            let newName = vc.theClassName.components(separatedBy: ".").last,
            let rootVC = window.rootViewController,
            let rootName = rootVC.theClassName.components(separatedBy: ".").last
            else {
                return
        }
        
        if let rootVCN = rootVC as? UINavigationController,
            let newVCN = vc as? UINavigationController{
            if   let newNameR = newVCN.viewControllers.first?.theClassName.components(separatedBy: ".").last,
                let r = rootVCN.viewControllers.first?.theClassName.components(separatedBy: ".").last,
                r == newNameR{
                //already showed
                return
            }
        }else if rootName == newName {
            //already showed
            return
        }
        
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
            window.rootViewController = vc
        }, completion: nil)
    }
    
    func topPresentedViewController(_ base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topPresentedViewController(nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topPresentedViewController(selected)
            }
        }
        if let presented = base?.presentedViewController{
            if presented is UISearchController{
                
            }else{
                return topPresentedViewController(presented)
            }
        }
        return base
    }
    
    func tabBarController()-> MainTabBarController? {
        let usersViewModel = UsersViewModel()
        let chatsViewModel = ChatsViewModel()
        let usersViewController = usersController(viewModel: usersViewModel)
        usersViewController?.tabBarItem = UITabBarItem(title: "Users", image: UIImage(named: "users"), selectedImage: nil)
        
        let chatsViewController = chatsController(viewModel: chatsViewModel)
        chatsViewController?.tabBarItem = UITabBarItem(title: "Chats", image: UIImage(named: "chats"), selectedImage: nil)
        
        let profileViewController = profileController(viewModel: usersViewModel)
        profileViewController?.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(named: "profile"), selectedImage: nil)
        
        guard
            let usersTab = usersViewController,
            let chatsTab = chatsViewController,
            let profileTab = profileViewController
            else { return nil }
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        guard let tabBarController = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as? MainTabBarController else {
            print("Error instantiate MainTabBarController.")
            return nil
        }
        
        tabBarController.viewControllers = [UINavigationController(rootViewController: usersTab), UINavigationController(rootViewController: chatsTab), UINavigationController(rootViewController: profileTab)]
        
        return tabBarController
    }
    
    func profileController(viewModel: UsersViewModel)-> ProfileViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        guard let profileViewController = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController else {
            print("Error instantiate ProfileViewController.")
            return nil
        }
        profileViewController.viewModel = viewModel
        return profileViewController
    }
    
    func chatsController(viewModel: ChatsViewModel)-> ChatsViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        guard let chatsViewController = storyboard.instantiateViewController(withIdentifier: "ChatsViewController") as? ChatsViewController
            else {
                print("Error instantiate ChatsViewController.")
                return nil
        }
        chatsViewController.viewModel = viewModel
        return chatsViewController
    }
    
    func usersController(viewModel: UsersViewModel)-> UsersViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        guard let usersViewController = storyboard.instantiateViewController(withIdentifier: "UsersViewController") as? UsersViewController
            else {
                print("Error instantiate UsersViewController.")
                return nil
        }
        usersViewController.viewModel = viewModel
        return usersViewController
    }
    
    func messagesController(viewModel: ChatViewModel) -> MessagesViewController? {
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let messagesViewController = storyboard.instantiateViewController(withIdentifier: "MessagesViewController") as? MessagesViewController else {
            print("Error instantiate MessagesViewController.")
            return nil
        }
        messagesViewController.viewModel = viewModel
        return messagesViewController
    }
    
    func showChat(viewModel: ChatViewModel) {
        if let messagesController = messagesController(viewModel: viewModel)
        {
            self.show(viewController: messagesController, inNavigationController: false, style: .modal)
        }
    }
    
    func closeChat() {
        self.dismiss()
    }
    
    func showChatInfo(viewModel: ChatInfoViewModel) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "ChatInfoViewController") as? ChatInfoViewController else {
            print("Error instantiate ChatInfoViewController.")
            return
        }
        vc.viewModel = viewModel
        self.show(viewController: vc, inNavigationController: false, style: .push)
    }
    
    func showUserDetail(viewModel: UserViewModel) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "UserDetailViewController") as? UserDetailViewController else {
            print("Error instantiate UserDetailViewController.")
            return
        }
        vc.viewModel = viewModel
        self.show(viewController: vc, inNavigationController: false, style: .push)
    }
    
    func showProfile(viewModel: UsersViewModel) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController else {
            print("Error instantiate ProfileViewController.")
            return
        }
        vc.viewModel = viewModel
        self.show(viewController: vc, inNavigationController: true, style: .push)
    }
    
    func showAlert(title: String, message: String) {
        DispatchQueue.main.async {
            let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self.show(viewController: ac, inNavigationController: false, style: .modal )
        }
    }
}

extension NSObject {
    var theClassName: String {
        return NSStringFromClass(type(of: self))
    }
}

