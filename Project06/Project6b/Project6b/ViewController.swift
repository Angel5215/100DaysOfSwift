//
//  ViewController.swift
//  Project6b
//
//  Created by Angel Vázquez on 3/2/19.
//  Copyright © 2019 Angel Vázquez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let label1 = UILabel()
        label1.translatesAutoresizingMaskIntoConstraints = false
        label1.backgroundColor = UIColor.red
        label1.text = "THESE"
        label1.sizeToFit()
        
        let label2 = UILabel()
        label2.translatesAutoresizingMaskIntoConstraints = false
        label2.backgroundColor = UIColor.cyan
        label2.text = "ARE"
        label2.sizeToFit()
        
        let label3 = UILabel()
        label3.translatesAutoresizingMaskIntoConstraints = false
        label3.backgroundColor = UIColor.yellow
        label3.text = "SOME"
        label3.sizeToFit()
        
        let label4 = UILabel()
        label4.translatesAutoresizingMaskIntoConstraints = false
        label4.backgroundColor = UIColor.green
        label4.text = "AWESOME"
        label4.sizeToFit()
        
        let label5 = UILabel()
        label5.translatesAutoresizingMaskIntoConstraints = false
        label5.backgroundColor = UIColor.orange
        label5.text = "LABELS"
        label5.sizeToFit()
        
        view.addSubview(label1)
        view.addSubview(label2)
        view.addSubview(label3)
        view.addSubview(label4)
        view.addSubview(label5)
        
        /*
        //  Auto Layout using Visual Format Language (VFL)
        let viewsDictionary = ["label1": label1, "label2": label2, "label3": label3, "label4": label4, "label5": label5]
        
       
        for label in viewsDictionary.keys {
            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[\(label)]|", options: [], metrics: nil, views: viewsDictionary))
        }
        
        
        //  Use metrics to give VFL a set of sized with names instead of using hard-coded numbers.
        let metrics = ["labelHeight": 88]
        
        //  - means space of 10 points by default.
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[label1(labelHeight@999)]-[label2(label1)]-[label3(label1)]-[label4(label1)]-[label5(label1)]-(>=10)-|", options: [], metrics: metrics, views: viewsDictionary))
        */
        
        //  Using anchors
        var previous: UILabel?
        for label in [label1, label2, label3, label4, label5] {
            
            //label.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
            
            //  Challenges 1 & 2. Using the leading and trailing anchor to explicitly pin the label to the edges. Using the safeAreaLayoutGuide so taht the labels won't go under the safe area.
            label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
            label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
            
            //  Challenge 3. Making the labels' height equal to 1/5 of the screen minus 10 for the spacing.
            label.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2, constant: -10).isActive = true
            
            
            //label.heightAnchor.constraint(equalToConstant: 88).isActive = true
            
            if let previous = previous {
                label.topAnchor.constraint(equalTo: previous.bottomAnchor, constant: 10).isActive = true
            }
            
            previous = label
        }
    }
}

