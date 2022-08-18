//
//  WeatherData.swift
//  WheatherNow
//
//  Created by Nihad Alakbarzade on 15.08.22.
//

import Foundation

struct WeatherData: Codable{
    let name: String
    let main: Main
    let wind: Wind
    let weather: [Weather]
}

struct Main: Codable{
    let temp: Double
    let feels_like: Double
    let humidity: Int
}

struct Weather: Codable{
    let main: String
    let id: Int
}

struct Wind: Codable{
    let speed: Double
}
