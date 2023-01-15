//
//  MiscInfoView.swift
//  WeatherTestApp
//
//  Created by Aleksandr Kretov on 24.12.2022.
//

import UIKit
import SnapKit

protocol MiscInfoViewModelProtocol {
    var weatherDescription: String { get }
    var sunriseTime: String { get }
    var sunsetTime: String { get }
    var chanceOfPop: String? { get }
    var humidity: String { get }
    var wind: String { get }
    var feelsLike: String { get }
    var precipitation: String { get }
    var pressure: String { get }
    var visibility: String { get }
    var uvIndex: String { get }
    var isRain: Bool { get }
}

final class MiscInfoView: UIView {
    
    @IBOutlet private weak var weatherDescriptionTitle: UILabel!
    @IBOutlet private weak var sunriseTitle: UILabel!
    @IBOutlet private weak var sunsetLabel: UILabel!
    @IBOutlet private weak var chanceOfTitle: UILabel!
    @IBOutlet private weak var chanceOfLabel: UILabel!
    @IBOutlet private weak var humidityLabel: UILabel!
    @IBOutlet private weak var windSpeedLabel: UILabel!
    @IBOutlet private weak var fellsLikeLabel: UILabel!
    @IBOutlet private weak var precipitationLabel: UILabel!
    @IBOutlet private weak var pressureLabel: UILabel!
    @IBOutlet private weak var visabilityLabel: UILabel!
    @IBOutlet private weak var uvIndexLabel: UILabel!
    @IBOutlet private weak var contentView: MiscInfoView!

    init() {
        super.init(frame: .zero)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func setup(viewModel: MiscInfoViewModelProtocol) {
        if !viewModel.isRain {
            chanceOfTitle.text = "CHANCE OF SNOW"
        }
        weatherDescriptionTitle.text = viewModel.weatherDescription
        sunriseTitle.text = viewModel.sunriseTime
        sunsetLabel.text = viewModel.sunsetTime
        chanceOfLabel.text = viewModel.chanceOfPop
        humidityLabel.text = viewModel.humidity
        windSpeedLabel.text = viewModel.wind
        fellsLikeLabel.text = viewModel.feelsLike
        precipitationLabel.text = viewModel.precipitation
        pressureLabel.text = viewModel.pressure
        visabilityLabel.text = viewModel.visibility
        uvIndexLabel.text = viewModel.uvIndex
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("MiscInfoView", owner: self)
        addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
