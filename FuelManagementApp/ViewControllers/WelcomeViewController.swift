//
//  ViewController.swift
//  FuelManagement
//
//  Created by ADJ on 29/07/2024.
//

import UIKit
import CoreData

class WelcomeViewController: UIViewController {

    private let backgroundView = ImageView()
    private let screenTitle = Label(text: "Fuel Management",textFont: .bold(ofSize: 40))
    private let pumpImage = ImageView(imageName: "pump")
    private let welcomeText = Label(text: "Welcome to find expense calculate total of your expenditure",textColor: .white, textFont: .medium(ofSize: 25))
    private let loginButton = Button(setTitle: "Sign in")
    private let SignupButton = Button(setTitle: "Sign up")
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        addTargets()
    }
    
    private func setUpViews() {
        view.addSubview(backgroundView)
        view.addSubview(screenTitle)
        view.addSubview(pumpImage)
        view.addSubview(welcomeText)
        view.addSubview(loginButton)
        view.addSubview(SignupButton)
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            screenTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            screenTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            pumpImage.heightAnchor.constraint(equalToConstant: 200),
            pumpImage.topAnchor.constraint(equalTo: screenTitle.bottomAnchor, constant: 25),
            pumpImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            pumpImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            
            welcomeText.bottomAnchor.constraint(equalTo: loginButton.topAnchor, constant: -25),
            welcomeText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            welcomeText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            loginButton.widthAnchor.constraint(equalToConstant: 150),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -25),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            
            SignupButton.widthAnchor.constraint(equalToConstant: 150),
            SignupButton.heightAnchor.constraint(equalToConstant: 50),
            SignupButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -25),
            SignupButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25)
        ])
    }
    private func addTargets() {
        loginButton.addTarget(self, action: #selector(didLoginButtonTapped), for: .touchUpInside)
        SignupButton.addTarget(self, action: #selector(didSignupButtonTapped), for: .touchUpInside)
    }
    
    @objc func didLoginButtonTapped() {
        let login = loginViewController()
        navigationController?.pushViewController(login, animated: true)
    }
    @objc func didSignupButtonTapped() {
        let signup = SignupViewController()
        navigationController?.pushViewController(signup, animated: true)
    }
}
