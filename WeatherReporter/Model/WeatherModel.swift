//
//  WeatherModel.swift
//  WeatherReporter
//
//  Created by 7KINGSCODE on 4/10/23.
//

import Foundation

struct WeatherModel
{
    //Stored Properties
    let conditonId: Int
    let cityName: String
    let temprature: Double
    
    //Computed Properties
    var tempratureInString: String
    {
        return String(format: "%.1f", temprature)
    }
    var conditionName: String {
        switch conditonId {
            
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
}

