//
//  WeatherData.swift
//  swift-mvvm
//
//  Created by Taylor Guidon on 11/30/16.
//  Copyright © 2016 ISL. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Weather {
    
    var weatherData = [WeatherData]()
    public init(_ jsonData: JSON) {
        
        guard let dataArray = jsonData["daily"]["data"].array else {
            print("No array")
            return
        }
        for item in dataArray{
            weatherData.append(WeatherData(item))
        }
    }
}
struct WeatherData {
    
    var rawUnixTime: Double?
    var minTemp: Int?
    var maxTemp: Int?
    var summary: String?
    var dateString: String = ""

    public init(_ jsonData: JSON) {

            let minTemp = jsonData["temperatureMin"].double ?? 0.00
            let maxTemp = jsonData["temperatureMax"].double ?? 0.00
            let summary = jsonData["summary"].string ?? "N/A"
            
            self.rawUnixTime = jsonData["time"].double ?? 0.00
            self.minTemp = Int(minTemp.rounded())
            self.maxTemp = Int(maxTemp.rounded())
            self.summary = summary
        
        guard let unixTime = rawUnixTime else {
            print("Invalid unix time")
            return
        }
        
        let date = Date(timeIntervalSince1970: unixTime)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateString = dateFormatter.string(from: date)
        
    }
    
}
