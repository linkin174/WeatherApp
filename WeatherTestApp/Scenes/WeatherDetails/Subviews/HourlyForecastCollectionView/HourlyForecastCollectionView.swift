//
//  HourlyForecastCollectionView.swift
//  WeatherTestApp
//
//  Created by Aleksandr Kretov on 16.01.2023.
//

import UIKit

final class HourlyForecastCollectionView: UICollectionView {

    // MARK: - Private Properties

    private var cells: [HourlyCellViewModelProtocol]?
    
    // MARK: - Initializers

    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 6, left: 20, bottom: 6, right: 20)
        layout.itemSize = CGSize(width: 45, height: 104)
        super.init(frame: .zero, collectionViewLayout: layout)
        showsHorizontalScrollIndicator = false
        backgroundColor = .clear
        alpha = 0
        register(HourlyCell.self, forCellWithReuseIdentifier: HourlyCell.reuseID)
        translatesAutoresizingMaskIntoConstraints = false
        dataSource = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods

    func setup(with cells: [HourlyCellViewModelProtocol]) {
        self.cells = cells
        reloadData()
    }
}

// MARK: - CollectionView Delegate

extension HourlyForecastCollectionView: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = dequeueReusableCell(withReuseIdentifier: HourlyCell.reuseID, for: indexPath) as? HourlyCell else { return UICollectionViewCell() }
        if let vm = cells?[indexPath.item] {
            cell.setup(viewModel: vm)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cells?.count ?? 0
    }
}
