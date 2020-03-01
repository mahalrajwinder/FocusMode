//
//  Copyright © 2020 Rajwinder Singh. All rights reserved.
//

import Foundation
import Alamofire

struct PlaceShort {
    let name: String
    let location: Location
    let open_now: Bool
    let rating: Double
    let type: String
    let placeID: String
}


func getNearByPlaces(coords: Location,
                     completion: @escaping ([PlaceShort]?, Error?) -> Void) {
    var placesArr = [PlaceShort]()
    
    getPlaces(coords: coords, type: "cafe", completion: { (places, err) in
        if let err = err {
            print("Error getting cafes: \(err)")
            completion(nil, err)
        } else {
            placesArr.append(contentsOf: places!)
            // Now get nearby libraries
            getPlaces(coords: coords, type: "library", completion: { (places, err) in
                if let err = err {
                    print("Error getting libraries: \(err)")
                    completion(nil, err)
                } else {
                    placesArr.append(contentsOf: places!)
                    completion(placesArr, nil)
                }
            })
        }
    })
}


private func getPlaces(coords: Location, type: String,
                       completion: @escaping ([PlaceShort]?, Error?) -> Void) {
    let url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
    let parameters: [String : Any] = [
        "location": "\(coords.lat),\(coords.lng)",
        "radius": 1000,
        "type": type,
        "key": "AIzaSyDa7o2oqHZX8X7-2zJJ3f2v1Ydd0zgtnhc"
    ]
    
    AF.request(url, parameters: parameters).responseJSON { (response) in
        switch (response.result) {
        case .failure(let error):
        print("Request failed with error: \(error)")
        return
        
        case .success(let JSON):
            let responseData = JSON as! [String: Any]
            let results = responseData["results"] as! [[String: Any]]
            var places = [PlaceShort]()
            
            for result in results {
                let name = result["name"] as! String
                let place_id = result["place_id"] as! String
                
                var rating = 2.5
                if let r = result["rating"] {
                    rating = Double(exactly: r as! NSNumber)!
                }
                
                var open_now = false
                if let opening = result["opening_hours"] {
                    let openingDict = opening as! [String: Any]
                    if let open = openingDict["open_now"] {
                        open_now = open as! Bool
                    }
                }
            
                let geo = result["geometry"] as! [String: Any]
                let loc = geo["location"] as! [String: Any]
                let coords = Location(loc["lat"] as! Double, loc["lng"] as! Double)
                
                let place = PlaceShort(name: name, location: coords, open_now: open_now,
                                       rating: rating, type: type, placeID: place_id)
                places.append(place)
            }
            
            completion(places, nil)
            return
        }
    }
}


// https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=33.644494,-117.840710&radius=1000&type=library&key=AIzaSyDa7o2oqHZX8X7-2zJJ3f2v1Ydd0zgtnhc

// https://maps.googleapis.com/maps/api/place/details/json?place_id=ChIJN1t_tDeuEmsRUsoyG83frY4&fields=name,rating,formatted_phone_number&key=YOUR_API_KEY
