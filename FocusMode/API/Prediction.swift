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
    ltodo.predictedDuration = 0
    ltodo.startBy = DTM(20, 12, 22, 0, 0, "AM")
    ltodo.averageTemp = 0.0
    ltodo.prefPlaces = [Coords(0.0, 0.0)]
    
    completion(ltodo, nil)
}
