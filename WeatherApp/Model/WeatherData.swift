//
//  WeatherData.swift
//  WeatherApp
//
//  Created by Дмитрий Кириченко on 01.12.2020.
//

import Foundation

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
    let feels_like:  Double
    let pressure: Double
    let humidity: Double
}

struct Weather: Codable {
    let id: Int
}
