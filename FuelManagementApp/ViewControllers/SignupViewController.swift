//
//  SignupViewController.swift
//  FuelManagementApp
//
//  Created by ADJ on 31/07/2024.
//

import UIKit
import CoreData

class SignupViewController: UIViewController {
    
    private let backgroundView = ImageView()
    private let screenTitle = Label(text: "Sign up")
    private let backButton = BackButton()
    private let usernameFieldView = View()
    private let usernameTextField = TextField(placeholder: "Enter your username")
    private let requiredUsernameLabel = Label(text: "Required*", textColor: .red, textFont: .medium(ofSize: 20))
    private let passwordFieldView = View()
    private let passwordTextField = TextField(placeholder: "Enter your password")
    private let requiredPasswordLabel = Label(text: "Required*", textColor: .red, textFont: .medium(ofSize: 20))
    private let signupButton = Button(setTitle: "Sign up")
    
//    private var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        addTargets()
    }
    
    private func setUpViews() {
        view.addSubview(backgroundView)
        view.addSubview(screenTitle)
        view.addSubview(backButton)
        view.addSubview(usernameFieldView)
        usernameFieldView.addSubview(usernameTextField)
        view.addSubview(requiredUsernameLabel)
        view.addSubview(passwordFieldView)
        passwordFieldView.addSubview(passwordTextField)
        view.addSubview(requiredPasswordLabel)
        view.addSubview(signupButton)
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            screenTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            screenTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            backButton.topAnchor.constraint(equalTo: screenTitle.bottomAnchor, constant: 25),
            backButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            
            usernameFieldView.heightAnchor.constraint(equalToConstant: 50),
            usernameFieldView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            usernameFieldView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            usernameFieldView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            
            usernameTextField.topAnchor.constraint(equalTo: usernameFieldView.topAnchor),
            usernameTextField.bottomAnchor.constraint(equalTo: usernameFieldView.bottomAnchor),
            usernameTextField.leadingAnchor.constraint(equalTo: usernameFieldView.leadingAnchor, constant: 25),
            usernameTextField.trailingAnchor.constraint(equalTo: usernameFieldView.trailingAnchor, constant: -25),
            
            requiredUsernameLabel.topAnchor.constraint(equalTo: usernameFieldView.bottomAnchor, constant: 15),
            requiredUsernameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            
            passwordFieldView.heightAnchor.constraint(equalToConstant: 50),
            passwordFieldView.topAnchor.constraint(equalTo: requiredUsernameLabel.bottomAnchor, constant: 25),
            passwordFieldView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            passwordFieldView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            
            passwordTextField.topAnchor.constraint(equalTo: passwordFieldView.topAnchor),
            passwordTextField.bottomAnchor.constraint(equalTo: passwordFieldView.bottomAnchor),
            passwordTextField.leadingAnchor.constraint(equalTo: passwordFieldView.leadingAnchor, constant: 25),
            passwordTextField.trailingAnchor.constraint(equalTo: passwordFieldView.trailingAnchor, constant: -25),
            
            requiredPasswordLabel.topAnchor.constraint(equalTo: passwordFieldView.bottomAnchor, constant: 15),
            requiredPasswordLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            
            signupButton.widthAnchor.constraint(equalToConstant: 150),
            signupButton.heightAnchor.constraint(equalToConstant: 50),
            signupButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -25),
            signupButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    private func addTargets() {
        backButton.addTarget(self, action: #selector(didBackButtonTapped), for: .touchUpInside)
        signupButton.addTarget(self, action: #selector(createUser), for: .touchUpInside)
    }
    private func postUserData(){
        do {
            try DataBaseHandler.context.save()
            print("data saved")
        }
        catch {
            print("error saving data")
        }
    }

    @objc func createUser() {
        guard let username = usernameTextField.text, let password = passwordTextField.text else {
            return
        }
        let userDetails = User(context: DataBaseHandler.context)
        userDetails.username = username
        userDetails.password = password
        DataBaseHandler.saveDataInCoreData()
        didSignUpSuccessful()
        print("Username Saved in CoreData", userDetails.username as Any, userDetails.password as Any)
    }
    @objc func didSignUpSuccessful() {
        let login = loginViewController()
        navigationController?.pushViewController(login, animated: true)
    }
    @objc func didBackButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
