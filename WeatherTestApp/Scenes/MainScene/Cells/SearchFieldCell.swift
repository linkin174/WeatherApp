//
//  SearchFieldCell.swift
//  WeatherTestApp
//
//  Created by Aleksandr Kretov on 08.12.2022.
//

import UIKit
import SnapKit

final class SearchFieldCell: UITableViewCell {

    // MARK: - Public properties

    static let reuseID = "searchCell"

    weak var delegate: UITextFieldDelegate!  {
        didSet {
            searchField.delegate = delegate
        }
    }

    // MARK: - Private properties

    private let searchField: UISearchTextField = {
        let field = UISearchTextField()
        field.backgroundColor = #colorLiteral(red: 0.1176470444, green: 0.1176470444, blue: 0.1176470444, alpha: 1)
        field.tintColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        field.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        field.leftView?.tintColor = #colorLiteral(red: 0.6980388761, green: 0.6980397105, blue: 0.7152424455, alpha: 1)
        field.attributedPlaceholder = NSAttributedString(string: "Search",
                                                        attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)])
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()

    // MARK: - Initializers

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .mainBackground
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Private methods
    
    private func setupConstraints() {
        contentView.addSubview(searchField)
        searchField.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
            make.height.equalToSuperview()
        }
    }
}
