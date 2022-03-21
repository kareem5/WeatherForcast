//
//  WeatherAPIService.swift
//  WeatherForecast
//
//  Created by Kareem Ahmed on 13/03/2022.
//

import Combine
import Foundation

protocol WeatherAPIServiceInterface {
    func fetchWeather(with locationId: Int) -> AnyPublisher<CityWeather, Error>
    func findLocation(with locationName: String) -> AnyPublisher<LocationList, Error>
}

struct WeatherAPIService: APIClient, WeatherAPIServiceInterface {
    func fetchWeather(with locationId: Int) -> AnyPublisher<CityWeather, Error> {
        fetch(endpoint: WeatherEndpoint.fetchWeatherForLocation(locationId: locationId))
    }
    
    func findLocation(with locationName: String) -> AnyPublisher<LocationList, Error> {
        fetch(endpoint: WeatherEndpoint.findLocation(locationName: locationName))
    }
}
