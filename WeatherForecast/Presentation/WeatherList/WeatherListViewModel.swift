//
//  WeatherListViewModel.swift
//  WeatherForecast
//
//  Created by Kareem Ahmed on 13/03/2022.
//

import Combine
import Dispatch
import Foundation

enum ViewState {
    case loading
    case error(message: String)
    case success
}

final class WeatherListViewModel {
    private let findLocationUseCase: FindLocationUseCaseInterface
    private let getTomorrowWeatherUseCase: GetTomorrowWeatherUseCaseInterface

    private var subscriptions = Set<AnyCancellable>()
    private let queue = DispatchQueue(label: "fetching_locations", attributes: .concurrent)
    private(set) var onNewsResponse = PassthroughSubject<([CityWeather]), Error>()
    private(set) var onViewStateChange = CurrentValueSubject<ViewState, Never>(.loading)

    
    init(findLocationUseCase: FindLocationUseCaseInterface,
         getTomorrowWeatherUseCase: GetTomorrowWeatherUseCaseInterface) {
        self.findLocationUseCase = findLocationUseCase
        self.getTomorrowWeatherUseCase = getTomorrowWeatherUseCase
    }
    
    func fetchWeatherForAllLocations() {
        let result = Publishers
            .MergeMany(
                findLocation(with: "Gothenburg"),
                findLocation(with: "Stockholm"),
                findLocation(with: "Mountain View"),
                findLocation(with: "London"),
                findLocation(with: "New York"),
                findLocation(with: "Berlin")
                )
            
            result
            .subscribe(on: queue)
            .receive(on: queue)
            .collect()
            .sink { [unowned self] completion in
                if case .failure(let error) = completion {
                    print("error: \(error)")
                    self.onViewStateChange.send(.error(message: FetchWeatherError.failedOnMergingWeathers.message))
                }
            } receiveValue: { [unowned self] result in
                self.onNewsResponse.send(result)
                self.onViewStateChange.send(.success)
            }.store(in: &subscriptions)
    }
    
    private func findLocation(with cityName: String) -> AnyPublisher<CityWeather, Error> {
        findLocationUseCase.perform(with: cityName)
            .flatMap({ [unowned self] loc in
                self.getTomorrowWeatherUseCase.perform(with: loc)
            }).eraseToAnyPublisher()
    }
}
