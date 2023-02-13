//
//  ViewController.swift
//  TestTaskSurf
//
//  Created by Антон Денисюк on 09.02.2023.
//

import UIKit

class MainViewController: UIViewController {

    // MARK: - Public Properties

    let viewModel = Internship.viewModel

    // MARK: - Private Properties

    private lazy var backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Constants.Images.mainImage
        imageView.contentMode = .top
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var bottomMainView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.maskedCorners = [
            .layerMinXMinYCorner,
            .layerMaxXMinYCorner
        ]
        view.layer.cornerRadius = 32
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.bounces = false
        collectionView.backgroundColor = .clear
        collectionView.register(SectionHeaderCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: Constants.Text.sectionHeader)
        collectionView.register(DirectionCollectionViewCell.self,
                                forCellWithReuseIdentifier: Constants.Text.directionCell)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    private lazy var bottomStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 24
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var doYouWantToJoinUsLabel: UILabel = {
        let label = UILabel()
        label.setupConfigure(
            title: Constants.Text.doYouWantToJoinUs,
            lineHeightMultiple: 1.2,
            maximumLineHeight: 20,
            lineBreakMode: .byTruncatingTail,
            alignment: .left,
            numberOfLines: 1,
            font: Constants.Fonts.SFProDisplay14Regular,
            textColor: Constants.Colors.grayColor)
        return label
    }()

    private lazy var sendRequestButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        let title = Constants.Text.sendRequest
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.05
        let attributeContainer = AttributeContainer([
            NSAttributedString.Key.font: Constants.Fonts.SFProDisplay16Medium,
            NSAttributedString.Key.paragraphStyle: paragraphStyle
        ])
        config.attributedTitle = AttributedString(title, attributes: attributeContainer)
        config.titleAlignment = .center
        config.baseForegroundColor = .white
        config.baseBackgroundColor = Constants.Colors.darkColor
        config.cornerStyle = .capsule
        config.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 44, bottom: 20, trailing: 44)
        button.configuration = config
        return button
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }

    // MARK: - Private Methods

    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(backgroundImage)
        view.addSubview(bottomMainView)
        bottomMainView.addSubview(collectionView)
        view.addSubview(bottomStackView)
        bottomStackView.addArrangedSubview(doYouWantToJoinUsLabel)
        bottomStackView.addArrangedSubview(sendRequestButton)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            bottomMainView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomMainView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomMainView.topAnchor.constraint(equalTo: view.topAnchor, constant: 302),
            bottomMainView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            collectionView.leadingAnchor.constraint(equalTo: bottomMainView.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: bottomMainView.trailingAnchor, constant: -20),
            collectionView.topAnchor.constraint(equalTo: bottomMainView.topAnchor, constant: 24),
            collectionView.heightAnchor.constraint(equalToConstant: 336),

            bottomStackView.leadingAnchor.constraint(equalTo: bottomMainView.leadingAnchor, constant: 20),
            bottomStackView.trailingAnchor.constraint(equalTo: bottomMainView.trailingAnchor, constant: -20),
            bottomStackView.bottomAnchor.constraint(equalTo: bottomMainView.bottomAnchor),
            bottomStackView.heightAnchor.constraint(equalToConstant: 60),

            doYouWantToJoinUsLabel.widthAnchor.constraint(equalToConstant: 92)
        ])
    }
}

// MARK: - create UICollectionViewCompositionalLayout

extension MainViewController {
    private func createLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let self = self else { return nil }
            let section = self.viewModel[sectionIndex]
            switch section.id {
            case 0:
                return self.createTopLayout()
            default:
                return self.createBotLayout()
            }
        }
    }
    
    private func createTopLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .estimated(70),
                                               heightDimension: .fractionalHeight(1)))


        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .estimated(630),
                                               heightDimension: .absolute(44)),
            subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 0, bottom: 12, trailing: 0)

        let layoutSectionHeader = createSectionHeader()
        section.boundarySupplementaryItems = [layoutSectionHeader]
        section.interGroupSpacing = 12
        return section
    }
    
    private func createBotLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .estimated(70),
                                               heightDimension: .absolute(44)))

        let verticalGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .estimated(400),
                                               heightDimension: .absolute(44)),
            subitems: [item, item, item, item, item])
        verticalGroup.interItemSpacing = .fixed(12)
        
        let nestedGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(widthDimension: .estimated(400),
                                               heightDimension: .absolute(100)),
            subitems: [verticalGroup, verticalGroup])
        nestedGroup.interItemSpacing = .fixed(12)
    
        let section = NSCollectionLayoutSection(group: nestedGroup)
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        section.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 0, bottom: 0, trailing: 0)

        let layoutSectionHeader = createSectionHeader()
        section.boundarySupplementaryItems = [layoutSectionHeader]
        section.interGroupSpacing = 12
        return section
    }

    func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let layoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                             heightDimension: .estimated(104))
        let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: layoutSectionHeaderSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        return layoutSectionHeader
    }
}

// MARK: - UICollectionViewDataSource

extension MainViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel[section].items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: Constants.Text.directionCell,
            for: indexPath) as? DirectionCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: viewModel[indexPath.section].items[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: Constants.Text.sectionHeader,
                for: indexPath) as? SectionHeaderCollectionReusableView else {
                return UICollectionReusableView()
            }
            header.configure(with: viewModel[indexPath.section])
            return header
        default:
            return UICollectionReusableView()
        }
    }
}

// MARK: - UICollectionViewDelegate

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
}
