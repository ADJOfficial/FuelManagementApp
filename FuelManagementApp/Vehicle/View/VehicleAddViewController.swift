//
//  AddVehicleViewController.swift
//  FuelManagementApp
//
//  Created by Arsalan Daud on 06/08/2024.
//

import UIKit

class VehicleAddViewController: BaseViewController {
    private let uploadLabel = Label(text: "Upload an image ?", textColor: .systemBlue, textFont: .bold(ofSize: 17))
    private let imageView = ImagePickerView(backgroundColor: .clear)
    private let vehicleNameTextField = TextFieldView(placeholder: "Vehicle Name", returnType: .next)
    private let vehicleCostLkmTextField = TextFieldView(placeholder: "Cost in L/km", returnType: .done)
    private let purchaseDate = DateTimePicker(maximumDate: nil, backgroundColor: .systemYellow)
    
    private var vehicleViewModel = VehicleViewModel()
    private var imagePicker = UIImagePickerController()
    
    init() {
        super.init(screenTitle: "Add Vehicle", actionTitle: "Add Vehicle Now")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegates()
        actionButton.alpha = 0.2
        actionButton.isUserInteractionEnabled = false
        uploadLabel.isUserInteractionEnabled = true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func setupViews() {
        super.setupViews()
        view.addSubview(imageView)
        view.addSubview(uploadLabel)
        view.addSubview(vehicleNameTextField)
        view.addSubview(vehicleCostLkmTextField)
        view.addSubview(purchaseDate)

        NSLayoutConstraint.activate([
            uploadLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 15.autoSized),
            uploadLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25.widthRatio),
            
            imageView.widthAnchor.constraint(equalToConstant: 150.widthRatio),
            imageView.heightAnchor.constraint(equalToConstant: 100.autoSized),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: uploadLabel.bottomAnchor, constant: 10.autoSized),

            vehicleNameTextField.heightAnchor.constraint(equalToConstant: 50.autoSized),
            vehicleNameTextField.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 15.autoSized),
            vehicleNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25.widthRatio),
            vehicleNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25.widthRatio),
            
            vehicleCostLkmTextField.heightAnchor.constraint(equalToConstant: 50.autoSized),
            vehicleCostLkmTextField.topAnchor.constraint(equalTo: vehicleNameTextField.bottomAnchor, constant: 25.autoSized),
            vehicleCostLkmTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25.widthRatio),
            vehicleCostLkmTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25.widthRatio),
            
            purchaseDate.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            purchaseDate.topAnchor.constraint(equalTo: vehicleCostLkmTextField.bottomAnchor, constant: 20.autoSized),
        ])
    }
    override func addTargets() {
        super.addTargets()
        actionButton.addTarget(self, action: #selector(addVehicles), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(didBackButtonTapped), for: .touchUpInside)
        let upload = UITapGestureRecognizer(target: self, action: #selector(didTappedUploadLabel))
        uploadLabel.addGestureRecognizer(upload)
        vehicleNameTextField.textField.addTarget(self, action: #selector(didTextFieldFilled), for: .editingChanged)
        vehicleCostLkmTextField.textField.addTarget(self, action: #selector(didTextFieldFilled), for: .editingChanged)
    }
    
    private func delegates() {
        vehicleNameTextField.textField.delegate = self
        vehicleCostLkmTextField.textField.delegate = self
    }
    private func changedDateFormat() -> String {
        return vehicleViewModel.changeDateTimeFormat(date: purchaseDate)
    }
    
    @objc func didTextFieldFilled() {
        vehicleViewModel.validateTextFields(name: vehicleNameTextField.textField.text ?? "", costLkm: vehicleCostLkmTextField.textField.text ?? "", visible: { visible in
            actionButton.alpha = visible ? 1.0 : 0.2
            actionButton.isUserInteractionEnabled = visible
        })
    }
    @objc func addVehicles() {
        vehicleViewModel.AddVehicle(name: vehicleNameTextField.textField.text, costLkm: vehicleCostLkmTextField.textField.text, image: imageView, date: changedDateFormat(), onSucces: {
            self.popupAlert(title: "Vehicle Added", message: "Your new vehicle is added successfully on App", actionTitles: ["Enjoy Vehicle"], actionStyles: [.default], actions: [{ _ in
                self.navigationController?.popViewController(animated: true)
            }])
        }, onFailure: { error in
            self.popupAlert(title: "Vehicle not added", message: error.localizedDescription, actionTitles: ["Try Again"], actionStyles: [.cancel], actions: [{ action in
                print("Try Again")
            }])
        })
    }
    @objc func didTappedUploadLabel() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        popupAlert(title: "Choose Image Source", message: nil, style: .actionSheet, actionTitles: ["Camera","Photo Library","Cancel"], actionStyles: [.default,.default,.destructive], actions: [{ _ in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.imagePicker.sourceType = .camera
                self.present(self.imagePicker, animated: true, completion: nil)
            } else {
                print("Camera is not available")
            }
        }, { _ in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                self.imagePicker.sourceType = .photoLibrary
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }, { _ in
            print("Operation Cancelled")
        }])
    }
}
extension VehicleAddViewController: UITextFieldDelegate , UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.editedImage] as? UIImage {
            imageView.image = selectedImage
        } else if let selectedImage = info[.originalImage] as? UIImage {
            imageView.image = selectedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == vehicleNameTextField.textField {
            vehicleCostLkmTextField.textField.becomeFirstResponder()
        } else {
            vehicleCostLkmTextField.textField.resignFirstResponder()
        }
        return true
    }
}
