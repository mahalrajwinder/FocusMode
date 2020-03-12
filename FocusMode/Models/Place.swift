//
//  Copyright © 2020 Rajwinder Singh. All rights reserved.
//

// MARK: - Place

struct Place {
    let name: String
    let location: Location
    let placeID: String
    let type: String
    var count: Int
    
    private var ratings: Double
    private var logs: [String: [String: Int]] // ["Mathematics,HW": ["frequency": 0, "minutesWorked": 0, "distractions": 0]]
    
    init(_ name: String, _ location: Location, _ placeID: String, _ type: String,
         _ rating: Double, _ subject: String, _ category: String,
         _ minutesWorked: Int, _ distractions: Int) {
        self.name = name
        self.location = location
        self.placeID = placeID
        self.type = type
        self.ratings = rating
        self.count = 1
        
        let entry = ["frequency": 1,
                     "minutesWorked": minutesWorked,
                     "distractions": distractions]
        self.logs = ["\(subject),\(category)": entry]
    }
    
    init(_ dictObj: [String: Any]) {
        self.name = dictObj["name"] as! String
        self.location = Location(dictObj["location"] as! [String : Double])
        self.placeID = dictObj["placeID"] as! String
        self.type = dictObj["type"] as! String
        self.ratings = dictObj["ratings"] as! Double
        self.count = dictObj["count"] as! Int
        self.logs = dictObj["logs"] as! [String : [String : Int]]
    }
}

// MARK: - Accessor Methods

extension Place {
    func toDict() -> [String: Any] {
        return ["name": name,
                "location": location.toDict(),
                "placeID": placeID,
                "type": type,
                "ratings": ratings,
                "count": count,
                "logs": logs]
    }
    
    func getRating() -> Double {
        return ratings / Double(count)
    }
    
    func isCloser(_ rhs: Place, _ current: Location) -> Bool {
        return current - self.location < current - rhs.location
    }
    
    func getProductivity(_ subject: String, _ category: String) -> Double {
        let log = self.logs["\(subject),\(category)"]
        if log == nil {
            return getAvgProductivity()
        }
        let minutesWorked = log!["minutesWorked"]!
        let distractions = log!["distractions"]!
        return calcProductivity(minutesWorked, distractions)
    }
    
    func getAvgProductivity() -> Double {
        var minutesWorked = 0
        var distractions = 0
        for (_, log) in self.logs {
            minutesWorked += log["minutesWorked"]!
            distractions += log["distractions"]!
        }
        return calcProductivity(minutesWorked, distractions)
    }
}

// MARK: - Mutator Methods

extension Place {
    mutating func log(_ rating: Double, _ subject: String, _ category: String,
                      _ minutesWorked: Int, _ distractions: Int) {
        self.ratings += rating
        self.count += 1
        
        let key = "\(subject),\(category)"
        if self.logs.index(forKey: key) == nil {
            let entry = ["frequency": 1,
                         "minutesWorked": minutesWorked,
                         "distractions": distractions]
            self.logs[key] = entry
        } else {
            self.logs[key]!["frequency"]! += 1
            self.logs[key]!["minutesWorked"]! += minutesWorked
            self.logs[key]!["distractions"]! += distractions
        }
    }
    
    mutating func log(place: Place) {
        self.ratings += place.ratings
        self.count += place.count
        
        for (key, entry) in place.logs {
            if self.logs.index(forKey: key) == nil {
                self.logs[key] = entry
            } else {
                self.logs[key]!["frequency"]! += entry["frequency"]!
                self.logs[key]!["minutesWorked"]! += entry["minutesWorked"]!
                self.logs[key]!["distractions"]! += entry["distractions"]!
            }
        }
    }
}

// MARK: - Private Methods

extension Place {
    private func calcProductivity(_ minutes: Int, _ distractions: Int) -> Double {
        var productivity = Double(minutes - distractions)
        productivity /= Double(minutes)
        productivity *= 100
        return productivity
    }
}
