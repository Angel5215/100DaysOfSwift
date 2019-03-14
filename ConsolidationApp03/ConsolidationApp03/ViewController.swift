//
//  ViewController.swift
//  ConsolidationApp03
//
//  Created by Angel Vázquez on 3/13/19.
//  Copyright © 2019 Angel Vázquez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var hangmanLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var answerLabel: UILabel!
    @IBOutlet var remainingLabel: UILabel!
    
    var words = [String]()
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }

    var currentErrors = 0 {
        didSet {
            updateHangman()
            remainingLabel.text = "Errors: \(currentErrors)"
        }
    }
    
    var word = ""
    var currentTry = "" {
        didSet {
            answerLabel.text = currentTry.uppercased()
        }
    }
    
    var letterButtons = [UIButton]()
    var activatedButtons = [UIButton]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(restart))
        
        loadWords()
        setButtons()
        restart()
    }
    
    func loadWords() {
        let url = Bundle.main.url(forResource: "words", withExtension: "txt")!
        
        guard let allWords = try? String(contentsOf: url).trimmingCharacters(in: .whitespacesAndNewlines) else { fatalError("Error while opening file") }
            
        words = allWords.components(separatedBy: "\n")
        
        for i in 0 ..< 10 {
            print(words[i], words.count)
        }
    }
    
    @objc func restart(_ action: UIAlertAction! = nil) {
        score = 0
        currentErrors = 0
        startLevel()
    }
    
    @objc func updateHangman() {
        if let url = Bundle.main.url(forResource: "man-\(currentErrors)", withExtension: "txt") {
            if let art = try? String(contentsOf: url).trimmingCharacters(in: .newlines) {
                hangmanLabel.text = art
                print("man-\(currentErrors)")
            }
        } else {
            print("error")
        }
    }
    
    func setButtons() {
        let buttonsView = view.viewWithTag(300)!
        
        buttonsView.layer.borderWidth = 1
        buttonsView.layer.cornerRadius = 10
        
        buttonsView.setNeedsLayout()
        buttonsView.layoutIfNeeded()
        
        let size = buttonsView.frame.size
        let width = size.width / 9
        let height = size.height / 4
        
        for row in 0 ..< 3 {
            for col in 0 ..< 9 {
 
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
                letterButton.setTitle(String.letters[row][col], for: .normal)
                let frame = CGRect(x: CGFloat(col) * width, y: CGFloat(row) * height, width: width, height: height)
                letterButton.frame = frame
                //letterButton.backgroundColor = UIColor.random
                
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                
                buttonsView.addSubview(letterButton)
                letterButtons.append(letterButton)
            }
        }
    }
    
    @objc func letterTapped(_ sender: UIButton!) {
        
        guard let tappedChar = sender.titleLabel?.text?.lowercased().first else { return }
        activatedButtons.append(sender)
        sender.isEnabled = false
        
        if word.contains(tappedChar) {
            
            var tempWord = word
            var tempCurrent = currentTry
            
            while tempWord.contains(tappedChar) {
                let index = tempWord.lastIndex(of: tappedChar)!
                let next = tempWord.index(after: index)
                tempCurrent.insert(tappedChar, at: index)
                tempCurrent.remove(at: next)
                
                tempWord.remove(at: index)
                
                print(tempCurrent)
            }
            
            for char in word{
                if char == tappedChar {
                    tempWord += "\(char)"
                } else {
                    tempWord += "-"
                }
            }
            
            currentTry = tempCurrent
        } else {
            currentErrors += 1
        }
        
        checkGameState()
    }
    
    func startLevel(_ action: UIAlertAction! = nil) {
        
        currentErrors = 0
        word = words.randomElement()!
        currentTry = String(repeating: "-", count: word.count)
        
        for button in activatedButtons {
            button.isEnabled = true
        }
        activatedButtons.removeAll()
        
        print(word)
        print(currentTry)
    }
    
    func checkGameState() {
        if word == currentTry {
            score += word.count * 100 - currentErrors * 50
            let next = UIAlertAction(title: "Next word", style: .default, handler: startLevel)
            showAlert(withTitle: "YOU WON!", message: "You guessed \"\(word)\" correctly!", actions: [next])
        } else if currentErrors == 9 {
            let again = UIAlertAction(title: "Restart game", style: .default, handler: restart)
            showAlert(withTitle: "GAME OVER", message: "The word was \(word).", actions: [again])
        }
    }
    
    func showAlert(withTitle title: String?, message: String?, actions: [UIAlertAction] = []) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        for action in actions {
            ac.addAction(action)
        }
        
        present(ac, animated: true)
    }
}

extension String {
    static var letters: [[String]] {
        return [
            ["A", "B", "C", "D", "E", "F", "G", "H", "I"],
            ["J", "K", "L", "M", "N", "Ñ", "O", "P", "Q"],
            ["R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
        ]
    }
}

extension UIColor {
    static var random: UIColor {
        let red = CGFloat.random(in: 0 ... 1)
        let blue = CGFloat.random(in: 0 ... 1)
        let green = CGFloat.random(in: 0 ... 1)
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
