//
//  DataView.swift
//  WeatherForecast
//
//  Created by Kareem Ahmed on 24/03/2022.
//

import UIKit

class DataView: UIView {
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.font = .boldSystemFont(ofSize: 17.0)
        return titleLabel
    }()
    private lazy var descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.textColor = .white
        descriptionLabel.numberOfLines = 2
        descriptionLabel.textAlignment = .center
        return descriptionLabel
    }()
    
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
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        configureLayout()
    }
    
    private func configureLayout() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 8),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: -2),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 8)
        ])
    }
    
    func setData(with title: String, description: String, textAlignment: NSTextAlignment? = nil) {
        titleLabel.text = title
        descriptionLabel.text = description
        guard let textAlignment = textAlignment else { return }
        titleLabel.textAlignment = textAlignment
        descriptionLabel.textAlignment = textAlignment
    }
    
    func setData(with title: String, description: NSAttributedString, textAlignment: NSTextAlignment? = nil) {
        titleLabel.text = title
        descriptionLabel.attributedText = description
        guard let textAlignment = textAlignment else { return }
        titleLabel.textAlignment = textAlignment
        descriptionLabel.textAlignment = textAlignment
    }
}
