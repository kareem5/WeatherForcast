//
//  LocationsSearchResultsViewController.swift
//  WeatherForecast
//
//  Created by Kareem Ahmed on 11/04/2022.
//

import UIKit

class LocationsSearchResultsViewController: UITableViewController {
    private lazy var dataSource = makeDataSource()
    private let viewModel: WeatherListViewModel
    var completionBlock: (() -> Void)?
    
    init(viewModel: WeatherListViewModel) {
        self.viewModel = viewModel
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.dataSource = dataSource
    }
    
    private func makeDataSource() -> UITableViewDiffableDataSource<Int, Location> {
        return UITableViewDiffableDataSource<Int, Location>(tableView: tableView, cellProvider: {tableView, indexPath, location in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            var content = cell.defaultContentConfiguration()
            content.text = location.title
            cell.contentConfiguration = content
            return cell
        })
    }

    
    func updateData(with locations: LocationList) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Location>()
        
        snapshot.appendSections([0])
        snapshot.appendItems(locations, toSection: 0)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: false)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let location = self.dataSource.itemIdentifier(for: indexPath) else { return }
        viewModel.didSelectLocationFromSearchResult(with: location)
        dismiss(animated: true, completion: nil)
        completionBlock?()
    }
}
