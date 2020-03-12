//
//  PlacesTableViewController.swift
//  FocusMode
//
//  Copyright © 2020 Rajwinder Singh. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class PlacesTableViewController: UITableViewController, UISearchResultsUpdating, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    let searchController = UISearchController(searchResultsController: nil)
    var coords: Location? = nil
    var places = [PlaceShort]()
    var db: Database!
    
    // An empty tuple that will be updated with search results.
    var searchResults = [PlaceShort]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize the Database
        db = Database()
        
        // [START location manager setup]
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            
            self.coords = Location((locationManager.location?.coordinate.latitude)!,
                                   (locationManager.location?.coordinate.longitude)!)
            
            getNearByPlaces(coords: self.coords!, completion: { (places, err) in
                if let err = err {
                    print("Error getting places: \(err)")
                } else {
                    let uid = UserDefaults.standard.string(forKey: "uid")!
                    self.db.getPlaces(uid: uid, completion: { (prefPlaces, err) in
                        if let err = err {
                            print("Error getting pref places: \(err)")
                        } else {
                            self.rankResults(self.coords!, places!, prefPlaces!)
                        }
                    })
                }
            })
        }
        // [END location manager setup]
                
        // [START search bar setup]
        searchController.searchResultsUpdater = self
        self.definesPresentationContext = true
        
        // Place the search bar in the navigation item's title view.
        self.navigationItem.titleView = searchController.searchBar
        
        // Don't hide the navigation bar because the search bar is in it.
        searchController.hidesNavigationBarDuringPresentation = false
        // [END search bar setup]
    }
    
    func filterContent(for searchText: String) {
        // Update the searchResults array with matches
        searchResults = places.filter({ (place: PlaceShort) -> Bool in
            var match = place.name.range(of: searchText, options: .caseInsensitive)
            if match == nil {
                match = place.type.range(of: searchText, options: .caseInsensitive)
            }
            return match != nil
        })
    }
    
    // MARK: - Location Manager method
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    
    // MARK: - UISearchResultsUpdating method
    
    func updateSearchResults(for searchController: UISearchController) {
        // If the search bar contains text, filter our data with the string
        if let searchText = searchController.searchBar.text {
            filterContent(for: searchText)
            // Reload the table view with the search result data.
            tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // If the search bar is active, use the searchResults data.
        return searchController.isActive ? searchResults.count : places.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "placeCell", for: indexPath) as! PlaceTableViewCell
        
        // If the search bar is active, use the searchResults data.
        let place = searchController.isActive ? searchResults[indexPath.row] : places[indexPath.row]
        cell.nameLabel.text = place.name
        cell.ratingLabel.text = "Rating: \(place.rating)"

        return cell
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "searchSegue") {
            // Find the selected task
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: cell)!
            let place = searchController.isActive ? searchResults[indexPath.row] : places[indexPath.row]
            
            // Pass the selected place to the details view controller
            let placeDetailViewController = segue.destination as! PlaceDetailViewController
            placeDetailViewController.place = place
            
            // De-selects the selected task cell
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    private func rankResults(_ coords: Location, _ places: [PlaceShort], _ prefPlaces: [Place]) {
        let rankedPlaces = places.sorted(by: { hasHighRank($0, $1, self.coords!)})
        var personalizedPlaces = [Int: PlaceShort]()
        var position = 1
        for place in rankedPlaces {
            if hasPlace(place.placeID, prefPlaces) {
                personalizedPlaces[position] = place
            } else {
                personalizedPlaces[2 * position] = place
            }
            position += 1
        }
        
        for (_,place) in personalizedPlaces.sorted(by: { $0.0 < $1.0}) {
            self.places.append(place)
        }
        
        self.tableView.reloadData()
    }
    
    private func hasPlace(_ placeID: String, _ places: [Place]) -> Bool {
        for place in places {
            if place.placeID == placeID {
                return true
            }
        }
        return false
    }
    
    private func hasHighRank(_ lhs: PlaceShort, _ rhs: PlaceShort, _ coords: Location) -> Bool {
        let lhsDistance = lhs.location - coords
        let rhsDistance = rhs.location - coords
        
        var percentageDiff = abs(lhsDistance - rhsDistance)
        percentageDiff /= ((lhsDistance + rhsDistance) / 2)
        percentageDiff *= 100
        
        if percentageDiff <= 25 {
            return lhs.rating < rhs.rating
        }
        
        return lhsDistance < rhsDistance
    }

}
