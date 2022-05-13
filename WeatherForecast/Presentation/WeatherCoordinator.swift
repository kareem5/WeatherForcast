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
        let weatherRepository = WeatherDataRepository(weatherService: WeatherAPIService(), locationStorageService: LocationStorage())
        let findLocationUseCase = FindLocationsUseCase(weatherRepository: weatherRepository)
        let getTodayWeatherUseCase = GetTodayWeatherUseCase(weatherRepository: weatherRepository)
        let saveLocationUseCase = SaveLocationUseCase(weatherRepository: weatherRepository)
        let getSavedLocationsUseCase = GetSavedLocationsUseCase(weatherRepository: weatherRepository)
        let deleteLocationUseCase = DeleteLocationUseCase(weatherRepository: weatherRepository)
        let viewModel = WeatherListViewModel(findLocationUseCase: findLocationUseCase,
                                             getTodayWeatherUseCase: getTodayWeatherUseCase, saveLocationUseCase: saveLocationUseCase, getSavedLocationsUseCase: getSavedLocationsUseCase, deleteLocationUseCase: deleteLocationUseCase)
        let weatherListVC = WeatherListViewController(viewModel: viewModel, coordinator: self)
        navigationController.pushViewController(weatherListVC, animated: false)
    }
    
    func weatherDetails(with weather: Weather) {
        let viewModel = WeatherDetailsViewModel(weather: weather)
        let weatherDetailsVC = WeatherDetailsViewController(viewModel: viewModel, coordinator: self)
        navigationController.pushViewController(weatherDetailsVC, animated: true)
    }
    
}
