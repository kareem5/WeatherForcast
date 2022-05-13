//
//  WeatherAPIServiceMock.swift
//  WeatherForecastTests
//
//  Created by Kareem Ahmed on 27/03/2022.
//

@testable import WeatherForecast
import Combine

class WeatherAPIServiceMock: WeatherAPIServiceInterface {
    
    var locationList: LocationList?
    var weatherList: [Weather]?
    
    func fetchWeather(with locationId: Int) -> AnyPublisher<Weather, Error> {
        guard let weathers = weatherList, let weather = weathers.first(where: { $0.woeid == locationId }) else {
            return Fail(error: FetchWeatherError.failedFetchWeather)
                .eraseToAnyPublisher()
        }
        
        return Just(weather)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func findLocation(with locationName: String) -> AnyPublisher<LocationList, Error> {
        guard let locationList = locationList else {
            return Fail(error: FetchWeatherError.faildFindLocation)
                .eraseToAnyPublisher()
        }
        return Just(locationList)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
}
