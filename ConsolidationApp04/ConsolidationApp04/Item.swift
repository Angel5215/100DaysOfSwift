//
//  Item.swift
//  ConsolidationApp04
//
//  Created by Angel Vázquez on 3/23/19.
//  Copyright © 2019 Angel Vázquez. All rights reserved.
//

import UIKit

class Item: Codable {
    var caption: String
    let imageName: String
    
    var image: UIImage? {
        let path = FileManager.documentsDirectory.appendingPathComponent(imageName)
        return UIImage(contentsOfFile: path.path)
    }
    
    init(caption: String, imageName: String) {
        self.caption = caption
        self.imageName = imageName
    }
    
    func deleteFile() {
        let path = FileManager.documentsDirectory.appendingPathComponent(imageName)
        let fileManager = FileManager.default
        try? fileManager.removeItem(at: path)
    }
    
}
