//
//  GetTodayWeatherUseCase.swift
//  WeatherForecast
//
//  Created by Kareem Ahmed on 14/03/2022.
//

import Combine

protocol GetTodayWeatherUseCaseInterface {
    func perform(with location: Location) -> AnyPublisher<Weather, Error>
}

final class GetTodayWeatherUseCase: GetTodayWeatherUseCaseInterface {
    
    private let weatherRepository: WeatherRepository
    init(weatherRepository: WeatherRepository) {
        self.weatherRepository = weatherRepository
    }
    
    func perform(with location: Location) -> AnyPublisher<Weather, Error> {
        weatherRepository.fetchWeather(with: location)
    }
}
