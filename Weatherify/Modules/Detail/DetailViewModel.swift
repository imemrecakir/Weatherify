//
//  DetailViewModel.swift
//  Weatherify
//
//  Created by Emre Çakır on 29.02.2024.
//

import Foundation

protocol DetailViewModelDelegate: AnyObject {
    func favouriteUpdated()
}

final class DetailViewModel: BaseViewModel {
    
    weak var delegate: DetailViewModelDelegate?
    
    let weather: WeatherModel
    
    var forecasts: [Forecast] = []
    
    init(weather: WeatherModel) {
        self.weather = weather
        let todayForecast = Forecast(date: Date().description,
                                     temperature: weather.temperature,
                                     weatherDescription: weather.weatherDescription,
                                     humidity: weather.humidity,
                                     windSpeed: weather.windSpeed)
        forecasts.append(todayForecast)
        forecasts.append(contentsOf: weather.forecast)
    }
    
    func updateFavourite() {
        if weather.isFavourite {
            //TODO: Remove from favourites
        } else {
            //TODO: Add to favourites
        }
    }
    
    private func getDayName(from dateString: String, format: String = "yyyy-MM-dd") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "EEEE"
            return dateFormatter.string(from: date)
        } else {
            return "N/A"
        }
    }
}
