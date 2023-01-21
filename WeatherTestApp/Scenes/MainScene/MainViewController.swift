//
//  MainViewController.swift
//  WeatherTestApp
//
//  Created by Aleksandr Kretov on 06.12.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol MainDisplayLogic: AnyObject {
    func displayCurrentWeather(viewModel: MainScene.LoadWeather.ViewModel)
    func displayError(viewModel: MainScene.HandleError.ViewModel)
    func displaySearchResults(viewModel: MainScene.LoadWeather.ViewModel)
}

final class MainViewController: UIViewController, MainDisplayLogic {
    // MARK: - Public Properties

    var router: (NSObjectProtocol & MainRoutingLogic & MainDataPassing)?
    var interactor: MainBusinessLogic?
    var isSearching = false

    // MARK: - Private properties

    private var notificationObserver: NSObjectProtocol?
    private var mainViewModel: MainScene.LoadWeather.ViewModel? {
        didSet {
            showHideTableInfoLabel()
        }
    }

    // MARK: - Views

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.frame)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(WeatherCell.self, forCellReuseIdentifier: WeatherCell.reuseID)
        tableView.register(SearchFieldCell.self, forCellReuseIdentifier: SearchFieldCell.reuseID)
        tableView.register(PlaceCell.self, forCellReuseIdentifier: PlaceCell.reuseID)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .mainBackground
        tableView.refreshControl = refreshControl
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()

    private let tableInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "Nothing Found"
        label.textColor = .white
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.isHidden = true
        return label
    }()

    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
        refreshControl.tintColor = .white
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 16)
        ]
        refreshControl.attributedTitle = NSAttributedString(string: "Reloading forecast...",
                                                            attributes: attributes)
        return refreshControl
    }()

    private let indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .white
        indicator.startAnimating()
        indicator.hidesWhenStopped = true
        return indicator
    }()

    private let sectionIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .white
        indicator.startAnimating()
        indicator.hidesWhenStopped = true
        return indicator
    }()

    // MARK: - Initializers

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setupModule()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    deinit {
        if let notificationObserver {
            NotificationCenter.default.removeObserver(notificationObserver)
        }
    }

    // MARK: - Lifecicle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Weather"
        setupNavigationBar()
        setupConstraints()
        loadData()
        notificationObserver = NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification,
                                                                      object: nil,
                                                                      queue: .main,
                                                                      using: { [unowned self] _ in loadData() })
    }

    // MARK: - Display Logic

    func displayCurrentWeather(viewModel: MainScene.LoadWeather.ViewModel) {
        tableView.isUserInteractionEnabled = true
        mainViewModel = viewModel
        indicator.stopAnimating()
        refreshControl.endRefreshing()
        tableView.reloadSections(IndexSet(integersIn: 1 ... 2), with: .fade)
    }

    func displaySearchResults(viewModel: MainScene.LoadWeather.ViewModel) {
        if isSearching {
            handleWeatherCellsWithRowAnimation(cells: viewModel.weatherCellViewModels)
            handlePlacesCellsWithRowAnimation(cells: viewModel.placeCellViewModels)
        }
    }

    func displayError(viewModel: MainScene.HandleError.ViewModel) {
        let retryAction = UIAlertAction(title: "Retry", style: .default) { [weak self] _ in
            self?.loadData()
        }
        showAlert(title: "OOPS", message: viewModel.errorMessage, actions: [retryAction])
    }

    // MARK: - Private Methods

    private func setupModule() {
        let networkService = AFNetworkService()
        let storageService = StorageService()
        let viewController = self
        let interactor = MainInteractor(storageService: storageService,
                                        networkService: networkService)
        let presenter = MainPresenter()
        let router = MainRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }

    private func setupConstraints() {
        view.addSubview(tableView)
        tableView.addSubview(tableInfoLabel)

        let labelOffset = tableView.rect(forSection: 0).height
        tableInfoLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(labelOffset)
        }
    }

    private func setupNavigationBar() {
        let appearence = UINavigationBarAppearance()
        appearence.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        appearence.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        appearence.backgroundColor = .mainBackground
        appearence.shadowColor = nil
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.standardAppearance = appearence
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: indicator)
        // Setup back button
        let backButtonImage = UIImage(named: "back")
        navigationController?.navigationBar.backIndicatorImage = backButtonImage
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = backButtonImage
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .white
    }

    private func showHideTableInfoLabel() {
        guard let mainViewModel else { return }
        if mainViewModel.weatherCellViewModels.isEmpty, mainViewModel.placeCellViewModels.isEmpty {
            tableInfoLabel.isHidden = false
        } else {
            tableInfoLabel.isHidden = true
        }
    }

    private func handleWeatherCellsWithRowAnimation(cells: [WeatherCellViewModelProtocol]) {
        guard let mainViewModel else { return }
        var indexPaths = [IndexPath]()
        let difference = mainViewModel.weatherCellViewModels.count - cells.count
        if difference > 0 {
            for (index, model) in mainViewModel.weatherCellViewModels.enumerated() {
                if !cells.contains(where: { $0.cityName == model.cityName }) {
                    let indexPath = IndexPath(row: index, section: 1)
                    indexPaths.append(indexPath)
                }
            }
            self.mainViewModel?.weatherCellViewModels = cells
            tableView.deleteRows(at: indexPaths, with: .left)
        } else {
            for (index, model) in cells.enumerated() {
                if !mainViewModel.weatherCellViewModels.contains(where: { $0.cityName == model.cityName }) {
                    let indexPath = IndexPath(row: index, section: 1)
                    indexPaths.append(indexPath)
                }
            }
            self.mainViewModel?.weatherCellViewModels = cells
            tableView.insertRows(at: indexPaths, with: .left)
        }
    }

    private func handlePlacesCellsWithRowAnimation(cells: [PlaceCellViewModelRepresentable]) {
        guard let mainViewModel else { return }
        let difference = mainViewModel.placeCellViewModels.count - cells.count
        self.mainViewModel?.placeCellViewModels = cells
        if difference > 0 {
            let pathsToDelete = (0..<difference).map { IndexPath(row: $0, section: 2) }
            tableView.deleteRows(at: pathsToDelete, with: .fade)
        } else if difference < 0 {
            let paths = (0..<abs(difference)).map { IndexPath(row: $0, section: 2) }
            tableView.insertRows(at: paths, with: .fade)
        }

        let pathsToReload = (0..<mainViewModel.placeCellViewModels.count).map { IndexPath(row: $0, section: 2) }
        reloadPlaceRows(at: pathsToReload)
    }

    private func reloadPlaceRows(at: [IndexPath]) {
        at.forEach { indexPath in
            guard
                let cell = tableView.cellForRow(at: indexPath) as? PlaceCell,
                let vm = mainViewModel?.placeCellViewModels[indexPath.row]
            else {
                return
            }
            cell.setup(with: vm)
        }
    }

    private func deleteCity(at indexPath: IndexPath) {
        guard let id = mainViewModel?.weatherCellViewModels[indexPath.row].cityId else { return }
        mainViewModel?.weatherCellViewModels.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        let request = MainScene.RemoveCity.Request(cityID: id)
        interactor?.removeCity(request: request)
    }

    private func search(_ cityName: String) {
        let request = MainScene.SearchCities.Request(searchString: cityName, isSearching: isSearching)
        interactor?.searchCity(request: request)
    }

    private func addCity(forRowAt indexPath: IndexPath) {
        indicator.startAnimating()
        isSearching = false
        view.endEditing(true)
        tableView.isUserInteractionEnabled = false
        let request = MainScene.AddCity.Request(indexPath: indexPath)
        interactor?.addCity(request: request)
    }

    @objc private func loadData() {
        if !refreshControl.isRefreshing {
            indicator.startAnimating()
        }
        interactor?.loadData()
    }
}

// MARK: Extension - UITableViewDelegate

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            router?.routeToDetailsVC()
            view.endEditing(true)
        } else if indexPath.section == 2 {
            addCity(forRowAt: indexPath)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.section == 1, indexPath.row != 0 {
            let deleteAction = UIContextualAction(style: .destructive, title: "Remove") { [weak self] _, _, completion in
                self?.deleteCity(at: indexPath)
                completion(true)
            }
            let config = UISwipeActionsConfiguration(actions: [deleteAction])
            config.performsFirstActionWithFullSwipe = true
            return config
        }
        return nil
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 2 {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 32))
            view.backgroundColor = .secondaryBackground
            let titleLabel = UILabel.makeLabel(title: "Maybe you looking for:",
                                               type: .custom(info: (font: .systemFont(ofSize: 13, weight: .semibold), color: .white)))
            view.addSubview(titleLabel)
            titleLabel.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(16)
                make.centerY.equalToSuperview()
            }
            return view
        }
        return nil
    }


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: return 33
        case 1: return 83
        default: return 53
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 2, !(mainViewModel?.placeCellViewModels.isEmpty ?? true) {
            return 32
        }
        return 0
    }
}

// MARK: Extension - UITableViewDataSource

extension MainViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return mainViewModel?.weatherCellViewModels.count ?? 0
        default: return mainViewModel?.placeCellViewModels.count ?? 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchFieldCell.reuseID) as? SearchFieldCell else { return UITableViewCell() }
            cell.delegate = self
            return cell
        case 1:
            guard
                let cell = tableView.dequeueReusableCell(withIdentifier: WeatherCell.reuseID) as? WeatherCell,
                let viewModel = mainViewModel?.weatherCellViewModels[indexPath.row]
            else {
                return UITableViewCell()
            }
            cell.setupCell(with: viewModel)
            return cell
        default:
            guard
                let cell = tableView.dequeueReusableCell(withIdentifier: PlaceCell.reuseID) as? PlaceCell,
                let viewModel = mainViewModel?.placeCellViewModels[indexPath.row]
            else {
                return UITableViewCell()
            }
            cell.setup(with: viewModel)
            return cell
        }
    }
}

// MARK: Extension - UITextFiledDelegate

extension MainViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else { return }
        isSearching = !text.isEmpty
        self.search(text)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if !isSearching {
            textField.text? = ""
        }
        textField.resignFirstResponder()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        tableInfoLabel.isHidden = true
        return true
    }
}
