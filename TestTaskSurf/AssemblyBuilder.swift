//
//  assemblyBuilder.swift
//  TestTaskSurf
//
//  Created by Антон Денисюк on 14.02.2023.
//

import UIKit

protocol AssemblyBuilderProtocol {
    func createMainModule() -> UIViewController
}

final class AssemblyBuilder: AssemblyBuilderProtocol {
    func createMainModule() -> UIViewController {
        let view = MainViewController()
        let presenter = MainViewPresenter(view: view)
        view.presenter = presenter
        return view
    }
}
