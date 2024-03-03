//
//  FavouriteViewModel.swift
//  Weatherify
//
//  Created by Emre Çakır on 29.02.2024.
//

import Foundation

protocol FavouriteViewModelDelegate: AnyObject {
    func isLoading(_ isLoading: Bool)
    func favouritesFetched()
}

final class FavouriteViewModel: BaseViewModel {
    
    weak var delegate: FavouriteViewModelDelegate?
    
    let router: FavouriteRouter
    
    var favourites: [Favourite] = []
    
    let emptyMessage = "There is no favourite yet"
    
    override var isLoading: Bool {
        didSet {
            delegate?.isLoading(isLoading)
        }
    }

    init(router: FavouriteRouter) {
        self.router = router
        super.init()
        fetchAllFavourites()
    }
    
    func fetchAllFavourites() {
        isLoading = true
        errorMessage = nil
        DatabaseManager.shared.fetchAllEntities(object: Favourite.self, entity: .favourite) { [weak self] result in
            switch result {
            case .success(let favourites):
                self?.favourites = favourites.sorted { firstFavourite, secondFavourite in
                    if let preAddedDate = firstFavourite.addedDate, let postAddedDate = secondFavourite.addedDate {
                        return preAddedDate > postAddedDate
                    }
                    return false
                }
            case .failure(let failure):
                self?.errorMessage = failure.errorMessage
            }
            
            DispatchQueue.main.async {
                self?.isLoading = false
                self?.delegate?.favouritesFetched()
            }
        }
    }
    
    func removeAllFavourites() {
        isLoading = true
        errorMessage = nil
        DatabaseManager.shared.deleteAllEntities(object: Favourite.self, entity: .favourite) { [weak self] result in
            switch result {
            case .success:
                self?.isLoading = false
                DispatchQueue.main.async {
                    self?.fetchAllFavourites()
                }
            case .failure(let failure):
                self?.isLoading = false
                self?.errorMessage = failure.errorMessage
            }
        }
    }
    
    func deleteItemBy(index: Int) {
        isLoading = true
        errorMessage = nil
        let favourite = favourites[index]
        DatabaseManager.shared.deleteObject(object: favourite) { [weak self] result in
            switch result {
            case .success:
                self?.fetchAllFavourites()
            case .failure(let failure):
                self?.isLoading = false
                self?.errorMessage = failure.errorMessage
            }
        }
    }
    
    func navigateToDetail(index: Int) {
        let weatherId = Int(favourites[index].id)
        router.navigateToDetail(router: DetailRouter(weatherId: weatherId))
    }
}
