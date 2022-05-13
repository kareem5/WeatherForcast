//
//  Location.swift
//  WeatherForecast
//
//  Created by Kareem Ahmed on 14/03/2022.
//

import Foundation

// MARK: - Location
struct Location: Codable, Hashable {
    let title, locationType: String?
    let woeid: Int
    let lattLong: String?

    enum CodingKeys: String, CodingKey {
        case title
        case locationType = "location_type"
        case woeid
        case lattLong = "latt_long"
    }
    
    static func == (lhs: Location, rhs: Location) -> Bool {
        return lhs.woeid == rhs.woeid
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(woeid)
    }
}

typealias LocationList = [Location]
