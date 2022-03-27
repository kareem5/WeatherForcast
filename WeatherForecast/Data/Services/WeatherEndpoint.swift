//
//  WeatherEndpoint.swift
//  WeatherForecast
//
//  Created by Kareem Ahmed on 13/03/2022.
//

import Foundation

enum WeatherEndpoint {
    case fetchWeatherForLocation(locationId: Int)
    case findLocation(locationName: String)
    
    struct Constants {
        static let baseUrl = "https://www.metaweather.com/api/location/"
        static let findLocationAPI = "search"
    }
}

extension WeatherEndpoint: Endpoint {
    var environmentBaseURL: String {
        return Constants.baseUrl
    }
    
    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    var path: String {
        switch self {
        case .fetchWeatherForLocation(let locationId):
            return "\(locationId)"
        case .findLocation:
            return Constants.findLocationAPI
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .fetchWeatherForLocation:
            return nil
        case .findLocation(let locationName):
            return [
                URLQueryItem(name: "query", value: locationName)
            ]
        }
        
    }
    
    var method: HTTPRequestMethod {
        switch self {
        case .fetchWeatherForLocation, .findLocation:
            return .get
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .fetchWeatherForLocation, .findLocation:
            return ["Content-Type": "application/json"]
        }
    }
}
