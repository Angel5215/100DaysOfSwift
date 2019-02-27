//
//  PagesTableViewController.swift
//  Project04
//
//  Created by Angel Vázquez on 2/26/19.
//  Copyright © 2019 Angel Vázquez. All rights reserved.
//

import UIKit

class PagesTableViewController: UITableViewController {
    
    var allowedWebsites = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Allowed websites"
        
        allowedWebsites = loadWebsites()
    }
    
    func loadWebsites() -> [String] {
        return ["apple.com", "amazon.com", "google.com", "youtube.com", "wikipedia.org", "facebook.com", "twitter.com", "github.com", "hackingwithswift.com"]
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allowedWebsites.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Website", for: indexPath)
        cell.textLabel?.text = allowedWebsites[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "WebBrowser") as? BrowserViewController {
            vc.startWebsite = allowedWebsites[indexPath.row]
            vc.websites = allowedWebsites
            navigationController?.pushViewController(vc, animated: true)
        }
    }

}
