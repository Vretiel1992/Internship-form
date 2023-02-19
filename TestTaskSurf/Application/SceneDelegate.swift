//
//  SceneDelegate.swift
//  TestTaskSurf
//
//  Created by Антон Денисюк on 09.02.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let assemblyBuilder = Assembly()
        window?.rootViewController = assemblyBuilder.createMainModule()
        window?.makeKeyAndVisible()
    }
}
