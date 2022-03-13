//
//  WeatherListViewController.swift
//  WeatherForecast
//
//  Created by Kareem Ahmed on 13/03/2022.
//

import UIKit
import Combine

class WeatherListViewController: UIViewController {
    
    var coordinator: WeatherCoordinator

    
    private let viewModel: WeatherListViewModel
    private var subscriptions = Set<AnyCancellable>()

    init(viewModel: WeatherListViewModel, coordinator: WeatherCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: "WeatherListViewController", bundle: nil)
        bindUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func bindUI() {
//        viewModel.onViewStateChange
//            .receive(on: DispatchQueue.main)
//            .sink { [unowned self] state in
//                self.render(state)
//            }.store(in: &subscriptions)
    }
    
}
