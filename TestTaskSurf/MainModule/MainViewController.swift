//
//  ViewController.swift
//  TestTaskSurf
//
//  Created by Антон Денисюк on 09.02.2023.
//

import UIKit

protocol MainViewProtocol: AnyObject {
    func loadViewModel(viewModel: [InternshipSection])
    func showAlert()
    func moveCellAndUpdateViewModel(indexPath: IndexPath, updateViewModel: [InternshipSection])
}

private enum BottomViewState {
    case closed
    case open
}

extension BottomViewState {
    var opposite: BottomViewState {
        switch self {
        case .open:
            return .closed
        case .closed:
            return .open
        }
    }
}

final class MainViewController: UIViewController {

    // MARK: - Public Properties

    var presenter: MainViewPresenterProtocol?
    var internshipSections: [InternshipSection] = []

    // MARK: - Private Properties

    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Constants.Images.mainBackgroundImage
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let bottomMainView: UIView = {
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
                                withReuseIdentifier: Constants.Text.sectionHeaderIdentifier)
        collectionView.register(DirectionCollectionViewCell.self,
                                forCellWithReuseIdentifier: Constants.Text.directionCellIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isUserInteractionEnabled = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    private let bottomStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 24
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let bottomLabel: UILabel = {
        let label = UILabel()
        label.setupConfigure(
            title: Constants.Text.bottomLabelTitle,
            lineHeightMultiple: 1.2,
            maximumLineHeight: 20,
            lineBreakMode: .byTruncatingTail,
            alignment: .left,
            numberOfLines: 1,
            font: Constants.Fonts.SFProDisplay14Regular,
            textColor: Constants.Colors.grayColor)
        return label
    }()

    private lazy var bottomButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        let title = Constants.Text.bottomButtonTitle
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
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.presenter?.didTapSendRequestButton()
        }), for: .touchUpInside)
        return button
    }()

    private lazy var panRecognizer: UIPanGestureRecognizer = {
        let recognizer = UIPanGestureRecognizer()
        recognizer.addTarget(self, action: #selector(popUpViewPanned(recognizer:)))
        return recognizer
    }()

    private var lastSelectedIndexes: [Int: Int] = [:]

    private var bottomConstraintBottomImageView = NSLayoutConstraint()
    private var heightConstraintBottomImageView = NSLayoutConstraint()
    private var popUpOffset: CGFloat = 0
    private var heightStatusBar: CGFloat = 0
    private var currentStateBottomView: BottomViewState = .closed
    private var runningAnimators = [UIViewPropertyAnimator]()
    private var animationProgress: [CGFloat] = []

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupGesture()
        presenter?.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        heightStatusBar = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        popUpOffset = view.bounds.height - bottomMainView.frame.height - heightStatusBar
        bottomConstraintBottomImageView.constant = popUpOffset
        heightConstraintBottomImageView.constant = view.bounds.height - heightStatusBar
    }

    // MARK: - Private Methods

    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(backgroundImageView)
        view.addSubview(bottomMainView)
        bottomMainView.addSubview(collectionView)
        view.addSubview(bottomStackView)
        bottomStackView.addArrangedSubview(bottomLabel)
        bottomStackView.addArrangedSubview(bottomButton)
    }

    private func setupConstraints() {
        bottomConstraintBottomImageView = bottomMainView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        heightConstraintBottomImageView = bottomMainView.heightAnchor.constraint(
            equalToConstant: Constants.Layout.bottomMainViewHeight
        )
        NSLayoutConstraint.activate([
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.heightAnchor.constraint(
                equalToConstant: round(view.bounds.width * Constants.Layout.aspectRatioToHeight)
            ),
            bottomMainView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomMainView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomConstraintBottomImageView,
            heightConstraintBottomImageView,

            collectionView.leadingAnchor.constraint(
                equalTo: bottomMainView.leadingAnchor,
                constant: Constants.Layout.collectionViewLeftAndRight
            ),
            collectionView.trailingAnchor.constraint(
                equalTo: bottomMainView.trailingAnchor,
                constant: -Constants.Layout.collectionViewLeftAndRight
            ),
            collectionView.topAnchor.constraint(
                equalTo: bottomMainView.topAnchor,
                constant: Constants.Layout.collectionViewTop),
            collectionView.heightAnchor.constraint(
                equalToConstant: Constants.Layout.collectionViewHeight
            ),

            bottomStackView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: Constants.Layout.bottomStackViewLeftAndRight
            ),
            bottomStackView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -Constants.Layout.bottomStackViewLeftAndRight),
            bottomStackView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor,
                constant: -Constants.Layout.bottomStackViewBot),
            bottomStackView.heightAnchor.constraint(
                equalToConstant: Constants.Layout.bottomStackViewHeight
            ),

            bottomLabel.widthAnchor.constraint(
                equalToConstant: Constants.Layout.bottomLabelWidth
            ),
            bottomButton.widthAnchor.constraint(
                equalToConstant: Constants.Layout.bottomButtonWidth
            )
        ])
    }

    private func setupGesture() {
        bottomMainView.addGestureRecognizer(panRecognizer)
    }

    private func animateTransitionIfNeeded(to state: BottomViewState, duration: TimeInterval) {
        guard runningAnimators.isEmpty else { return }

        let transitionAnimator = UIViewPropertyAnimator(
            duration: duration,
            dampingRatio: 1,
            animations: { [weak self] () -> Void in
                guard let self = self else { return }
                switch state {
                case .open:
                    self.bottomConstraintBottomImageView.constant = 0
                case .closed:
                    self.bottomConstraintBottomImageView.constant = self.popUpOffset
                }
                self.view.layoutIfNeeded()
            })

        transitionAnimator.addCompletion { [weak self] position in
            guard let self = self else { return }
            switch position {
            case .start:
                self.currentStateBottomView = state.opposite
            case .end:
                self.currentStateBottomView = state
            case .current:
                ()
            @unknown default:
                fatalError()
            }

            switch self.currentStateBottomView {
            case .open:
                self.bottomConstraintBottomImageView.constant = 0
            case .closed:
                self.bottomConstraintBottomImageView.constant = self.popUpOffset
            }

            self.runningAnimators.removeAll()
        }
        transitionAnimator.startAnimation()
        runningAnimators.append(transitionAnimator)
    }

    // MARK: - Object Methods

    @objc
    private func popUpViewPanned(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            animateTransitionIfNeeded(to: currentStateBottomView.opposite, duration: 1)
            runningAnimators.forEach { $0.pauseAnimation() }
            animationProgress = runningAnimators.map { $0.fractionComplete }
        case .changed:
            guard let firstElementInRunningAnimators = runningAnimators.first else { return }
            let translation = recognizer.translation(in: bottomMainView)
            var fraction = -translation.y / popUpOffset
            if currentStateBottomView == .open { fraction *= -1 }
            if firstElementInRunningAnimators.isReversed { fraction *= -1 }
            for (index, animator) in runningAnimators.enumerated() {
                animator.fractionComplete = fraction + animationProgress[index]
            }
        case .ended:
            let yVelocity = recognizer.velocity(in: bottomMainView).y
            let shouldClose = yVelocity > 0
            if yVelocity == 0 {
                runningAnimators.forEach {
                    $0.continueAnimation(withTimingParameters: nil, durationFactor: 0)
                }
                break
            }
            guard let firstElementInRunningAnimators = runningAnimators.first else { return }
            switch currentStateBottomView {
            case .open:
                if !shouldClose && !firstElementInRunningAnimators.isReversed {
                    runningAnimators.forEach { $0.isReversed = !$0.isReversed }
                }
                if shouldClose && firstElementInRunningAnimators.isReversed {
                    runningAnimators.forEach { $0.isReversed = !$0.isReversed }
                }
            case .closed:
                if shouldClose && !firstElementInRunningAnimators.isReversed {
                    runningAnimators.forEach { $0.isReversed = !$0.isReversed }
                }
                if !shouldClose && firstElementInRunningAnimators.isReversed {
                    runningAnimators.forEach { $0.isReversed = !$0.isReversed }
                }
            }

            runningAnimators.forEach {
                $0.continueAnimation(withTimingParameters: nil, durationFactor: 0)
            }
        default:
            break
        }
    }
}

// MARK: - UICollectionViewCompositionalLayout

extension MainViewController {
    private func createLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let self = self else { return nil }
            let section = self.internshipSections[sectionIndex]
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
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .estimated(Constants.Layout.itemWidth),
                heightDimension: .fractionalHeight(Constants.Layout.itemHeight)
            )
        )

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .estimated(Constants.Layout.firstSectionGroupWidth),
                heightDimension: .absolute(Constants.Layout.firstSectionGroupHeight)
            ),
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = Constants.EdgeInsets.firstSection

        let layoutSectionHeader = createSectionHeader()
        section.boundarySupplementaryItems = [layoutSectionHeader]
        section.interGroupSpacing = Constants.Layout.interSpacing
        return section
    }

    private func createBotLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .estimated(Constants.Layout.itemWidth),
                heightDimension: .fractionalHeight(Constants.Layout.itemHeight)
            )
        )

        let verticalGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .estimated(Constants.Layout.secondSectionGroupWidth),
                heightDimension: .absolute(Constants.Layout.secondSectionGroupHeight)
            ),
            subitems: [item, item, item, item, item]
        )
        verticalGroup.interItemSpacing = .fixed(Constants.Layout.interSpacing)
        
        let nestedGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .estimated(Constants.Layout.secondSectionNestedGroupWidth),
                heightDimension: .absolute(Constants.Layout.secondSectionNestedGroupHeight)
            ),
            subitems: [verticalGroup, verticalGroup]
        )
        nestedGroup.interItemSpacing = .fixed(Constants.Layout.interSpacing)

        let section = NSCollectionLayoutSection(group: nestedGroup)
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        section.contentInsets = Constants.EdgeInsets.secondSection

        let layoutSectionHeader = createSectionHeader()
        section.boundarySupplementaryItems = [layoutSectionHeader]
        section.interGroupSpacing = Constants.Layout.interSpacing
        return section
    }

    func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let layoutSectionHeaderSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(Constants.Layout.headerWidth),
            heightDimension: .estimated(Constants.Layout.headerHeight)
        )
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
        internshipSections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        internshipSections[section].items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: Constants.Text.directionCellIdentifier,
            for: indexPath) as? DirectionCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: internshipSections[indexPath.section].items[indexPath.row])
        if lastSelectedIndexes[indexPath.section] == indexPath.row {
            cell.setSelection(.selected)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: Constants.Text.sectionHeaderIdentifier,
                for: indexPath) as? SectionHeaderCollectionReusableView else {
                return UICollectionReusableView()
            }
            header.configure(with: internshipSections[indexPath.section])
            return header
        default:
            return UICollectionReusableView()
        }
    }
}

// MARK: - UICollectionViewDelegate

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter?.didTapItem(indexPath: indexPath)
    }
}

// MARK: - MainViewProtocol

extension MainViewController: MainViewProtocol {
    func loadViewModel(viewModel: [InternshipSection]) {
        self.internshipSections = viewModel
        collectionView.reloadData()
    }

    func showAlert() {
        let alert = UIAlertController(
            title: Constants.Text.alertTitle,
            message: Constants.Text.alertMessage,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: Constants.Text.alertClose, style: .cancel))
        present(alert, animated: true, completion: nil)
    }

    func moveCellAndUpdateViewModel(indexPath: IndexPath, updateViewModel: [InternshipSection]) {
        self.internshipSections = updateViewModel
        if let cell = collectionView.cellForItem(at: indexPath) as? DirectionCollectionViewCell {
            cell.toggleSelection()
            let section = indexPath.section
            if let lastSelectedCellIndex = lastSelectedIndexes[section],
               lastSelectedCellIndex != indexPath.row,
               let lastSelectedCell = collectionView.cellForItem(
                at: IndexPath(
                    row: lastSelectedCellIndex,
                    section: section)) as? DirectionCollectionViewCell {
                lastSelectedCell.toggleSelection()
            }
            let newIndex = 0
            collectionView.moveItem(
                at: indexPath,
                to: IndexPath(row: 0, section: indexPath.section)
            )
            collectionView.scrollToItem(
                at: IndexPath(item: newIndex, section: indexPath.section),
                at: .left,
                animated: true
            )
            lastSelectedIndexes[section] = cell.currentSelectionState == .selected
            ? newIndex
            : nil
        }
    }
}
