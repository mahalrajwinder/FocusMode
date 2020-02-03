//
//  User.swift
//  FocusMode
//
//  Copyright © 2020 Rajwinder Singh. All rights reserved.
//

import Foundation

struct User {
    let uid: String
    let name: String
    let age: Double
    let gender: String
    let height: Double // in centimeters
    let weight: Double // in pounds
    let timePreference: String // morning or night
    let bedtime: String // HH:MM AM/PM
    let major: String
    let dailyGoal: Double // in minutes
    let deadlineSuccessRate: Double
    let handlingPriorities: Double
    let tasksCreated: Int
    let tasksCompleted: Int
    //let rankedDays: [String]
    //let mostVisitedPlaces: [Coordinates]
    //var averageSteps: Int
    //var averageCalories: Int
    //var sleepDuration: Double // number of hours
}
