//
//  FuelViewController.swift
//  FuelManagementApp
//
//  Created by Arsalan Daud on 01/08/2024.
//

import UIKit

class FuelViewController: UIViewController {
    
    private let backgroundView = ImageView()
    private let screenTitle = Label(text: "Fuel Management")
    private let backButton = BackButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        addTargets()
    }
    
    private func setUpViews() {
        view.addSubview(backgroundView)
        view.addSubview(screenTitle)
        view.addSubview(backButton)
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            screenTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            screenTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            backButton.topAnchor.constraint(equalTo: screenTitle.bottomAnchor, constant: 25),
            backButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25)
        ])
    }
    private func addTargets() {
        backButton.addTarget(self, action: #selector(didBackButtonTapped), for: .touchUpInside)
    }
    
    @objc func didBackButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
