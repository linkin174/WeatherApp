//
//  WeatherCell.swift
//  WeatherTestApp
//
//  Created by Aleksandr Kretov on 07.12.2022.
//

import UIKit
import SnapKit

protocol WeatherCellViewModelProtocol {
    var cityName: String { get }
    var weatherIcon: UIImage? { get }
    var temp: String { get }
    var currentTime: String { get }
    var cityId: Int { get }
}

final class WeatherCell: UITableViewCell {

    // MARK: - Public properties

    static let reuseID = "weathercell"

    // MARK: - Private properties

    private let locationLabel = UILabel.makeLabel(type: .large)
    private let topText = UILabel.makeLabel(type: .small)

    private let tempLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .mainTextColor
        label.font = .systemFont(ofSize: 50, weight: .ultraLight)
        return label
    }()


    private var weatherIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Initializers

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
        contentView.backgroundColor = .mainBackground
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods

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

    // MARK: - Private methods

    private func setupConstraints() {
        contentView.addSubview(locationLabel)
        contentView.addSubview(tempLabel)
        contentView.addSubview(topText)
        contentView.addSubview(weatherIcon)

        locationLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(38)
        }

        tempLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(10)
        }

        topText.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.bottom.equalTo(locationLabel.snp.top).offset(3)
        }

        weatherIcon.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.trailing.equalToSuperview().inset(141)
            make.bottom.equalToSuperview().inset(13)
        }
    }
}
