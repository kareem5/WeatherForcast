//
//  FetchWeatherError.swift
//  WeatherForecast
//
//  Created by Kareem Ahmed on 27/03/2022.
//

enum FetchWeatherError: Error {
    case faildFindLocation
    case failedOnMergingWeathers
    case failedFetchWeather
    
    var message: String {
        switch self {
        case .faildFindLocation:
            return "Failed find location"
        case .failedOnMergingWeathers:
            return "Failed merging the weathers into a list"
        case .failedFetchWeather:
            return "Failed fetching weather for this location"
        }
    }
}
