//
//  PlaceTableViewCell.swift
//  WeatherTestApp
//
//  Created by Aleksandr Kretov on 05.01.2023.
//

import SnapKit
import UIKit

protocol PlaceCellViewModelRepresentable {
    var cityName: String { get }
    var stateName: String { get }
    var countryName: String { get }
}

final class PlaceCell: UITableViewCell {

    // MARK: - Static Properties

    static let reuseID = "placeCell"

    // MARK: - Private properties

    private let cityNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mainTextColor
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    }()

    private let stateNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mainTextColor
        label.font = .systemFont(ofSize: 13)
        return label
    }()

    private let countryNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mainTextColor
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        return label
    }()

    // MARK: - Initializers

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .mainBackground
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods

    func setup(with viewModel: PlaceCellViewModelRepresentable) {
        cityNameLabel.text = viewModel.cityName
        stateNameLabel.text = viewModel.stateName
        countryNameLabel.text = viewModel.countryName
    }

    // MARK: - Private Methods

    private func setupConstraints() {
        contentView.addSubview(cityNameLabel)
        contentView.addSubview(stateNameLabel)
        contentView.addSubview(countryNameLabel)

        cityNameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(8)
        }

        stateNameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().inset(8)
        }

        countryNameLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
    }
}
