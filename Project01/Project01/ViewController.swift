//
//  ViewController.swift
//  Project01
//
//  Created by Angel Vázquez on 2/18/19.
//  Copyright © 2019 Angel Vázquez. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController {
	
	var pictures = [String]()

	override func viewDidLoad() {
		super.viewDidLoad()
        
        
        
        performSelector(inBackground: #selector(loadImages), with: nil)
		
		
		//	Title and design guidelines.
		title = "Storm Viewer"
		navigationController?.navigationBar.prefersLargeTitles = true
	}
    
    @objc func loadImages() {
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasPrefix("nssl") {
                pictures.append(item)
                print(pictures)
            }
        }
        
        //    Challenge 2. Names in sorted order.
        pictures.sort()
        
        collectionView.performSelector(onMainThread: #selector(UICollectionView.reloadData), with: nil, waitUntilDone: false)
    }
	
	
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Picture", for: indexPath) as! PictureCell
        
        let current = pictures[indexPath.item]
        
        cell.textLabel?.text = current
        cell.picture.image = UIImage(named: current)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedImage = pictures[indexPath.row]
            
            let pictureNumber = indexPath.row + 1
            vc.pictureTitle = "Picture \(pictureNumber) of \(pictures.count)"
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }

}

