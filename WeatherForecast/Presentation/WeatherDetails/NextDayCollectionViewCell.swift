//
//  NextDayCollectionViewCell.swift
//  WeatherForecast
//
//  Created by Kareem Ahmed on 10/05/2022.
//

import UIKit

class NextDayCollectionViewCell: UICollectionViewCell, CellReusable {

    @IBOutlet
    private var highTempLabel: UILabel!
    @IBOutlet
    private var lowTempLabel: UILabel!
    @IBOutlet
    private weak var weatherStateLabel: UILabel!
    @IBOutlet
    private weak var weatherStateImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setShadows()
    }
    
    func configure(weather: ConsolidatedWeather) {
        setTempLabels(weather)
        
        let weatherUrl = "\(WeatherConstants.weatherStateImageUrl.rawValue)\(weather.weatherStateAbbr)\(WeatherConstants.weatherStateImageType.rawValue)"
        let url = URL(string: weatherUrl)!
//        print(url.absoluteString)
        weatherStateImage.setImage(with: url, PlaceHolderImage: UIImage())
        weatherStateLabel.text = weather.weatherStateName
    }
    
    private func setTempLabels(_ weather: ConsolidatedWeather) {
        let keyAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14.0, weight: .light)]
        let valueAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22.0, weight: .bold),
            NSAttributedString.Key.foregroundColor: UIColor.yellowColor]
        
        var tempAttributedString = NSMutableAttributedString()
        tempAttributedString.append(NSAttributedString(string: "High ", attributes: keyAttributes))
        tempAttributedString.append(NSAttributedString(string: "\(weather.maxTemp.roundedInt())º\n", attributes: valueAttributes))
        
        highTempLabel.attributedText = tempAttributedString
        
        tempAttributedString = NSMutableAttributedString()
        tempAttributedString.append(NSAttributedString(string: "Low ", attributes: keyAttributes))
        tempAttributedString.append(NSAttributedString(string: "\(weather.minTemp.roundedInt())º", attributes: valueAttributes))
        
        lowTempLabel.attributedText = tempAttributedString
    }
    
    private func setShadows() {
        
        backgroundColor = .init(white: 1.0, alpha: 0.3)
        // Apply rounded corners to contentView
        contentView.layer.cornerRadius = 5.0
        contentView.layer.masksToBounds = true
        
        // Set masks to bounds to false to avoid the shadow
        // from being clipped to the corner radius
        layer.cornerRadius = 5.0
        layer.masksToBounds = false
        
        // Apply a shadow
//        layer.shadowRadius = 8.0
//        layer.shadowOpacity = 0.10
//        layer.shadowColor = UIColor.black.cgColor
//        layer.shadowOffset = CGSize(width: 0, height: 5)
    }

}
