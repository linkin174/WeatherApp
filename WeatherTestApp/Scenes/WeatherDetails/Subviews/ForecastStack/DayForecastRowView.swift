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

final class DayForecastRowView: UIView {

    // MARK: - Views

    private let dayLabel = UILabel.makeLabel(type: .regular)
    private let dayTempLabel = UILabel.makeLabel(type: .regular)
    private let precipitationLabel = UILabel.makeLabel(type: .custom(info: (font: .systemFont(ofSize: 13), color: #colorLiteral(red: 0.4862208962, green: 0.8088949323, blue: 0.9760338664, alpha: 1))))
    private let nightTempLabel = UILabel.makeLabel(type: .custom(info: (font: .systemFont(ofSize: 20), color: #colorLiteral(red: 0.6233376265, green: 0.7574332356, blue: 0.9322997928, alpha: 1))))

    private let iconImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
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

    override func layoutSubviews() {
        super.layoutSubviews()
        iconImageView.dropContactShadow(height: 6)
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
//        addSubview(containerView)
//        containerView.addSubview(iconImageView)

        for subview in subviews {
            subview.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
            }
        }

        dayLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
        }

//        containerView.snp.makeConstraints { make in
//            make.centerX.equalToSuperview()
//            make.width.height.equalTo(25)
//        }

        iconImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.height.equalTo(25)
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
