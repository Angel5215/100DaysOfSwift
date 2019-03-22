//
//  ViewController.swift
//  Project01
//
//  Created by Angel Vázquez on 2/18/19.
//  Copyright © 2019 Angel Vázquez. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController {
	
	var pictures = [Photograph]()

	override func viewDidLoad() {
		super.viewDidLoad()
        
        
        
        performSelector(inBackground: #selector(loadFromDefaults), with: nil)
		
		
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
                let photograph = Photograph(name: item)
                pictures.append(photograph)
                print(pictures)
            }
        }
        
        //    Challenge 2. Names in sorted order.
        pictures.sort { $0.name < $1.name }
        
        /*for i in 0 ..< 1000 {
            let photo = pictures[i % 10]
            let newPhoto = Photograph(from: photo)
            pictures.append(newPhoto)
        }*/
        
        collectionView.performSelector(onMainThread: #selector(UICollectionView.reloadData), with: nil, waitUntilDone: false)
    }
	
	
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Picture", for: indexPath) as! PictureCell
        
        let current = pictures[indexPath.item]
        
        cell.textLabel?.text = current.name
        cell.picture.image = UIImage(named: current.name)
        cell.viewsLabel.text = "Views: \(current.viewsCount)"
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            
            let selected = pictures[indexPath.item]
            vc.selectedImage = selected.name
            
            selected.viewsCount += 1
            collectionView.reloadItems(at: [indexPath])
            save()
            
            let pictureNumber = indexPath.row + 1
            vc.pictureTitle = "Picture \(pictureNumber) of \(pictures.count)"
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        
        if let savedData = try? jsonEncoder.encode(pictures) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "pictures")
        } else {
            print("Failed to save pictures")
        }
    }
    
    @objc func loadFromDefaults() {
        let defaults = UserDefaults.standard
        
        if let data = defaults.object(forKey: "pictures") as? Data {
            let jsonDecoder = JSONDecoder()
            do {
                pictures = try jsonDecoder.decode([Photograph].self, from: data)
                
                collectionView.performSelector(onMainThread: #selector(UICollectionView.reloadData), with: nil, waitUntilDone: false)
            } catch {
                print("Failed to load images")
            }
        } else {
            loadImages()
        }
    }

}

