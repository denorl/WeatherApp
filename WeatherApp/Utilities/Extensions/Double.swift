//
//  Double.swift
//  WeatherApp
//
//  Created by Denis's MacBook on 27/3/26.
//
import Foundation



extension Double {
    var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1
        return formatter
    }
    
    var numberAsString: String {
        numberFormatter.string(for: self) ?? ""
    }
    
    func asTemperatureString(for units: UnitsSystem) -> String {
        let tempSign = units.tempSymbol
        return numberAsString + tempSign
    }
    
    var percentageString: String {
        numberAsString + "%"
    }
    
    
}
