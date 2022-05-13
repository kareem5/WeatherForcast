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
    private let findLocationUseCase: FindLocationsUseCaseInterface
    private let getTodayWeatherUseCase: GetTodayWeatherUseCaseInterface
    private let saveLocationUseCase: SaveLocationUseCaseInterface
    private let getSavedLocationsUseCase: GetSavedLocationsUseCaseInterface
    private let deleteLocationUseCase: DeleteLocationUseCaseInterface

    private var subscriptions = Set<AnyCancellable>()
    private let queue = DispatchQueue(label: "fetching_locations", attributes: .concurrent)
    @Published private(set) var weatherList: [Weather] = []
    @Published private(set) var locationsResult: LocationList = []
    @Published private(set) var state: ViewState = .loading
    @Published var searchText: String = ""

    
    init(findLocationUseCase: FindLocationsUseCaseInterface,
         getTodayWeatherUseCase: GetTodayWeatherUseCaseInterface,
         saveLocationUseCase: SaveLocationUseCaseInterface,
         getSavedLocationsUseCase: GetSavedLocationsUseCaseInterface,
         deleteLocationUseCase: DeleteLocationUseCaseInterface) {
        self.findLocationUseCase = findLocationUseCase
        self.getTodayWeatherUseCase = getTodayWeatherUseCase
        self.saveLocationUseCase = saveLocationUseCase
        self.getSavedLocationsUseCase = getSavedLocationsUseCase
        self.deleteLocationUseCase = deleteLocationUseCase
        subscribeSearch()
    }
    
    func fetchWeatherForAllLocations() {
        let savedLocationsPublishers = getSavedLocationsUseCase.perform()
            .compactMap{ findLocation(with: $0.title!) }
        
        let result = Publishers
            .MergeMany(savedLocationsPublishers)
            
            result
            .subscribe(on: queue)
            .receive(on: queue)
            .collect()
            .sink { [unowned self] completion in
                checkSinkError(completion)
            } receiveValue: { [unowned self] result in
                self.weatherList = result
                self.state = .success
            }.store(in: &subscriptions)
    }
    
    private func findLocation(with cityName: String) -> AnyPublisher<Weather, Error> {
        findLocationUseCase.perform(with: cityName)
            .combineLatest(Just(cityName).setFailureType(to: Error.self))
            .tryCompactMap(getFirstLocation)
            .flatMap(getTodayWeatherUseCase.perform)
            .eraseToAnyPublisher()
    }
    
    private func getFirstLocation(locations: LocationList, locationName: String) throws -> Location? {
        guard let result = locations.first(where: { $0.title == locationName}) else {
            throw FetchWeatherError.faildFindLocation
        }
        return result
    }
    
    private func subscribeSearch() {
        $searchText
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map { [unowned self] val in
                self.findLocationUseCase.perform(with: val)
                    .replaceError(with: [])
            }.switchToLatest()
            .assign(to: &$locationsResult)
    }
    
    private func checkSinkError(_ completion: Subscribers.Completion<Error>) {
        if case .failure(let error) = completion {
            print("error: \(error)")
            self.state = .error(message: FetchWeatherError.failedOnMergingWeathers.message)
        }
    }
    
    func didSelectLocationFromSearchResult(with location: Location) {
        searchText.removeAll()
        print("location::::: \(location)")
        guard !weatherList.contains(where: {
            $0.woeid == location.woeid
        }) else { return }
        
        getTodayWeatherUseCase.perform(with: location)
            .sink { [unowned self] completion in
                checkSinkError(completion)
            } receiveValue: { weather in
                self.weatherList.append(weather)
            }.store(in: &subscriptions)
        
        DispatchQueue.global(qos: .background).async {
            self.saveLocationUseCase.perform(with: location)
        }
    }
    
    func didDeleteWeather(with weather: Weather) {
        deleteLocationUseCase.perform(with: weather.woeid)
        weatherList.removeAll(where: { $0 == weather})
    }
}
