//
//  Weather.swift
//  FocusMode
//
//  Copyright © 2020 Rajwinder Singh. All rights reserved.
//


import Foundation
import Alamofire

func getWeather(lon :Double, lat :Double, completion: @escaping ([String: Double]?, Error?) -> Void) {
    let apiKey = "bbe06ef2b08340469f7a5b8e48581537"

    AF.request ("http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=imperial")
        .responseJSON { (response) in
            switch (response.result) {
                case .failure(let error):
                    print("Error getting weather data: \(error)")
                    completion(nil, error)
                
                case .success(let JSON):
                    let responseData = JSON as! [String: Any]
                    let weather = responseData["weather"] as! [String: Double]
                    completion(weather, nil)
            }
        }
}
