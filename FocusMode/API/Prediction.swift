//
//  Prediction.swift
//  FocusMode
//
//  Copyright © 2020 Rajwinder Singh. All rights reserved.
//

import Foundation

func getInitialPredictions(db: Database, uid: String, todo: Todo,
                           completion: @escaping (Todo?, Error?) -> Void) {
    //
    // get tasks from tasks/done/(subject,category)
    // Then, go through all the logs to find priority, duration.
    // If there is not enough data, go to user's neighborhood.
    
    // Then based on that use pending tasks and calendar events to claculate startby date.
    
    //
    // get places/uid/
    // Filter places that are within 1000 meters
    // Short all places based on productivity
    // Then, add value to each place for productivity for a particular taqsk subject and category.
    // Get the first 10 places.
    
    // If there are not enough places, find places from user's neighborhood
    
    //
    
    db.getPlaces(uid: uid, completion: { (places, err) in
        if let err = err {
            print("Error getting places: \(err)")
            completion(nil, err)
        } else {
            var ltodo = todo
            ltodo.prefPlaces = getRankedPlaces(todo: ltodo, places: places!)
            
            db.getDoneTasks(uid: uid, subject: ltodo.subject, category: ltodo.category,
                            completion: { (task, err) in
                if let err = err {
                    print("Error getting Done tasks")
                    completion(nil, err)
                } else {
                    ltodo.priority = ltodo.rawPriority * (task?.getEasiness())!
                    ltodo.duration = task?.getAvgDuration()
                    ltodo.startBy = ltodo.duration! + (task?.getAvgTimeLag())!
                    completion(ltodo, nil)
                }
            })
        }
    })
}

func calculatePriority(todo: Todo, task: Done) -> Int {
//    let date = todo.due
//    let urgency = date.minutes(from: Date())
    return todo.rawPriority * task.getEasiness()
}

func getRankedPlaces(todo: Todo, places: [Place]) -> [Place] {
    let ranked = places.sorted(by: {
        $0.getProductivity(todo.subject, todo.category) * $0.getRating() >
        $1.getProductivity(todo.subject, todo.category) * $1.getRating()
    })
    
    return ranked
}
