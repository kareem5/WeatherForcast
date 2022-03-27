//
//  WeatherRepositoryTests.swift
//  WeatherForecastTests
//
//  Created by Kareem Ahmed on 27/03/2022.
//

import XCTest
import Combine
@testable import WeatherForecast

class WeatherRepositoryTests: XCTestCase {

    var sut: WeatherRepository!
    var weatherApiService: WeatherAPIServiceMock!
    var subscriptions = Set<AnyCancellable>()

    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        weatherApiService = WeatherAPIServiceMock()
        sut = WeatherDataRepository(weatherService: weatherApiService)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_FindLocationWithSuccess_ReturnsLocation() throws {
        var result: Location?
        var resultError: Error?
        weatherApiService.locationList = StubWeatherRepositoryResult.locations
        let expectation = expectation(description: "Find Location with success")
        sut.findLocation(with: "London")
            .sink { completion in
                if case .failure(let error) = completion {
                    resultError = error
                }
            } receiveValue: { location in
                result = location
                expectation.fulfill()
            }.store(in: &subscriptions)

        waitForExpectations(timeout: 1.0, handler: nil)
        
        XCTAssertNil(resultError, "Error is not nil")
        XCTAssertEqual(result?.woeid, StubWeatherRepositoryResult.locations[1].woeid, "Failed loading location")
    }
    
    func test_FindLocationWithError_ReturnsFailedFindLocation() throws {
        var result: Location?
        var resultError: Error?
        weatherApiService.locationList = StubWeatherRepositoryResult.locations
        let expectation = expectation(description: "Find Location with error failed find location")
        sut.findLocation(with: "Paris")
            .sink { completion in
                if case .failure(let error) = completion {
                    resultError = error
                    expectation.fulfill()
                }
            } receiveValue: { location in
                result = location
                
            }.store(in: &subscriptions)

        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertNotNil(resultError)
        XCTAssertNil(result)
    }

    func test_FetchWeatherWithSuccess_ReturnsCityWeather() throws {
        var result: CityWeather?
        var resultError: Error?
        weatherApiService.weathers = StubWeatherRepositoryResult.cityWeathers
        let expectation = expectation(description: "Fetch Weather With success")
        sut.fetchWeather(with: StubWeatherRepositoryResult.locations[0])
            .sink { completion in
                if case .failure(let error) = completion {
                    resultError = error
                }
            } receiveValue: { weather in
                result = weather
                expectation.fulfill()
            }.store(in: &subscriptions)

        waitForExpectations(timeout: 1.0, handler: nil)
        
        XCTAssertNil(resultError, "Error is not nil")
        XCTAssertEqual(result?.woeid, StubWeatherRepositoryResult.locations[0].woeid, "Failed loading weather")
    }
    
    func test_FetchWeatherWithError_ReturnsFailedFetchWeather() throws {
        var result: CityWeather?
        var resultError: Error?
        weatherApiService.weathers = StubWeatherRepositoryResult.cityWeathers
        let expectation = expectation(description: "Fetch Weather With error failed fetch weather")
        sut.fetchWeather(with: StubWeatherRepositoryResult.locations[3])
            .sink { completion in
                if case .failure(let error) = completion {
                    resultError = error
                    expectation.fulfill()
                }
            } receiveValue: { weather in
                result = weather
            }.store(in: &subscriptions)

        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertNotNil(resultError)
        XCTAssertNil(result)
    }
    
    // MARK: - Stub
    struct StubWeatherRepositoryResult {
        static let locations = [
            Location(title: "Gothenburg", locationType: "City", woeid: 123422, lattLong: nil),
            Location(title: "London", locationType: "City", woeid: 437282, lattLong: nil),
            Location(title: "Berlin", locationType: "City", woeid: 908728, lattLong: nil),
            Location(title: "Madrid", locationType: "City", woeid: 890726, lattLong: nil)
        ]
        
        static let cityWeathers = [
            CityWeather(consolidatedWeather: nil, time: nil, sunRise: nil, sunSet: nil, timezoneName: nil, country: locations[0], sources: nil, title: "Gothenburg", locationType: "City", woeid: locations[0].woeid, lattLong: nil, timezone: nil),
            CityWeather(consolidatedWeather: nil, time: nil, sunRise: nil, sunSet: nil, timezoneName: nil, country: locations[1], sources: nil, title: "London", locationType: "City", woeid: locations[1].woeid, lattLong: nil, timezone: nil),
            CityWeather(consolidatedWeather: nil, time: nil, sunRise: nil, sunSet: nil, timezoneName: nil, country: locations[2], sources: nil, title: "Gothenburg", locationType: "City", woeid: locations[2].woeid, lattLong: nil, timezone: nil)
        ]
    }

}
