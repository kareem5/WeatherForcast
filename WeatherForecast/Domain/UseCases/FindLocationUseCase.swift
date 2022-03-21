//
//  FindLocationUseCase.swift
//  WeatherForecast
//
//  Created by Kareem Ahmed on 14/03/2022.
//

import Combine

protocol FindLocationUseCaseInterface {
    func perform(with locationName: String) -> AnyPublisher<Location, Error>
}

final class FindLocationUseCase: FindLocationUseCaseInterface {
    
    private let weatherRepository: WeatherRepository
    init(weatherRepository: WeatherRepository) {
        self.weatherRepository = weatherRepository
    }
    
    func perform(with locationName: String) -> AnyPublisher<Location, Error> {
        weatherRepository.findLocation(with: locationName)
    }
}
