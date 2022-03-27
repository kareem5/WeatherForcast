//
//  WeatherListViewController.swift
//  WeatherForecast
//
//  Created by Kareem Ahmed on 13/03/2022.
//

import UIKit
import Combine

class WeatherListViewController: UITableViewController, Alertable {
    
    var coordinator: WeatherCoordinator

    private let viewModel: WeatherListViewModel
    private var subscriptions = Set<AnyCancellable>()
    private lazy var dataSource = makeDataSource()
    private lazy var loadingView: LoadingView = {
        let loadingView = LoadingView()
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingView)
        loadingView.attachAnchors(to: (navigationController?.view)!)
        return loadingView
    }()

    init(viewModel: WeatherListViewModel, coordinator: WeatherCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(style: .plain)
        bindUI()
        viewModel.fetchWeatherForAllLocations()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(CityWeatherTableViewCell.nib, forCellReuseIdentifier: CityWeatherTableViewCell.reuseIdentifier)
        tableView.rowHeight = 70
        tableView.dataSource = dataSource
    }
    
    private func makeDataSource() -> UITableViewDiffableDataSource<Int, CityWeather> {
        return UITableViewDiffableDataSource<Int, CityWeather>(tableView: tableView, cellProvider: {tableView, indexPath, city in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CityWeatherTableViewCell.reuseIdentifier, for: indexPath) as? CityWeatherTableViewCell else { fatalError("Cannot create header view") }
            cell.configure(city: city)
            return cell
        })
    }
    
    private func updateData(with cities: [CityWeather]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, CityWeather>()
        
        snapshot.appendSections([0])
        snapshot.appendItems(cities, toSection: 0)
        DispatchQueue.main.async {
            self.title = "Tomorrow's Weather"
            self.dataSource.apply(snapshot, animatingDifferences: false)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            guard let cityWeather = self.dataSource.itemIdentifier(for: indexPath) else { return }
            self.coordinator.weatherDetails(with: cityWeather)
            tableView.isUserInteractionEnabled = true
        }
        
    }
    
    private func bindUI() {
        viewModel.onNewsResponse
            .receive(on: DispatchQueue.global(qos: .background))
            .sink { completion in
                if case .failure(let error) = completion {
                    print("error: \(error)")
                }
            } receiveValue: { [unowned self] cities in
                self.updateData(with: cities)
            }.store(in: &subscriptions)

        viewModel.onViewStateChange
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] state in
                self.render(state)
            }.store(in: &subscriptions)
    }
    
    private func render(_ state: ViewState) {
        switch state {
        case .loading:
//            loadingView.isHidden = false
            loadingView.show()
        case .error(let message):
//            loadingView.isHidden = true
            loadingView.hide()
            showAlert(message: message)
        case .success:
//            loadingView.isHidden = true
            loadingView.hide()
        }
    }

    
}
