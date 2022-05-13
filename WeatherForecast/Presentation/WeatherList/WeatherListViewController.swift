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
    
    private lazy var searchController: UISearchController = {
        let resultVC = LocationsSearchResultsViewController(viewModel: viewModel)
        let searchVC = UISearchController(searchResultsController: resultVC)
        resultVC.completionBlock = { [weak self] in
            self?.searchController.searchBar.text = ""
        }
        return searchVC
    }()

    init(viewModel: WeatherListViewModel, coordinator: WeatherCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        
        super.init(style: .plain)
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        bindUI()
        fetchWeatherList()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareTableView()
    }
    
    private func prepareTableView() {
        tableView.register(WeatherTableViewCell.nib, forCellReuseIdentifier: WeatherTableViewCell.reuseIdentifier)
        tableView.rowHeight = 70
        tableView.dataSource = dataSource
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(fetchWeatherList), for: .valueChanged)
    }
    
    @objc
    private func fetchWeatherList() {
        viewModel.fetchWeatherForAllLocations()
    }
    
    
    private func makeDataSource() -> UITableViewDiffableDataSource<Int, Weather> {
        return UITableViewDiffableDataSource<Int, Weather>(tableView: tableView, cellProvider: {tableView, indexPath, city in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.reuseIdentifier, for: indexPath) as? WeatherTableViewCell else { fatalError("Cannot create header view") }
            cell.configure(city: city)
            return cell
        })
    }
    
    private func updateData(with cities: [Weather]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Weather>()
        
        snapshot.appendSections([0])
        snapshot.appendItems(cities, toSection: 0)
        DispatchQueue.main.async {
            self.title = "Today's Weather"
            self.dataSource.apply(snapshot, animatingDifferences: false)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            guard let weather = self.dataSource.itemIdentifier(for: indexPath) else { return }
            self.coordinator.weatherDetails(with: weather)
            tableView.isUserInteractionEnabled = true
        }
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { action, view, completion in
            completion(true)
            
            var snapshot = self.dataSource.snapshot()
            guard let itemToDelete = self.dataSource.itemIdentifier(for: indexPath) else { return }
            snapshot.deleteItems([itemToDelete])
            self.dataSource.apply(snapshot)
            self.viewModel.didDeleteWeather(with: itemToDelete)
        }
        return .init(actions: [deleteAction])
    }
    
    private func bindUI() {
        viewModel.$weatherList
            .receive(on: DispatchQueue.global(qos: .background))
            .sink { [unowned self] completion in
                if case .failure(let error) = completion {
                    print("error: \(error)")
                    self.endRefreshing()
                }
            } receiveValue: { [unowned self] cities in
                self.updateData(with: cities)
                self.endRefreshing()
            }.store(in: &subscriptions)

        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] state in
                self.render(state)
            }.store(in: &subscriptions)
        
        viewModel.$locationsResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] locations in
                print("$locationsResult::::: \(locations)")
                guard !locations.isEmpty, let resultVC = self?.searchController.searchResultsController as? LocationsSearchResultsViewController else { return }
                    resultVC.updateData(with: locations)
            }
            .store(in: &subscriptions)
    }
    
    private func render(_ state: ViewState) {
        switch state {
        case .loading:
            loadingView.show()
        case .error(let message):
            loadingView.hide()
            showAlert(message: message)
        case .success:
            loadingView.hide()
        }
    }
    
    private func endRefreshing() {
        DispatchQueue.main.async {
            self.tableView.refreshControl?.endRefreshing()
        }
    }
}

extension WeatherListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else { return }
        viewModel.searchText = searchText
    }
}
