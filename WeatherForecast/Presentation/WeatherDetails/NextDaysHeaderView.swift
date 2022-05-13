//
//  NextDaysHeaderView.swift
//  WeatherForecast
//
//  Created by Kareem Ahmed on 13/05/2022.
//

import UIKit

class NextDaysHeaderView: UICollectionReusableView, CellReusable {
    
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        backgroundColor = .clear
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 20.0)
        
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let insets = CGFloat(0)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: insets),
            label.topAnchor.constraint(equalTo: topAnchor, constant: insets),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: insets)
        ])
    }
}
