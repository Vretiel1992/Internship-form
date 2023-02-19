//
//  MainViewPresenter.swift
//  TestTaskSurf
//
//  Created by Антон Денисюк on 14.02.2023.
//

import Foundation

protocol MainViewPresenterProtocol: AnyObject {
    init(view: MainViewProtocol)
    func viewDidLoad()
    func didTapSendRequestButton()
    func didTapItem(indexPath: IndexPath)
}

final class MainViewPresenter: MainViewPresenterProtocol {

    // MARK: - Public Properties

    weak var view: MainViewProtocol?

    // MARK: - Private Properties

    private var internshipSections: [InternshipSection] = []

    // MARK: - Protocol Methods

    required init(view: MainViewProtocol) {
        self.view = view
    }

    func viewDidLoad() {
        getViewModel()
    }
    
    func didTapSendRequestButton() {
        view?.showAlert()
    }

    func didTapItem(indexPath: IndexPath) {
        updateViewModel(indexPath: indexPath)
        view?.moveCellAndUpdateViewModel(indexPath: indexPath, updateViewModel: internshipSections)
    }

    // MARK: - Private Methods

    private func getViewModel() {
        internshipSections = InternshipSection.internshipSections
        view?.loadViewModel(viewModel: internshipSections)
    }

    private func updateViewModel(indexPath: IndexPath) {
        let moveItem = internshipSections[indexPath.section].items.remove(at: indexPath.row)
        internshipSections[indexPath.section].items.insert(moveItem, at: 0)
    }
}
