//
//  ViewController.swift
//  Project25
//
//  Created by Angel Vázquez on 4/25/19.
//  Copyright © 2019 Angel Vázquez. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ViewController: UICollectionViewController {
    
    var images = [UIImage]()
    
    //  Identifies each user uniquely in a session
    var peerID = MCPeerID(displayName: UIDevice.current.name)
    
    //  Manager class that handles all multipeer connectivity.
    var mcSession: MCSession?
    
    //  Used when creating a session, telling others that we exist and handling invitations.
    var mcAdvertiserAssistant: MCAdvertiserAssistant?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Selfie Share"
        let importPictureButton = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(importPicture))
        let sendMessageButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(sendMessage))
        let connectionButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showConnectionPrompt))
        let showConnectionsButton = UIBarButtonItem(title: "Show", style: .plain, target: self, action: #selector(showConnections))
        
        navigationItem.rightBarButtonItems = [importPictureButton, sendMessageButton]
        navigationItem.leftBarButtonItems = [connectionButton, showConnectionsButton]
        
        //  Inititialize MCSession
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        mcSession?.delegate = self
    }
    
    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageView", for: indexPath)
        
        if let imageView = cell.viewWithTag(1000) as? UIImageView {
            imageView.image = images[indexPath.item]
        }
        
        return cell
    }
    
    @objc func showConnectionPrompt() {
        let ac = UIAlertController(title: "Connect to others", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Host a session", style: .default, handler: startHosting))
        ac.addAction(UIAlertAction(title: "Join a session", style: .default, handler: joinSession))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(ac, animated: true)
    }
    
    func startHosting(_ action: UIAlertAction) {
        guard let mcSession = mcSession else { return }
        mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "hws-project25", discoveryInfo: nil, session: mcSession)
        mcAdvertiserAssistant?.start()
    }
    
    func joinSession(_ action: UIAlertAction) {
        guard let mcSession = mcSession else { return }
        let mcBrowser = MCBrowserViewController(serviceType: "hws-project25", session: mcSession)
        mcBrowser.delegate = self
        present(mcBrowser, animated: true)
    }
    
    func showAlert(title: String?, message: String?, style: UIAlertController.Style = .alert, actions: UIAlertAction...) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: style)
        
        for action in actions {
            ac.addAction(action)
        }
        
        present(ac, animated: true)
    }
    
    @objc func sendMessage() {
        let ac = UIAlertController(title: "Send message", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "Send", style: .default, handler: { [weak self, weak ac] _ in
            guard let textfield = ac?.textFields?.first else { return }
            guard let text = textfield.text?.trimmingCharacters(in: .whitespacesAndNewlines), !text.isEmpty else { return }
            guard let mcSession = self?.mcSession else { return }
            
            if !mcSession.connectedPeers.isEmpty {
                let data = Data(text.utf8)
                
                do {
                    try self?.mcSession?.send(data, toPeers: mcSession.connectedPeers, with: .reliable)
                } catch {
                    self?.showAlert(title: "Error", message: error.localizedDescription, actions: .ok)
                }
            }
        }))
        ac.addAction(.cancel)
        
        present(ac, animated: true)
    }
    
    @objc func showConnections() {
        guard let mcSession = mcSession else {
            showAlert(title: "Error", message: "There's no active session.", actions: .ok)
            return
        }
        
        if mcSession.connectedPeers.count == 0 {
            showAlert(title: "No people here.", message: "There are no active connections in this session.", actions: .ok)
        } else {
            let peers = mcSession.connectedPeers.map { #""\#($0.displayName)""# }.joined(separator: ", ")
            showAlert(title: "Active connections", message: "Currently connected devices: \(peers)", actions: .ok)
        }
    }
}

extension ViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        dismiss(animated: true)
        
        images.insert(image, at: 0)
        collectionView.insertItems(at: [IndexPath(row: 0, section: 0)])
        
        guard let mcSession = mcSession else { return }
        if mcSession.connectedPeers.count > 0 {
            if let imageData = image.pngData() {
                do {
                    try mcSession.send(imageData, toPeers: mcSession.connectedPeers, with: .reliable)
                } catch {
                    showAlert(title: "Send error", message: error.localizedDescription, actions: .ok)
                }
            }
        }
    }
}

extension ViewController: MCSessionDelegate, MCBrowserViewControllerDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            print("Connected: \(peerID.displayName)")
        case .connecting:
            print("Connecting: \(peerID.displayName)")
        case .notConnected:
            showAlert(title: "Not connected", message: "\(peerID.displayName) has disconnected.", actions: .ok)
        @unknown default:
            print("Unknown state received: \(peerID.displayName)")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        DispatchQueue.main.async { [weak self] in
            if let image = UIImage(data: data) {
                self?.images.insert(image, at: 0)
                self?.collectionView.insertItems(at: [IndexPath(row: 0, section: 0)])
            } else if let message = String(data: data, encoding: .utf8) {
                self?.showAlert(title: "Received message", message: message, actions: .ok)
            }
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    
}

extension UIAlertAction {
    static var ok: UIAlertAction {
        return self.init(title: "OK", style: .default)
    }
    
    static var cancel: UIAlertAction {
        return self.init(title: "Cancel", style: .cancel)
    }
}
