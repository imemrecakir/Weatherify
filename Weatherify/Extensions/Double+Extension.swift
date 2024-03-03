//
//  Double+Extension.swift
//  Weatherify
//
//  Created by Emre Çakır on 2.03.2024.
//

import Foundation

extension Double {
    func formattedTemperature(with unit: UnitTemperature = .celsius) -> String {
        let measurement = Measurement(value: self, unit: unit)
        let measurementFormatter = MeasurementFormatter()
        measurementFormatter.unitStyle = .short
        measurementFormatter.numberFormatter.maximumFractionDigits = 1
        measurementFormatter.numberFormatter.decimalSeparator = "."
        measurementFormatter.unitOptions = .temperatureWithoutUnit
        return measurementFormatter.string(from: measurement)
    }
    
    func formatted(maxDigitCount: Int = 1) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = maxDigitCount
        numberFormatter.decimalSeparator = "."
        return numberFormatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
