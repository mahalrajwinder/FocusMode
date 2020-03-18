//
//  Copyright © 2020 Rajwinder Singh. All rights reserved.
//

//import Foundation

struct Profile {
    let uid: String
    let name: String
    let age: Int
    let gender: String
    let height: Double // in centimeters
    let weight: Double // in pounds
    let address: Location
    let major: String
    let timePreference: String // morning or night
    let dailyGoal: Int // in minutes
    let bedtime: String
    let successRate: Double // how often user meets the given deadlines
    let handlingPrioritiesRate: Double // How well the user deal with changing priorities
    let hardworkingRate: Double
    
    init(uid: String, name: String, age: Int, gender: String, height: Double,
         weight: Double, address: Location, major: String, timePreference: String,
         dailyGoal: Int, bedtime: String, successRate: Double, handlingPrioritiesRate: Double,
         hardworkingRate: Double) {
        self.uid = uid
        self.name = name
        self.age = age
        self.gender = gender
        self.height = height
        self.weight = weight
        self.address = address
        self.major = major
        self.timePreference = timePreference
        self.dailyGoal = dailyGoal
        self.bedtime = bedtime
        self.successRate = successRate
        self.handlingPrioritiesRate = handlingPrioritiesRate
        self.hardworkingRate = hardworkingRate
    }
    
    init(_ uid: String, _ dictObj: [String: Any]) {
        self.uid = uid
        self.name = dictObj["name"] as! String
        self.age = dictObj["age"] as! Int
        self.gender = dictObj["gender"] as! String
        self.height = dictObj["height"] as! Double
        self.weight = dictObj["weight"] as! Double
        self.address = Location(dictObj["address"] as! [String: Double])
        self.major = dictObj["major"] as! String
        self.timePreference = dictObj["timePreference"] as! String
        self.dailyGoal = dictObj["dailyGoal"] as! Int
        self.bedtime = dictObj["bedtime"] as! String
        self.successRate = dictObj["successRate"] as! Double
        self.handlingPrioritiesRate = dictObj["handlingPrioritiesRate"] as! Double
        self.hardworkingRate = dictObj["hardworkingRate"] as! Double
    }
    
    func toDict() -> [String: Any] {
        return ["name": name,
                "age": age,
                "gender": gender,
                "height": height,
                "weight": weight,
                "timePreference": timePreference,
                "bedtime": bedtime,
                "major": major,
                "dailyGoal": dailyGoal,
                "successRate": successRate,
                "handlingPrioritiesRate": handlingPrioritiesRate,
                "hardworkingRate": hardworkingRate,
                "address": address.toDict()]
    }
}

struct UserModel {
    let uid: String
    let tasksCreated: Int
    let tasksCompleted: Int
    let daysIndex: [[String: Any]]
    //let mostVisitedPlaces: [Place]
//    let averageDistractions: Int
//    let averageTimeLag: Int
//    let averageTaskDuration: Int
//    let mostFrequentSubject: String
//    let mostFrequentCategory: String
//    let mostMissedDeadlinesTaskSubject: String
//    let mostMissedDeadlinesTaskCategory: String
    let activity: Int // number of minutes study. Reset to 0 at midnight.
    let tempRange: [String: Double] // ["temperatures": Double, "count": # of readings] Then use this to find average temp. Reset temperatures to average and Count to 1 after each month.
//    let avgSteps: Int
}
