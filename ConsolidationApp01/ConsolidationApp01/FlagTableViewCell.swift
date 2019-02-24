//
//  FlagTableViewCell.swift
//  ConsolidationApp01
//
//  Created by Angel Vázquez on 2/23/19.
//  Copyright © 2019 Angel Vázquez. All rights reserved.
//

import UIKit

class FlagTableViewCell: UITableViewCell {
	
	@IBOutlet weak var flagImageView: UIImageView!
	@IBOutlet weak var flagLabel: UILabel!
	
	var imageName: String? {
		didSet {
			if let imageName = imageName {
				flagImageView?.layer.borderColor = UIColor.black.cgColor
				flagImageView?.layer.borderWidth = 1
				
				flagImageView?.image = UIImage(named: imageName)
			}
		}
	}
	var flagText: String? {
		didSet {
			flagLabel.text = flagText
		}
	}

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
