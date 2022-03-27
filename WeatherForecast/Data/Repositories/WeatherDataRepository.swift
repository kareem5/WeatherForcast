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
    
    init (weatherService: WeatherAPIServiceInterface) {
        self.weatherService = weatherService
    }

    func fetchWeather(with location: Location) -> AnyPublisher<CityWeather, Error> {
        weatherService.fetchWeather(with: location.woeid)
    }
    
    func findLocation(with locationName: String) -> AnyPublisher<Location, Error> {
        weatherService.findLocation(with: locationName)
            .tryCompactMap({ locations in
                guard let result = locations.first(where: { $0.title == locationName}) else {
                    throw FetchWeatherError.faildFindLocation
                }
                return result
            }).eraseToAnyPublisher()
    }
}
