//
//  Coordinator.swift
//  WeatherForecast
//
//  Created by Kareem Ahmed on 12/03/2022.
//

import UIKit

protocol Coordinator: AnyObject {
    var children: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}
