//
//  WeatherCoordinator.swift
//  WeatherForecast
//
//  Created by Kareem Ahmed on 13/03/2022.
//

import UIKit

final class WeatherCoordinator: Coordinator {
    var children = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let weatherRepository = WeatherDataRepository(weatherService: WeatherAPIService())
        let findLocationUseCase = FindLocationUseCase(weatherRepository: weatherRepository)
        let getTomorrowWeatherUseCase = GetTomorrowWeatherUseCase(weatherRepository: weatherRepository)
        let viewModel = WeatherListViewModel(findLocationUseCase: findLocationUseCase, getTomorrowWeatherUseCase: getTomorrowWeatherUseCase)
        let weatherListVC = WeatherListViewController(viewModel: viewModel, coordinator: self)
        navigationController.pushViewController(weatherListVC, animated: false)
    }
    
    
}
