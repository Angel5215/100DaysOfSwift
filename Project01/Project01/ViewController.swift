//
//  ViewController.swift
//  Project01
//
//  Created by Angel Vázquez on 2/18/19.
//  Copyright © 2019 Angel Vázquez. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
	
	var pictures = [String]()

	override func viewDidLoad() {
		super.viewDidLoad()
        
        
        
        performSelector(inBackground: #selector(loadImages), with: nil)
		
		
		//	Title and design guidelines.
		title = "Storm Viewer"
		navigationController?.navigationBar.prefersLargeTitles = true
	}
    
    @objc func loadImages() {
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasPrefix("nssl") {
                pictures.append(item)
                print(pictures)
            }
        }
        
        //    Challenge 2. Names in sorted order.
        pictures.sort()
        
        tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
    }
	
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return pictures.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
		
		cell.textLabel?.text = pictures[indexPath.row]
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
			vc.selectedImage = pictures[indexPath.row]
			
			let pictureNumber = indexPath.row + 1
			vc.pictureTitle = "Picture \(pictureNumber) of \(pictures.count)"
			
			navigationController?.pushViewController(vc, animated: true)
		}
	}

}

