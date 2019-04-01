//
//  Country.swift
//  ConsolidationApp05
//
//  Created by Angel Vázquez on 3/31/19.
//  Copyright © 2019 Angel Vázquez. All rights reserved.
//

import Foundation

class Country: Codable {
    
    let name: String
    let fullName: String
    let motto: String?
    let anthem: String
    let capitalCity: String
    let languages: [String]
    let demonyms: [String]
    let currency: String
    let timezone: String
    let drivingSide: String
    let size: Int
    let population: Int
    let flagImageStringURL: String
    
    func randomFact() -> String {
        switch Int.random(in: 1...9) {
        case 1:
            return "The capital city of \(name) is \(capitalCity)."
        case 2:
            return "The currency of \(name) is \(currency)."
        case 3:
            return "The driving side of \(name) is \(drivingSide)."
        case 4:
            return "\(name)'s population is of \(population) people!"
        case 5:
            return "The size of \(name) is \(size) km²!"
        case 6:
            return #""\#(anthem)" is the name of the anthem of \#(name)."#
        case 7:
            return "\(name)'s people are called \(demonyms.randomElement()!)."
        case 8:
            return "\(languages.randomElement()!) is spoken at \(name)."
        case 9:
            if let motto = motto {
                return "The motto of \(name) is \(motto)."
            } else {
                return "\(name) doesn't have a motto."
            }
        default:
            return ""
        }
    }
}
