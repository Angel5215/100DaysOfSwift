//
//  ViewController.swift
//  Project18
//
//  Created by Angel Vázquez on 4/5/19.
//  Copyright © 2019 Angel Vázquez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("I'm inside the viewDidLoad() method!")
        print(1, 2, 3, 4, 5, separator: "-")
        print("Some message", terminator: "")
        print()
        
        //  Assertions are debug-only checks that will force an appto crash if an specific condition isn't true.
        assert(1 == 1, "Maths failure!")
        //assert(1 == 2, "Maths failure!")
        
        
        //  Breakpoints.
        for i in 1 ... 100 {
            print("Got number \(i)")
        }
    }


}

