//
//  Alertable.swift
//  WeatherForecast
//
//  Created by Kareem Ahmed on 27/03/2022.
//

import UIKit

protocol Alertable { }
extension Alertable where Self: UIViewController {

    func showAlert(message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel) { _ in }
        alertController.addAction(okAction)

        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }

}
