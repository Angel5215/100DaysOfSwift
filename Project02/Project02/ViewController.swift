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
	var correctAnswer = 0
	var questionsAsked = 0
    
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
		
		askQuestion()
		
		//	Challenges Day 22.
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Show Score", style: .plain, target: self, action: #selector(showScore))
	}
	
	func askQuestion(_ action: UIAlertAction! = nil) {
		//	Shuffles the array in place.
		countries.shuffle()
		
		correctAnswer = Int.random(in: 0 ... 2)
		
		title = countries[correctAnswer].uppercased()
		
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
		
		
		//	Challenge 2.
		questionsAsked += 1
		print(questionsAsked)
	}
	
	@IBAction func buttonTapped(_ sender: UIButton) {
		var title: String
		var message: String
		
		if sender.tag == correctAnswer {
			title = "Correct"
			score += 1
			message = "Your score is \(score)."
		} else {
			title = "Wrong"
			score -= 1
			//	Challenge 3.
			
			let currentCountry = countries[sender.tag] == "us" ? "the United States" : countries[sender.tag].capitalized
			
			message = "That's the flag of \(currentCountry). Your score is \(score)."
		}
		
		let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
		ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: questionsAsked < 10 ? askQuestion : showFinalAlert))
		present(ac, animated: true)
	}
	
	func showFinalAlert(action: UIAlertAction! = nil) {
		
		title = "Your final score is: \(score)"
		
		let ac = UIAlertController(title: "Game Over", message: "Your final score is \(score)", preferredStyle: .alert)

		ac.addAction(UIAlertAction(title: "Restart", style: .default, handler: restart))
		ac.addAction(UIAlertAction(title: "Share", style: .default, handler: share))
		
		present(ac, animated: true)
	}
	
	@objc func showScore() {
		let ac = UIAlertController(title: "Score", message: "Your current score is \(score)", preferredStyle: .alert)
		
		let ok = UIAlertAction(title: "OK", style: .default)
		
		ac.addAction(ok)
		present(ac, animated: true)
	}
	
	
	func share(action: UIAlertAction! = nil) {
		let finalScore = "My final score in Guess the Flag was \(score)!"
		
		let ac = UIActivityViewController(activityItems: [finalScore], applicationActivities: [])
		
		ac.completionWithItemsHandler = { [unowned self] activity, success, items, error in
			self.restart()
		}
		
		popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
		
		present(ac, animated: true)
	}
	
	func restart(action: UIAlertAction! = nil) {
        
        let defaults = UserDefaults.standard
        let maxScore = defaults.integer(forKey: "maxScore")
        if maxScore >= 0, score > maxScore {
            let ac = UIAlertController(title: "New highest score!", message: "You beat your previous score of \(maxScore) points with \(score) points.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            
            defaults.set(score, forKey: "maxScore")
        }
        
		score = 0
		correctAnswer = 0
		questionsAsked = 0
		
		askQuestion()
	}
}

