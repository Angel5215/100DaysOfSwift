//
//  ViewController.swift
//  Project16
//
//  Created by Angel Vázquez on 4/1/19.
//  Copyright © 2019 Angel Vázquez. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let london = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Home to the 2012 Summer Olympics.")
        let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "Founded over a thousand years ago.")
        let paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "Often called the City of Light.")
        let rome = Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "Has a whole country inside it.")
        let washington = Capital(title: "Washington DC", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), info: "Named after George himself.")
        let mexicoCity = Capital(title: "Mexico City", coordinate: CLLocationCoordinate2D(latitude: 19.390519, longitude: -99.4238064), info: "Mexico City has the most museums in the world, with more than 160, almost all of which are free on Sundays!")
        
        /*mapView.addAnnotation(london)
        mapView.addAnnotation(oslo)
        mapView.addAnnotation(paris)
        mapView.addAnnotation(rome)
        mapView.addAnnotation(washington)*/
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(changeMap))
        
        mapView.addAnnotations([london, oslo, paris, rome, washington, mexicoCity])
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is Capital else { return nil }
        
        let identifier = "Capital"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            
            
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
        } else {
            annotationView?.annotation = annotation
        }
        
        annotationView?.pinTintColor = .purple
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let capital = view.annotation as? Capital else { return }
        
        let placeName = capital.title
        //let placeInfo = capital.info
        
        if let vc = navigationController?.storyboard?.instantiateViewController(withIdentifier: "WikipediaViewController") as? WikipediaViewController {
            vc.city = placeName
            navigationController?.pushViewController(vc, animated: true)
        }
        
        /* let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)*/
    }
    
    @objc func changeMap() {
        let ac = UIAlertController(title: "Edit map type", message: "Select an option", preferredStyle: .actionSheet)
        
        let types: KeyValuePairs = ["Hybrid": MKMapType.hybrid, "Hybrid flyover": .hybridFlyover,
                     "Muted standard": .mutedStandard, "Satellite": .satellite,
                     "Satellite flyover": .satelliteFlyover, "Standard": .standard]
        
        for (key, type) in types {
            ac.addAction(UIAlertAction(title: key, style: .default) { [weak self] action in
                self?.mapView.mapType = type
            })
        }
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(ac, animated: true)
    }
}

