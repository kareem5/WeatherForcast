//
//  Location.swift
//  WeatherForecast
//
//  Created by Kareem Ahmed on 14/03/2022.
//

import Foundation

// MARK: - Location
struct Location: Codable {
    let title, locationType: String?
    let woeid: Int
    let lattLong: String?

    enum CodingKeys: String, CodingKey {
        case title
        case locationType = "location_type"
        case woeid
        case lattLong = "latt_long"
    }
}

typealias LocationList = [Location]
