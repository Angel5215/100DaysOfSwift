//
//  ViewController.swift
//  ConsolidationApp07
//
//  Created by Angel Vázquez on 4/16/19.
//  Copyright © 2019 Angel Vázquez. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController, Storyboarded {
    
    weak var coordinator: MainCoordinator?
    
    var notes = [Note]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        notes.append(Note(content: "Sample text 1", date: Date(timeIntervalSinceNow: -86400)))
        notes.append(Note(content: "Sample text 2"))
        notes.append(Note(content: "Sample text 3"))
        notes.append(Note(content: "Sample text 4"))
        notes.append(Note(content: "Sample text 5"))
        
        navigationController?.isToolbarHidden = false
    }
    
    //  MARK: Cell creation
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Note", for: indexPath)
        
        let note = notes[indexPath.row]
        
        cell.textLabel?.text = note.title
        cell.detailTextLabel?.text = note.date
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let note = notes[indexPath.row]
        coordinator?.editNote(note)
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print(indexPath)
    }
}

