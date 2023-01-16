//
//  HourlyForecastCollectionView.swift
//  WeatherTestApp
//
//  Created by Aleksandr Kretov on 16.01.2023.
//

import UIKit

final class HourlyForecastCollectionView: UICollectionView {

    private var cells: [HourlyCellViewModelProtocol]? 

    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 12, left: 20, bottom: 12, right: 20)
        layout.itemSize = CGSize(width: 45, height: 92)
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

    func setup(with cells: [HourlyCellViewModelProtocol]) {
        self.cells = cells
        reloadData()
    }
}

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
