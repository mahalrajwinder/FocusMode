//
//  Copyright © 2020 Rajwinder Singh. All rights reserved.
//

import Foundation

// MARK: - Todo

struct Todo {
    var tid: String
    let title: String
    let due: Date
    let category: String
    let subject: String
    let rawPriority: Int
    var priority: Int? = nil
    var duration: Int? = nil // in minutes
    var startBy: Int? = nil // number of minutes the user should start working on the task before the due date
    var pauseTime: Date? = nil
    var breaks: Int?
    var timeLag: Int? // in minutes
    var distractions: Int?
    var prefPlaces: [Place]? = nil
    
    init(tid: String?, title: String, due: Date, category: String,
         subject: String, rawPriority: Int, priority: Int?, duration: Int?,
         startBy: Int?, pauseTime: Date?, breaks: Int?, timeLag: Int?,
         distractions: Int?, prefPlaces: [Place]?) {
        self.tid = tid ?? ""
        self.title = title
        self.due = due
        self.category = category
        self.subject = subject
        self.rawPriority = rawPriority
        self.priority = priority
        self.duration = duration
        self.startBy = startBy
        self.pauseTime = pauseTime
        self.breaks = breaks ?? 0
        self.timeLag = timeLag ?? 0
        self.distractions = distractions ?? 0
        self.prefPlaces = prefPlaces
    }
    
    init(_ tid: String, _ dictObj: [String: Any]) {
        self.tid = tid
        self.title = dictObj["title"] as! String
        self.due = Date(dictObj["due"] as! String)
        self.category = dictObj["category"] as! String
        self.subject = dictObj["subject"] as! String
        self.rawPriority = dictObj["rawPriority"] as! Int
        self.priority = dictObj["priority"] as? Int
        self.duration = dictObj["duration"] as? Int
        self.startBy = dictObj["startBy"] as? Int
        self.breaks = dictObj["breaks"] as? Int
        self.timeLag = dictObj["timeLag"] as? Int
        self.distractions = dictObj["distractions"] as? Int
        
        if let pauseTime = dictObj["pauseTime"] {
            self.pauseTime = Date(pauseTime as! String)
        }
        if let places = dictObj["prefPlaces"] {
            self.prefPlaces = []
            for place in places as! [[String: Any]] {
                self.prefPlaces?.append(Place(place))
            }
        }
    }
}

// MARK: - Todo Accessor Methods

extension Todo {
    func toDict() -> [String: Any] {
        var data: [String: Any] = ["title": title,
                                    "due": due.toString(),
                                    "category": category,
                                    "subject": subject,
                                    "rawPriority": rawPriority,
                                    "priority": priority!,
                                    "duration": duration!,
                                    "startBy": startBy!,
                                    "breaks": breaks!,
                                    "timeLag": timeLag!,
                                    "distractions": distractions!]
        if pauseTime != nil {
            data["pauseTime"] = pauseTime?.toString()
        }
        
        if prefPlaces != nil {
            var places: [[String: Any]] = []
            for place in prefPlaces! {
                places.append(place.toDict())
            }
            data["prefPlaces"] = places
        }
        
        return data
    }
}

// MARK: - Done

struct Done {
    let key: String // "subject,category"
    
    private var rating: Double
    private var logs: [[String: Int]]
    // ["rawPriority": 0, "duration": 0, "timeLag": 0, "distractions": 0, "breaks": 0, "rating": 0.0, "status": 0, "overdue": 0] For overdue: -Int means number of minutes the task was completed before due date, +Int means how many minutes after due date the task was completed.
    
    init(_ subject: String, _ category: String, _ rawPriority: Int, _ duration: Int,
         _ timeLab: Int, _ distractions: Int, _ breaks: Int, _ rating: Double,
         _ status: Int, _ overdue: Int) {
        self.key = "\(subject),\(category)"
        self.rating = rating
        let entry: [String: Int] = ["rawPriority": rawPriority,
                                    "duration": duration,
                                    "timeLab": timeLab,
                                    "distractions": distractions,
                                    "breaks": breaks,
                                    "status": status,
                                    "overdue": overdue]
        self.logs = [entry]
    }
    
    init(_ key: String, _ dictObj: [String: Any]) {
        self.key = key
        self.rating = dictObj["rating"] as! Double
        self.logs = dictObj["logs"] as! [[String : Int]]
    }
}

// MARK: - Done Accessor Methods

extension Done {
    func toDict() -> [String: Any] {
        return ["rating": rating, "logs": logs]
    }
}

// MARK: - Done Mutator Methods

extension Done {
    mutating func log(_ rawPriority: Int, _ duration: Int, _ timeLab: Int,
                      _ distractions: Int, _ breaks: Int, _ rating: Double,
                      _ status: Int, _ overdue: Int) {
        self.rating += rating
        let entry: [String: Int] = ["rawPriority": rawPriority,
                                    "duration": duration,
                                     "timeLab": timeLab,
                                     "distractions": distractions,
                                     "breaks": breaks,
                                     "status": status,
                                     "overdue": overdue]
        self.logs.append(entry)
    }
}
