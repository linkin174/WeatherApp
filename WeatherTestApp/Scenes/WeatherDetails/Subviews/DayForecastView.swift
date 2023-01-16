//
//  DayForecastView.swift
//  WeatherTestApp
//
//  Created by Aleksandr Kretov on 11.12.2022.
//

import UIKit
import SnapKit

protocol DayForecastViewModelProtocol {
    var dayName: String { get }
    var iconName: String { get }
    var precipitationTitle: String? { get }
    var dayTemp: String { get }
    var nightTemp: String { get }
}

final class DayForecastView: UIView {

    // MARK: - Views
    #warning("complete static factory, refactor all of the code!!!")
//    private let dayLbl = UILabel.makeLabel(type: .large)

    private let dayLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = .systemFont(ofSize: 20)
        label.dropShadow()
        return label
    }()

    private let iconImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.dropShadow()
        return view
    }()

    private let precipitationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = #colorLiteral(red: 0.4862208962, green: 0.8088949323, blue: 0.9760338664, alpha: 1)
        label.font = .systemFont(ofSize: 13, weight: .light)
        label.dropShadow()
        return label
    }()

    private let dayTempLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.dropShadow()
        return label
    }()

    private let nightTempLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = #colorLiteral(red: 0.6233376265, green: 0.7574332356, blue: 0.9322997928, alpha: 1)
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.dropShadow()
        return label
    }()

    // MARK: - Initializers

    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods

    func setup(viewModel: DayForecastViewModelProtocol) {
        dayLabel.text = viewModel.dayName
        iconImageView.image = UIImage(named: viewModel.iconName)
        precipitationLabel.text = viewModel.precipitationTitle
        dayTempLabel.text = viewModel.dayTemp
        nightTempLabel.text = viewModel.nightTemp
    }

    // MARK: - Private Methods

    private func setupConstraints() {
        addSubview(dayLabel)
        addSubview(iconImageView)
        addSubview(precipitationLabel)
        addSubview(dayTempLabel)
        addSubview(nightTempLabel)

        for subview in subviews {
            subview.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
            }
        }

        dayLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
        }

        iconImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.height.equalTo(30)
        }

        precipitationLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(9)
        }

        nightTempLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
        }

        dayTempLabel.snp.makeConstraints { make in
            make.trailing.equalTo(nightTempLabel.snp.trailing).inset(50)
        }
    }
}
