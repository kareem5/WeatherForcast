//
//  SaveLocationUseCase.swift
//  WeatherForecast
//
//  Created by Kareem Ahmed on 02/05/2022.
//

import Foundation

protocol SaveLocationUseCaseInterface {
    func perform(with location: Location)
}

final class SaveLocationUseCase: SaveLocationUseCaseInterface {
    
    private let weatherRepository: WeatherRepository
    
    init(weatherRepository: WeatherRepository) {
        self.weatherRepository = weatherRepository
    }
    
    func perform(with location: Location) {
        weatherRepository.saveLocation(with: location)
    }
}
