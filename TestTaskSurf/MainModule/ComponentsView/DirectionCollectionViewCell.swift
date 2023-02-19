//
//  DirectionCollectionViewCell.swift
//  TestTaskSurf
//
//  Created by Антон Денисюк on 10.02.2023.
//

import UIKit

class DirectionCollectionViewCell: UICollectionViewCell {

    enum SelectionState {
        case selected
        case notSelected
    }

    // MARK: - Public Properties

    var currentSelectionState: SelectionState = .notSelected

    // MARK: - Private Properties

    private let titleLabel = UILabel()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Override Methods
    
    override func prepareForReuse() {
        setSelection(.notSelected)
    }

    // MARK: - Public Methods

    func configure(with direction: Direction) {
        titleLabel.setupConfigure(
            title: direction.title,
            lineHeightMultiple: 1.0,
            maximumLineHeight: 20,
            lineBreakMode: .byTruncatingTail,
            alignment: .center,
            numberOfLines: 1,
            font: Constants.Fonts.SFProDisplay14Medium,
            textColor: Constants.Colors.darkColor
        )
    }

    func toggleSelection() {
        switch currentSelectionState {
        case .selected:
            setSelection(.notSelected)
        case .notSelected:
            setSelection(.selected)
        }
    }

    func setSelection(_ state: SelectionState) {
        switch state {
        case .selected:
            contentView.backgroundColor = Constants.Colors.darkColor
            titleLabel.textColor = .white
            currentSelectionState = .selected
        case .notSelected:
            contentView.backgroundColor = Constants.Colors.lightGrayColor
            titleLabel.textColor = Constants.Colors.darkColor
            currentSelectionState = .notSelected
        }
    }
    // MARK: - Private Methods

    private func setupViews() {
        layer.cornerRadius = 12
        clipsToBounds = true
        contentView.backgroundColor = Constants.Colors.lightGrayColor
        contentView.addSubview(titleLabel)
    }
    
    private func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: Constants.Layout.titleLabelItemLeftAndRight
            ),
            titleLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -Constants.Layout.titleLabelItemLeftAndRight
            ),
            titleLabel.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: Constants.Layout.titleLabelItemTopAndBot
            ),
            titleLabel.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -Constants.Layout.titleLabelItemTopAndBot
            )
        ])
    }
}
