//
//  Weather.swift
//  FocusMode
//
//  Copyright © 2020 Rajwinder Singh. All rights reserved.
//


import Foundation

func getWeather(lon :Double, lat :Double, completion: @escaping (Double?, Error?) -> Void) {
    let apiKey = "bbe06ef2b08340469f7a5b8e48581537"
    let weatherURL = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=imperial")!
    
    let session = URLSession.shared
    let dataTask = session.dataTask(with: weatherURL) {
        (data: Data?, response: URLResponse?, error: Error?) in
        if let error = error {
            completion(nil, error)
        } else {
            if let data = data {
                let dataString = String(data: data, encoding: String.Encoding.utf8)
                print("All the weather data:\n\(dataString!)")
                if let jsonObj = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary {
                    if let mainDictionary = jsonObj.value(forKey: "main") as? NSDictionary {
                        if let temperature = mainDictionary.value(forKey: "temp") {
                            DispatchQueue.main.async {
                                completion(temperature as? Double, nil)
                            }
                        }
                    } else {
                        print("Error: unable to find temperature in dictionary")
                    }
                } else {
                    print("Error: unable to convert json data")
                }
            } else {
                print("Error: did not receive data")
            }
        }
    }
    dataTask.resume()
}
