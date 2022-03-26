//
//  WeatherDetailsViewModel.swift
//  WeatherForecast
//
//  Created by Kareem Ahmed on 23/03/2022.
//

import Combine

final class WeatherDetailsViewModel {
    
    private let cityWeather: CityWeather
    
    private var subscriptions = Set<AnyCancellable>()
    private(set) var cityWeatherSubject = PassthroughSubject<(CityWeather), Never>()
    
    init(cityWeather: CityWeather) {
        self.cityWeather = cityWeather
    }
    
    func viewDidLoad() {
        cityWeatherSubject.send(cityWeather)
    }
    
}
    
