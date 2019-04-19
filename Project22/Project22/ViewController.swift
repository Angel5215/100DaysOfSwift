//
//  ViewController.swift
//  Project22
//
//  Created by Angel Vázquez on 4/17/19.
//  Copyright © 2019 Angel Vázquez. All rights reserved.
//

import UIKit
import CoreLocation


class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet var distanceReading: UILabel!
    @IBOutlet var beaconLabel: UILabel!
    @IBOutlet var circle: UIView!
    
    var shownBeacons: Set<UUID> = []
    
    //  Configure how we want to be notified about location and deliver location updates to us.
    var locationManager: CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        
        view.backgroundColor = .gray
        circle.layer.cornerRadius = 128
        circle.backgroundColor = .gray
        circle.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                //  Ability to tell roughly how far something else is away from a device.
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
    }
    
    func startScanning() {
        
        
        let registeredBeacons = [
            Beacon(name: "Apple Airlocate", uuid: UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!),
            Beacon(name: "Estimote", uuid: UUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!),
            Beacon(name: "TwoCanoes", uuid: UUID(uuidString: "92AB49BE-4127-42F4-B532-90fAF1E26491")!),
        ]
        
        for beacon in registeredBeacons {
            let beaconRegion = CLBeaconRegion(proximityUUID: beacon.uuid, major: 123, minor: 456, identifier: beacon.name)
            locationManager?.startMonitoring(for: beaconRegion)
            locationManager?.startRangingBeacons(in: beaconRegion)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if let beacon = beacons.first {
            update(distance: beacon.proximity, identifier: region.identifier)
            
            if !shownBeacons.contains(beacon.proximityUUID) {
                shownBeacons.insert(beacon.proximityUUID)
                showAlertForBeacon(beacon)
            }
        }
    }
    
    func update(distance: CLProximity, identifier: String? = nil) {
        
        beaconLabel.text = identifier
        
        UIView.animate(withDuration: 1) {
            switch distance {
            case .far:
                self.view.backgroundColor = .blue
                self.circle.backgroundColor = .yellow
                self.distanceReading.text = "FAR"
                self.circle.transform = CGAffineTransform(scaleX: 1, y: 1)
            case .near:
                self.view.backgroundColor = .orange
                self.circle.backgroundColor = .cyan
                self.distanceReading.text = "NEAR"
                self.circle.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            case .immediate:
                self.view.backgroundColor = .red
                self.circle.backgroundColor = .green
                self.distanceReading.text = "RIGHT HERE"
                self.circle.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
            default:
                self.view.backgroundColor = .gray
                self.circle.backgroundColor = .white
                self.distanceReading.text = "UNKNOWN"
                self.circle.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                self.beaconLabel.text = "No beacon detected"
            }
        }
    }
    
    func showAlertForBeacon(_ beacon: CLBeacon) {
        let ac = UIAlertController(title: "Beacon detected", message: "UUID:  \(beacon.proximityUUID.uuidString) detected!", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(ac, animated: true)
    }
}

