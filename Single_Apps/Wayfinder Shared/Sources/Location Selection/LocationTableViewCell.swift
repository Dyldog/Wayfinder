//
//  LocationTableViewCell.swift
//  Wayfinder
//
//  Created by Dylan Elliott on 29/12/2024.
//

import UIKit
import DylKit

struct LocationTableViewCellModel {
    let name: String
    let address: String
    let isStarred: Bool
}

final class LocationTableViewCell: UITableViewCell, ReusableView {
    let nameLabel: UILabel = .init()
    let addressLabel: UILabel = .init()
    let starButton: UIButton = .init()
    var onStarTapped: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .background
        nameLabel.textColor = .h2
        nameLabel.font = .arial(size: 17)
        addressLabel.textColor = .h1
        addressLabel.font = .arial(size: 12)
        starButton.tintColor = .systemYellow
        starButton.addTarget(self, action: #selector(starButtonTapped), for: .primaryActionTriggered)
        
        let labelStack = UIStackView(arrangedSubviews: [nameLabel, addressLabel])
        labelStack.axis = .vertical
        
        let contentStack = UIStackView(arrangedSubviews: [labelStack, .init(), starButton])
        contentStack.axis = .horizontal
        
        contentStack.embedded(in: contentView, all: 12)
    }
    
    func bind(with viewModel: LocationTableViewCellModel) {
        nameLabel.text = viewModel.name
        addressLabel.text = viewModel.address
        starButton.setImage(viewModel.starImage, for: .normal)
    }
    
    @objc private func starButtonTapped() {
        onStarTapped?()
    }
}

private extension LocationTableViewCellModel {
    var starImage: UIImage {
        .init(systemName: isStarred ? "star.fill" : "star")!.withTintColor(.systemYellow)
    }
}

private extension UIFont {
    static func arial(size: Int) -> UIFont {
        .init(name: "Arial Rounded MT Bold", size: CGFloat(size))!
    }
}
