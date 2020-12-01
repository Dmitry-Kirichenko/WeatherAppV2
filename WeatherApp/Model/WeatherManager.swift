//
//  WeatherManager.swift
//  WeatherApp
//
//  Created by Дмитрий Кириченко on 01.12.2020.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}
 
struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=09d6ff2ba2dcf5587c9e934facd9a611&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cytyName: String) {
        let urlString = "\(weatherURL)&q=\(cytyName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees , longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, responce, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                        
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            let pressure = decodedData.main.pressure
            let humidity = decodedData.main.humidity
            let apparentTemp = decodedData.main.feels_like
            
            
            let weather = WeatherModel(conditionId: id, cityName: name,
                                       temperature: temp, pressure: pressure,
                                       humidity: humidity,
                                       apparentTemperature: apparentTemp)
            
            return weather
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}

