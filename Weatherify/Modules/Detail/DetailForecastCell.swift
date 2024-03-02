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
        stackView.spacing = 6
        stackView.clipsToBounds = true
        stackView.layer.cornerRadius = 12
        stackView.layer.borderWidth = 1
        stackView.layoutMargins = .init(top: 8, left: 16, bottom: 8, right: 16)
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
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .label
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
    
    func configureCell(day: String, iconName: String, temperature: Double, isSelected: Bool) {
        contentStackView.layer.borderColor = (isSelected ? UIColor.label : UIColor.clear).cgColor
        
        contentStackView.backgroundColor = isSelected ? .systemFill : .secondarySystemBackground

        let cellTintColor: UIColor = isSelected ? .label : .secondaryLabel
        
        forecastDayLabel.text = day
        forecastDayLabel.textColor = cellTintColor
        
        forecastWeatherIcon.image = UIImage(systemName: iconName)
        forecastWeatherIcon.tintColor = cellTintColor
        
        forecastTemperatureLabel.text = temperature.formattedTemperature()
        forecastTemperatureLabel.textColor = cellTintColor
    }
}
