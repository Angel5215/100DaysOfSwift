//
//  WikipediaViewController.swift
//  Project16
//
//  Created by Angel Vázquez on 4/2/19.
//  Copyright © 2019 Angel Vázquez. All rights reserved.
//

import UIKit
import WebKit

class WikipediaViewController: UIViewController {
    
    var webView: WKWebView!
    var city: String!
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = city
        
        //  URLs cannot contain spaces. They're normally replaced with '+' or '%20'.
        //  https://www.w3schools.com/tags/ref_urlencode.asp
        let formattedCity = city.replacingOccurrences(of: " ", with: "%20")
        
        if let url = URL(string: "https://en.wikipedia.org/wiki/\(formattedCity)") {
            webView.load(URLRequest(url: url))
        }
    }
}
