//
//  ListRouter.swift
//  Weatherify
//
//  Created by Emre Çakır on 2.03.2024.
//

import Foundation

final class ListRouter: BaseRouter {
    
    override init() {
        super.init()
        let viewModel = ListViewModel(router: self)
        let viewController = ListViewController(viewModel: viewModel)
        viewModel.delegate = viewController
        initialViewController = viewController
    }
    
    func navigateToDetail(router: DetailRouter) {
        initialViewController.navigationController?.pushViewController(router.initialViewController, animated: true)
    }
}
