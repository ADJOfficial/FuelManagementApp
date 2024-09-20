//
//  UserViewModel.swift
//  FuelManagementApp
//
//  Created by Arsalan Daud on 05/09/2024.
//

import LocalAuthentication
import KeychainSwift

class UserViewModel {
    // MARK: Create User
    func createUser(username: String, password: String) {
        let userDetails = User(context: DataBaseHandler.context)
        userDetails.username = username
        userDetails.password = password
        DataBaseHandler.saveContext()
        print("Username Saved in CoreData", userDetails.username as Any, userDetails.password as Any)
    }
    // MARK: Login User With Username, Password
    func loginUser(username: String, password: String, onSuccess: (String) -> Void, onFailure: (String) -> Void) {
        let fetchRequest = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "username == %@ AND password == %@", username, password)
        do {
            let users = try DataBaseHandler.context.fetch(fetchRequest)
            if let user = users.first {
                onSuccess("Successfully Login")
                print("Successfully Login \(user.username!)")
            } else {
                print("Invalid Credentials")
                onFailure("Invalid Credentials")
            }
        } catch {
            print("Error Fetching Data: \(error.localizedDescription)")
            onFailure("Error Fetching Data \(error.localizedDescription)")
        }
    }
    // MARK: Login User Using FaceID
    func loginWithFaceID(username: String, password: String, onSuccess: @escaping (VehicleViewController) -> Void, onFailure: @escaping (String) -> Void) {
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "Authenticate With FaceID To Sign in") { succes, error in
                DispatchQueue.main.async {
                    if succes {
                        print("FaceID Successfull")
                        let push = VehicleViewController()
                        onSuccess(push)
                    } else {
                        onFailure("FaceID Failed : \(error?.localizedDescription ?? "Unknown Error")")
                    }
                }
            }
        } else {
            onFailure("Device Not Support : \(error?.localizedDescription ?? "Unknown Error")")
        }
    }
    // MARK: Validate TextFields & Enable Button
    func didTextFieldChanged(username: String?, password: String?, visible: (Bool) -> Void) {
        let isValidEntry = isValidUsername(username: username ?? "") && isValidPassword(password: password ?? "")
        visible(isValidEntry)
    }
    // MARK: Email Regx
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[com]{2,3}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return predicate.evaluate(with: email)
    }
    // MARK: Username Regx
    func isValidUsername(username: String) -> Bool {
        let usernameRegEx = "^[A-Za-z ]{3,}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", usernameRegEx)
        return predicate.evaluate(with: username)
    }
    // MARK: Password Regx
    func isValidPassword(password: String) -> Bool {
        let passwordRegEx = "(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return predicate.evaluate(with: password)
    }
    // MARK: To Store Credential on Keychain
    func storeCredentials(username: String, password: String) {
        let keychain = KeychainSwift()
        keychain.set(username, forKey: "userUsername")
        keychain.set(password, forKey: "userPassword")
        print("Stored User Credentails with email \(username) and password \(password)")
    }
    // MARK: To Fetch Store Credentials
    func retrieveCredentials() -> (username: String?, password: String?) {
        let keychain = KeychainSwift()
        let username = keychain.get("userUsername")
        let password = keychain.get("userPassword")
        print("Fetched User With Email : \(username ?? "") and Password \(password ?? "")")
        return (username, password)
    }
}
