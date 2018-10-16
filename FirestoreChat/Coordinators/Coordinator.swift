//
//  Coordinator.swift
//  FirestoreChat
//
//  Created by Admin on 10/8/18.
//  Copyright © 2018 Admin. All rights reserved.
//
import UIKit

protocol Coordinator {
    //MARK: - internal properties
    var navigationController: UINavigationController { get set }
    
    //MARK: - internal methods
    func start()
}
