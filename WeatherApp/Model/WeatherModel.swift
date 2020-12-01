//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Дмитрий Кириченко on 01.12.2020.
//

import Foundation

struct WeatherModel {
    let conditionId: Int
    let cityName: String
    let temperature: Double
    let pressure: Double
    let humidity: Double
    let apparentTemperature: Double
    
    var temperatureString: String {
        return String(format: "%.0f", temperature)
    }
    var pressureString: String {
        return String(format: "%.0f", pressure)
    }
    var humidityString: String {
        return String(format: "%.0f", humidity)
    }
    var apparentTemperatureString: String {
        return String(format: "%.0f", apparentTemperature)
    }
    
    
    var conditionName: String {
        switch conditionId {
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
            return "cloud"
        default:
            return "cloud"
        }
    }
}
