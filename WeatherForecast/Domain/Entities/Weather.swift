//
//  Weather.swift
//  WeatherForecast
//
//  Created by Kareem Ahmed on 13/03/2022.
//

import Foundation

// MARK: - Weather
struct Weather: Codable, Hashable {
    let nextDaysWeather: [ConsolidatedWeather]?
    let time, sunRise, sunSet, timezoneName: String?
    let country: Location?
    let sources: [Source]?
    let title, locationType: String?
    let woeid: Int
    let lattLong, timezone: String?
    var todayWeather: ConsolidatedWeather? {
        let today = Date()//Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let todayString = dateFormatter.string(from: today)
        guard let weather = nextDaysWeather?.first(where: { $0.applicableDate == todayString}) else { return nil }
        
        return weather
    }

    enum CodingKeys: String, CodingKey {
        case nextDaysWeather = "consolidated_weather"
        case time
        case sunRise = "sun_rise"
        case sunSet = "sun_set"
        case timezoneName = "timezone_name"
        case country = "parent"
        case sources, title
        case locationType = "location_type"
        case woeid
        case lattLong = "latt_long"
        case timezone
    }
    
    static func == (lhs: Weather, rhs: Weather) -> Bool {
        return lhs.woeid == rhs.woeid
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(woeid)
    }
}

// MARK: - ConsolidatedWeather
struct ConsolidatedWeather: Codable, Hashable {
    let id: Int?
    let weatherStateName, weatherStateAbbr, windDirectionCompass, created: String
    let applicableDate: String
    let minTemp, maxTemp, theTemp, windSpeed: Double
    let windDirection: Double?
    let airPressure, humidity: Double
    let visibility: Double?
    let predictability: Int?
    
    var airPressureKmh: Double {
        return airPressure * 1.609
    }
    
    var visibilityKmh: Double {
        return visibility ?? 0.0 * 1.609
    }

    enum CodingKeys: String, CodingKey {
        case id
        case weatherStateName = "weather_state_name"
        case weatherStateAbbr = "weather_state_abbr"
        case windDirectionCompass = "wind_direction_compass"
        case created
        case applicableDate = "applicable_date"
        case minTemp = "min_temp"
        case maxTemp = "max_temp"
        case theTemp = "the_temp"
        case windSpeed = "wind_speed"
        case windDirection = "wind_direction"
        case airPressure = "air_pressure"
        case humidity, visibility, predictability
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - Source
struct Source: Codable {
    let title, slug: String?
    let url: String?
    let crawlRate: Int?

    enum CodingKeys: String, CodingKey {
        case title, slug, url
        case crawlRate = "crawl_rate"
    }
}
