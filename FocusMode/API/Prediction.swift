//
//  Prediction.swift
//  FocusMode
//
//  Copyright © 2020 Rajwinder Singh. All rights reserved.
//


func getInitialPredictions(title: String,
                           due: DTM,
                           category: String,
                           subject: String,
                           rawPriority: Int) -> [String: Any] {
    //
    
    return [
        "priority": 0,
        "predictedDuration": 0,
        "startBy": DTM(0,0,0,0,0,"AM"),
        "tempRange": [
            "min": 0.0,
            "max": 0.0,
        ],
        "prefPlaces": [
            Coords(0.0, 0.0),
        ],
    ]
}
