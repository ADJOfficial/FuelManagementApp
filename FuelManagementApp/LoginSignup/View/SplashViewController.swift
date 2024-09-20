//
//  SplashController.swift
//  FuelManagementApp
//
//  Created by Arsalan Daud on 09/09/2024.
//

import UIKit

class SplashViewController: BaseViewController {
    private let logoImage = BackgroundImageView(imageName: "icon")
    
    init(screenTitle: String = "") {
        super.init(screenTitle: "Welcome", isBackButtonVisible: false, isActionButtonVisible: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startSplashScreenAnimation()
    }
    
    override func setupViews() {
        super.setupViews()
        view.addSubview(logoImage)
        NSLayoutConstraint.activate([
            logoImage.widthAnchor.constraint(equalToConstant: 200),
            logoImage.heightAnchor.constraint(equalToConstant: 200),
            logoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    private func startSplashScreenAnimation() {
        logoImage.alpha = 0.0
        UIView.animate(withDuration: 0.8, animations: {
            self.logoImage.alpha = 1.0
        }) { _ in
            self.goToMainScreen()
        }
    }
    private func goToMainScreen() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let mainViewController = LoginViewController()
            let navigationController = UINavigationController(rootViewController: mainViewController)
            navigationController.modalPresentationStyle = .fullScreen
            navigationController.setNavigationBarHidden(true, animated: false)
            self.present(navigationController, animated: true, completion: nil)
        }
    }
}
