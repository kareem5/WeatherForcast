//
//  WeatherRepository.swift
//  WeatherForecast
//
//  Created by Kareem Ahmed on 13/03/2022.
//

import Combine

protocol WeatherRepository {
    func fetchWeather(with locationId: Location) -> AnyPublisher<CityWeather, Error>
    func findLocation(with locationName: String) -> AnyPublisher<Location, Error>
}
