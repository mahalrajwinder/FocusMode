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
    @IBOutlet weak var taskProductivityLabel: UILabel!
    @IBOutlet weak var avgProductivityLabel: UILabel!
    @IBOutlet weak var startPauseBtn: UIButton!
    
    let locationManager = CLLocationManager()
    let motionManager = CMMotionActivityManager()
    var db: Database!
    var coords: Location? = nil
    var places = [Place]()
    var timer: Timer?
    var motionTimer: Timer?
    var counter: Counter?
    var isPaused = true
    var task: Todo!
    var workingPlace: PlaceShort? = nil
    var secondsWorked = 0
    var distractions = 0
    var lastDistractionSecondsAgo = 0
    
    
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
            self.taskProductivityLabel.text = String(format: "Task Productivity Rate: %.2f%%", place.getProductivity(self.task.subject, self.task.category))
            self.avgProductivityLabel.text = String(format: "Average Productivity Rate: %.2f%%", place.getAvgProductivity())
            
            getNearByPlaces(coords: self.coords!, completion: { (newPlaces, err) in
                if let err = err {
                    print("Error getting places: \(err)")
                } else {
                    self.parseCurrentLocation(self.coords!, newPlaces!)
                }
            })
            
            // Update weather information
            getWeather(lon: self.coords!.lng, lat: self.coords!.lat, completion: { (temp, err) in
                if let err = err {
                    print("Error getting weather data: \(err)")
                } else {
                    self.db.updateWeather(temp: temp!)
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
        if !isPaused {
            task.breaks! += 1
        }
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
            startDetectingMotion()
        } else {
            timer?.invalidate()
            timer = nil
            task.pauseTime = Date()
            task.breaks! += 1
            self.startPauseBtn.setTitle("Start", for: .normal)
            isPaused = true
            endDetectingMotion()
        }
    }
    
    @IBAction func didTapSeeAll(_ sender: Any) {
        performSegue(withIdentifier: "seeAllSegue", sender: nil)
    }
    
    @objc func onMotionTimer() {
        if lastDistractionSecondsAgo >= 60 {
            motionTimer?.invalidate()
            motionTimer = nil
            lastDistractionSecondsAgo = 0
        } else {
            lastDistractionSecondsAgo += 1
        }
        print(lastDistractionSecondsAgo)
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
    
    private func applyContextToPlaces(coords: Location, places: [Place]) -> [Place] {
        return places.sorted(by: { hasHighRank($0, $1, coords) })
    }
    
    private func hasHighRank(_ lhs: Place, _ rhs: Place, _ coords: Location) -> Bool {
        let lhsDistance = lhs.location - coords
        let rhsDistance = rhs.location - coords
        
        var percentageDiff = abs(lhsDistance - rhsDistance)
        percentageDiff /= ((lhsDistance + rhsDistance) / 2)
        percentageDiff *= 100
        
        if percentageDiff <= 25 {
            return lhs.getRating() * (lhs.getAvgProductivity() / 100) >
                rhs.getRating() * (rhs.getAvgProductivity() / 100)
        }
        
        return lhsDistance < rhsDistance
    }
    
    private func parseCurrentLocation(_ coords: Location, _ places: [PlaceShort]) {
        let newPlaces = places.sorted(by: { $0.location - coords < $1.location - coords})
        if newPlaces.count != 0 {
            let currentPlace = newPlaces[0]
            if currentPlace.location - coords < 500 {
                workingPlace = currentPlace
            }
        }
    }
    
    private func startDetectingMotion() {
        if !CMMotionActivityManager.isActivityAvailable() {
            return
        }
        self.motionManager.startActivityUpdates(to: OperationQueue.main) { (motion) in
            if (motion?.stationary)! && self.lastDistractionSecondsAgo == 0 {
                self.distractions += 1
                 self.motionTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.onMotionTimer), userInfo: nil, repeats: true)
            }
        }
    }
    
    private func endDetectingMotion() {
        motionManager.stopActivityUpdates()
        if motionTimer != nil {
            motionTimer?.invalidate()
            motionTimer = nil
        }
    }
}
