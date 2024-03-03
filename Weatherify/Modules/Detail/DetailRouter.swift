//
//  DetailRouter.swift
//  Weatherify
//
//  Created by Emre Çakır on 3.03.2024.
//

import Foundation

final class DetailRouter: BaseRouter {
    
    init(weather: WeatherModel) {
        super.init()
        let viewModel = DetailViewModel(weather: weather)
        let viewController = DetailViewController(viewModel: viewModel)
        viewController.hidesBottomBarWhenPushed = true
        viewModel.delegate = viewController
        initialViewController = viewController
    }
}
