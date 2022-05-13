//
//  DeleteLocationUseCase.swift
//  WeatherForecast
//
//  Created by Kareem Ahmed on 03/05/2022.
//

import Foundation

protocol DeleteLocationUseCaseInterface {
    func perform(with locationId: Int)
}

final class DeleteLocationUseCase: DeleteLocationUseCaseInterface {
    
    private let weatherRepository: WeatherRepository
    
    init(weatherRepository: WeatherRepository) {
        self.weatherRepository = weatherRepository
    }
    
    func perform(with locationId: Int) {
        weatherRepository.removeLocation(with: locationId)
    }
}
