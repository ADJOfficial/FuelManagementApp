//
//  VehicleRefillViewController.swift
//  FuelManagementApp
//
//  Created by ADJ on 11/08/2024.
//

import UIKit

class AddMaintenanceViewController: BaseViewController {
    private let stationLabel = Label(text: "What's Vehicle Condition", textFont: .bold(ofSize: 20))
    private let shellButton = SystemImageButton(image: UIImage(systemName: "circle"), setTitle: "Clean", setTitleColor: .white)
    private let psoButton = SystemImageButton(image: UIImage(systemName: "circle"), setTitle: "Dusty", setTitleColor: .white)
    private let attockButton = SystemImageButton(image: UIImage(systemName: "circle"), setTitle: "Faulty", setTitleColor: .white)
    private var refilDate = DateTimePicker(minimumDate: nil)
    private var maintenanceTextField = TextFieldView(placeholder: "Maintenance Cost", keyboardType: .phonePad)
    private var repairTextField = TextFieldView(placeholder: "Repair Cost", keyboardType: .phonePad)

    private var selectedButton = ""
    private var vehicleRecords: VehicleModel
    private var expenseViewModel = ExpenseViewModel()
    
    init(vehicleRecords: VehicleModel) {
        self.vehicleRecords = vehicleRecords
        super.init(screenTitle: "Apply Maintenance", actionTitle: "Maintain Now")
        actionButton.alpha = 0.5
        actionButton.isUserInteractionEnabled = false
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    override func setupViews() {
        super.setupViews()
        view.addSubview(stationLabel)
        view.addSubview(shellButton)
        view.addSubview(psoButton)
        view.addSubview(attockButton)
        view.addSubview(refilDate)
        view.addSubview(maintenanceTextField)
        view.addSubview(repairTextField)
        
        NSLayoutConstraint.activate([
            stationLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 25.autoSized),
            stationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25.widthRatio),
            
            shellButton.topAnchor.constraint(equalTo: stationLabel.bottomAnchor, constant: 25.autoSized),
            shellButton.leadingAnchor.constraint(equalTo: stationLabel.leadingAnchor, constant: 25.widthRatio),
            
            psoButton.topAnchor.constraint(equalTo: stationLabel.bottomAnchor, constant: 25.autoSized),
            psoButton.leadingAnchor.constraint(equalTo: shellButton.trailingAnchor, constant: 25.widthRatio),
            
            attockButton.topAnchor.constraint(equalTo: stationLabel.bottomAnchor, constant: 25.autoSized),
            attockButton.leadingAnchor.constraint(equalTo: psoButton.trailingAnchor, constant: 25.widthRatio),

            refilDate.topAnchor.constraint(equalTo: shellButton.bottomAnchor, constant: 25.autoSized),
            refilDate.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25.widthRatio),
            
            maintenanceTextField.heightAnchor.constraint(equalToConstant: 50.autoSized),
            maintenanceTextField.topAnchor.constraint(equalTo: refilDate.bottomAnchor, constant: 25.autoSized),
            maintenanceTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25.widthRatio),
            maintenanceTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25.widthRatio),

            repairTextField.heightAnchor.constraint(equalToConstant: 50.autoSized),
            repairTextField.topAnchor.constraint(equalTo: maintenanceTextField.bottomAnchor, constant: 25.autoSized),
            repairTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25.widthRatio),
            repairTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25.widthRatio),
        ])
    }
    override func addTargets() {
        super.addTargets()
        actionButton.addTarget(self, action: #selector(applyMaintenance), for: .touchUpInside)
        shellButton.addTarget(self, action: #selector(didRadioButtonTapped), for: .touchUpInside)
        psoButton.addTarget(self, action: #selector(didRadioButtonTapped), for: .touchUpInside)
        attockButton.addTarget(self, action: #selector(didRadioButtonTapped), for: .touchUpInside)
        maintenanceTextField.textField.addTarget(self, action: #selector(didTextFieldChanged), for: .editingChanged)
        repairTextField.textField.addTarget(self, action: #selector(didTextFieldChanged), for: .editingChanged)
    }
    private func changedDateFormat() -> String {
        return expenseViewModel.changeDateTimeFormat(date: refilDate)
    }
    
    @objc func didTextFieldChanged() {
        expenseViewModel.validateTextFields(maintenance: maintenanceTextField.textField.text ?? "", repair: repairTextField.textField.text ?? "", visible: { visible in
            actionButton.alpha = visible ? 1.0 : 0.5
            actionButton.isUserInteractionEnabled = visible
        })
    }
    @objc func applyMaintenance() {
        expenseViewModel.applyMaintenance(objectID: vehicleRecords.objectID, selectedButton: selectedButton, date: changedDateFormat(), maintenance: maintenanceTextField.textField.text, repair: repairTextField.textField.text, onSuccess: {
            popupAlert(title: "Successful", message: "Vehicle Maintenance Completed Successfully", actionTitles: ["OK"], actionStyles: [.default], actions: [{ _ in
                self.navigationController?.popViewController(animated: true)
            }])
        }, onFailure: {
            popupAlert(title: "Unknown Error", message: "Failed To Maintained Vehicle", actionTitles: ["Try Again"], actionStyles: [.default], actions: [{ _ in print("Try Again") }])
        })
    }
    @objc func didRadioButtonTapped(_ sender: UIButton) {
        shellButton.isSelected = false
        psoButton.isSelected = false
        attockButton.isSelected = false
        if sender == shellButton {
            selectedButton = "Clean"
        } else if sender == psoButton {
            selectedButton = "Dusty"
        } else if sender == attockButton {
            selectedButton = "Faulty"
        }
        sender.isSelected = true
        shellButton.setImage(UIImage(systemName: shellButton.isSelected ? "circle.fill" : "circle"), for: .normal)
        psoButton.setImage(UIImage(systemName: psoButton.isSelected ? "circle.fill" : "circle"), for: .normal)
        attockButton.setImage(UIImage(systemName: attockButton.isSelected ? "circle.fill" : "circle"), for: .normal)
    }
}

