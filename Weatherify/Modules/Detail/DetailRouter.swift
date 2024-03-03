//
//  DetailRouter.swift
//  Weatherify
//
//  Created by Emre Çakır on 3.03.2024.
//

import Foundation

final class DetailRouter: BaseRouter {

    private init(viewModel: DetailViewModel) {
        super.init()
        let viewController = DetailViewController(viewModel: viewModel)
        viewController.hidesBottomBarWhenPushed = true
        viewModel.delegate = viewController
        initialViewController = viewController
    }
    
    convenience init(weather: WeatherModel) {
        let viewModel = DetailViewModel(weather: weather)
        self.init(viewModel: viewModel)
    }
    
    convenience init(weatherId: Int) {
        let viewModel = DetailViewModel(weatherId: weatherId)
        self.init(viewModel: viewModel)
    }
}
