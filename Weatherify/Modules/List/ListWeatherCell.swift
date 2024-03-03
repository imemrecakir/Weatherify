//
//  ListWeatherCell.swift
//  Weatherify
//
//  Created by Emre Çakır on 29.02.2024.
//

import UIKit

final class ListWeatherCell: UICollectionViewCell {
    
    static let reuseIdentifier = "WeatherListCell"
    
    private lazy var informationStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [temperatureDescriptionStackView, locationStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .secondarySystemFill
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.clipsToBounds = true
        stackView.layer.cornerRadius = 8
        stackView.layoutMargins = .init(top: 16, left: 16, bottom: 16, right: 16)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    private lazy var temperatureDescriptionStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [temperatureLabel, weatherDescription])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 16
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 24, weight: .heavy)
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()
    
    private lazy var weatherDescription: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var locationStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [locationIcon, cityNameLabel])
        stackView.spacing = 4
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var locationIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "mappin")
        imageView.tintColor = Colors.mapPin
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        return imageView
    }()
    
    private lazy var cityNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    private lazy var weatherIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(informationStackView)
        contentView.addSubview(weatherIcon)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            informationStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            informationStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            informationStackView.trailingAnchor.constraint(equalTo: weatherIcon.leadingAnchor),
            informationStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            locationIcon.widthAnchor.constraint(equalToConstant: 20),
            
            weatherIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            weatherIcon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24)
        ])
    }
    
    func configureCell(weather: WeatherModel) {
        temperatureLabel.text = weather.temperature.formattedTemperature()
        weatherDescription.text = weather.weatherDescription.rawValue
        cityNameLabel.text = "\(weather.city), \(weather.country)"
        weatherIcon.image = UIImage(systemName: weather.weatherDescription.iconName)
        weatherIcon.tintColor = Colors.getWeatherColor(for: weather.weatherDescription)
    }
}
