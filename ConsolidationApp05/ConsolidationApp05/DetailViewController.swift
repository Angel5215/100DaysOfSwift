//
//  DetailViewController.swift
//  ConsolidationApp05
//
//  Created by Angel Vázquez on 3/31/19.
//  Copyright © 2019 Angel Vázquez. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView!
    var country: Country!
    var cardButton: UIBarButtonItem!
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        title = country.name
        
        cardButton = UIBarButtonItem(title: "Card", style: .plain, target: self, action: #selector(loadFile))
        toolbarItems = [cardButton]
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareRandomFact))
        
        loadFile()
    }
    
    @objc func loadFile() {
        let html = """
        <html>
        <head>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <!-- Compiled and minified CSS -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/css/materialize.min.css">
        
        <!-- Compiled and minified JavaScript -->
        <script src="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/js/materialize.min.js"></script>
        </head>
        <body>
        <!--<h2 class="center-align">\(country.name)</h2>-->
        <div class="row">
        <div class="col s12 m7">
        <div class="card">
        <div class="card-image">
        <img class="responsive-img" src="\(country.flagImageStringURL)" alt="Flag of \(country.name)" style="border:1px solid gray">
        </div>
        <div class="card-content">
        <span class="card-title"><b>\(country.fullName)</b></span>
        <ul>
        <li><b>Motto:</b> \(country.motto ?? "None")</li>
        <li><b>Anthem:</b> \(country.anthem)</li>
        <li><b>Capital city:</b> \(country.capitalCity)</li>
        <li><b>Currency:</b> \(country.currency)</li>
        <li><b>Time zone:</b> \(country.timezone)</li>
        <li><b>Size:</b> \(country.size) km²</li>
        <li><b>Population:</b> \(country.population)</li>
        <li><b>Languages:</b> \(country.languages.joined(separator: ", "))</li>
        <li><b>Demonyms:</b> \(country.demonyms.joined(separator: ", "))</li>
        <li><b>Driving side:</b> \(country.drivingSide)</li>
        </ul>
        </div>
        <div class="card-action">
        <a class="blue-text" href="https://en.wikipedia.org/wiki/\(country.name)"><b>Wikipedia</b></a>
        </div>
        </div>
        </div>
        </div>
        </body>
        </html>
        """
        
        webView.loadHTMLString(html, baseURL: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isToolbarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isToolbarHidden = true
    }
    
    @objc func shareRandomFact() {
        let fact = country.randomFact()
        let ac = UIActivityViewController(activityItems: [fact], applicationActivities: [])
        present(ac, animated: true)
    }
}
