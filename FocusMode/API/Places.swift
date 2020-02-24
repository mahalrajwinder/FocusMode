//
//  Places.swift
//  FocusMode
//
//  Copyright © 2020 Rajwinder Singh. All rights reserved.
//

import Foundation
import Alamofire

struct Place {
    let name: String
    let coords: Coords
    let open_now: Bool
    let rating: Double
    let type: String
    let place_id: String
}

func getNearByPlaces(coords: Coords,
                     completion: @escaping ([Place]?, Error?) -> Void) {
    let url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
    let parameters: [String : Any] = [
        "location": "\(coords.lat),\(coords.long)",
        "radius": 1000,
        "type": "library",
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
            var places = [Place]()
            
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
                let coords = Coords(loc["lat"] as! Double, loc["lng"] as! Double)
                
                let place = Place(name: name, coords: coords, open_now: open_now,
                                  rating: rating, type: "library", place_id: place_id)
                places.append(place)
            }
            
            completion(places, nil)
            return
        }
    }
}


// https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=33.644494,-117.840710&radius=1000&type=library&key=AIzaSyDa7o2oqHZX8X7-2zJJ3f2v1Ydd0zgtnhc

// https://maps.googleapis.com/maps/api/place/details/json?place_id=ChIJN1t_tDeuEmsRUsoyG83frY4&fields=name,rating,formatted_phone_number&key=YOUR_API_KEY
