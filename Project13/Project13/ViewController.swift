//
//  ViewController.swift
//  Project13
//
//  Created by Angel Vázquez on 3/24/19.
//  Copyright © 2019 Angel Vázquez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var slider: UISlider!
    
    var currentImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        title = "YACIFP"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))
    }
    
    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        
        picker.delegate = self
        
        present(picker, animated: true)
    }

    @IBAction func changeFilter(_ sender: Any) {
        
    }
    
    @IBAction func save(_ sender: Any) {
        
    }
    
    @IBAction func intensityChanged(_ sender: Any) {
        
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        dismiss(animated: true)
        
        currentImage = image
    }
}

