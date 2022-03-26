//
//  CityWeatherTableViewCell.swift
//  WeatherForecast
//
//  Created by Kareem Ahmed on 22/03/2022.
//

import UIKit

class CityWeatherTableViewCell: UITableViewCell, CellReusable {
    
    
    @IBOutlet
    private weak var cityNameLabel: UILabel!
    @IBOutlet
    private weak var temperatureLabel: UILabel!
    @IBOutlet
    private weak var weatherStateLabel: UILabel!
    @IBOutlet
    private weak var weatherStateImage: UIImageView!
    
    
    func configure(city: CityWeather) {
        if let cityName = city.title, let countryName = city.country?.title {
            cityNameLabel.text = "\(cityName), \(countryName)"
        }
        guard let tomorrowWeather = city.tomorrowWeather else { return }
        weatherStateLabel.text = tomorrowWeather.weatherStateName
        let weatherUrl = "https://www.metaweather.com/static/img/weather/png/64/\(tomorrowWeather.weatherStateAbbr).png"
        let url = URL(string: weatherUrl)!
        print(url.absoluteString)
        weatherStateImage.setImage(with: url, PlaceHolderImage: UIImage())
        
        let keyAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14.0, weight: .light)]
        let valueAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22.0, weight: .bold),
                               NSAttributedString.Key.foregroundColor: UIColor(named: "yellowColor")!]
        
        let fullTempString = NSMutableAttributedString()
        fullTempString.append(NSAttributedString(string: "High  ", attributes: keyAttributes))
        fullTempString.append(NSAttributedString(string: "\(tomorrowWeather.maxTemp.roundedInt())º\n", attributes: valueAttributes))
        fullTempString.append(NSAttributedString(string: "Low    ", attributes: keyAttributes))
        fullTempString.append(NSAttributedString(string: "\(tomorrowWeather.minTemp.roundedInt())º", attributes: valueAttributes))
        
        temperatureLabel.attributedText = fullTempString
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            UIView.animate(withDuration: 0.2, animations: {
                self.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
            }, completion: { finished in
                UIView.animate(withDuration: 0.2) {
                    self.transform = .identity
                }
            })
        }
    }
}
