//
//  WeatherDataRepository.swift
//  WeatherForecast
//
//  Created by Kareem Ahmed on 13/03/2022.
//

import Foundation
import Combine

enum LocationError: Error {
    case faildFindLocation
}

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
            .compactMap { locations in
//                Publishers.Sequence(sequence: locations).eraseToAnyPublisher()
                locations.first(where: { $0.title == locationName})!
            }.eraseToAnyPublisher()
//            .map { locationList in
//                guard let location = locationList.first(where: { $0.title == locationName}) else {
//                    Fail(error: NSError(domain: "Missing Feed URL", code: -10001, userInfo: nil))
//                }
//                Just(location)
//            }
    }
}
