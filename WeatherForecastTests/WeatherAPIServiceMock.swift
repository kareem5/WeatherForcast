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
    var weathers: [CityWeather]?
    
    func fetchWeather(with locationId: Int) -> AnyPublisher<CityWeather, Error> {
        guard let weathers = weathers, let cityWeather = weathers.first(where: { $0.woeid == locationId }) else {
            return Fail(error: FetchWeatherError.failedFetchWeather)
                .eraseToAnyPublisher()
        }
        
        return Just(cityWeather)
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
