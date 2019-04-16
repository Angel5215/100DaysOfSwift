//
//  Note.swift
//  ConsolidationApp07
//
//  Created by Angel Vázquez on 4/16/19.
//  Copyright © 2019 Angel Vázquez. All rights reserved.
//

import Foundation

class Note: Codable {
    
    //  MARK: Properties
    var content: String
    private var isoDate: Date
    
    var title: String {
        return content.components(separatedBy: "\n").first ?? "No title"
    }
    
    var date: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        
        return formatter.string(from: isoDate)
    }
    
    //  MARK: Initializers
    init(content: String, date: Date = Date()) {
        self.content = content
        self.isoDate = date
    }
    
    //  MARK: Methods
    static func loadFromFile(named: String) -> [Note] {
        return []
    }
    
    static func saveInFile(named: String) -> Bool {
        return true
    }
}
