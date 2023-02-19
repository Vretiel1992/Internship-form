//
//  SectionHeaderCollectionReusableView.swift
//  TestTaskSurf
//
//  Created by Антон Денисюк on 12.02.2023.
//

import UIKit

final class SectionHeaderCollectionReusableView: UICollectionReusableView, UIScrollViewDelegate {

    // MARK: - Private Properties

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods

    func configure(with section: InternshipSection) {
        titleLabel.setupConfigure(
            title: section.title,
            lineHeightMultiple: 1.12,
            maximumLineHeight: 32,
            lineBreakMode: .byTruncatingTail,
            alignment: .left,
            numberOfLines: 1,
            font: Constants.Fonts.SFProDisplay24Bold,
            textColor: Constants.Colors.darkColor
        )
        subtitleLabel.setupConfigure(
            title: section.subTitle,
            lineHeightMultiple: 1.2,
            maximumLineHeight: 20,
            lineBreakMode: .byWordWrapping,
            alignment: .left,
            numberOfLines: 0,
            font: Constants.Fonts.SFProDisplay14Regular,
            textColor: Constants.Colors.grayColor
        )
    }

    // MARK: - Private Methods

    private func setupViews() {
        addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
