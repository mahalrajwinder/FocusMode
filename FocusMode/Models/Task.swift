//
//  Task.swift
//  FocusMode
//
//  Copyright © 2020 Rajwinder Singh. All rights reserved.
//

import Foundation

struct Todo {
    let tid: String?
    let title: String
    let dueDate: DTM
    let category: String
    let subject: String
    let priority: Int
    let predictedDuration: Int // in minutes
    var totalBreaks: Int
    var breakDuration: Int // in minutes
    var totalDistractions: Int
    var startBy: DTM
    var tempRange: [String : Double]
    var prefPlaces: [Coords]
}

//struct DoneTask {
//    let tid: String
//    let title: String
//    let dueDate: String
//    let category: String
//    let subject: String
//    let priority: Double
//    let predictedDuration: Double? = nil
//    var observedDuration: Double? = nil
//    var totalBreaks: Int? = 0
//    var breakDuration: Double? = 0.0
//    var totalDistractions: Int? = 0
//    var start: String? = nil
//    var end: String? = nil
//    var status: Int? = 0
//    var ratings: Double? = nil
//    var temperature: Double? = nil
//    var location: Double? = nil
//}
