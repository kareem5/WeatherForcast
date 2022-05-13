//
//  WeatherDetailsViewModel.swift
//  WeatherForecast
//
//  Created by Kareem Ahmed on 23/03/2022.
//

import Combine

final class WeatherDetailsViewModel {
    
    private let weather: Weather
    
    private var subscriptions = Set<AnyCancellable>()
    
    private(set) var weatherSubject = PassthroughSubject<(Weather), Never>()
    
    init(weather: Weather) {
        self.weather = weather
    }
    
    func viewDidLoad() {
        weatherSubject.send(weather)
    }
    
}
    
