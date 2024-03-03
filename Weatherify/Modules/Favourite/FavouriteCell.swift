//
//  FavouriteCell.swift
//  Weatherify
//
//  Created by Emre Çakır on 2.03.2024.
//

import UIKit

protocol FavouriteCellDelegate: AnyObject {
    func didRemoveTapped(index: Int)
}

final class FavouriteCell: UICollectionViewCell {
    
    static let reuseIdentifier = "FavouriteCell"
    
    weak var delegate: FavouriteCellDelegate?
    
    private var index = 0
    
    private lazy var removeButton: UIButton = {
        var configuration = UIButton.Configuration.tinted()
        configuration.imagePadding = 8
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.configuration = configuration
        button.configuration?.baseBackgroundColor = .clear
        button.imageView?.backgroundColor = .clear
        button.setImage(UIImage(systemName: "bookmark.slash.fill"), for: .normal)
        button.addTarget(self, action: #selector(removeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var contentStackView: UIStackView = {
       let stackView = UIStackView(arrangedSubviews: [cityNameLabel, countryNameLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var cityNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.font = .monospacedSystemFont(ofSize: 18, weight: .medium)
        label.setContentHuggingPriority(.required, for: .vertical)
        return label
    }()
    
    private lazy var countryNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .secondaryLabel
        label.font = .monospacedSystemFont(ofSize: 12, weight: .regular)
        label.setContentHuggingPriority(.required, for: .vertical)
        return label
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
        backgroundColor = .systemFill
        clipsToBounds = true
        layer.cornerRadius = 12
        
        contentView.addSubview(removeButton)
        contentView.addSubview(contentStackView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            removeButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            removeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            removeButton.widthAnchor.constraint(equalToConstant: 40),
            removeButton.heightAnchor.constraint(equalToConstant: 40),
            
            contentStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            contentStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func configureCell(favourite: Favourite, index: Int) {
        cityNameLabel.text = favourite.city
        countryNameLabel.text = favourite.country
        self.index = index
    }
    
    @objc private func removeButtonTapped() {
        delegate?.didRemoveTapped(index: index)
    }
}
