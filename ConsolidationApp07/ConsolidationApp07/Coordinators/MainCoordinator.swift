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
    
    func editNote(_ note: Note, at indexPath: IndexPath, updateIn viewController: UIViewController? = nil, animated: Bool = true) {
        let detail = DetailViewController.instantiate()
        
        detail.note = note
        
        detail.reloadAction = { [weak viewController, indexPath] in
            let vc = viewController as? UITableViewController
            let tableView = vc?.tableView
            tableView?.reloadRows(at: [indexPath], with: .automatic)
        }
        
        detail.composeAction = { [weak viewController, weak self] in
            let vc = viewController as? MainViewController
            self?.navigationController.popViewController(animated: false)
            self?.compose(updateIn: vc, animated: false)
        }
        
        detail.deleteAction = { [weak viewController, weak self] in
            let vc = viewController as? MainViewController
            let tableView = vc?.tableView
            
            vc?.notes.remove(at: indexPath.row)
            tableView?.deleteRows(at: [indexPath], with: .automatic)
            self?.navigationController.popViewController(animated: true)
        }
        
        detail.save = { [weak viewController] in
            guard let vc = viewController as? MainViewController else { fatalError() }
            Note.save(contents: vc.notes)
            print("Saving!")
        }
        
        
        navigationController.pushViewController(detail, animated: animated)
        
        print(indexPath)
    }
    
    func compose(updateIn viewController: UIViewController? = nil, animated: Bool = true) {
        let vc = viewController as? MainViewController
        let tableView = vc?.tableView
        
        let newNote = Note(content: "")
        vc?.notes?.insert(newNote, at: 0)
        
        let indexPath = IndexPath(row: 0, section: 0)
        tableView?.insertRows(at: [indexPath], with: .automatic)
        
        editNote(newNote, at: indexPath, updateIn: vc, animated: animated)
    }
}
