//
//  DetailViewController.swift
//  Project07
//
//  Created by Angel Vázquez on 3/7/19.
//  Copyright © 2019 Angel Vázquez. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    
    var webView: WKWebView!
    var detailItem: Petition?
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let detailItem = detailItem else { return }
        
        let html = """
        <html>
            <head>
                <meta name="viewport" content="width=device-width, initial-scale=1">
                <style> body { font-size: 150%; } </style>
                <!-- Compiled and minified CSS -->
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/css/materialize.min.css">
        
                <!-- Compiled and minified JavaScript -->
                <script src="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/js/materialize.min.js"></script>
            </head>
            <body>
                <div class="container">
                    <h2>\(detailItem.title)</h2>
                    <p style="text-align:right;">Signature count: \(detailItem.signatureCount)</p>
                    <p class="flow-text">\(detailItem.body)</p>
                </div>
            </body>
        </html>
        """
        
        webView.loadHTMLString(html, baseURL: nil)
    }
    
    
}
