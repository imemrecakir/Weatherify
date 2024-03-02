//
//  Double+Extension.swift
//  Weatherify
//
//  Created by Emre Çakır on 2.03.2024.
//

import UIKit

extension Double {
    func attributedTemperature(fontSize: CGFloat, suffix: String = "°C") -> NSMutableAttributedString {
        let temperatureString = self.truncatingRemainder(dividingBy: 1) == 0 ? "\(Int(self))" : "\(self)"
        let attributedTemperatureString = NSMutableAttributedString(string: temperatureString,
                                                                    attributes: [.font: UIFont.systemFont(ofSize: fontSize)])
        
        let suffixFontSize = fontSize / 2
        let baselineOffset = suffixFontSize - 2
        attributedTemperatureString.append(NSMutableAttributedString(string: suffix,
                                                                     attributes: [
                                                                        .font: UIFont.systemFont(ofSize: suffixFontSize),
                                                                        .baselineOffset: NSNumber(value: baselineOffset)
                                                                     ]))
        return attributedTemperatureString
    }
}
