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
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(city: CityWeather) {
        cityNameLabel.text = city.title
        guard let tomorrowWeather = city.tomorrowWeather else { return }
        weatherStateLabel.text = tomorrowWeather.weatherStateName
        temperatureLabel.text = "H: \(tomorrowWeather.maxTempInt)\nL:\(tomorrowWeather.minTempInt)"
        let weatherUrl = "https://www.metaweather.com/static/img/weather/png/64/\(tomorrowWeather.weatherStateAbbr).png"
        let url = URL(string: weatherUrl)!
        weatherStateImage.setImage(with: url, PlaceHolderImage: UIImage())
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected{
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
