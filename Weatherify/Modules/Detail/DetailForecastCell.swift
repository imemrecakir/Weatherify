//
//  DetailForecastCell.swift
//  Weatherify
//
//  Created by Emre Çakır on 2.03.2024.
//

import UIKit

final class DetailForecastCell: UICollectionViewCell {
    
    static let reuseIdentifier = "DetailForecastCell"
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [forecastDayLabel, forecastWeatherIcon, forecastTemperatureLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .secondarySystemFill
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 12
        stackView.clipsToBounds = true
        stackView.layer.cornerRadius = 12
        stackView.layer.borderWidth = 1
        stackView.layoutMargins = .init(top: 12, left: 16, bottom: 12, right: 16)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    private lazy var forecastDayLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        label.setContentHuggingPriority(.required, for: .vertical)
        return label
    }()
    
    private lazy var forecastWeatherIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var forecastTemperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .label
        label.setContentHuggingPriority(.required, for: .vertical)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(contentStackView)
        
        NSLayoutConstraint.activate([
            contentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(forecast: Forecast, isSelected: Bool) {
        contentStackView.layer.borderColor = (isSelected ? UIColor.label : UIColor.clear).cgColor
        
        contentStackView.backgroundColor = isSelected ? .systemFill : .secondarySystemBackground

        let cellTintColor: UIColor = isSelected ? .label : .tertiaryLabel
        
        forecastDayLabel.text = forecast.dayOfDate
        forecastDayLabel.textColor = cellTintColor
        
        forecastWeatherIcon.image = UIImage(systemName: forecast.weatherDescription.iconName)
        forecastWeatherIcon.tintColor = Colors.getWeatherColor(for: forecast.weatherDescription).withAlphaComponent(isSelected ? 1 : 0.25)
        
        forecastTemperatureLabel.text = forecast.temperature.formattedTemperature()
        forecastTemperatureLabel.textColor = cellTintColor
    }
}
