//
//  DetailViewController.swift
//  Weatherify
//
//  Created by Emre Çakır on 29.02.2024.
//

import UIKit

final class DetailViewController: BaseViewController<DetailViewModel> {}

extension DetailViewController {
    func setupUI() {
        title = "Detail"
        navigationController?.navigationItem.largeTitleDisplayMode = .inline
    }
    
    func setupConstraints() {}
}
