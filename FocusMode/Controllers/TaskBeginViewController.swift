//
//  TaskBeginViewController.swift
//  FocusMode
//
//  Copyright © 2020 Rajwinder Singh. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class TaskBeginViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    var task: Todo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    @IBAction func didTapStop(_ sender: Any) {
        // TODO: pause the Task
        self.dismiss(animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
}
