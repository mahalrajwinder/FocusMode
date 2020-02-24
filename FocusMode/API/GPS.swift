//
//  GPS.swift
//  FocusMode
//
//  Created by Rajwinder on 2/22/20.
//  Copyright © 2020 Rajwinder Singh. All rights reserved.
//

import Foundation
import CoreLocation

func getCoordsFromAddress(address: String,
                          completion: @escaping (Coords?, Error?) -> Void) {
    let geocoder = CLGeocoder()
    geocoder.geocodeAddressString(address) { (placemarks, err) in
        if err == nil {
            if let placemark = placemarks?[0] {
                let location = placemark.location!
                let coords = Coords(location.coordinate.latitude,
                                    location.coordinate.longitude)
                
                completion(coords, nil)
                return
            }
        }
        
        completion(nil, err)
    }
}
