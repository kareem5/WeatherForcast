//
//  LocationStorage.swift
//  WeatherForecast
//
//  Created by Kareem Ahmed on 20/04/2022.
//

import Foundation

protocol LocationStorageInterface {
    func add(with location: Location)
    func getAll() -> [Location]?
    func remove(with locationId: Int)
    func removeAll()
}

struct LocationStorage: LocationStorageInterface {
   
    private let storageKey = "LocationLocalStorage"

    func add(with location: Location) {
        var items = getAll() ?? []
        items.append(location)
        UserDefaults.standard.setCodable(items, forKey: storageKey)
    }
    
    func getAll() -> [Location]? {
        return UserDefaults.standard.codable(forKey: storageKey)
    }
    
    func remove(with locationId: Int) {
        var items = getAll()
        items?.removeAll(where: { $0.woeid == locationId })
        UserDefaults.standard.setCodable(items, forKey: storageKey)
    }
    
    func removeAll() {
        UserDefaults.standard.removeObject(forKey: storageKey)
    }
}
