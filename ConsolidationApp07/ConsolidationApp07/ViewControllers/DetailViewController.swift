//
//  DetailViewController.swift
//  ConsolidationApp07
//
//  Created by Angel Vázquez on 4/16/19.
//  Copyright © 2019 Angel Vázquez. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, Storyboarded {
    
    weak var coordinator: MainCoordinator?
    
    @IBOutlet var textView: UITextView!
    var note: Note!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.text = note.content
    }
}
