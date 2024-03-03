//
//  WeatherModel.swift
//  Weatherify
//
//  Created by Emre Çakır on 2.03.2024.
//

import Foundation

struct WeatherModel: Codable {
    let id: Int
    let city: String
    let country: String
    let latitude: Double
    let longitude: Double
    let temperature: Double
    let weatherDescription: WeatherDescription
    let humidity: Double
    let windSpeed: Double
    let forecast: [Forecast]
    var isFavourite = false
    
    enum CodingKeys: String, CodingKey {
        case id, city, country, latitude, longitude, temperature
        case weatherDescription = "weather_description"
        case humidity
        case windSpeed = "wind_speed"
        case forecast
    }
}

struct Forecast: Codable {
    let date: String
    let temperature: Double
    let weatherDescription: WeatherDescription
    let humidity: Double
    let windSpeed: Double
    
    enum CodingKeys: String, CodingKey {
        case date, temperature
        case weatherDescription = "weather_description"
        case humidity
        case windSpeed = "wind_speed"
    }
}

enum WeatherDescription: String, Codable {
    case clearSky = "Clear sky"
    case cloudy = "Cloudy"
    case partlyCloudy = "Partly cloudy"
    case rain = "Rain"
    case rainShowers = "Rain showers"
    case rainy = "Rainy"
    case scatteredClouds = "Scattered clouds"
    case sunny = "Sunny"
    case weatherDescriptionPartlyCloudy = "Partly Cloudy"
    
    var iconName: String {
        switch self {
        case .clearSky:
            return "rainbow"
        case .cloudy:
            return "cloud"
        case .partlyCloudy, .weatherDescriptionPartlyCloudy:
            return "cloud.sun"
        case .rain:
            return "cloud.rain"
        case .rainShowers:
            return "cloud.bolt.rain"
        case .rainy:
            return "cloud.heavyrain"
        case .scatteredClouds:
            return "smoke"
        case .sunny:
            return "sun.max"
        }
    }
}
