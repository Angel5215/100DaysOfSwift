//
//  ActionViewController.swift
//  Extension
//
//  Created by Angel Vázquez on 4/8/19.
//

import UIKit
import MobileCoreServices

class ActionViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
    
        //  The extension context lets us control how the extension interacts with the parent app. inputItems is an array of data the parent app is sending to the extension.
        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
            
            //  inputItems
            if let itemProvider = inputItem.attachments?.first {
                itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) { [weak self] (dict, error) in
                    
                }
            }
        }
    }

    @IBAction func done() {
        // Return any edited content to the host app.
        // This template doesn't do anything, so we just echo the passed in items.
        self.extensionContext!.completeRequest(returningItems: self.extensionContext!.inputItems, completionHandler: nil)
    }

}
