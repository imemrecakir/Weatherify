//
//  ListViewController.swift
//  Weatherify
//
//  Created by Emre Çakır on 29.02.2024.
//

import UIKit

final class ListViewController: BaseViewController {
    
    let viewModel: ListViewModel
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.backgroundColor = .clear
        searchBar.placeholder = "Search City"
        searchBar.searchTextField.font = .systemFont(ofSize: 14, weight: .semibold)
        searchBar.tintColor = .label
        searchBar.searchTextField.backgroundColor = .systemFill
        searchBar.backgroundImage = UIImage()
        searchBar.setImage(UIImage(systemName: "magnifyingglass"), for: .search, state: .normal)
        searchBar.searchTextField.addCloseToolbar()
        searchBar.returnKeyType = .done
        searchBar.delegate = self
        return searchBar
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset = .init(top: 12, left: 0, bottom: 12, right: 0)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ListWeatherCell.self, forCellWithReuseIdentifier: ListWeatherCell.reuseIdentifier)
        return collectionView
    }()
    
    private lazy var emptyMessageLabel: UILabel = {
        let label = UILabel()
        label.text = "The city was not found"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .monospacedSystemFont(ofSize: 18, weight: .medium)
        label.center = collectionView.center
        label.sizeToFit()
        return label
    }()
    
    init(viewModel: ListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadCollectionView() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

extension ListViewController {
    func setupUI() {
        view.addSubview(searchBar)
        view.addSubview(collectionView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            searchBar.bottomAnchor.constraint(equalTo: collectionView.topAnchor),
            
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension ListViewController: ListViewModelDelegate {
    func isLoading(_ isLoading: Bool) {
        showLoading(isLoading)
    }
    
    func weathersFetched() {
        reloadCollectionView()
    }
    
    func weathersSearched() {
        reloadCollectionView()
    }
}

extension ListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchWeathers(query: searchBar.text ?? "")
    }
}

extension ListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if viewModel.displayedWeathers.isEmpty {
            collectionView.backgroundView = emptyMessageLabel
        } else {
            collectionView.backgroundView = nil
        }
        
        return viewModel.displayedWeathers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListWeatherCell.reuseIdentifier, for: indexPath) as? ListWeatherCell {
            cell.configureCell(weather: viewModel.displayedWeathers[indexPath.item])
            return cell
        }
        
        return UICollectionViewCell(frame: .zero)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cell = self.collectionView(collectionView, cellForItemAt: indexPath)
        return cell.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height),
                                            withHorizontalFittingPriority: .required,
                                            verticalFittingPriority: .fittingSizeLevel)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let detailViewController = DetailRouter(weather: viewModel.weathers[indexPath.item]).initialViewController {
            navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let screenHeight = scrollView.frame.height
        
        let threshold: CGFloat = 100
        let lastItemIndex = collectionView.numberOfItems(inSection: 0) - 1
 
        if offsetY + screenHeight + threshold >= contentHeight && lastItemIndex >= 0 {
            viewModel.fetchWeathers()
        }
    }
}
