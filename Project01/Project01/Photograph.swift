//
//  Photograph.swift
//  Project01
//
//  Created by Angel Vázquez on 3/21/19.
//  Copyright © 2019 Angel Vázquez. All rights reserved.
//

import Foundation

class Photograph: Codable {
    let name: String
    var viewsCount: Int
    
    init(name: String, viewsCount: Int = 0) {
        self.name = name
        self.viewsCount = viewsCount
    }
    
    init(from photograph: Photograph) {
        self.name = photograph.name
        self.viewsCount = photograph.viewsCount
    }
}
