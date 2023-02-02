//
//  DayForecastStackView.swift
//  WeatherTestApp
//
//  Created by Aleksandr Kretov on 11.12.2022.
//

import UIKit

protocol DayForecastStackViewModelProtocol {
    var daysForecastViewModels: [DayForecastViewModelProtocol] { get }
}

final class DayForecastStackView: UIStackView {

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        axis = .vertical
        spacing = 8
        distribution = .fillEqually
        alignment = .fill
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods

    func setup(viewModels: [DayForecastViewModelProtocol]) {
        for (index, viewModel) in viewModels.enumerated() {
            if arrangedSubviews.count < viewModels.count {
                let dayRow = DayForecastRowView()
                dayRow.setup(viewModel: viewModel)
                addArrangedSubview(dayRow)
            } else {
                guard let subview = arrangedSubviews[index] as? DayForecastRowView else { return }
                subview.setup(viewModel: viewModel)
            }
        }
    }
}
