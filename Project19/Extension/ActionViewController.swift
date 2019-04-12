//
//  ActionViewController.swift
//  Extension
//
//  Created by Angel Vázquez on 4/8/19.
//

import UIKit
import MobileCoreServices

class ActionViewController: UIViewController {
    
    @IBOutlet var script: UITextView!
    
    var pageTitle = ""
    var pageURL = ""

    override func viewDidLoad() {
        super.viewDidLoad()
    
        //  The extension context lets us control how the extension interacts with the parent app. inputItems is an array of data the parent app is sending to the extension.
        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
            
            //  inputItems
            if let itemProvider = inputItem.attachments?.first {
                itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) { [weak self] (dict, error) in
                    guard let itemDictionary = dict as? NSDictionary else { return }
                    guard let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else { return }
                    print(javaScriptValues)
                    
                    self?.pageTitle = javaScriptValues["title"] as? String ?? ""
                    self?.pageURL = javaScriptValues["URL"] as? String ?? ""
                    
                    DispatchQueue.main.async {
                        self?.title = self?.pageTitle
                    }
                }
            }
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(selectScript))
        
        //  Keyboard hiding
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    @objc func done() {
        // Return any edited content to the host app.
        // This template doesn't do anything, so we just echo the passed in items.
        let item = NSExtensionItem()
        let argument: NSDictionary = ["customJavaScript": script.text]
        let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
        let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
        item.attachments = [customJavaScript]
        
        //  User Defaults
        let defaults = UserDefaults.standard
        let url = URL(string: self.pageURL)!
        defaults.set(script.text, forKey: url.host ?? self.pageURL)
        
        extensionContext?.completeRequest(returningItems: [item])
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            script.contentInset = .zero
        } else {
            script.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        script.scrollIndicatorInsets = script.contentInset
        
        let selectedRange = script.selectedRange
        script.scrollRangeToVisible(selectedRange)
    }
    
    @objc func selectScript() {
        
        let functions = readJSON()
        let ac = UIAlertController(title: "Select script", message: nil, preferredStyle: .actionSheet)
        
        for (key, value) in functions {
            ac.addAction(UIAlertAction(title: "Show \(key)", style: .default) { [weak self] action in
                guard let self = self else { return }
                self.script.text = value
            })
        }
        
        if let host = URL(string: pageURL)?.host, let savedScriptHost = UserDefaults.standard.value(forKey: host) as? String {
            ac.addAction(UIAlertAction(title: "Saved: \(host)", style: .default) { [weak self] _ in
                guard let self = self else { return }
                self.script.text = savedScriptHost
            })
        } else if let savedScriptPage = UserDefaults.standard.value(forKey: pageURL) as? String {
            ac.addAction(UIAlertAction(title: "Saved: \(pageURL)", style: .default) { [weak self] _ in
                guard let self = self else { return }
                self.script.text = savedScriptPage
            })
        }
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(ac, animated: true)
    }

    
    
    func readJSON() -> [String: String] {
        guard let jsonPath = Bundle.main.path(forResource: "code", ofType: "json") else { fatalError(#"File "code.json" not found."#) }
        
        var functions = [String: String]()
        do {
            let url = URL(fileURLWithPath: jsonPath)
            let data = try Data(contentsOf: url)
            
            let decoder = JSONDecoder()
            functions = (try? decoder.decode([String: String].self, from: data)) ?? [:]
        } catch {
            print(error.localizedDescription)
        }
        
        return functions
    }
}
