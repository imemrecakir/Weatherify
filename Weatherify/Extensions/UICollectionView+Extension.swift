//
//  UICollectionView+Extension.swift
//  Weatherify
//
//  Created by Emre Çakır on 3.03.2024.
//

import UIKit

extension UICollectionView {

    func addEmptyView(message: String) {
        lazy var emptyMessageLabel: UILabel = {
            let label = UILabel()
            label.text = message
            label.numberOfLines = 0
            label.textAlignment = .center
            label.font = .monospacedSystemFont(ofSize: 18, weight: .medium)
            label.center = self.center
            label.sizeToFit()
            return label
        }()
        
        self.backgroundView = emptyMessageLabel
    }
    
    func removeEmptyView() {
        self.backgroundView = nil
        self.backgroundView?.removeFromSuperview()
    }
}
