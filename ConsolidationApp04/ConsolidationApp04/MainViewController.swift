//
//  ViewController.swift
//  ConsolidationApp04
//
//  Created by Angel Vázquez on 3/23/19.
//  Copyright © 2019 Angel Vázquez. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController {
    
    var photos = [Item]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showPhotoOptions))
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        photos = loadItems()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Photo", for: indexPath) as! PhotoCell
        
        let item = photos[indexPath.row]
        
        cell.captionLabel.text = item.caption
        cell.photoImageView.image = item.image
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            remove(at: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = navigationController?.storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.item = photos[indexPath.row]
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    @objc func showPhotoOptions() {
        let ac = UIAlertController(title: "Select an option", message: nil, preferredStyle: .actionSheet)
    
        
        ac.addAction(UIAlertAction(title: "Photo library", style: .default) {[unowned self] _ in
            self.showImagePicker(forType: .photoLibrary)
        })

        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            ac.addAction(UIAlertAction(title: "Camera", style: .default) { [unowned self] _ in
                self.showImagePicker(forType: .camera)
            })
        }
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(ac, animated: true)
    }
    
    func showImagePicker(forType type: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.sourceType = type
        
        picker.allowsEditing = true
        picker.delegate = self
        
        present(picker, animated: true)
    }
    
    func add(item: Item) {
        let row = photos.count
        let section = 0
        
        let indexPath = IndexPath(row: row, section: section)
        
        photos.append(item)
        
        tableView.insertRows(at: [indexPath], with: .automatic)
        save()
    }
    
    func remove(at indexPath: IndexPath) {
        let item = photos[indexPath.row]
        item.deleteFile()
        
        photos.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        
        save()
    }
    
    func showCaptionAlert(forItem item: Item) {
        let ac = UIAlertController(title: "Add a caption", message: nil, preferredStyle: .alert)
        ac.addTextField { textField in
            textField.placeholder = "Type a new caption for your photo."
        }
        
        let ok = UIAlertAction(title: "OK", style: .default) { [unowned self, unowned item, ac] action in
            guard let textField = ac.textFields?.first else { return }
            guard let text = textField.text else { return }
            
            item.caption = text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "No caption" : text
            
            let row = self.photos.count - 1
            let section = 0
            
            let indexPath = IndexPath(row: row, section: section)
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
            self.save()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        ac.addAction(ok)
        ac.addAction(cancel)
        
        present(ac, animated: true)
    }
    
    func save() {
        let itemsPath = FileManager.documentsDirectory.appendingPathComponent("items").appendingPathExtension("json")
        
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        
        do {
            let data = try jsonEncoder.encode(photos)
            try data.write(to: itemsPath, options: .atomic)
        } catch {
            print("Error while saving data. Error: \(error.localizedDescription)")
        }
    }

    func loadItems() -> [Item] {
        
        let itemsPath = FileManager.documentsDirectory.appendingPathComponent("items").appendingPathExtension("json")
        
        let jsonDecoder = JSONDecoder()
        
        var photos: [Item]? = nil
        
        do {
            let data = try Data(contentsOf: itemsPath)
            photos = try jsonDecoder.decode([Item].self, from: data)
        } catch {
            print("Error while loading data. Error: \(error.localizedDescription)")
        }
        
        return photos ?? [Item]()
    }
}

extension MainViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            print("Error while taking a picture.")
            return
        }
        
        let name = UUID().uuidString
        let path = FileManager.documentsDirectory.appendingPathComponent(name)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: path)
        }
        
        let newPhoto = Item(caption: "No caption", imageName: name)
        add(item: newPhoto)
        
        dismiss(animated: true) { [unowned self] in
            self.showCaptionAlert(forItem: newPhoto)
        }
    }
}

extension FileManager {
    static var documentsDirectory: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}


