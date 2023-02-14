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
}

final class MainViewPresenter: MainViewPresenterProtocol {

    // MARK: - Public Properties

    weak var view: MainViewProtocol?

    // MARK: - Private Properties

    private var viewModel: [Internship] = []

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

    // MARK: - Private Methods

    private func getViewModel() {
        viewModel = Internship.viewModel
        view?.loadViewModel(viewModel: viewModel)
    }
}
