//
//  SearchFieldCell.swift
//  WeatherTestApp
//
//  Created by Aleksandr Kretov on 08.12.2022.
//

import UIKit

final class SearchFieldCell: UITableViewCell {

    static let reuseID = "searchCell"

    weak var delegate: UITextFieldDelegate!  {
        didSet {
            searchField.delegate = delegate
        }
    }

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

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .black
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        contentView.addSubview(searchField)

        searchField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        searchField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant:  -20).isActive = true
        searchField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        searchField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
    }
}
