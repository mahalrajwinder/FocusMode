//
//  Prediction.swift
//  FocusMode
//
//  Copyright © 2020 Rajwinder Singh. All rights reserved.
//


func getInitialPredictions(todo: Todo,
                           completion: @escaping (Todo?, Error?) -> Void) {
    //
    var ltodo = todo
    ltodo.priority = 0
    ltodo.duration = 0
    ltodo.startBy = 0
    //ltodo.prefPlaces = [Place]
    
    completion(ltodo, nil)
}
