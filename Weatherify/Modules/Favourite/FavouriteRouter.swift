//
//  FavouriteRouter.swift
//  Weatherify
//
//  Created by Emre Çakır on 3.03.2024.
//

import Foundation

final class FavouriteRouter: BaseRouter {
    
    override init() {
        super.init()
        let viewModel = FavouriteViewModel(router: self)
        let viewController = FavouriteViewController(viewModel: viewModel)
        viewModel.delegate = viewController
        initialViewController = viewController
    }
    
    func navigateToDetail(router: DetailRouter) {
        initialViewController.navigationController?.pushViewController(router.initialViewController, animated: true)
    }
}
