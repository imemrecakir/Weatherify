//
//  UINavigationBar+Extension.swift
//  Weatherify
//
//  Created by Emre Çakır on 3.03.2024.
//

import UIKit

extension UINavigationBar {
    func adjustLargeTitle() {
        guard let largeTitleLabel = subviews
            .compactMap({ $0 as? UILabel })
            .first(where: { $0.font == UIFont.preferredFont(forTextStyle: .largeTitle) }) else {
                return
        }
        largeTitleLabel.adjustsFontSizeToFitWidth = true
        largeTitleLabel.minimumScaleFactor = 0.5
    }
}
