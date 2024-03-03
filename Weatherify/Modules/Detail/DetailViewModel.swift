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
            checkIsFavourite()
            configureForecasts()
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
                self?.isLoading = false
                self?.errorMessage = nil
                DispatchQueue.main.async {
                    self?.checkIsFavourite()
                    self?.configureForecasts()
                }
            case .failure(let error):
                self?.isLoading = false
                self?.errorMessage = error.errorMessage
            }
        }
    }
    
    private func checkIsFavourite() {
        isLoading = true
        if let weather {
            let predicate = NSPredicate(format: "id == \(weather.id)")
            DatabaseManager.shared.fetchEntity(object: Favourite.self, entity: .favourite, predicate: predicate) { [weak self] result in
                switch result {
                case .success(let favourites):
                    self?.weather?.isFavourite = !favourites.isEmpty
                case .failure(let failure):
                    self?.errorMessage = failure.errorMessage
                }
                
                self?.isLoading = false
                DispatchQueue.main.async {
                    self?.delegate?.favouriteUpdated()
                }
            }
        }
    }
    
    func updateFavourite() {
        if let weather {
            isLoading = true
            if weather.isFavourite {
                getFavouriteById { [weak self] result in
                    switch result {
                    case .success(let favourite):
                        DatabaseManager.shared.deleteObject(object: favourite) { result in
                            switch result {
                            case .success:
                                self?.checkIsFavourite()
                            case .failure(let failure):
                                self?.errorMessage = failure.errorMessage
                                self?.isLoading = false
                                DispatchQueue.main.async {
                                    self?.delegate?.favouriteUpdated()
                                }
                            }
                            
                            self?.isLoading = false
                        }
                    case .failure(let failure):
                        self?.errorMessage = failure.errorMessage
                        self?.isLoading = false
                        DispatchQueue.main.async {
                            self?.delegate?.favouriteUpdated()
                        }
                    }
                }
            } else {
                let favourite = Favourite(context: DatabaseManager.shared.context)
                favourite.id = Int64(weather.id)
                favourite.city = weather.city
                favourite.country = weather.country
                favourite.addedDate = Date.now
                
                DatabaseManager.shared.saveObject(object: favourite) { [weak self] result in
                    switch result {
                    case .success:
                        self?.weather?.isFavourite = true
                    case .failure(let failure):
                        self?.errorMessage = failure.errorMessage
                    }
                    
                    self?.isLoading = false
                    DispatchQueue.main.async {
                        self?.delegate?.favouriteUpdated()
                    }
                }
            }
        }
    }
    
    private func getFavouriteById(completion: @escaping (Result<Favourite, DatabaseError>) -> Void) {
        if let weather {
            let predicate = NSPredicate(format: "id == \(weather.id)")
            DatabaseManager.shared.fetchEntity(object: Favourite.self, entity: .favourite, predicate: predicate) { result in
                switch result {
                case .success(let favourites):
                    if let favourite = favourites.first {
                        completion(.success(favourite))
                    } else {
                        completion(.failure(.fetchingError))
                    }
                case .failure(let failure):
                    completion(.failure(failure))
                }
            }
        } else {
            completion(.failure(.fetchingError))
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
