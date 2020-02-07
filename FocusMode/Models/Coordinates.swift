//
//  Coordinates.swift
//  FocusMode
//
//  Created by Rajwinder on 2/6/20.
//  Copyright © 2020 Rajwinder Singh. All rights reserved.
//

import Foundation

struct Coords {
    var lat: Double
    var long: Double
    
    init(_ latitude: Double, _ longitude: Double) {
        self.lat = latitude
        self.long = longitude
    }
}
