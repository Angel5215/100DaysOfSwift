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
        
        if let first = content.components(separatedBy: "\n").first {
            if first.isEmpty {
                return "No title"
            } else {
                return first
            }
        } else {
            return "No title"
        }
    }
    
    var date: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        
        return formatter.string(from: isoDate)
    }
    
    var additionalText: String {
        let components = content.components(separatedBy: "\n").filter { $0.trimmingCharacters(in: .whitespacesAndNewlines) != "" }
        return components.count >= 2 ? components[1] : "No additional text"
    }
    
    //  MARK: Initializers
    init(content: String, date: Date = Date()) {
        self.content = content
        self.isoDate = date
    }
    
    //  MARK: Methods
    static func loadFromFile(named filename: String = "notes") -> [Note] {
        
        let documents = FileManager.documentsDirectory
        let filePath = documents.appendingPathComponent(filename)
        let jsonDecoder = JSONDecoder()
        
        jsonDecoder.dateDecodingStrategy = .iso8601
        
        do {
            let data = try Data(contentsOf: filePath)
            return try jsonDecoder.decode([Note].self, from: data)
        } catch {
            print(#"Could not read file "\#(filename)". Reason: \#(error.localizedDescription)."#)
            return []
        }
    }
    
    static func save(contents: [Note], inFileNamed name: String = "notes") {
        
        let documents = FileManager.documentsDirectory
        let filePath = documents.appendingPathComponent(name)
        let jsonEncoder = JSONEncoder()
        
        jsonEncoder.dateEncodingStrategy = .iso8601
        jsonEncoder.outputFormatting = .prettyPrinted
        
        do {
            let data = try jsonEncoder.encode(contents)
            try data.write(to: filePath, options: .atomic)
        } catch {
            print("Error while saving data. Reason: \(error.localizedDescription).")
        }
    }
}
