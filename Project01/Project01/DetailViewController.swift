//
//  DetailViewController.swift
//  Project01
//
//  Created by Angel Vázquez on 2/18/19.
//  Copyright © 2019 Angel Vázquez. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

	@IBOutlet var imageView: UIImageView!
	
	var selectedImage: String?
	var pictureTitle: String?
	
	override var prefersHomeIndicatorAutoHidden: Bool {
		return navigationController?.hidesBarsOnTap ?? false
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		if let imageToLoad = selectedImage {
			imageView.image = UIImage(named: imageToLoad)
		}
		
		//	Title and design guidelines
		title = pictureTitle
		navigationItem.largeTitleDisplayMode = .never
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		navigationController?.hidesBarsOnTap = true
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		navigationController?.hidesBarsOnTap = false
	}
}
