//
//  ViewController.swift
//  Project13
//
//  Created by Angel Vázquez on 3/24/19.
//  Copyright © 2019 Angel Vázquez. All rights reserved.
//

import UIKit
import CoreImage

class ViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var intensity: UISlider!
    
    @IBOutlet var centerX: UISlider!
    @IBOutlet var centerY: UISlider!
    
    
    @IBOutlet var radius: UISlider!
    @IBOutlet var scale: UISlider!
    
    @IBOutlet var changeFilterButton: UIButton!
    
    //  Handles rendering.
    var context: CIContext!
    
    var currentFilter: CIFilter!
    
    var currentImage: UIImage!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        title = "YACIFP"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))
        
        context = CIContext()
        
        let initialFilterTitle = "CISepiaTone"
        currentFilter = CIFilter(name: initialFilterTitle)
        changeFilterButton.setTitle(initialFilterTitle, for: .normal)
        setSliders()
        
    }
    
    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        
        picker.delegate = self
        
        present(picker, animated: true)
    }

    @IBAction func changeFilter(_ sender: Any) {
        
        let filterNames = ["CIBumpDistortion", "CIGaussianBlur", "CIPixellate", "CISepiaTone", "CITwirlDistortion", "CIUnsharpMask", "CIVignette", "CICircularWrap", "CIVortexDistortion"]
        
        let ac = UIAlertController(title: "Choose filter", message: nil, preferredStyle: .actionSheet)
        
        for name in filterNames {
            ac.addAction(UIAlertAction(title: name, style: .default, handler: setFilter))
        }
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func setFilter(action: UIAlertAction) {
        guard currentImage != nil else { return }
        guard let actionTitle = action.title else { return }
        
        currentFilter = CIFilter(name: actionTitle)
        changeFilterButton.setTitle(actionTitle, for: .normal)
        
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        
        setSliders()
        applyProcessing()
    }
    
    @IBAction func save(_ sender: Any) {
        guard let image = imageView.image else {
            let ac = UIAlertController(title: "Error", message: "There's no image to save.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(ac, animated: true)
            return
        }
        
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    @IBAction func intensityChanged(_ sender: Any) {
        applyProcessing()
    }
    
    func applyProcessing() {
        guard let image = currentFilter.outputImage else { return }
        
        let inputKeys = currentFilter.inputKeys
        
        if inputKeys.contains(kCIInputIntensityKey) { currentFilter.setValue(intensity.value, forKey: kCIInputIntensityKey) }
        if inputKeys.contains(kCIInputRadiusKey) { currentFilter.setValue(radius.value * 200, forKey: kCIInputRadiusKey) }
        if inputKeys.contains(kCIInputScaleKey) { currentFilter.setValue(scale.value * 10, forKey: kCIInputScaleKey) }
        if inputKeys.contains(kCIInputCenterKey) {
            
            let x = currentImage.size.width * CGFloat(centerX.value)
            let y = currentImage.size.width * CGFloat(centerY.value)
            
            currentFilter.setValue(CIVector(x: x, y: y), forKey: kCIInputCenterKey)
            
        }
        
        if let cgimg = context.createCGImage(image, from: image.extent) {
            let processedImage = UIImage(cgImage: cgimg)
            self.imageView.image = processedImage
        }
    }
    
    func setSliders() {
        let inputKeys = currentFilter.inputKeys
        intensity.isEnabled = inputKeys.contains(kCIInputIntensityKey)
        radius.isEnabled = inputKeys.contains(kCIInputRadiusKey)
        scale.isEnabled = inputKeys.contains(kCIInputScaleKey)
        centerX.isEnabled = inputKeys.contains(kCIInputCenterKey)
        centerY.isEnabled = inputKeys.contains(kCIInputCenterKey)
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        dismiss(animated: true)
        
        currentImage = image
        
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        
        applyProcessing()
    }
}

