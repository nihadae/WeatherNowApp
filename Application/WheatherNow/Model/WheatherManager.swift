//
//  WheatherManager.swift
//  WheatherNow
//
//  Created by Nihad Alakbarzade on 14.08.22.
//

import Foundation
import CoreLocation
protocol WeatherManagerDelegate{
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager{
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?&appid=ea6e1b3eed80f9fc19f2d14bf9668de1&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String){
        let replaced = (cityName as NSString).replacingOccurrences(of: " ", with: "+")
        let urlString = "\(weatherURL)&q=\(replaced)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    
    func performRequest(with urlString: String){
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil{
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data{
                    if let weather = self.parseJSON(safeData){
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let desc = decodedData.weather[0].main
            let temp = decodedData.main.temp
            let name = decodedData.name
            let feels = decodedData.main.feels_like
            let hum = decodedData.main.humidity
            let wind = decodedData.wind.speed
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp, description: desc, feelsLikeSetting: feels, humidityLabel: hum, WindLabel: wind)
            
            return weather
        }catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}

