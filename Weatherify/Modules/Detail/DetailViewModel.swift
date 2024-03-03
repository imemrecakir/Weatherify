//
//  DetailViewModel.swift
//  Weatherify
//
//  Created by Emre Çakır on 29.02.2024.
//

import Foundation

protocol DetailViewModelDelegate: AnyObject {
    func isLoading(_ isLoading: Bool)
    func weatherUpdated()
    func favouriteUpdated()
}

final class DetailViewModel: BaseViewModel {
    
    weak var delegate: DetailViewModelDelegate?
    
    var weather: WeatherModel?
    
    var forecasts: [Forecast] = []
    
    var selectedForecastIndex = 0 {
        didSet {
            delegate?.weatherUpdated()
        }
    }
    
    var selectedForecast: Forecast? {
        if forecasts.isEmpty {
            return nil
        } else {
            return forecasts[selectedForecastIndex]
        }
    }
    
    override var isLoading: Bool {
        didSet {
            delegate?.isLoading(isLoading)
        }
    }
    
    private init(weather: WeatherModel?, weatherId: Int?) {
        super.init()
        if let weather {
            self.weather = weather
            self.configureForecasts()
        } else if let weatherId {
            fetchWeather(with: weatherId)
        }
    }
    
    convenience init(weather: WeatherModel) {
        self.init(weather: weather, weatherId: nil)
    }
    
    convenience init(weatherId: Int) {
        self.init(weather: nil, weatherId: weatherId)
    }
    
    private func fetchWeather(with id: Int) {
        isLoading = true
        NetworkManager.shared.request(type: WeatherModel.self, endpoint: .getWeather(id: id), httpMethod: .get) { [weak self] result in
            switch result {
            case .success(let weather):
                self?.weather = weather
                self?.configureForecasts()
                self?.errorMessage = nil
            case .failure(let error):
                self?.errorMessage = error.errorMessage
            }
            
            self?.isLoading = false
        }
    }
    
    private func updateFavourite() {
        if let weather, weather.isFavourite {
            //TODO: Remove from favourites
        } else {
            //TODO: Add to favourites
        }
    }
    
    private func configureForecasts() {
        if let weather {
            let todayForecast = Forecast(date: Date.now.formatted(),
                                         temperature: weather.temperature,
                                         weatherDescription: weather.weatherDescription,
                                         humidity: weather.humidity,
                                         windSpeed: weather.windSpeed,
                                         dayOfDate: "Today")
            forecasts.append(todayForecast)
            
            let nextDaysForecasts = weather.forecast.map { forecast in
                var updatedForecast = forecast
                updatedForecast.dayOfDate = getDayName(from: forecast.date)
                return updatedForecast
            }
            
            forecasts.append(contentsOf: nextDaysForecasts)
            
            DispatchQueue.main.async { [weak self] in
                self?.delegate?.weatherUpdated()
            }
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
