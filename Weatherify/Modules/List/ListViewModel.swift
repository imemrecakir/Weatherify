//
//  ListViewModel.swift
//  Weatherify
//
//  Created by Emre Çakır on 29.02.2024.
//

import Foundation

protocol ListViewModelDelegate: AnyObject {
    func isLoading(_ isLoading: Bool)
    func weathersFetched()
    func weathersSearched()
}

final class ListViewModel: BaseViewModel {
    
    weak var delegate: ListViewModelDelegate?
    
    let router: ListRouter
    
    var displayedWeathers: [WeatherModel] = []
    
    let emptyMessage = "The city was not found"
    
    var weathers: [WeatherModel] = [] {
        didSet {
                displayedWeathers = weathers
        }
    }

    override var isLoading: Bool {
        didSet {
            delegate?.isLoading(isLoading)
        }
    }
    
    var isSearching = false
    
    var paginationLimit = 10
    var isPaginationReachedEndLimit = false

    init(router: ListRouter) {
        self.router = router
        super.init()
    }
    
    func fetchWeathers() {
        if !isPaginationReachedEndLimit && !isLoading && !isSearching {
            isLoading = true
            errorMessage = nil
            
            NetworkManager.shared.request(type: [WeatherModel].self, endpoint: .getWeathers(limit: paginationLimit), httpMethod: .get) { [weak self] result in
                switch result {
                case .success(let weathers):
                    self?.paginationLimit += 10
                    if weathers.count % 10 != 0 {
                        self?.isPaginationReachedEndLimit = true
                    }
                    self?.weathers = weathers
                    self?.errorMessage = nil
                case .failure(let error):
                    self?.errorMessage = error.errorMessage
                }
                
                self?.isLoading = false
                self?.delegate?.weathersFetched()
            }
        }
    }
    
    func searchWeathers(query: String) {
        if query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            isSearching = false
            displayedWeathers = weathers
            delegate?.weathersSearched()
        } else {
            isSearching = true
            displayedWeathers = weathers.filter {
                let lowercasedFilterName = $0.city.lowercased()
                let lowercasedSearchText = query.lowercased()
                return lowercasedFilterName.prefix(query.count) == lowercasedSearchText || lowercasedFilterName.contains(lowercasedSearchText)
            }
            
            delegate?.weathersSearched()
        }
    }
    
    func navigateToDetail(index: Int) {
        let weather = displayedWeathers[index]
        router.navigateToDetail(router: DetailRouter(weather: weather))
    }
}
