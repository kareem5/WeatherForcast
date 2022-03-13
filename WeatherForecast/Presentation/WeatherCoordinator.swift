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
        let viewModel = WeatherListViewModel()
        let weatherListVC = WeatherListViewController(viewModel: viewModel, coordinator: self)
        navigationController.pushViewController(weatherListVC, animated: false)
    }
    
    
}
