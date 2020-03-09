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
    
    // An empty tuple that will be updated with search results.
    //var searchResults : [(title: String, image: String)] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                    self.places = places!.sorted(by: { $0.location - self.coords! < $1.location - self.coords!})
                    // do sorting and apply personalization filters here
                    self.tableView.reloadData()
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
        // in our entries based on the title value.
//        searchResults = entries.filter({ (title: String, image: String) -> Bool in
//            let match = title.range(of: searchText, options: .caseInsensitive)
//            // Return the tuple if the range contains a match.
//            return match != nil
//        })
    }
    
    // MARK: - Location Manager method
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
//        print("locations = \(locValue.latitude) \(locValue.longitude)")
//    }
    
    // MARK: - UISearchResultsUpdating method
    
    func updateSearchResults(for searchController: UISearchController) {
        // If the search bar contains text, filter our data with the string
//        if let searchText = searchController.searchBar.text {
//            filterContent(for: searchText)
//            // Reload the table view with the search result data.
//            tableView.reloadData()
//        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // If the search bar is active, use the searchResults data.
        //return searchController.isActive ? searchResults.count : entries.count
        return places.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "placeCell", for: indexPath) as! PlaceTableViewCell
        
        let place = places[indexPath.row]
        cell.nameLabel.text = place.name
        cell.ratingLabel.text = "Rating: \(place.rating)"

        return cell
        
        // If the search bar is active, use the searchResults data.
//        let entry = searchController.isActive ?
//                    searchResults[indexPath.row] : entries[indexPath.row]
//
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
//        cell.textLabel?.text = entry.title
//        cell.imageView?.image = UIImage(named: entry.image)
//        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
