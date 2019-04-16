//
//  MainCoordinator.swift
//  ConsolidationApp07
//
//  Created by Angel Vázquez on 4/16/19.
//  Copyright © 2019 Angel Vázquez. All rights reserved.
//

import UIKit

class MainCoordinator: NSObject, Coordinator, UINavigationControllerDelegate {
    var childCoordinators = [Coordinator]()
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        navigationController.delegate = self
        let vc = MainViewController.instantiate()
        
        vc.coordinator = self
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    func editNote(_ note: Note) {
        let detail = DetailViewController.instantiate()
        
        detail.note = note
        
        navigationController.pushViewController(detail, animated: true)
    }
}
