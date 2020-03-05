//
//  Copyright © 2020 Rajwinder Singh. All rights reserved.
//

import CoreLocation

struct Location {
    let lat: Double
    let lng: Double
    
    init(_ latitude: Double, _ longitude: Double) {
        self.lat = latitude
        self.lng = longitude
    }
    
    init(_ dictObj: [String: Double]) {
        self.lat = dictObj["lat"]!
        self.lng = dictObj["lng"]!
    }
}

// MARK: - Methods

extension Location {
    func toDict() -> [String: Double] {
        return ["lat": self.lat,
                "lng": self.lng]
    }
    
    func equals(_ rhs: Location) -> Bool {
        return (self - rhs) <= 10.0
    }
}

// MARK: - Operators

extension Location {
    static func - (lhs: Location, rhs: Location) -> Double {
        let left = CLLocation(latitude: lhs.lat, longitude: lhs.lng)
        let right = CLLocation(latitude: rhs.lat, longitude: rhs.lng)
        return left.distance(from: right)
    }
}
