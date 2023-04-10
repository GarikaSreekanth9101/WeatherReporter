//
//  WeatherData.swift
//  WeatherReporter
//
//  Created by 7KINGSCODE on 4/10/23.
//

import Foundation

struct WeatherData: Codable
{
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
}
struct Weather: Codable {
    let id: Int
    let description: String
}


