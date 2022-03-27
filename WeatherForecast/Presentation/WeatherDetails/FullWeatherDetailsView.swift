//
//  FullWeatherDetailsView.swift
//  WeatherForecast
//
//  Created by Kareem Ahmed on 26/03/2022.
//

import UIKit

class FullWeatherDetailsView: UIView {

    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 35
        return stackView
    }()
    
    private let keyAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14.0, weight: .light)]
    private let valueAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22.0, weight: .bold),
                                   NSAttributedString.Key.foregroundColor: UIColor.yellowColor]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .clear
        addSubview(verticalStackView)
        configureLayout()
    }
    
    private func configureLayout() {
        NSLayoutConstraint.activate([
            verticalStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            verticalStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            verticalStackView.topAnchor.constraint(equalTo: topAnchor),
            verticalStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func setData(with weather: ConsolidatedWeather) {
        makeTopStack(with: weather)
        makeBottomStack(with: weather)
    }
    
    private func makeTopStack(with weather: ConsolidatedWeather) {
        let topStackView = makeHorizontalStack()
        let tempView = DataView()
        
        var fullTempString = NSMutableAttributedString()
        fullTempString.append(NSAttributedString(string: "High  ", attributes: keyAttributes))
        fullTempString.append(NSAttributedString(string: "\(weather.maxTemp.roundedInt())º\n", attributes: valueAttributes))
        fullTempString.append(NSAttributedString(string: "Low  ", attributes: keyAttributes))
        fullTempString.append(NSAttributedString(string: "\(weather.minTemp.roundedInt())º", attributes: valueAttributes))
        tempView.setData(with: "Temp", description: fullTempString, textAlignment: .left)
        
        
        let windSpeedView = DataView()
        fullTempString = NSMutableAttributedString()
        fullTempString.append(NSAttributedString(string: "\(weather.windSpeed.roundedInt())", attributes: valueAttributes))
        fullTempString.append(NSAttributedString(string: " km/h", attributes: keyAttributes))
        
        windSpeedView.setData(with: "Wind Speed", description: fullTempString)
        
        let airPressureView = DataView()
        fullTempString = NSMutableAttributedString()
        fullTempString.append(NSAttributedString(string: "\(weather.airPressureKmh.roundedInt())", attributes: valueAttributes))
        fullTempString.append(NSAttributedString(string: " mbar", attributes: keyAttributes))
        
        airPressureView.setData(with: "Air Pressure", description: fullTempString, textAlignment: .right)
        
        topStackView.addArrangedSubview(tempView)
        topStackView.addArrangedSubview(windSpeedView)
        topStackView.addArrangedSubview(airPressureView)
        
        verticalStackView.addArrangedSubview(topStackView)
    }
    
    private func makeBottomStack(with weather: ConsolidatedWeather) {
        let bottomStackView = makeHorizontalStack()
        let visibilityView = DataView()
        var fullTempString = NSMutableAttributedString()
        fullTempString.append(NSAttributedString(string: "\(weather.visibilityKmh.roundedInt())", attributes: valueAttributes))
        fullTempString.append(NSAttributedString(string: " km", attributes: keyAttributes))
        visibilityView.setData(with: "Visibility", description: fullTempString, textAlignment: .left)
        
        let humidityView = DataView()
        fullTempString = NSMutableAttributedString()
        fullTempString.append(NSAttributedString(string: "\(weather.humidity.roundedInt())", attributes: valueAttributes))
        fullTempString.append(NSAttributedString(string: " %", attributes: keyAttributes))
        humidityView.setData(with: "Humidity", description: fullTempString)
        
        
        let emptyView = UIView()
        bottomStackView.addArrangedSubview(visibilityView)
        bottomStackView.addArrangedSubview(humidityView)
        bottomStackView.addArrangedSubview(emptyView)
        
        verticalStackView.addArrangedSubview(bottomStackView)
    }
    
    private func makeHorizontalStack() -> UIStackView {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        return stackView
    }
    
}
