//
//  SceneDelegate.swift
//  FuelManagementApp
//
//  Created by Arsalan Daud on 01/08/2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        self.navigateToSplashScreen()
    }
    private func navigateToSplashScreen() {
        let navigation = UINavigationController(rootViewController: SplashViewController())
        window?.rootViewController = navigation
        navigation.setNavigationBarHidden(true, animated: false)
        window?.makeKeyAndVisible()
    }
}

