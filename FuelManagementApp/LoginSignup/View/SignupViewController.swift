//
//  SignupViewController.swift
//  FuelManagementApp
//
//  Created by ADJ on 31/07/2024.
//

import UIKit
import CoreData

class SignupViewController: BaseViewController {
    private let usernameTextField = TextFieldView(placeholder: "Enter username", returnType: .next)
    private let passwordTextField = TextFieldView(placeholder: "Enter password", isSecure: true, returnType: .done)
    private let showPassword = SystemImageButton(image: UIImage(systemName: "eye"), tintColor: .gray)
    private var emailTextFieldCenterYConstrainst: NSLayoutConstraint?
    private var userViewModel = UserViewModel()
//    private let alreadyUser = SystemImageButton(image: UIImage(systemName: "person.circle.fill"), size: UIImage.SymbolConfiguration(pointSize: 30), tintColor: .systemYellow)

    init() {
        super.init(screenTitle: "Sign up", actionTitle: "Sign up")
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegates()
        actionButton.alpha = 0.2
        actionButton.isUserInteractionEnabled = false
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    override func setupViews() {
        super.setupViews()
//        view.addSubview(alreadyUser)
        view.addSubview(usernameTextField)
        view.addSubview(passwordTextField)
        passwordTextField.addSubview(showPassword)
        
        NSLayoutConstraint.activate([
//            alreadyUser.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 25.autoSized),
//            alreadyUser.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25.widthRatio),
//            
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
            showPassword.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor, constant: -15.widthRatio),
        ])
    }
    override func addTargets() {
        super.addTargets()
//        alreadyUser.addTarget(self, action: #selector(didTappedPersonSymbol), for: .touchUpInside)
        actionButton.addTarget(self, action: #selector(createUser), for: .touchUpInside)
        showPassword.addTarget(self, action: #selector(visiblePassword), for: .touchUpInside)
        usernameTextField.textField.addTarget(self, action: #selector(didTextFieldChanged), for: .editingChanged)
        passwordTextField.textField.addTarget(self, action: #selector(didTextFieldChanged), for: .editingChanged)
    }
    
//    private func changeState() {
//        actionButton.alpha = 0.2
//        actionButton.isUserInteractionEnabled = false
//        usernameTextField.textField.text = ""
//        passwordTextField.textField.text = ""
//    }
    private func delegates() {
        usernameTextField.textField.delegate = self
        passwordTextField.textField.delegate = self
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
    @objc func createUser() {
        guard let username = usernameTextField.textField.text, let password = passwordTextField.textField.text else {
            return
        }
        userViewModel.createUser(username: username, password: password)
        popupAlert(title: "Sign up Successful", message: "Congratulations! Tap on ok to Sign up!", actionTitles: ["Login"], actionStyles: [.default], actions: [{ _ in
            self.navigationController?.pushViewController(LoginViewController(), animated: true )
//            self.changeState()
        }])
        userViewModel.storeCredentials(username: username, password: password)
    }
//    @objc func didTappedPersonSymbol() {
//        navigationController?.pushViewController(LoginViewController(), animated: true)
//        self.changeState()
//    }
}
extension SignupViewController: UITextFieldDelegate {
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
