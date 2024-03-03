//
//  FavouriteViewController.swift
//  Weatherify
//
//  Created by Emre Çakır on 29.02.2024.
//

import UIKit

final class FavouriteViewController: BaseViewController {
    
    private var ids = [1, 2, 3, 4, 5]
    private var cities = ["Berlin", "Madrid", "İstanbul", "New York", "Londra"]
    private var countries = ["Germany", "Spaint", "Turkey", "USA", "England"]
    private var temperatures = [22, 23.4, 29.14, 18, 16]
    
    private lazy var removeAllFavouritesBarButtonItem: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "trash.slash.fill"), for: .normal)
        button.isEnabled = !cities.isEmpty
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
    
    private lazy var emptyMessageLabel: UILabel = {
        let label = UILabel()
        label.text = "There is no favourite yet"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .monospacedSystemFont(ofSize: 18, weight: .medium)
        label.center = favouritesCollectionView.center
        label.sizeToFit()
        return label
    }()
    
    private func reloadData() {
        removeAllFavouritesBarButtonItem.isEnabled = !cities.isEmpty
        DispatchQueue.main.async { [weak self] in
            self?.favouritesCollectionView.reloadData()
        }
    }
    
    @objc private func removeAllFavouritesBarButtonItemTapped() {
        let alertController = UIAlertController(title: "Are you sure?", message: "You are deleting all favourites", preferredStyle: .alert)

        alertController.addAction(
            UIAlertAction(title: "Yes", style: .destructive) { [weak self] _ in
                self?.cities.removeAll()
                self?.countries.removeAll()
                self?.temperatures.removeAll()
                self?.reloadData()
            }
        )
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alertController, animated: true, completion: nil)
    }
}

extension FavouriteViewController {
    func setupUI() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: removeAllFavouritesBarButtonItem)
        view.addSubview(favouritesCollectionView)
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

extension FavouriteViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if cities.isEmpty {
            collectionView.backgroundView = emptyMessageLabel
        } else {
            collectionView.backgroundView = nil
        }
        
        return cities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavouriteCell.reuseIdentifier, for: indexPath) as? FavouriteCell {
            cell.configureCell(city: cities[indexPath.item], country: cities[indexPath.item], temperature: temperatures[indexPath.item], index: indexPath.item)
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
        if let detailViewController = DetailRouter(weatherId: ids[indexPath.item]).initialViewController {
            navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
}

extension FavouriteViewController: FavouriteCellDelegate {
    func didRemoveTapped(index: Int) {
        cities.remove(at: index)
        countries.remove(at: index)
        temperatures.remove(at: index)
        reloadData()
    }
}
