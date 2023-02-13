//
//  DirectionCollectionViewCell.swift
//  TestTaskSurf
//
//  Created by Антон Денисюк on 10.02.2023.
//

import UIKit

class DirectionCollectionViewCell: UICollectionViewCell {

    // MARK: - Private Properties

    private lazy var directionLabel = UILabel()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Override Properties

    override var isSelected: Bool {
        didSet {
            if isSelected {
                contentView.backgroundColor = Constants.Colors.darkColor
                directionLabel.textColor = .white
            } else {
                contentView.backgroundColor = Constants.Colors.lightGrayColor
                directionLabel.textColor = Constants.Colors.darkColor
            }
        }
    }

    // MARK: - Public Methods

    func configure(with direction: Direction) {
        directionLabel.setupConfigure(
            title: direction.title,
            lineHeightMultiple: 1.0,
            maximumLineHeight: 20,
            lineBreakMode: .byTruncatingTail,
            alignment: .center,
            numberOfLines: 1,
            font: Constants.Fonts.SFProDisplay14Medium,
            textColor: Constants.Colors.darkColor)
    }

    // MARK: - Private Methods

    private func setupViews() {
        layer.cornerRadius = 12
        clipsToBounds = true
        contentView.backgroundColor = Constants.Colors.lightGrayColor
        contentView.addSubview(directionLabel)
    }

    private func setupConstraints() {
        directionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            directionLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 24),
            directionLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -24),
            directionLabel.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 12),
            directionLabel.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -12)
        ])
    }
}
