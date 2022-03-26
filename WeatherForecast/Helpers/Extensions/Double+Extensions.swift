//
//  Double+Extensions.swift
//  WeatherForecast
//
//  Created by Kareem Ahmed on 26/03/2022.
//

import Foundation

extension Double {
    func roundedInt() -> Int {
        return Int(self.rounded())
    }
}
