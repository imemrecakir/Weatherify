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
    
    var displayedWeathers: [WeatherModel] = []
    
    var weathers: [WeatherModel] = [] {
        didSet {
            if searchedWeathers.isEmpty {
                displayedWeathers = weathers
            }
        }
    }
    
    var searchedWeathers: [WeatherModel] = [] {
        didSet {
            displayedWeathers = searchedWeathers
        }
    }

    override var isLoading: Bool {
        didSet {
            delegate?.isLoading(isLoading)
        }
    }
    
    var isSearching = false
    
    var paginationLimit = 0
    var isPaginationReachedEndLimit = false
    
    weak var delegate: ListViewModelDelegate?
    
    override init() {
        super.init()
        fetchWeathers()
    }
    
    func fetchWeathers() {
        if !isPaginationReachedEndLimit && !isLoading {
            isLoading = true
            errorMessage = nil
            paginationLimit += 10
            
            NetworkManager.shared.request(type: [WeatherModel].self, endpoint: .getWeathers(limit: paginationLimit), httpMethod: .get) { [weak self] result in
                switch result {
                case .success(let weathers):
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
}
