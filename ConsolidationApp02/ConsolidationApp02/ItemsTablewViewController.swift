//
//  ViewController.swift
//  ConsolidationApp02
//
//  Created by Angel Vázquez on 3/4/19.
//  Copyright © 2019 Angel Vázquez. All rights reserved.
//

import UIKit

class ItemsTablewViewController: UITableViewController {
    
    var shoppingList: [String] = []
    
    var shareButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Shopping list"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addAction))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clear))
        
        navigationController?.isToolbarHidden = false
        
        shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbarItems = [spacer, shareButton]
        
        setButtons()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath)
        
        cell.textLabel?.text = shoppingList[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @objc func addAction() {
        let ac = UIAlertController(title: "Add new item", message: nil, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default) { [weak self, weak ac] action in
            
            guard let textField = ac?.textFields?[0] else { return }
            guard let item = textField.text, item.notEmpty() else { return }
            
            self?.add(item)
        }
        
        ac.addTextField { textfield in
            textfield.placeholder = "Type your new item."
        }
        
        ac.addAction(ok)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(ac, animated: true)
    }
    
    func add(_ item: String) {
        shoppingList.insert(item, at: 0)
        
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        
        setButtons()
    }
    
    @objc func clear() {
        
        let ac = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let clearAction = UIAlertAction(title: "Clear All Items", style: .destructive) { [weak self] _ in
            self?.shoppingList.removeAll(keepingCapacity: true)
            self?.tableView.reloadData()
            self?.setButtons()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        ac.addAction(clearAction)
        ac.addAction(cancelAction)
        
        present(ac, animated: true)
    }
    
    func setButtons() {
        let clearButton = navigationItem.leftBarButtonItem
        
        if shoppingList.isEmpty {
            clearButton?.isEnabled = false
            shareButton.isEnabled = false
        } else {
            clearButton?.isEnabled = true
            shareButton.isEnabled = true
        }
    }
    
    @objc func share() {
        
        var reducedList = shoppingList.reduce("") { (acc, item) in
            return acc + "> \(item)\n"
        }
        reducedList.removeLast()
        
        let ac = UIActivityViewController(activityItems: ["My Shopping List:", reducedList], applicationActivities: [])
        present(ac, animated: true)
    }
}

extension String {
    func notEmpty() -> Bool {
        return !self.trimmingCharacters(in: .whitespaces).isEmpty
    }
}
