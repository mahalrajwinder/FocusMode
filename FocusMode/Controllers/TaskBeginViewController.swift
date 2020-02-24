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
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var placeRatingLabel: UILabel!
    @IBOutlet weak var startPauseBtn: UIButton!
    
    let locationManager = CLLocationManager()
    var coords: Coords? = nil
    var places = [Place]()
    var timer:Timer?
    var timeLeft = 0
    var isPaused = true
    var task: Todo!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get timeleft from task and initialize timeLeft.
        timeLeft = 60
        timerLabel.text = "00:00:\(timeLeft)"
        
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            
            self.coords = Coords((locationManager.location?.coordinate.latitude)!,
            (locationManager.location?.coordinate.longitude)!)
            
            getNearByPlaces(coords: self.coords!, completion: { (places, err) in
                if let err = err {
                    print("Error getting places: \(err)")
                } else {
                    self.places = places!
                    // do sorting and apply personalization filters here
                    let place = self.places[0]
                    self.placeNameLabel.text = place.name
                    self.placeRatingLabel.text = "Rating: \(place.rating)"
                }
            })
        }
    }
    
    @IBAction func didTapStop(_ sender: Any) {
        timer?.invalidate()
        timer = nil
        // Save the current time in Todo
        // Save the Todo in database
        self.dismiss(animated: true)
    }
    
    @IBAction func didTapDone(_ sender: Any) {
        timer?.invalidate()
        timer = nil
        // Save the current time in Todo
        performSegue(withIdentifier: "showRatingSegue", sender: nil)
    }
    
    @IBAction func didTapStartPause(_ sender: Any) {
        if isPaused {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(onTimerFires), userInfo: nil, repeats: true)
            startPauseBtn.titleLabel?.text = "Pause"
        } else {
            timer?.invalidate()
            timer = nil
            startPauseBtn.titleLabel?.text = "Start"
        }
    }
    
    @IBAction func didTapSeeAll(_ sender: Any) {
        performSegue(withIdentifier: "seeAllSegue", sender: nil)
    }
    
    @objc func onTimerFires()
    {
        timeLeft -= 1
        timerLabel.text = "\(timeLeft)"
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showRatingSegue") {
            let ratingVC = segue.destination as! RatingViewController
            ratingVC.todo = self.task
        } else if (segue.identifier == "seeAllSegue") {
            let destinationNC = segue.destination as! UINavigationController
            let seeAllVC = destinationNC.topViewController as! SeeAllTableViewController
            seeAllVC.places = places
        }
    }
}
