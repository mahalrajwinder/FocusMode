//
//  TaskBeginViewController.swift
//  FocusMode
//
//  Copyright © 2020 Rajwinder Singh. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreMotion

class TaskBeginViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var placeRatingLabel: UILabel!
    @IBOutlet weak var startPauseBtn: UIButton!
    
    let locationManager = CLLocationManager()
    let motionManager = CMMotionManager()
    var db: Database!
    var coords: Location? = nil
    var places = [Place]()
    var timer:Timer?
    var counter: Counter?
    var isPaused = true
    var task: Todo!
    var workingPlace: PlaceShort? = nil
    var secondsWorked = 0
    var distractions = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize the Database
        db = Database()
        
        if let counter = task.counter {
            self.counter = counter
        } else {
            self.counter = Counter(task.duration!)
        }
        
        timerLabel.text = self.counter?.toString()
        
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            
            self.coords = Location((locationManager.location?.coordinate.latitude)!,
                                   (locationManager.location?.coordinate.longitude)!)
            self.places = applyContextToPlaces(coords: self.coords!, places: task.prefPlaces!)
            let place = self.places[0]
            self.placeNameLabel.text = place.name
            self.placeRatingLabel.text = "Rating: \(place.getRating())"
            
            getNearByPlaces(coords: self.coords!, completion: { (newPlaces, err) in
                if let err = err {
                    print("Error getting places: \(err)")
                } else {
                    // sort newPlaces based on distance
                    // Remove all places outside of 100 meters radius
                    // check if any of the placeID is in user DB
                    // if so, update Class variable for DB
                    // Otherwise create a newPlace entry.
                }
            })
        }
    }
    
    @IBAction func didTapStop(_ sender: Any) {
        timer?.invalidate()
        timer = nil
        
        if secondsWorked / 60 <= 0 {
            self.dismiss(animated: true)
            return
        }
        
        task.counter = counter
        task.pauseTime = Date()
        task.breaks! += 1
        task.distractions! += distractions
        
        let uid = UserDefaults.standard.string(forKey: "uid")!
        db.updateTodo(uid: uid, todo: task)
        
        let nc = NotificationCenter.default
        nc.post(name: NSNotification.Name("updateTodo"), object: nil, userInfo: ["updateTodo": task!])
        
        if workingPlace != nil {
            performSegue(withIdentifier: "ratePlaceSegue", sender: nil)
        } else {
            self.dismiss(animated: true)
        }
        //performSegue(withIdentifier: "ratePlaceSegue", sender: nil)
    }
    
    @IBAction func didTapDone(_ sender: Any) {
        timer?.invalidate()
        timer = nil
        task.counter = counter
        task.distractions! += distractions
        performSegue(withIdentifier: "showRatingSegue", sender: nil)
    }
    
    @IBAction func didTapStartPause(_ sender: Any) {
        if isPaused {
            if let pauseTime = task.pauseTime {
                task.timeLag! += Date().minutes(from: pauseTime)
            }
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(onTimerFires), userInfo: nil, repeats: true)
            self.startPauseBtn.setTitle("Pause", for: .normal)
            isPaused = false
        } else {
            timer?.invalidate()
            timer = nil
            task.pauseTime = Date()
            task.breaks! += 1
            self.startPauseBtn.setTitle("Start", for: .normal)
            isPaused = true
        }
    }
    
    @IBAction func didTapSeeAll(_ sender: Any) {
        performSegue(withIdentifier: "seeAllSegue", sender: nil)
    }
    
    @objc func onTimerFires()
    {
        counter?.decrement()
        secondsWorked += 1
        timerLabel.text = counter?.toString()
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
            ratingVC.workingPlace = workingPlace
            ratingVC.minutesWorked = secondsWorked / 60
            ratingVC.distractions = distractions
        } else if (segue.identifier == "seeAllSegue") {
            let destinationNC = segue.destination as! UINavigationController
            let seeAllVC = destinationNC.topViewController as! SeeAllTableViewController
            seeAllVC.places = places
        } else if (segue.identifier == "ratePlaceSegue") {
            let ratePlaceVC = segue.destination as! RatePlaceViewController
            ratePlaceVC.todo = self.task
            ratePlaceVC.workingPlace = workingPlace
            ratePlaceVC.minutesWorked = secondsWorked / 60
            ratePlaceVC.distractions = distractions
        }
    }
    
    // MARK: - Private Methods
    
    func applyContextToPlaces(coords: Location, places: [Place]) -> [Place] {
        // TODO: apply weights to rank and nearest to current location
        // then sort
        return places
    }
}
