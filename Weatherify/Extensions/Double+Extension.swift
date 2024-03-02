//
//  Double+Extension.swift
//  Weatherify
//
//  Created by Emre Çakır on 2.03.2024.
//

import UIKit

extension Double {
    func formattedTemperature(unit: UnitTemperature = .celsius) -> String {
        let measurement = Measurement(value: self, unit: unit)
        let measurementFormatter = MeasurementFormatter()
        measurementFormatter.unitStyle = .short
        measurementFormatter.numberFormatter.maximumFractionDigits = 1
        measurementFormatter.numberFormatter.decimalSeparator = "."
        measurementFormatter.unitOptions = .temperatureWithoutUnit
        return measurementFormatter.string(from: measurement)
    }
}
