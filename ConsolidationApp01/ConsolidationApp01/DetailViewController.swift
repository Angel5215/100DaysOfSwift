//
//  DetailViewController.swift
//  ConsolidationApp01
//
//  Created by Angel Vázquez on 2/23/19.
//  Copyright © 2019 Angel Vázquez. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

	@IBOutlet var imageView: UIImageView!
	var imageName: String?
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		imageView.layer.borderWidth = 1
		imageView.layer.borderColor = UIColor.black.cgColor
		
		if let imageName = imageName {
			imageView.image = UIImage(named: imageName)
		}
		
		title = imageName?.uppercased()
		navigationItem.largeTitleDisplayMode = .never
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share))
    }
	
	@objc func share() {
		guard let image = imageView.image?.jpegData(compressionQuality: 0.8), let imageName = imageName else { return }
		
		let message = imageName.count < 3 ? "This is the flag of the \(imageName.uppercased())" : "This is the flag of \(imageName.capitalized)"
		
		let vc = UIActivityViewController(activityItems: [message, image], applicationActivities: [])
		
		present(vc, animated: true)
	}
	
	
}
