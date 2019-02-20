//
//  ViewController.swift
//  Project02
//
//  Created by Angel Vázquez on 2/19/19.
//  Copyright © 2019 Angel Vázquez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	//	Interface Builder buttons.
	@IBOutlet weak var button1: UIButton!
	@IBOutlet weak var button2: UIButton!
	@IBOutlet weak var button3: UIButton!
	
	//	Names of the flag images.
	var countries = [String]()
	
	var score = 0
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
		
		askQuestion()
	}
	
	func askQuestion() {
		button1.setImage(UIImage(named: countries[0]), for: .normal)
		button2.setImage(UIImage(named: countries[1]), for: .normal)
		button3.setImage(UIImage(named: countries[2]), for: .normal)
		
		button1.layer.borderWidth = 1
		button2.layer.borderWidth = 1
		button3.layer.borderWidth = 1
		
		//	Set a dark purple color.
		button1.layer.borderColor = UIColor(red: 0.34, green: 0.104, blue: 0.556, alpha: 1.0).cgColor
		button2.layer.borderColor = UIColor(red: 0.34, green: 0.104, blue: 0.556, alpha: 1.0).cgColor
		button3.layer.borderColor = UIColor(red: 0.34, green: 0.104, blue: 0.556, alpha: 1.0).cgColor
		
		
	}

}

