//
//  Profile.swift
//  FocusMode
//
//  Created by Rajwinder on 2/6/20.
//  Copyright © 2020 Rajwinder Singh. All rights reserved.
//

import Foundation

struct Profile {
    let uid: String
    let name: String
    let age: Int
    let gender: String
    let height: Double // in centimeters
    let weight: Double // in pounds
    let address: Coords
    let major: String
    let timePreference: String // morning or night
    let dailyGoal: Int // in minutes
    let bedtime: TM
    let successRate: Double // how often user meets the given deadlines
    let handlingPrioritiesRate: Double // How well the user deal with changing priorities
    let hardworkingRate: Double
}

struct UserModel {
    let uid: String
    let tasksCreated: Int
    let tasksCompleted: Int
    let daysIndex: [[String: Any]]
    let mostVisitedPlaces: [Coords]
    let averageDistractions: Int
    let averageBreakDuration: Int
    let averageTaskDuration: Int
    let mostFrequentSubject: String
    let mostFrequentCategory: String
    let mostMissedDeadlinesTaskSubject: String
    let mostMissedDeadlinesTaskCategory: String
    let activity: Int // number of minutes study. Reset to 0 at midnight.
    let tempRange: [String : Double]
}
