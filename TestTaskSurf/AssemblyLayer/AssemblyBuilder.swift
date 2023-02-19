//
//  assemblyBuilder.swift
//  TestTaskSurf
//
//  Created by Антон Денисюк on 14.02.2023.
//

import UIKit

protocol AssemblyProtocol {
    func createMainModule() -> UIViewController
}

final class Assembly: AssemblyProtocol {
    func createMainModule() -> UIViewController {
        let view = MainViewController()
        let presenter = MainViewPresenter(view: view)
        view.presenter = presenter
        return view
    }
}
