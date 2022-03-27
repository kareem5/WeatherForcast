//
//  WeatherDetailsViewController.swift
//  WeatherForecast
//
//  Created by Kareem Ahmed on 23/03/2022.
//

import UIKit
import Combine

class WeatherDetailsViewController: UIViewController {
    
    var coordinator: WeatherCoordinator
    private let viewModel: WeatherDetailsViewModel
    private var subscriptions = Set<AnyCancellable>()

    
    @IBOutlet
    private weak var dateLabel: UILabel!
    @IBOutlet
    private weak var weatherStateLabel: UILabel!
    @IBOutlet
    private weak var weatherStateImage: UIImageView!
    @IBOutlet
    private weak var weatherDetailsView: FullWeatherDetailsView!
    
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
    
    private func bindUI() {
        viewModel.cityWeatherSubject.sink { [unowned self] cityWeather in
            self.updateData(with: cityWeather)
        }.store(in: &subscriptions)
    }
    
    private func updateData(with city: CityWeather) {
        if let cityName = city.title {
            title = "\(cityName)"
        }
        guard let tomorrowWeather = city.tomorrowWeather else { return }
        dateLabel.text = tomorrowWeather.applicableDate
        weatherStateLabel.text = tomorrowWeather.weatherStateName
        let weatherUrl = "\(WeatherConstants.weatherStateImageUrl.rawValue)\(tomorrowWeather.weatherStateAbbr)\(WeatherConstants.weatherStateImageType.rawValue)"
        let url = URL(string: weatherUrl)!
        print(url.absoluteString)
        weatherStateImage.setImage(with: url, PlaceHolderImage: UIImage())
        weatherDetailsView.setData(with: tomorrowWeather)
    }
}
