//
//  Task.swift
//  FocusMode
//
//  Copyright © 2020 Rajwinder Singh. All rights reserved.
//

import Foundation

struct Todo {
    var tid: String?
    let title: String
    let dueDate: DTM
    let category: String
    let subject: String
    let rawPriority: Int
    var priority: Int? = nil
    var predictedDuration: Int? = nil // in minutes
    var startBy: DTM? = nil
    var pauseTime: DTM? = nil
    var totalBreaks: Int? = 0
    var breakDuration: Int? = 0 // in minutes
    var totalDistractions: Int? = 0
    var averageTemp: Double? = nil
    var prefPlaces: [Coords]? = nil
}

struct DoneTask {
    let tid: String
    let title: String
    let dueDate: String
    let category: String
    let subject: String
    let rawPriority: Int
    let priority: Int
    let observedDuration: Int
    let totalBreaks: Int
    let breakDuration: Int // in minutes
    let totalDistractions: Int
    let finishedAt: DTM
    let ratings: Double
    let status: Int // 1 = finished, 0 = not finished
    let averageTemp: Double
    let mostWorkedPlace: Coords // place where most of the task was completed
}
