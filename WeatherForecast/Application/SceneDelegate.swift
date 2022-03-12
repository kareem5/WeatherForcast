//
//  SceneDelegate.swift
//  WeatherForecast
//
//  Created by Kareem Ahmed on 12/03/2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        window = UIWindow()
        window?.windowScene = scene as? UIWindowScene
        
        let navController = UINavigationController()
//        let coordinator = ShopCoordinator(navigationController: navController, dependencies: DependenciesBuilder())
//        coordinator.start()

        window?.rootViewController = navController
        window?.makeKeyAndVisible()
    }
    
}

