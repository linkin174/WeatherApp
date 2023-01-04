//
//  DayForecastView.swift
//  WeatherTestApp
//
//  Created by Aleksandr Kretov on 11.12.2022.
//

import UIKit

protocol DayForecastViewModelProtocol {
    var dayName: String { get }
    var iconName: String { get }
    var precipitationTitle: String? { get }
    var dayTemp: String { get }
    var nightTemp: String { get }
}

final class DayForecastView: UIView {

    // MARK: Views

    private let dayLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = .systemFont(ofSize: 20)
        return label
    }()

    private let iconImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        return view
    }()

    private let precipitationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = #colorLiteral(red: 0.4862208962, green: 0.8088949323, blue: 0.9760338664, alpha: 1)
        label.font = .systemFont(ofSize: 13, weight: .light)
        return label
    }()

    private let dayTempLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()

    private let nightTempLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = #colorLiteral(red: 0.6233376265, green: 0.7574332356, blue: 0.9322997928, alpha: 1)
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()

    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup(viewModel: DayForecastViewModelProtocol) {
        dayLabel.text = viewModel.dayName
        iconImageView.image = UIImage(named: viewModel.iconName)
        precipitationLabel.text = viewModel.precipitationTitle
        dayTempLabel.text = viewModel.dayTemp
        nightTempLabel.text = viewModel.nightTemp
    }

    private func setupConstraints() {
        addSubview(dayLabel)
        addSubview(iconImageView)
        addSubview(precipitationLabel)
        addSubview(dayTempLabel)
        addSubview(nightTempLabel)

        for subview in subviews {
            subview.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        }

//        heightAnchor.constraint(equalToConstant: 32).isActive = true
        dayLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true

//        iconImageView.leadingAnchor.constraint(equalTo: dayLabel.leadingAnchor, constant: 152).isActive = true
        iconImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true

        precipitationLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 9).isActive = true

        nightTempLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true

        dayTempLabel.trailingAnchor.constraint(equalTo: nightTempLabel.trailingAnchor, constant:  -50).isActive = true

    }
}
