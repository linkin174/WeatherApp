//
//  DayForecastStackView.swift
//  WeatherTestApp
//
//  Created by Aleksandr Kretov on 11.12.2022.
//

import UIKit

protocol DayForecastStackViewModelProtocol {
    var dayViewModel: [DayForecastViewModelProtocol] { get }
}

final class DayForecastStackView: UIStackView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        axis = .vertical
        spacing = 8
        distribution = .fillEqually
        alignment = .fill
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup(viewModel: [DayForecastViewModelProtocol]) {
        for viewModel in viewModel {
            let dayRow = DayForecastView()
            dayRow.setup(viewModel: viewModel)
            addArrangedSubview(dayRow)
        }
    }
}
