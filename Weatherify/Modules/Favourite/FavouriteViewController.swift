//
//  FavouriteViewController.swift
//  Weatherify
//
//  Created by Emre Çakır on 29.02.2024.
//

import UIKit

final class FavouriteViewController: BaseViewController {
    
    let viewModel: FavouriteViewModel
    
    private lazy var removeAllFavouritesBarButtonItem: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "trash.slash.fill"), for: .normal)
        button.addTarget(self, action: #selector(removeAllFavouritesBarButtonItemTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var favouritesCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset = .init(top: 8, left: 16, bottom: 8, right: 16)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(FavouriteCell.self, forCellWithReuseIdentifier: FavouriteCell.reuseIdentifier)
        return collectionView
    }()
    
    private func reloadData() {
        removeAllFavouritesBarButtonItem.isEnabled = !viewModel.favourites.isEmpty
        DispatchQueue.main.async { [weak self] in
            self?.favouritesCollectionView.reloadSections(IndexSet(integer: 0))
        }
    }
    
    init(viewModel: FavouriteViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchAllFavourites()
    }
    
    @objc private func removeAllFavouritesBarButtonItemTapped() {
        showAlertWithMultipleAction(title: "Are you sure?", message: "You are deleting all favourites", style: .actionSheet) { [weak self] in
            self?.viewModel.removeAllFavourites()
        }
    }
}

extension FavouriteViewController {
    func setupUI() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: removeAllFavouritesBarButtonItem)
        view.addSubview(favouritesCollectionView)
        reloadData()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            favouritesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            favouritesCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            favouritesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            favouritesCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension FavouriteViewController: FavouriteViewModelDelegate {
    func isLoading(_ isLoading: Bool) {
        showLoading(isLoading)
    }
    
    func favouritesFetched() {
        if let errorMessage = viewModel.errorMessage {
            showAlert(title: "Error", message: errorMessage, style: .alert)
        } else {
            reloadData()
        }
    }
}

extension FavouriteViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if viewModel.favourites.isEmpty && !viewModel.isLoading {
            collectionView.addEmptyView(message: viewModel.emptyMessage)
        } else {
            collectionView.backgroundView = nil
        }
        
        return viewModel.favourites.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavouriteCell.reuseIdentifier, for: indexPath) as? FavouriteCell {
            cell.configureCell(favourite: viewModel.favourites[indexPath.item], index: indexPath.item)
            cell.delegate = self
            return cell
        }
        
        return UICollectionViewCell(frame: .zero)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewSize = collectionView.frame.size
        let collectionViewHorizontalPadding = collectionView.contentInset.left + collectionView.contentInset.right + 32
        let cellSize = (collectionViewSize.width - collectionViewHorizontalPadding) / 2
        return .init(width: cellSize, height: cellSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 32
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        16
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.navigateToDetail(index: indexPath.item)
    }
}

extension FavouriteViewController: FavouriteCellDelegate {
    func didRemoveTapped(index: Int) {
        showAlertWithMultipleAction(title: "Are you sure?", message: "You are deleting the favourite city", style: .actionSheet) { [weak self] in
            self?.viewModel.deleteItemBy(index: index)
        }
    }
}
