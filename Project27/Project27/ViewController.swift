//
//  ViewController.swift
//  Project27
//
//  Created by Angel Vázquez on 5/12/19.
//  Copyright © 2019 Angel Vázquez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - Properties
    var currentDrawType = 0

    // MARK: - Life cycle methods.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        drawRectangle()
    }
    
    // MARK: - IBActions
    @IBAction func redrawTapped(_ sender: UIButton) {
        currentDrawType += 1
        
        if currentDrawType > 5 { currentDrawType = 0 }
        
        switch currentDrawType {
        case 0:
            drawRectangle()
        default:
            break
        }
    }
    
    // MARK: - Drawing functions
    // A context is a canvas upon which we can draw but it also stores information about
    // how we want to draw (line thickness, for example) and information about the device
    // we are drawing to. In other words, a context is the combination of a canvas and metadata.
    func drawRectangle() {
        // With no scale or opacity specified, the renderer will asume the same scale as the device (2x for retina and transparent)
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { context in
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512)
            
            //  Units are specified in points.
            context.cgContext.setFillColor(UIColor.red.cgColor)
            context.cgContext.setStrokeColor(UIColor.black.cgColor)
            context.cgContext.setLineWidth(10)
            
            context.cgContext.addRect(rectangle)
            context.cgContext.drawPath(using: .fillStroke)
        }
        
        imageView.image = image
    }
}

