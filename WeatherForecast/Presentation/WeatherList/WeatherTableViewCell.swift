//
//  WeatherTableViewCell.swift
//  WeatherForecast
//
//  Created by Kareem Ahmed on 22/03/2022.
//

import UIKit

class WeatherTableViewCell: UITableViewCell, CellReusable {
    
    
    @IBOutlet
    private weak var cityNameLabel: UILabel!
    @IBOutlet
    private weak var temperatureLabel: UILabel!
    @IBOutlet
    private weak var weatherStateLabel: UILabel!
    @IBOutlet
    private weak var weatherStateImage: UIImageView!
    
    
    func configure(city: Weather) {
        if let cityName = city.title, let countryName = city.country?.title {
            cityNameLabel.text = "\(cityName), \(countryName)"
        }
        guard let todayWeather = city.todayWeather else { return }
        weatherStateLabel.text = todayWeather.weatherStateName
        let weatherUrl = "\(WeatherConstants.weatherStateImageUrl.rawValue)\(todayWeather.weatherStateAbbr)\(WeatherConstants.weatherStateImageType.rawValue)"
        let url = URL(string: weatherUrl)!
//        print(url.absoluteString)
        weatherStateImage.setImage(with: url, PlaceHolderImage: UIImage())
        
        let keyAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14.0, weight: .light)]
        let valueAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22.0, weight: .bold),
                               NSAttributedString.Key.foregroundColor: UIColor.yellowColor]
        
        let fullTempString = NSMutableAttributedString()
        fullTempString.append(NSAttributedString(string: "High  ", attributes: keyAttributes))
        fullTempString.append(NSAttributedString(string: "\(todayWeather.maxTemp.roundedInt())º\n", attributes: valueAttributes))
        fullTempString.append(NSAttributedString(string: "Low    ", attributes: keyAttributes))
        fullTempString.append(NSAttributedString(string: "\(todayWeather.minTemp.roundedInt())º", attributes: valueAttributes))
        
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
