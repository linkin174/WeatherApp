//
//  HourlyCell.swift
//  WeatherTestApp
//
//  Created by Aleksandr Kretov on 11.12.2022.
//

import UIKit
import SnapKit

protocol HourlyCellViewModelProtocol {
    var timeTitle: String { get }
    var iconName: String { get }
    var tempTitle: String { get }
}

protocol HourlyCellProtocol {
    func setup(viewModel: HourlyCellViewModelProtocol)
}

final class HourlyCell: UICollectionViewCell, HourlyCellProtocol {
    // MARK: - Public Properteies

    static let reuseID = "hourlyCell"

    // MARK: - Private Properties

    private let timeLabel = UILabel.makeLabel(type: .small)
    private let tempTitleLabel = UILabel.makeLabel(type: .regular)

    private let iconImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.dropShadow()
        return view
    }()


    private lazy var mainStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [timeLabel, iconImageView, tempTitleLabel])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.alignment = .center
        return stack
    }()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods

    func setup(viewModel: HourlyCellViewModelProtocol) {
        timeLabel.text = viewModel.timeTitle
        iconImageView.image = UIImage(named: viewModel.iconName)
        tempTitleLabel.text = viewModel.tempTitle
    }

    // MARK: - Private Methods

    private func setupConstraints() {
        contentView.addSubview(mainStack)

        mainStack.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview()
        }

        iconImageView.snp.makeConstraints { make in
            make.width.height.equalTo(30)
        }
    }
}
