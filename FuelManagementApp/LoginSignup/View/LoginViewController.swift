//
//  LoginViewController.swift
//  FuelManagementApp
//
//  Created by ADJ on 31/07/2024.
//

import UIKit

class LoginViewController: BaseViewController {
    private let faceIDView = View()
    private let faceIDSymbol = SystemImageButton(image: UIImage(systemName: "faceid"), size: UIImage.SymbolConfiguration(pointSize: 40), tintColor: .white)
    private let usernameTextField = TextFieldView(placeholder: "Enter username", returnType: .next)
    private let passwordTextField = TextFieldView(placeholder: "Enter password", isSecure: true, returnType: .done)
    private let showPassword = SystemImageButton(image: UIImage(systemName: "eye"), tintColor: .gray)
    private let createAccount = SystemImageButton(image: UIImage(systemName: "person.fill.badge.plus"), size: UIImage.SymbolConfiguration(pointSize: 30), tintColor: .systemYellow)
    
    private let userViewModel = UserViewModel()
    
    init() {
        super.init(screenTitle: "Login", actionTitle: "Login", isBackButtonVisible: false)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        actionButton.alpha = 0.2
        actionButton.isUserInteractionEnabled = false
        usernameTextField.textField.delegate = self
        passwordTextField.textField.delegate = self
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    override func setupViews() {
        super.setupViews()
        view.addSubview(createAccount)
        view.addSubview(faceIDView)
        faceIDView.addSubview(faceIDSymbol)
        view.addSubview(usernameTextField)
        view.addSubview(passwordTextField)
        passwordTextField.addSubview(showPassword)

        NSLayoutConstraint.activate([
            createAccount.topAnchor.constraint(equalTo: screenTitleText.bottomAnchor, constant: 25.autoSized),
            createAccount.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25.widthRatio),
            
            faceIDView.widthAnchor.constraint(equalToConstant: 80.widthRatio),
            faceIDView.heightAnchor.constraint(equalToConstant: 70.autoSized),
            faceIDView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            faceIDView.bottomAnchor.constraint(equalTo: usernameTextField.topAnchor, constant: -25.autoSized),
            
            faceIDSymbol.centerXAnchor.constraint(equalTo: faceIDView.centerXAnchor),
            faceIDSymbol.centerYAnchor.constraint(equalTo: faceIDView.centerYAnchor),
            
            usernameTextField.heightAnchor.constraint(equalToConstant: 50.autoSized),
            usernameTextField.bottomAnchor.constraint(equalTo: passwordTextField.topAnchor, constant: -25.autoSized),
            usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25.widthRatio),
            usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25.widthRatio),

            passwordTextField.heightAnchor.constraint(equalToConstant: 50.autoSized),
            passwordTextField.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -70.autoSized),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25.widthRatio),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25.widthRatio),

            showPassword.topAnchor.constraint(equalTo: passwordTextField.topAnchor),
            showPassword.bottomAnchor.constraint(equalTo: passwordTextField.bottomAnchor),
            showPassword.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor, constant: -25.widthRatio),
        ])
    }
    override func addTargets() {
        super.addTargets()
        createAccount.addTarget(self, action: #selector(didTappedCreateButton), for: .touchUpInside)
        actionButton.addTarget(self, action: #selector(loginUser), for: .touchUpInside)
        showPassword.addTarget(self, action: #selector(visiblePassword), for: .touchUpInside)
        faceIDSymbol.addTarget(self, action: #selector(loginWithFaceID), for: .touchUpInside)
        usernameTextField.textField.addTarget(self, action: #selector(didTextFieldChanged), for: .editingChanged)
        passwordTextField.textField.addTarget(self, action: #selector(didTextFieldChanged), for: .editingChanged)
    }
    
    private func changeState() {
        actionButton.alpha = 0.2
        actionButton.isUserInteractionEnabled = false
        usernameTextField.textField.text = ""
        passwordTextField.textField.text = ""
    }
     
    @objc func visiblePassword() {
        passwordTextField.textField.isSecureTextEntry.toggle()
        let image = passwordTextField.textField.isSecureTextEntry ? "eye" : "eye.fill"
        showPassword.setImage(UIImage(systemName: image), for: .normal)
    }
    @objc func didTextFieldChanged() {
        userViewModel.didTextFieldChanged(username: usernameTextField.textField.text, password: passwordTextField.textField.text, visible: { visible in
            actionButton.alpha = visible ? 1.0 : 0.2
            actionButton.isUserInteractionEnabled = visible
        })
    }
    @objc func loginUser() {
        guard let username = usernameTextField.textField.text, let password = passwordTextField.textField.text else { return }
        userViewModel.loginUser(username: username, password: password, onSuccess: { success in
            self.didLoginButtonTapped()
            print("Successfully login \(success)")
        }, onFailure: { error in
            self.popAlert(title: "Login Failed", message: "Invalid username/password! New user? Tap on create or + symbol to create new account", cancelTitle: "Cancel", pushTitle: "Create", cancel: { print("ok") }, push: { self.navigationController?.pushViewController(SignupViewController(), animated: true)})
        })
    }
    @objc func loginWithFaceID() {
        let credentials = userViewModel.retrieveCredentials()
        userViewModel.loginWithFaceID(username: credentials.username ?? "", password: credentials.password ?? "", onSuccess: { push in
            self.navigationController?.pushViewController(push, animated: true)
            print("Successfully login \(push)")
        }, onFailure: { error in
            self.popupAlert(title: "Login Failed", message: "The credentails you have provided is invalid or expired", actionTitles: ["Try Again"], actionStyles: [.cancel], actions: [{ _ in print("Try Again") }])
        })
    }
    @objc func didLoginButtonTapped() {
        navigationController?.pushViewController(VehicleViewController(), animated: true)
    }
    @objc func didTappedCreateButton() {
        navigationController?.pushViewController(SignupViewController(), animated: true)
        self.changeState()
    }
}
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameTextField.textField {
            passwordTextField.textField.becomeFirstResponder()
        } else {
            passwordTextField.textField.resignFirstResponder()
        }
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == passwordTextField.textField {
            let currentText = passwordTextField.textField.text ?? ""
            let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
            return newText.count <= 8
        }
        return true
    }
}

