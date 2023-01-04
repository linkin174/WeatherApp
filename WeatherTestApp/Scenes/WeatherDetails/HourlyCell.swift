//
//  HourlyCell.swift
//  WeatherTestApp
//
//  Created by Aleksandr Kretov on 11.12.2022.
//

import UIKit

protocol HourlyCellViewModelProtocol {
    var timeTitle: String { get }
    var iconName: String { get }
    var tempTitle: String { get }
}

protocol HourlyCellProtocol {
    func setup(viewModel: HourlyCellViewModelProtocol)
}

final class HourlyCell: UICollectionViewCell, HourlyCellProtocol {

    static let reuseID = "hourlyCell"

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let timeLabel: UILabel = {
        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = .systemFont(ofSize: 15)
        return label
    }()

    private let iconImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        return view
    }()

    private let tempTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = .systemFont(ofSize: 20, weight: .medium)
        return label
    }()

    private lazy var mainStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [timeLabel, iconImageView, tempTitleLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.alignment = .center
        return stack
    }()

    func setup(viewModel: HourlyCellViewModelProtocol) {
        timeLabel.text = viewModel.timeTitle
        iconImageView.image = UIImage(named: viewModel.iconName)
        tempTitleLabel.text = viewModel.tempTitle
    }


    private func setupConstraints() {
        contentView.addSubview(mainStack)

        mainStack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        mainStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        mainStack.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
//        mainStack.heightAnchor.constraint(equalToConstant: 100).isActive = true

        iconImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        iconImageView.centerXAnchor.constraint(equalTo: mainStack.centerXAnchor).isActive = true
        iconImageView.centerYAnchor.constraint(equalTo: mainStack.centerYAnchor).isActive = true

    }
}
