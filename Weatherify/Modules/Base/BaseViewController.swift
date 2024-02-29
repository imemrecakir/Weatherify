//
//  BaseViewController.swift
//  Weatherify
//
//  Created by Emre Çakır on 29.02.2024.
//

import UIKit

protocol BaseViewControllerProtocol {
    func setupUI()
    func setupConstraints()
}

typealias BaseViewController<VM> = BaseViewControllerProtocol & BaseViewControllerClass<VM> where VM: BaseViewModel

class BaseViewControllerClass<VM>: UIViewController where VM: BaseViewModel {
    var viewModel: VM!
    
    private let activityIndicatorContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .secondarySystemGroupedBackground
        view.alpha = 0.15
        view.isHidden = true
        return view
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .systemBackground
        return activityIndicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .secondarySystemBackground
        
        guard let controller = self as? BaseViewController<VM> else {
            return
        }

        setupBaseUI()
        controller.setupUI()
        setupBaseConstraint()
        controller.setupConstraints()
    }

    private func setupBaseUI() {
        view.addSubview(activityIndicatorContainer)
        view.addSubview(activityIndicator)
    }

    private func setupBaseConstraint() {
        NSLayoutConstraint.activate([
            activityIndicatorContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            activityIndicatorContainer.topAnchor.constraint(equalTo: view.topAnchor),
            activityIndicatorContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            activityIndicatorContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.heightAnchor.constraint(equalToConstant: 48),
            activityIndicator.widthAnchor.constraint(equalToConstant: 48)
        ])
    }

    func showLoading(_ isActive: Bool) {
        activityIndicatorContainer.isHidden = !isActive
        
        if isActive {
            activityIndicator.startAnimating()
            view.bringSubviewToFront(activityIndicatorContainer)
            view.bringSubviewToFront(activityIndicator)
        } else {
            view.sendSubviewToBack(activityIndicator)
            view.sendSubviewToBack(activityIndicatorContainer)
            activityIndicator.stopAnimating()
        }
    }
}
