//
//  Colors.swift
//  Weatherify
//
//  Created by Emre Çakır on 3.03.2024.
//

import UIKit

struct Colors {
    static let clearSky = UIColor(red: 135, green: 206, blue: 235)
    static let cloudy = UIColor(red: 112, green: 128, blue: 144)
    static let partlyCloudy = UIColor(red: 255, green: 255, blue: 153)
    static let rain = UIColor(red: 169, green: 169, blue: 169)
    static let rainShowers = UIColor(red: 176, green: 196, blue: 222)
    static let rainy = UIColor(red: 169, green: 169, blue: 169)
    static let scatteredClouds = UIColor(red: 211, green: 211, blue: 211)
    static let sunny = UIColor(red: 255, green: 165, blue: 0)
    
    static let humidity = UIColor(red: 0, green: 191, blue: 255)
    static let windSpeed = UIColor(red: 0, green: 128, blue: 0)
    
    static let mapPin = UIColor(red: 255, green: 0, blue: 0)

    static func getWeatherColor(for weather: WeatherDescription) -> UIColor {
        switch weather {
        case .clearSky:
            return Colors.clearSky
        case .cloudy:
            return Colors.cloudy
        case .partlyCloudy, .weatherDescriptionPartlyCloudy:
            return Colors.partlyCloudy
        case .rain:
            return Colors.rain
        case .rainShowers:
            return Colors.rainShowers
        case .rainy:
            return Colors.rainy
        case .scatteredClouds:
            return Colors.scatteredClouds
        case .sunny:
            return Colors.sunny
        }
    }
    
    static func getWeatherInformationColor(for weatherInformation: WeatherInformationType) -> UIColor {
        switch weatherInformation {
        case .humidity:
            return Colors.humidity
        case .windSpeed:
            return Colors.windSpeed
        }
    }
}
