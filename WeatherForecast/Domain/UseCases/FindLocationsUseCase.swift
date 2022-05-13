//
//  FindLocationsUseCase.swift
//  WeatherForecast
//
//  Created by Kareem Ahmed on 14/03/2022.
//

import Combine

protocol FindLocationsUseCaseInterface {
    func perform(with locationName: String) -> AnyPublisher<LocationList, Error>
}

final class FindLocationsUseCase: FindLocationsUseCaseInterface {
    
    private let weatherRepository: WeatherRepository
    init(weatherRepository: WeatherRepository) {
        self.weatherRepository = weatherRepository
    }
    
    func perform(with locationName: String) -> AnyPublisher<LocationList, Error> {
        weatherRepository.findLocations(with: locationName)
    }
}
