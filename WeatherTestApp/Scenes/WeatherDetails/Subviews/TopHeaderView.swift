//
//  TopHeaderView.swift
//  WeatherTestApp
//
//  Created by Aleksandr Kretov on 11.12.2022.
//

import UIKit
import SnapKit

private struct HeaderConstants {

    static let baseHeight: CGFloat = 326
    static let smallHeight: CGFloat = 69

    static let fullTopInset: CGFloat = 32
    static let smallTopInset: CGFloat = 0

    static let changeOpacityDistance: CGFloat = 40

    static var topConstraintRatio: CGFloat {
        (fullTopInset - smallTopInset) / (baseHeight - smallHeight)
    }
}

protocol TopHeaderViewModelProtocol {
    var cityName: String { get }
    var temp: String { get }
    var conditionDescription: String { get }
    var hiTemp: String { get }
    var lowTemp: String { get }
    var shorInfo: String { get }
}

protocol TopHeaderViewProtocol {
    func setup(viewModel: TopHeaderViewModelProtocol)
}

final class TopHeaderView: UIView, TopHeaderViewProtocol {

    // MARK: - Private Properties

    private let cityNameLabel = UILabel.makeLabel(type: .extraLarge)
    private let tempLabel = UILabel.makeLabel(type: .custom(info: (font: .systemFont(ofSize: 96, weight: .thin),
                                                                   color: .white)))
    private let conditionLabel = UILabel.makeLabel(type: .regular)
    private let hiLowLabel = UILabel.makeLabel(type: .regular)

    private let shortInfoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.isHidden = true
        label.text = "8° | Cloudy"
        label.font = .systemFont(ofSize: 20)
        label.layer.opacity = 0
        label.tag = 100
        label.dropShadow()
        return label
    }()

    private lazy var mainStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [cityNameLabel, shortInfoLabel, tempLabel, conditionLabel, hiLowLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fillProportionally
        stack.spacing = 1
        return stack
    }()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods

    func setup(viewModel: TopHeaderViewModelProtocol) {
        cityNameLabel.text = viewModel.cityName
        tempLabel.text = viewModel.temp
        conditionLabel.text = viewModel.conditionDescription
        hiLowLabel.text = "H: " + viewModel.hiTemp + " " + "L: " + viewModel.lowTemp
        shortInfoLabel.text = viewModel.shorInfo
    }

    // MARK: - Private Methods

    private func setupConstraints() {
        addSubview(mainStack)

        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: topAnchor, constant: HeaderConstants.fullTopInset),
            mainStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStack.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
// MARK: - Extensions

extension TopHeaderView: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        handleFrameSize(scrollDistance: scrollView.contentOffset.y)
        handleTopConstraint(scrollDistance: scrollView.contentOffset.y)
        if frame.height > HeaderConstants.smallHeight, frame.height < HeaderConstants.baseHeight {
            scrollView.contentOffset.y = 0
        }
        handleOpacity()
    }

    private func handleOpacity() {
        #warning("optimize")
       mainStack.arrangedSubviews
            .dropFirst()
            .forEach { view in
                var diff = frame.height - view.frame.maxY
                let step: CGFloat = 1 / HeaderConstants.changeOpacityDistance
                if view.tag != 100 {
                    view.layer.opacity = Float(step * (diff - HeaderConstants.changeOpacityDistance))
                } else {
                    view.isHidden = view.layer.opacity <= 0 ? true : false
                    diff += view.frame.height
                    view.layer.opacity = 1 - Float(step * (diff - HeaderConstants.changeOpacityDistance * 2))
                }
            }
    }

    private func handleFrameSize(scrollDistance: CGFloat) {
        if scrollDistance > 0 {
            frame.size.height = max(frame.height - scrollDistance, HeaderConstants.smallHeight)
        } else {
            frame.size.height = min(frame.height - scrollDistance, HeaderConstants.baseHeight)
        }
    }

    private func handleTopConstraint(scrollDistance: CGFloat) {
        guard let topConstraint = constraints.first(where: { $0.firstAttribute == .top && $0.secondAttribute == .top })
        else { return }
        if scrollDistance > 0, topConstraint.constant > HeaderConstants.smallTopInset {
            let topAmmount = scrollDistance * HeaderConstants.topConstraintRatio
            topConstraint.constant = max(topConstraint.constant - topAmmount, HeaderConstants.smallTopInset)
        } else if scrollDistance < 0, topConstraint.constant < HeaderConstants.fullTopInset {
            let ammount = scrollDistance * HeaderConstants.topConstraintRatio
            topConstraint.constant = min(topConstraint.constant - ammount, HeaderConstants.fullTopInset)
        }
    }
}
