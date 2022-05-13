//
//  WeatherRepository.swift
//  WeatherForecast
//
//  Created by Kareem Ahmed on 13/03/2022.
//

import Combine

protocol WeatherRepository {
    func fetchWeather(with locationId: Location) -> AnyPublisher<Weather, Error>
    func findLocations(with locationName: String) -> AnyPublisher<LocationList, Error>
    func saveLocation(with location: Location)
    func getSavedLocations() -> LocationList
    func removeLocation(with locationId: Int)
}
