//
//  DetailViewController.swift
//  Weatherify
//
//  Created by Emre Çakır on 29.02.2024.
//

import UIKit

final class DetailViewController: BaseViewController<DetailViewModel> {
    
    private var selectedForecastIndex = 0 {
        didSet {
            configureViews()
        }
    }
    
    private lazy var favouriteBarButtonItem: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "bookmark"), for: .normal)
        button.addTarget(self, action: #selector(favouriteBarButtonItemTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [weatherIcon, weatherDescriptionLabel, temperatureLabel, humidityWindStackView, forecastCollectionView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .center
        stackView.layoutMargins = .init(top: 24, left: 16, bottom: 8, right: 16)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    private lazy var weatherIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var weatherDescriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .boldSystemFont(ofSize: 18)
        label.setContentHuggingPriority(.required, for: .vertical)
        return label
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
        view.backgroundColor = .secondaryLabel
        return view
    }()
    
    private lazy var windView: DetailWeatherInformationView = {
        return DetailWeatherInformationView()
    }()
    
    private lazy var forecastTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Forecasts"
        label.textColor = .label
        label.font = .monospacedSystemFont(ofSize: 14, weight: .medium)
        return label
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
    
    @objc private func favouriteBarButtonItemTapped() {
        //TODO: add to favourite list
        print("favourite button tapped")
    }
}

extension DetailViewController {
    func setupUI() {
        title = "Istanbul, Turkey"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: favouriteBarButtonItem)
        
        view.addSubview(contentStackView)
        
        configureViews()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            contentStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            weatherIcon.widthAnchor.constraint(equalTo: contentStackView.layoutMarginsGuide.widthAnchor),
            
            humidityWindDivider.widthAnchor.constraint(equalToConstant: 1),
            
            forecastCollectionView.widthAnchor.constraint(equalTo: contentStackView.layoutMarginsGuide.widthAnchor),
            forecastCollectionView.heightAnchor.constraint(equalToConstant: 120)
        ])
    }
    
    func configureViews() {
        weatherIcon.image = UIImage(systemName: "cloud.sun")
        weatherDescriptionLabel.text = "Partly cloudy"
        let temperature: Double = 22
        temperatureLabel.text = temperature.formattedTemperature()
        humidityView.configure(name: "Humidity", iconName: "drop.halffull", value: "50", unit: "%")
        windView.configure(name: "Wind speed", iconName: "wind", value: "7", unit: " km/h")
        DispatchQueue.main.async { [weak self] in
            self?.forecastCollectionView.reloadData()
        }
    }
}

extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailForecastCell.reuseIdentifier, for: indexPath) as? DetailForecastCell {
            cell.configureCell(day: "Day \(indexPath.item)",
                               iconName: "sun.max.fill",
                               temperature: 22 + Double(indexPath.item),
                               isSelected: selectedForecastIndex == indexPath.item)
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
        selectedForecastIndex = indexPath.item
    }
}
