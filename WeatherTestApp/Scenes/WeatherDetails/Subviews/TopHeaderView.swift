//
//  TopHeaderView.swift
//  WeatherTestApp
//
//  Created by Aleksandr Kretov on 11.12.2022.
//

import UIKit
import SnapKit

struct HeaderConstants {

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

    private let cityNameLabel = makeLabel(.systemFont(ofSize: 34))
    private let tempLabel = makeLabel(.systemFont(ofSize: 96, weight: .thin))
    private let conditionLabel = makeLabel(.systemFont(ofSize: 20))
    private let hiLowLabel = makeLabel(.systemFont(ofSize: 20, weight: .light))

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

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup(viewModel: TopHeaderViewModelProtocol) {
        cityNameLabel.text = viewModel.cityName
        tempLabel.text = viewModel.temp
        conditionLabel.text = viewModel.conditionDescription
        hiLowLabel.text = "H: " + viewModel.hiTemp + " " + "L: " + viewModel.lowTemp
        shortInfoLabel.text = viewModel.shorInfo
    }

    private func setupConstraints() {
        addSubview(mainStack)

        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: topAnchor, constant: HeaderConstants.fullTopInset),
            mainStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStack.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}

extension TopHeaderView {
    private class func makeLabel(_ font: UIFont) -> UILabel {
        let label = UILabel()
        label.textColor = .white
        label.font = font
        label.dropShadow(width: 5)
        return label
    }
}

extension TopHeaderView: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let distance = scrollView.contentOffset.y
        handleFrameSize(scrollDistance: distance)
        handleTopConstraint(scrollDistance: distance)
        handleOpacity()
    }

    private func handleOpacity() {
        mainStack.arrangedSubviews
            .dropFirst()
            .map { $0 }
            .forEach { view in
                let viewMaxYDimension = view.frame.maxY
                var diff = frame.height - viewMaxYDimension
                let step: CGFloat = 1 / HeaderConstants.changeOpacityDistance

                if view.tag != 100 {
                    view.layer.opacity = Float(step * (diff - HeaderConstants.changeOpacityDistance))
                } else {
                    view.isHidden = view.layer.opacity <= 0 ? true : false
                    diff += view.frame.height
                    view.layer.opacity = 1 - Float(step * (diff - HeaderConstants.changeOpacityDistance))
                }
            }
    }

    private func handleFrameSize(scrollDistance: CGFloat) {
        if scrollDistance > 0, frame.height > HeaderConstants.smallHeight {
            frame.size.height = max(frame.height - scrollDistance, HeaderConstants.smallHeight)
        } else if scrollDistance < 0, frame.height < HeaderConstants.baseHeight {
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
