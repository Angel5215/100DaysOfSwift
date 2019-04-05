//
//  ViewController.swift
//  Project07
//
//  Created by Angel Vázquez on 3/6/19.
//  Copyright © 2019 Angel Vázquez. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var petitions = [Petition]()
    
    var filteredPetitions = [Petition]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlString: String
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
            //let urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
            //urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        
        /* DispatchQueue.global().async { [weak self] in
            if let url = URL(string: urlString), let data = try? Data(contentsOf: url) {
                self?.parse(json: data)
            } else {
                self?.showError()
            }
        }*/
        
        //  EASY GCD
        performSelector(inBackground: #selector(fetchJSON), with: nil)
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(showCredits))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(filterItems))
        
        /*if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
            } else {
                showError()
            }
        } else {
            showError()
        }*/
    }
    
    @objc func showCredits() {
        let ac = UIAlertController(title: "Credits", message: "This data was fetched from the We The People API of the Whitehouse", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(ac, animated: true)
    }
    
    @objc func filterItems() {
        let ac = UIAlertController(title: "Filter", message: nil, preferredStyle: .alert)
        
        ac.addTextField { textField in
            textField.placeholder = "Type a word to filter"
        }
        
        let filter = UIAlertAction(title: "Filter", style: .default) { [unowned self, unowned ac] action in
            guard let textField = ac.textFields?[0] else { return }
            guard let text = textField.text?.lowercased() else { return }
            
            if text.isNotEmpty {
                self.filteredPetitions = self.petitions.filter { petition in
                    
                    print("""
                    title: \(petition.title)
                    body: \(petition.body)
                    text: \(text)
                    """)
                    
                    return petition.title.lowercased().contains(text) || petition.body.lowercased().contains(text)
                }
            } else {
                self.filteredPetitions = self.petitions
            }
            
            self.tableView.reloadData()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        ac.addAction(filter)
        ac.addAction(cancel)
        
        present(ac, animated: true)
    }
    
    @objc func fetchJSON() {
        let urlString: String
        
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
        } else {
            urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
        }
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                return
            }
        }
        
        performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)

    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            filteredPetitions = petitions
            
            /*DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }*/
            
            tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
        } else {
            performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPetitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let petition = filteredPetitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = filteredPetitions[indexPath.row]
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func showError() {
        
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(ac, animated: true)
        
        /*DispatchQueue.main.async { [weak self] in
            let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(ac, animated: true)
        }*/
    }
}

extension String {
    var isNotEmpty: Bool {
        return !self.trimmingCharacters(in: .whitespaces).isEmpty
    }
}

