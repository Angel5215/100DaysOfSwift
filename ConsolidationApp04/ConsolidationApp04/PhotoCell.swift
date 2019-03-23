//
//  PhotoCell.swift
//  ConsolidationApp04
//
//  Created by Angel Vázquez on 3/23/19.
//  Copyright © 2019 Angel Vázquez. All rights reserved.
//

import UIKit

class PhotoCell: UITableViewCell {
    
    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet var captionLabel: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        
        photoImageView.layer.borderColor = UIColor.black.cgColor
        photoImageView.layer.borderWidth = 1
        photoImageView.layer.cornerRadius = 5
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
