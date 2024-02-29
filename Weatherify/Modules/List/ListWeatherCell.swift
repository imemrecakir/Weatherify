//
//  ListWeatherCell.swift
//  Weatherify
//
//  Created by Emre Çakır on 29.02.2024.
//

import UIKit

final class ListWeatherCell: UICollectionViewCell {
    
    static let reuseIdentifier = "WeatherListCell"
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [temperatureCityStackView, weatherIcon])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .secondarySystemFill
        stackView.spacing = 16
        stackView.clipsToBounds = true
        stackView.layer.cornerRadius = 16
        stackView.layoutMargins = .init(top: 16, left: 16, bottom: 16, right: 16)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    private lazy var temperatureCityStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [weatherTemperatureStackView, locationStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var weatherTemperatureStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [temperatureLabel, weatherDescription, UIView()])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 16
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 24, weight: .heavy)
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
        let stackView = UIStackView(arrangedSubviews: [locationIcon, cityNameLabel, UIView()])
        stackView.spacing = 4
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var locationIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "mappin.and.ellipse")
        imageView.tintColor = UIColor.label
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
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(contentStackView)
        
        NSLayoutConstraint.activate([
            contentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            weatherIcon.widthAnchor.constraint(equalToConstant: 60),
            weatherIcon.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell() {
        let attributedTemperatureString = NSMutableAttributedString(string: "25",
                                                         attributes: [.font: UIFont.systemFont(ofSize: temperatureLabel.font.pointSize)])
        
        attributedTemperatureString.append(NSMutableAttributedString(string: "°C",
                                                          attributes: [
                                                            .font: UIFont.systemFont(ofSize: 12),
                                                            .baselineOffset: NSNumber(value: 10)
                                                          ]))
        
        temperatureLabel.attributedText = attributedTemperatureString
        
        weatherDescription.text = "Partly Cloudy"
        
        cityNameLabel.text = "İstanbul, Turkey"
        
        weatherIcon.image = UIImage(systemName: "cloud.sun")
        weatherIcon.tintColor = .systemYellow //TODO: change color
    }
}
