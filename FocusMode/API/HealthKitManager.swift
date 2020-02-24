//
//  HealthKitManager.swift
//  FocusMode
//
//  Copyright © 2020 Rajwinder Singh. All rights reserved.
//

import UIKit
import HealthKit

class HealthKitManager {
    
    let healthStore = HKHealthStore()
    
    init() {
        self.getHealthKitPermission()
    }
    
    func getTodaysSteps(completion: @escaping (Double) -> Void) {
        if !HKHealthStore.isHealthDataAvailable() {
            completion(0.0)
            return
        }
        
        let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: stepsQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (_, result, error) in
            var resultCount = 0.0
            guard let result = result else {
                print("Failed to fetch steps rate")
                completion(resultCount)
                return
            }
            if let sum = result.sumQuantity() {
                resultCount = sum.doubleValue(for: HKUnit.count())
            }
            
            DispatchQueue.main.async {
                completion(resultCount)
            }
        }
        healthStore.execute(query)
    }
    
    func getAvgSteps(completion: @escaping (Double) -> Void) {
        if !HKHealthStore.isHealthDataAvailable() {
            completion(0.0)
            return
        }
        
        let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        
        let now = Date()
        let exactlySevenDaysAgo = Calendar.current.date(byAdding: DateComponents(day: -7), to: now)!
        let startOfSevenDaysAgo = Calendar.current.startOfDay(for: exactlySevenDaysAgo)
        let predicate = HKQuery.predicateForSamples(withStart: startOfSevenDaysAgo, end: now, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: stepsQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (_, result, error) in
            var resultCount = 0.0
            guard let result = result else {
                print("Failed to fetch steps rate")
                completion(resultCount)
                return
            }
            if let sum = result.sumQuantity() {
                resultCount = sum.doubleValue(for: HKUnit.count())
            }
            
            DispatchQueue.main.async {
                completion(resultCount)
            }
        }
        healthStore.execute(query)
    }
    
    private func getHealthKitPermission() {
        let allTypes = Set([HKObjectType.quantityType(forIdentifier: .stepCount)!,
                            HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!])

        healthStore.requestAuthorization(toShare: nil, read: allTypes) { (success, error) in
            if !success {
                // Handle the error here.
                print("Permission denied.")
                return
            }
            print("Permission accept.")
        }
    }
}
