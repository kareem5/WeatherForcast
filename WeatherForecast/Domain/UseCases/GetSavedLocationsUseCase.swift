//
//  GetSavedLocationsUseCase.swift
//  WeatherForecast
//
//  Created by Kareem Ahmed on 02/05/2022.
//

import Foundation

protocol GetSavedLocationsUseCaseInterface {
    func perform() -> LocationList
}

final class GetSavedLocationsUseCase: GetSavedLocationsUseCaseInterface {
    private let weatherRepository: WeatherRepository
    
    init(weatherRepository: WeatherRepository) {
        self.weatherRepository = weatherRepository
    }
    func perform() -> LocationList {
        return weatherRepository.getSavedLocations()
    }
}
