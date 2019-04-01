//
//  ViewController.swift
//  ConsolidationApp05
//
//  Created by Angel Vázquez on 3/31/19.
//  Copyright © 2019 Angel Vázquez. All rights reserved.
//

import UIKit

class CountriesViewController: UITableViewController {
    
    var countries = [Country]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        performSelector(inBackground: #selector(loadContents), with: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Country", for: indexPath)
        
        let country = countries[indexPath.row]
        
        cell.textLabel?.text = country.name
        
        return cell
    }
    
    @objc func loadContents() {
        guard let jsonPath = Bundle.main.path(forResource: "countries", ofType: "json") else { fatalError(#"Could not find file named "countries.json""#) }
        
        let url = URL(fileURLWithPath: jsonPath)
        print(url.absoluteString)
        
        do {
            let jsonDecoder = JSONDecoder()
            let data = try Data(contentsOf: url)
            
            print(data)
            countries = try jsonDecoder.decode([Country].self, from: data)
            
            tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = navigationController?.storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.country = countries[indexPath.row]
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }

}

