//
//  WeatherManager.swift
//  Clima
//
//  Created by Arnold Tjiawi on 26/06/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation
protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=85f5188f31dcbf8444b33b8ac178a74a&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    func fetchWeather(cityName: String){
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String){
        // 1. Create a URL
        if let url = URL(string: urlString) {
            // 2. Create a URL Session
            let session = URLSession(configuration: .default)
            
            // 3. give URLSession a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil{
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data{
                    //                    let dataString = String(data: safeData, encoding: .utf8)
                    if let weather = parseJSON(safeData){
                        self.delegate?.didUpdateWeather(self, weather: weather)
                        
                    }
                }
            }
            
            // 4. start a task
            task.resume()
        }
        
        func parseJSON(_ weatherData: Data) -> WeatherModel?{
            let decoder = JSONDecoder()
            do{
                let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
                let id = decodedData.weather[0].id
                let name = decodedData.name
                let temp = decodedData.main.temp
                
                let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
                
                return weather
                
            } catch{
                self.delegate?.didFailWithError(error: error)
                return nil
            }
        }
        
        
        
    }
    
    
    
}

