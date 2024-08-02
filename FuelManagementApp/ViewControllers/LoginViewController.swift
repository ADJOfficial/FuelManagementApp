//
//  LoginViewController.swift
//  FuelManagementApp
//
//  Created by ADJ on 31/07/2024.
//

import UIKit
import LocalAuthentication

class loginViewController: UIViewController {
    
    private let backgorundView = ImageView()
    private let screenTitle = Label(text: "Login")
    private let backButton = BackButton()
    private let faceID = SystemImageButton(image: UIImage(systemName: "faceid"))
    private let usernameFieldView = View()
    private let usernameTextField = TextField(placeholder: "Enter your username")
    private let requiredUsernameLabel = Label(text: "Required*", textColor: .red, textFont: .medium(ofSize: 20))
    private let passwordFieldView = View()
    private let passwordTextField = TextField(placeholder: "Enter your password")
    private let requiredPasswordLabel = Label(text: "Required*", textColor: .red, textFont: .medium(ofSize: 20))
    private let loginButton = Button(setTitle: "Login")
    
//    private var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        addTargets()
    }
    private func setUpViews() {
        view.addSubview(backgorundView)
        view.addSubview(screenTitle)
        view.addSubview(backButton)
        view.addSubview(faceID)
        view.addSubview(usernameFieldView)
        usernameFieldView.addSubview(usernameTextField)
        view.addSubview(requiredUsernameLabel)
        view.addSubview(passwordFieldView)
        passwordFieldView.addSubview(passwordTextField)
        view.addSubview(requiredPasswordLabel)
        view.addSubview(loginButton)
        
        NSLayoutConstraint.activate([
            backgorundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgorundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgorundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgorundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            screenTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            screenTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            backButton.topAnchor.constraint(equalTo: screenTitle.bottomAnchor, constant: 25),
            backButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            
            faceID.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            faceID.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            usernameFieldView.heightAnchor.constraint(equalToConstant: 50),
            usernameFieldView.topAnchor.constraint(equalTo: faceID.bottomAnchor, constant: 25),
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
            
            loginButton.widthAnchor.constraint(equalToConstant: 150),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -25),
        ])
    }
    private func addTargets() {
        backButton.addTarget(self, action: #selector(didBackButtonTapped), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginUser), for: .touchUpInside)
        faceID.addTarget(self, action: #selector(loginWithFaceID), for: .touchUpInside)
    }

    @objc func loginUser() {
        guard let username = usernameTextField.text, let password = passwordTextField.text else {
            return
        }
        let getUserData = User.fetchRequest()
        getUserData.predicate = NSPredicate(format: "username == %@ AND password == %@", username, password)
        
        do {
            let users = try DataBaseHandler.context.fetch(getUserData)
            if let user = users.first {
                didLoginButtonTapped()
                print("Successfully Login \(user.username!)")
            } else {
                print("Invalid Credentials")
            }
        } catch {
            print("Error Fetching Data: \(error)")
        }
    }
    @objc func loginWithFaceID() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "Authenticate With FaceID To Sign in") { succes, error in
                if succes {
                    print("FaceID Successfull")
                    let getUserData = User.fetchRequest()
                    getUserData.predicate = NSPredicate(format: "username == %@ AND password == %@", "Raja1", "Janjua1")
                    
                    do {
                        let users = try DataBaseHandler.context.fetch(getUserData)
                        if let user = users.first {
                            print("Successfully Login \(user.username!)")
                            DispatchQueue.main.async {
                                self.didLoginButtonTapped()
                            }
                        } else {
                            print("Invalid Credentials")
                        }
                    } catch {
                        print("Error Fetching Data: \(error)")
                    }
                } else if let error = error {
                    print("FaceID Failed \(error.localizedDescription)")
                }
            }
        } else {
            print("Phone Does'nt Support faceID")
        }
    }
    @objc func didLoginButtonTapped() {
        let fuelViewController = FuelViewController()
        navigationController?.pushViewController(fuelViewController, animated: true)
    }
    @objc func didBackButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
