//
//  ViewController.swift
//  ConsolidationApp01
//
//  Created by Angel Vázquez on 2/23/19.
//  Copyright © 2019 Angel Vázquez. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController {
	
	var flags = [String]()

	override func viewDidLoad() {
		super.viewDidLoad()
		
		//	Listing flags
		let bundle = Bundle.main.bundleURL
		let json = bundle.appendingPathComponent("countries").appendingPathExtension("json")
		
		let contents = try! String(contentsOf: json, encoding: .utf8)
		flags = contents.components(separatedBy: "\n")
		
		for flag in flags {
			print(flag)
		}
		
		//	Navigation Controller customization
		navigationController?.navigationBar.prefersLargeTitles = true
		title = "Flags"
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Flag", for: indexPath) as! FlagTableViewCell
		
		print(cell)
		
		let currentFlag = flags[indexPath.row]
		cell.imageName = currentFlag
		cell.flagText = currentFlag.count < 3 ? currentFlag.uppercased() : currentFlag.capitalized
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return flags.count
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let dvc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
			dvc.imageName = flags[indexPath.row]
			
			navigationController?.pushViewController(dvc, animated: true)
		}
	}
}

