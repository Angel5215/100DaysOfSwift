//
//  Person.swift
//  Project10
//
//  Created by Angel Vázquez on 3/15/19.
//  Copyright © 2019 Angel Vázquez. All rights reserved.
//

import UIKit

class Person: NSObject {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
