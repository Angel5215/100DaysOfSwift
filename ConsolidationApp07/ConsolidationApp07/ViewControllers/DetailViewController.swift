//
//  DetailViewController.swift
//  ConsolidationApp07
//
//  Created by Angel Vázquez on 4/16/19.
//  Copyright © 2019 Angel Vázquez. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, Storyboarded {
    
    weak var coordinator: MainCoordinator?
    
    var reloadAction: (() -> Void)?
    var composeAction: (() -> Void)?
    var deleteAction: (() -> Void)?
    var save: (() -> Void)?
    
    @IBOutlet var textView: UITextView!
    
    var note: Note!
    
    var shareButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //  Keyboard handling
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        //  Large titles off
        navigationItem.largeTitleDisplayMode = .never
        
        shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share))
        navigationItem.rightBarButtonItem = shareButton
        
        let composeButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(compose))
        let deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteNote))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbarItems = [deleteButton, flexibleSpace, composeButton]
        
        textView.text = note.content
        textView.becomeFirstResponder()
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            textView.contentInset = .zero
        } else {
            textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        textView.scrollIndicatorInsets = textView.contentInset
        
        let selectedRange = textView.selectedRange
        textView.scrollRangeToVisible(selectedRange)
    }
    
    @objc func compose() {
        composeAction?()
    }
    
    @objc func deleteNote() {
        deleteAction?()
        save?()
    }
    
    @objc func done() {
        textView.resignFirstResponder()
        save?()
    }
    
    @objc func share() {
        guard let text = textView.text else { return }
        let ac = UIActivityViewController(activityItems: [text], applicationActivities: [])
        present(ac, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        save?()
    }
}

extension DetailViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        note.content = textView.text
        reloadAction?()
        
        shareButton.isEnabled = !textView.text.isEmpty
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        
        if textView.text.isEmpty {
            shareButton.isEnabled = false
        }
    
        navigationItem.setRightBarButtonItems([doneButton, shareButton], animated: true)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        let composeButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(compose))
        let deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteNote))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbarItems = [deleteButton, flexibleSpace, composeButton]
        
        navigationItem.setRightBarButtonItems([shareButton], animated: true)
    }
}
