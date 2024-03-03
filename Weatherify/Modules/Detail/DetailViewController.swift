//
//  DetailViewController.swift
//  Weatherify
//
//  Created by Emre Çakır on 29.02.2024.
//

import UIKit

final class DetailViewController: BaseViewController {
    
    let viewModel: DetailViewModel
   
    private lazy var favouriteBarButtonItem: UIButton = {
        var configuration = UIButton.Configuration.tinted()
        configuration.imagePadding = 8
        let button = UIButton()
        button.backgroundColor = .clear
        button.configuration = configuration
        button.configuration?.baseBackgroundColor = .clear
        button.imageView?.backgroundColor = .clear
        button.setImage(UIImage(systemName: "bookmark"), for: .normal)
        button.addTarget(self, action: #selector(favouriteBarButtonItemTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var weatherDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.setContentHuggingPriority(.required, for: .vertical)
        return label
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [weatherIcon, temperatureLabel, humidityWindStackView, forecastCollectionView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.alignment = .center
        stackView.layoutMargins = .init(top: 0, left: 16, bottom: 8, right: 16)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    private lazy var weatherIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .monospacedDigitSystemFont(ofSize: 84, weight: .black)
        label.setContentHuggingPriority(.required, for: .vertical)
        return label
    }()
    
    private lazy var humidityWindStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [UIView(), humidityView, humidityWindDivider, windView, UIView()])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 12
        stackView.setContentHuggingPriority(.required, for: .vertical)
        return stackView
    }()
    
    private lazy var humidityView: DetailWeatherInformationView = {
        return DetailWeatherInformationView()
    }()
    
    private lazy var humidityWindDivider: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var windView: DetailWeatherInformationView = {
        return DetailWeatherInformationView()
    }()
    
    private lazy var forecastCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(DetailForecastCell.self, forCellWithReuseIdentifier: DetailForecastCell.reuseIdentifier)
        return collectionView
    }()
    
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func favouriteBarButtonItemTapped() {
        viewModel.updateFavourite()
    }
}

extension DetailViewController {
    func setupUI() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: favouriteBarButtonItem)
        
        view.addSubview(weatherDescriptionLabel)
        view.addSubview(contentStackView)
        
        configureViews()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            weatherDescriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            weatherDescriptionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            weatherDescriptionLabel.bottomAnchor.constraint(equalTo: contentStackView.topAnchor),
            
            contentStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            weatherIcon.widthAnchor.constraint(equalTo: contentStackView.layoutMarginsGuide.widthAnchor),
            
            humidityWindDivider.widthAnchor.constraint(equalToConstant: 1),
            
            forecastCollectionView.widthAnchor.constraint(equalTo: contentStackView.layoutMarginsGuide.widthAnchor),
            forecastCollectionView.heightAnchor.constraint(equalToConstant: 120)
        ])
    }
    
    func configureViews() {
        showLoading(viewModel.isLoading)
        
        DispatchQueue.main.async { [weak self] in
            self?.forecastCollectionView.reloadSections(IndexSet(integer: 0))
        }
        
        if let weather = viewModel.weather {
            title = "\(weather.city), \(weather.country)"
            navigationController?.navigationBar.adjustLargeTitle()
            favouriteBarButtonItem.setImage(UIImage(systemName: weather.isFavourite ? "bookmark.fill" : "bookmark"), for: .normal)
            if let forecast = viewModel.selectedForecast {
                weatherIcon.image = UIImage(systemName: forecast.weatherDescription.iconName)
                weatherIcon.tintColor = Colors.getWeatherColor(for: forecast.weatherDescription)
                weatherDescriptionLabel.text = forecast.weatherDescription.rawValue
                temperatureLabel.text = forecast.temperature.formattedTemperature()
                humidityView.configure(type: .humidity, value: forecast.humidity)
                humidityWindDivider.backgroundColor = .secondaryLabel
                windView.configure(type: .windSpeed, value: forecast.windSpeed)
            }
        }
    }
}

extension DetailViewController: DetailViewModelDelegate {
    func isLoading(_ isLoading: Bool) {
        showLoading(isLoading)
    }
    
    func weatherUpdated() {
        if let errorMessage = viewModel.errorMessage {
            showAlert(title: "Error", message: errorMessage, style: .alert)
        } else {
            configureViews()
        }
    }
    
    func favouriteUpdated() {
        if let errorMessage = viewModel.errorMessage {
            showAlert(title: "Error", message: errorMessage, style: .alert)
        } else if let weather = viewModel.weather {
            favouriteBarButtonItem.setImage(UIImage(systemName: weather.isFavourite ? "bookmark.fill" : "bookmark"), for: .normal)
        }
    }
}

extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.forecasts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailForecastCell.reuseIdentifier, for: indexPath) as? DetailForecastCell {
            cell.configureCell(forecast: viewModel.forecasts[indexPath.item],
                               isSelected: viewModel.selectedForecastIndex == indexPath.item)
            return cell
        }
        
        return UICollectionViewCell(frame: .zero)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let collectionViewWidth = collectionView.frame.width
            let collectionViewItemSpacingConstant = flowLayout.minimumInteritemSpacing
            let cellCount = CGFloat(collectionView.numberOfItems(inSection: indexPath.section))
            let collectionViewTotalSpacing = (cellCount - 1) * collectionViewItemSpacingConstant
            let cellWidth = (collectionViewWidth - collectionViewTotalSpacing) / cellCount
            return CGSize(width: cellWidth, height: collectionView.frame.height)
        }
        
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.configureViews()
        }

        viewModel.selectedForecastIndex = indexPath.item
    }
}
