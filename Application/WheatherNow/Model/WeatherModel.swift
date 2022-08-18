//
//  WeatherModel.swift
//  WheatherNow
//
//  Created by Nihad Alakbarzade on 15.08.22.
//

import Foundation

struct WeatherModel{
    let formatter = NumberFormatter()
    let conditionId: Int
    let cityName: String
    let temperature: Double
    let description: String
    let feelsLikeSetting: Double
    let humidityLabel: Int
    let WindLabel: Double
    
    var temperatureString: String{
        return formatter.string(from: temperature as NSNumber) ?? "n/a"
    }
    
    var feelsLikeString: String{
        return formatter.string(from: feelsLikeSetting as NSNumber) ?? "n/a"
    }
    var conditionName: String{
        switch conditionId {
        case 200...232:
            return "thunderstorm"
        case 300...321:
            return "thunderstorm-rain"
        case 500...531:
            return "rain2"
        case 600...622:
            return "snow-cloud"
        case 701...781:
            return "sun-cloud"
        case 800:
            return "sun"
        case 801...804:
            return "thunderstorm"
        default:
            return "sun-cloud"
        }
    }
}
