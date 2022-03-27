//
//  CellReusable.swift
//  WeatherForecast
//
//  Created by Kareem Ahmed on 22/03/2022.
//

import UIKit

protocol CellReusable {
    static var reuseIdentifier: String { get }
    static var nib: UINib { get }
}

extension CellReusable where Self: UIView {
    static var nib: UINib {
        get {
            return UINib(nibName: reuseIdentifier, bundle: nil)
        }
    }
    static var reuseIdentifier: String {
        get {
            return String(describing: self)
        }
    }
}
