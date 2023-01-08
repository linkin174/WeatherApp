//
//  WeatherCell.swift
//  WeatherTestApp
//
//  Created by Aleksandr Kretov on 07.12.2022.
//

import UIKit

protocol WeatherCellViewModelProtocol {
    var cityName: String { get }
    var weatherIcon: UIImage? { get }
    var temp: String { get }
    var currentTime: String { get }
    var cityId: Int { get }
}

final class WeatherCell: UITableViewCell {

    static let reuseID = "weathercell"

    private let locationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .mainTextColor
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 25, weight: .semibold)
        return label
    }()

    private let tempLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .mainTextColor
        label.font = .systemFont(ofSize: 50, weight: .ultraLight)
        return label
    }()

    private let topText: UILabel = {
        let label = UILabel()
        label.textColor = .mainTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15, weight: .light)
        
        return label
    }()

    private var weatherIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
        contentView.backgroundColor = .mainBackground
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupCell(with viewModel: WeatherCellViewModelProtocol) {
        if viewModel.cityId == 0 {
            locationLabel.text = "My Location"
            topText.text = viewModel.cityName
        } else {
            locationLabel.text = viewModel.cityName
            topText.text = viewModel.currentTime
        }
        tempLabel.text = viewModel.temp
        weatherIcon.image = viewModel.weatherIcon
    }

    private func setupConstraints() {
        contentView.addSubview(locationLabel)
        contentView.addSubview(tempLabel)
        contentView.addSubview(topText)
        contentView.addSubview(weatherIcon)

        locationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        locationLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 38).isActive = true
        locationLabel.trailingAnchor.constraint(equalTo: weatherIcon.leadingAnchor, constant: -16).isActive = true

        tempLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        tempLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true

        topText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        topText.bottomAnchor.constraint(equalTo: locationLabel.topAnchor, constant: 3).isActive = true

        weatherIcon.widthAnchor.constraint(equalToConstant: 50).isActive = true
        weatherIcon.heightAnchor.constraint(equalToConstant: 50).isActive = true
        weatherIcon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -141).isActive = true
        weatherIcon.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -13).isActive = true
    }
}
