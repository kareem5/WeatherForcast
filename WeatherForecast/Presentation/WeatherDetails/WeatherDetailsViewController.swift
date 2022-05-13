//
//  WeatherDetailsViewController.swift
//  WeatherForecast
//
//  Created by Kareem Ahmed on 23/03/2022.
//

import UIKit
import Combine

class WeatherDetailsViewController: UIViewController {
    private let nextDaysSectionHeaderElementKind = "section-header-element-kind"

    var coordinator: WeatherCoordinator
    private let viewModel: WeatherDetailsViewModel
    private var subscriptions = Set<AnyCancellable>()
    private lazy var dataSource = makeDataSource()
    
    @IBOutlet
    private weak var dateLabel: UILabel!
    @IBOutlet
    private weak var weatherStateLabel: UILabel!
    @IBOutlet
    private weak var weatherStateImage: UIImageView!
    @IBOutlet
    private weak var weatherDetailsView: FullWeatherDetailsView!
    @IBOutlet
    private weak var nextDaysCollectionView: UICollectionView!
    
    enum Section: String, CaseIterable {
      case nextDays = "Next Days"
    }
    
    init(viewModel: WeatherDetailsViewModel, coordinator: WeatherCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: "WeatherDetailsViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindUI()
        registerCells()
        nextDaysCollectionView.collectionViewLayout = generateNextDaysLayout()
        viewModel.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateNavigationBarColor(isDefault: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        updateNavigationBarColor(isDefault: true)
    }
    
    private func updateNavigationBarColor(isDefault: Bool) {
        let color: UIColor = isDefault ? .black : .white
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: color]
        navigationController?.navigationBar.tintColor = color
    }
    
    private func registerCells() {
        nextDaysCollectionView.register(NextDayCollectionViewCell.nib, forCellWithReuseIdentifier: NextDayCollectionViewCell.reuseIdentifier)
        nextDaysCollectionView.register(NextDaysHeaderView.self, forSupplementaryViewOfKind: nextDaysSectionHeaderElementKind, withReuseIdentifier: NextDaysHeaderView.reuseIdentifier)
    }
    
    private func bindUI() {
        viewModel.weatherSubject.sink { [unowned self] weather in
            self.updateData(with: weather)
        }.store(in: &subscriptions)
    }
    
    private func updateData(with city: Weather) {
        if let cityName = city.title {
            title = "\(cityName)"
        }
        guard let tomorrowWeather = city.todayWeather else { return }
        dateLabel.text = tomorrowWeather.applicableDate
        weatherStateLabel.text = tomorrowWeather.weatherStateName
        let weatherUrl = "\(WeatherConstants.weatherStateImageUrl.rawValue)\(tomorrowWeather.weatherStateAbbr)\(WeatherConstants.weatherStateImageType.rawValue)"
        let url = URL(string: weatherUrl)!
        print(url.absoluteString)
        weatherStateImage.setImage(with: url, PlaceHolderImage: UIImage())
        weatherDetailsView.setData(with: tomorrowWeather)
        applySnapshot(with: city.nextDaysWeather)
    }
    
    // MARK: - UICollectionView
    
    private func generateNextDaysLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3), heightDimension: .absolute(100))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(30))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: nextDaysSectionHeaderElementKind,
            alignment: .top)
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [sectionHeader]
        section.orthogonalScrollingBehavior = .continuous
        
        return UICollectionViewCompositionalLayout(section: section)
        
    }
    
    private func makeDataSource() -> UICollectionViewDiffableDataSource<Section, ConsolidatedWeather> {
        let datasource = UICollectionViewDiffableDataSource<Section, ConsolidatedWeather>(collectionView: nextDaysCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NextDayCollectionViewCell.reuseIdentifier, for: indexPath) as? NextDayCollectionViewCell else {
                fatalError("Could not dequeue next day cell")
            }
            cell.configure(weather: itemIdentifier)
            return cell
        })
        
        datasource.supplementaryViewProvider = {(
            collectionView: UICollectionView,
            kind: String,
            indexPath: IndexPath) -> UICollectionReusableView? in
            
            guard let supplementaryView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: NextDaysHeaderView.reuseIdentifier, for: indexPath) as? NextDaysHeaderView else { fatalError("Cannot create Next Days Header View")}
            
            supplementaryView.label.text = Section.nextDays.rawValue
            return supplementaryView
        }
        
        
        return datasource
    }
    
    private func applySnapshot(with nextDaysWeatherList: [ConsolidatedWeather]?) {
        guard let nextDaysWeatherList = nextDaysWeatherList else {
            return
        }

        var snapshot = NSDiffableDataSourceSnapshot<Section, ConsolidatedWeather>()
        snapshot.appendSections([Section.nextDays])
        snapshot.appendItems(nextDaysWeatherList)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
