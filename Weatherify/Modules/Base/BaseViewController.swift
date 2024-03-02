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

typealias BaseViewController = BaseViewControllerProtocol & BaseViewControllerClass

class BaseViewControllerClass: UIViewController {
    
    private let activityIndicatorContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .secondaryLabel
        view.alpha = 0.15
        view.isHidden = true
        return view
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .systemFill
        return activityIndicator
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        hideKeyboardWhenTappedAround()
        guard let controller = self as? BaseViewController else {
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
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.activityIndicatorContainer.isHidden = !isActive
            if isActive {
                self.activityIndicator.startAnimating()
                self.view.bringSubviewToFront(self.activityIndicatorContainer)
                self.view.bringSubviewToFront(self.activityIndicator)
            } else {
                self.view.sendSubviewToBack(self.activityIndicator)
                self.view.sendSubviewToBack(self.activityIndicatorContainer)
                self.activityIndicator.stopAnimating()
            }
        }
    }
}
