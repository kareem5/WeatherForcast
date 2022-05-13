//
//  WeatherDataRepository.swift
//  WeatherForecast
//
//  Created by Kareem Ahmed on 13/03/2022.
//

import Foundation
import Combine

final class WeatherDataRepository: WeatherRepository {
    private let weatherService: WeatherAPIServiceInterface
    private let locationStorageService: LocationStorageInterface
    
    typealias StoreModel = Location
    
    init(weatherService: WeatherAPIServiceInterface,
          locationStorageService: LocationStorageInterface) {
        self.weatherService = weatherService
        self.locationStorageService = locationStorageService
    }

    func fetchWeather(with location: Location) -> AnyPublisher<Weather, Error> {
        weatherService.fetchWeather(with: location.woeid)
    }
    
    func findLocations(with locationName: String) -> AnyPublisher<LocationList, Error> {
        weatherService.findLocation(with: locationName)
            .eraseToAnyPublisher()
    }
    
    func saveLocation(with location: Location) {
        locationStorageService.add(with: location)
    }
    
    func getSavedLocations() -> LocationList {
        return locationStorageService.getAll() ?? []
    }
    
    func removeLocation(with locationId: Int) {
        locationStorageService.remove(with: locationId)
    }
    
}
