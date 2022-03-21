//
//  FetchWeatherUseCase.swift
//  WeatherForecast
//
//  Created by Kareem Ahmed on 14/03/2022.
//

import Combine

protocol GetTomorrowWeatherUseCaseInterface {
    func perform(with location: Location) -> AnyPublisher<CityWeather, Error>
}

final class GetTomorrowWeatherUseCase: GetTomorrowWeatherUseCaseInterface {
    
    private let weatherRepository: WeatherRepository
    init(weatherRepository: WeatherRepository) {
        self.weatherRepository = weatherRepository
    }
    
    func perform(with location: Location) -> AnyPublisher<CityWeather, Error> {
        weatherRepository.fetchWeather(with: location)
    }
}
