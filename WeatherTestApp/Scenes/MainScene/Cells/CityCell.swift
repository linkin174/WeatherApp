//
//  CityCell.swift
//  WeatherTestApp
//
//  Created by Aleksandr Kretov on 31.12.2022.
//

import UIKit
import SnapKit

protocol CityCellViewModelProtocol {
    var cityName: String { get }
    var stateName: String { get }
    var countryName: String { get }
    var latitude: Double { get }
    var longitude: Double { get }
}

final class CityCell: UITableViewCell {

    static let reuseID = "cityCell"

    private let cityNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()

    private let countryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()

    private let stateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 14, weight: .light)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup(viewModel: CityCellViewModelProtocol) {
        cityNameLabel.text = viewModel.cityName
        countryLabel.text = viewModel.countryName
        stateLabel.text = viewModel.stateName
    }

    private func setupConstraints() {
        contentView.addSubview(cityNameLabel)
        contentView.addSubview(countryLabel)
        contentView.addSubview(stateLabel)

        cityNameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }

        stateLabel.snp.makeConstraints { make in
            make.leading.equalTo(cityNameLabel.snp.trailing).offset(16)
            make.centerY.equalToSuperview()
        }

        countryLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
        }
    }
}
