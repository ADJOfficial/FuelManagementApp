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
    private let emailFieldView = View()
    private let emailTextField = TextField(placeholder: "Enter your email", keyboardReturn: .next)
    private let emailRequiredLabel = Label(text: "Required*", textColor: .systemRed, textFont: .medium(ofSize: 20))
    private let usernameFieldView = View()
    private let usernameTextField = TextField(placeholder: "Enter your username", keyboardReturn: .next)
    private let usernameRequiredLabel = Label(text: "Required*", textColor: .systemRed, textFont: .medium(ofSize: 20))
    private let passwordFieldView = View()
    private let passwordTextField = TextField(placeholder: "Enter your password", keyboardReturn: .done)
    private let passwordRequiredLabel = Label(text: "Required*", textColor: .systemRed, textFont: .medium(ofSize: 20))
    private let signupButton = Button(setTitle: "Sign up")
    
//    private var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        addTargets()
        setupKeyboardLayout()
        emailTextField.delegate = self
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        signupButton.alpha = 0.5
        signupButton.isUserInteractionEnabled = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func setUpViews() {
        view.addSubview(backgroundView)
        view.addSubview(screenTitle)
        view.addSubview(backButton)
        view.addSubview(emailFieldView)
        emailFieldView.addSubview(emailTextField)
        view.addSubview(emailRequiredLabel)
        view.addSubview(usernameFieldView)
        usernameFieldView.addSubview(usernameTextField)
        view.addSubview(usernameRequiredLabel)
        view.addSubview(passwordFieldView)
        passwordFieldView.addSubview(passwordTextField)
        view.addSubview(passwordRequiredLabel)
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
            
            emailFieldView.heightAnchor.constraint(equalToConstant: 50),
            emailFieldView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emailFieldView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            emailFieldView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            
            emailTextField.topAnchor.constraint(equalTo: emailFieldView.topAnchor),
            emailTextField.bottomAnchor.constraint(equalTo: emailFieldView.bottomAnchor),
            emailTextField.leadingAnchor.constraint(equalTo: emailFieldView.leadingAnchor, constant: 25),
            emailTextField.trailingAnchor.constraint(equalTo: emailFieldView.trailingAnchor, constant: -25),
            
            emailRequiredLabel.topAnchor.constraint(equalTo: emailFieldView.bottomAnchor, constant: 15),
            emailRequiredLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            
            usernameFieldView.heightAnchor.constraint(equalToConstant: 50),
            usernameFieldView.topAnchor.constraint(equalTo: emailRequiredLabel.bottomAnchor, constant: 25),
            usernameFieldView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            usernameFieldView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            
            usernameTextField.topAnchor.constraint(equalTo: usernameFieldView.topAnchor),
            usernameTextField.bottomAnchor.constraint(equalTo: usernameFieldView.bottomAnchor),
            usernameTextField.leadingAnchor.constraint(equalTo: usernameFieldView.leadingAnchor, constant: 25),
            usernameTextField.trailingAnchor.constraint(equalTo: usernameFieldView.trailingAnchor, constant: -25),
            
            usernameRequiredLabel.topAnchor.constraint(equalTo: usernameFieldView.bottomAnchor, constant: 15),
            usernameRequiredLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            
            passwordFieldView.heightAnchor.constraint(equalToConstant: 50),
            passwordFieldView.topAnchor.constraint(equalTo: usernameRequiredLabel.bottomAnchor, constant: 25),
            passwordFieldView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            passwordFieldView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            
            passwordTextField.topAnchor.constraint(equalTo: passwordFieldView.topAnchor),
            passwordTextField.bottomAnchor.constraint(equalTo: passwordFieldView.bottomAnchor),
            passwordTextField.leadingAnchor.constraint(equalTo: passwordFieldView.leadingAnchor, constant: 25),
            passwordTextField.trailingAnchor.constraint(equalTo: passwordFieldView.trailingAnchor, constant: -25),
            
            passwordRequiredLabel.topAnchor.constraint(equalTo: passwordFieldView.bottomAnchor, constant: 15),
            passwordRequiredLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            
            signupButton.widthAnchor.constraint(equalToConstant: 150),
            signupButton.heightAnchor.constraint(equalToConstant: 50),
            signupButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -25),
            signupButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    private func addTargets() {
        backButton.addTarget(self, action: #selector(didBackButtonTapped), for: .touchUpInside)
        signupButton.addTarget(self, action: #selector(createUser), for: .touchUpInside)
        emailTextField.addTarget(self, action: #selector(didTextFieldChanged), for: .editingChanged )
        usernameTextField.addTarget(self, action: #selector(didTextFieldChanged), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(didTextFieldChanged), for: .editingChanged)
    }
    private func validateEmail() {
        if let email = emailTextField.text, !email.isEmpty {
            if isValidEmail(email: email) {
                emailRequiredLabel.text = "Valid Email"
                emailRequiredLabel.textColor = .systemGreen
            } else {
                emailRequiredLabel.text = "Invalid Email"
                emailRequiredLabel.textColor = .systemRed
            }
        } else {
            emailRequiredLabel.text = "Required*"
        }
    }
    private func validUsername() {
        if let username = usernameTextField.text, !username.isEmpty {
            if isValidUsername(username: username) {
                usernameRequiredLabel.text = "Valid Username"
                usernameRequiredLabel.textColor = .systemGreen
            } else {
                usernameRequiredLabel.text = "Invalid Username"
                usernameRequiredLabel.textColor = .systemRed
            }
        } else {
            usernameRequiredLabel.text = "Required*"
        }
    }
    private func validatePassword() {
        if let password = passwordTextField.text, !password.isEmpty {
            if isValidPassword(password: password) {
                passwordRequiredLabel.text = "Valid Password"
                passwordRequiredLabel.textColor = .systemGreen
            } else {
                passwordRequiredLabel.text = "Invalid Password"
                passwordRequiredLabel.textColor = .systemRed
            }
        } else {
            passwordRequiredLabel.text = "Required*"
        }
    }
    private func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[com]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return predicate.evaluate(with: email)
    }
    private func isValidUsername(username: String) -> Bool {
        let usernameRegEx = "^[A-Za-z ]{3,}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", usernameRegEx)
        return predicate.evaluate(with: username)
    }
    private func isValidPassword(password: String) -> Bool {
        let passwordRegEx = "(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return predicate.evaluate(with: password)
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

    @objc func didTextFieldChanged() {
        if emailTextField.isFirstResponder{
            validateEmail()
        } else if usernameTextField.isFirstResponder {
            validUsername()
        } else if passwordTextField.isFirstResponder {
            validatePassword()
        }
        let isSignupEnabled = emailRequiredLabel.textColor == .systemGreen && usernameRequiredLabel.textColor == .systemGreen && passwordRequiredLabel.textColor == .systemGreen
        signupButton.alpha = isSignupEnabled ? 1.0 : 0.5
        signupButton.isUserInteractionEnabled = true
    }
    @objc func createUser() {
        guard let email = emailTextField.text, let username = usernameTextField.text, let password = passwordTextField.text else {
            return
        }
        let userDetails = User(context: DataBaseHandler.context)
        userDetails.email = email
        userDetails.username = username
        userDetails.password = password
        DataBaseHandler.saveDataInCoreData()
        let alert = UIAlertController(title: "Sign up Successful", message: "Congratulations! Tap on ok to Login in!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .default) {_ in
            self.didSignupSuccessful()
        })
        present(alert, animated: true, completion: nil)
        print("Username Saved in CoreData",userDetails.email as Any, userDetails.username as Any, userDetails.password as Any)
    }
    @objc func didSignupSuccessful() {
        let login = loginViewController()
        navigationController?.pushViewController(login, animated: true)
    }
    @objc func didBackButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

extension SignupViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            usernameTextField.becomeFirstResponder()
        } else if textField == usernameTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            passwordTextField.resignFirstResponder()
        }
        return true
    }
}
