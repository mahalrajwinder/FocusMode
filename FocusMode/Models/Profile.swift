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
    let timePreference: String // morning or night
    let bedtime: TM
    let major: String
    let dailyGoal: Int // in minutes
    let successRate: Double // how often user meets the given deadlines
    let handlingPrioritiesRate: Double // How well the user deal with changing priorities
    let tasksCreated: Int
    let tasksCompleted: Int
    let daysIndex: [String]
    let activity: Int
    let mostVisitedPlaces: [Coords]
    let averageSteps: Int
    let averageCalories: Int
}
