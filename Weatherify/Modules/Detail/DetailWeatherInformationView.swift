//
//  DetailWeatherInformationView.swift
//  Weatherify
//
//  Created by Emre Çakır on 2.03.2024.
//

import UIKit

final class DetailWeatherInformationView: UIStackView {
    
    private lazy var informationIconValueStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [informationIcon, informationValueLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 6
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var informationIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .label
        return imageView
    }()
    
    private lazy var informationValueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private lazy var informationNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        axis = .vertical
        spacing = 4
        distribution = .fillProportionally
        alignment = .center
        layoutMargins = .init(top: 8, left: 8, bottom: 8, right: 8)
        isLayoutMarginsRelativeArrangement = true
        addArrangedSubview(informationIconValueStackView)
        addArrangedSubview(informationNameLabel)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(name: String, iconName: String, value: String, suffix: String) {
        informationNameLabel.text = name
        informationIcon.image = UIImage(systemName: iconName)
        informationValueLabel.text = "\(value)\(suffix)"
    }
}
