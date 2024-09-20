//
//  VehicleRefillViewController.swift
//  FuelManagementApp
//
//  Created by ADJ on 11/08/2024.
//

import UIKit

class AddFuelViewController: BaseViewController {
    private let stationLabel = Label(text: "Select Gas Station", textFont: .bold(ofSize: 20))
    private let shellButton = SystemImageButton(image: UIImage(systemName: "circle"), setTitle: "Shell", setTitleColor: .white)
    private let psoButton = SystemImageButton(image: UIImage(systemName: "circle"), setTitle: "Pso", setTitleColor: .white)
    private let attockButton = SystemImageButton(image: UIImage(systemName: "circle"), setTitle: "Attock", setTitleColor: .white)
    private let refilDate = DateTimePicker(minimumDate: nil)
    private let leterTextField = TextFieldView(placeholder: "Fuel in Leter", keyboardType: .decimalPad)
    private let economyTextField = TextFieldView(placeholder: "Fuel economy", keyboardType: .decimalPad)
    private let averageTextField = TextFieldView(placeholder: "Average L/km", returnType: .done, keyboardType: .decimalPad)
    
    private var selectedButton = ""
    private var fuelViewModel = FuelViewModel()
    private var vehicleRecords: VehicleModel
    
    init(vehicleRecords: VehicleModel) {
        self.vehicleRecords = vehicleRecords
        super.init(screenTitle: "Fill Vehicle", actionTitle: "Fill Vehicle Now")
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        actionButton.alpha = 0.5
        actionButton.isUserInteractionEnabled = false
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
        view.addSubview(leterTextField)
        view.addSubview(economyTextField)
        view.addSubview(averageTextField)
        
        NSLayoutConstraint.activate([
            stationLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 25.autoSized),
            stationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25.widthRatio),
            
            shellButton.topAnchor.constraint(equalTo: stationLabel.bottomAnchor, constant: 15.autoSized),
            shellButton.leadingAnchor.constraint(equalTo: stationLabel.leadingAnchor, constant: 25.widthRatio),
            
            psoButton.topAnchor.constraint(equalTo: stationLabel.bottomAnchor, constant: 15.autoSized),
            psoButton.leadingAnchor.constraint(equalTo: shellButton.trailingAnchor, constant: 25.widthRatio),
            
            attockButton.topAnchor.constraint(equalTo: stationLabel.bottomAnchor, constant: 15.autoSized),
            attockButton.leadingAnchor.constraint(equalTo: psoButton.trailingAnchor, constant: 25.widthRatio),

            refilDate.topAnchor.constraint(equalTo: shellButton.bottomAnchor, constant: 25.autoSized),
            refilDate.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25.widthRatio),
            
            leterTextField.heightAnchor.constraint(equalToConstant: 50.autoSized),
            leterTextField.topAnchor.constraint(equalTo: refilDate.bottomAnchor, constant: 25.autoSized),
            leterTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25.widthRatio),
            leterTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25.widthRatio),

            economyTextField.heightAnchor.constraint(equalToConstant: 50.autoSized),
            economyTextField.topAnchor.constraint(equalTo: leterTextField.bottomAnchor, constant: 25.autoSized),
            economyTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25.widthRatio),
            economyTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25.widthRatio),
            
            averageTextField.heightAnchor.constraint(equalToConstant: 50.autoSized),
            averageTextField.topAnchor.constraint(equalTo: economyTextField.bottomAnchor, constant: 25.autoSized),
            averageTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25.widthRatio),
            averageTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25.widthRatio),
        ])
    }
    override func addTargets() {
        super.addTargets()
        actionButton.addTarget(self, action: #selector(addFuel), for: .touchUpInside)
        shellButton.addTarget(self, action: #selector(didRadioButtonTapped), for: .touchUpInside)
        psoButton.addTarget(self, action: #selector(didRadioButtonTapped), for: .touchUpInside)
        attockButton.addTarget(self, action: #selector(didRadioButtonTapped), for: .touchUpInside)
        leterTextField.textField.addTarget(self, action: #selector(didTextFieldChanged), for: .editingChanged)
        economyTextField.textField.addTarget(self, action: #selector(didTextFieldChanged), for: .editingChanged)
        averageTextField.textField.addTarget(self, action: #selector(didTextFieldChanged), for: .editingChanged)
    }
    
    private func changedDateFormat() -> String {
        return fuelViewModel.changeDateTimeFormat(date: refilDate)
    }

    @objc func didTextFieldChanged() {
        fuelViewModel.validateTextFields(leter: leterTextField.textField.text ?? "", economy: economyTextField.textField.text ?? "", average: averageTextField.textField.text ?? "", visible: { visible in
            actionButton.alpha = visible ? 1.0 : 0.5
            actionButton.isUserInteractionEnabled = visible
        })
    }
    @objc func addFuel() {
        fuelViewModel.addFuel(objectID: vehicleRecords.objectID, station: selectedButton, date: changedDateFormat(), quantity: leterTextField.textField.text, cost: economyTextField.textField.text, mileage: averageTextField.textField.text, onSuccess: {
            popupAlert(title: "Successful", message: "Fuel Added Successfully", actionTitles: ["OK"], actionStyles: [.default], actions: [{ _ in
                self.navigationController?.popViewController(animated: true)
            }])
        }, onFailure: {
            popupAlert(title: "Unknown Error", message: "Failed To Add Fuel", actionTitles: ["Try Again"], actionStyles: [.default], actions: [{ _ in print("Try Again") }])
        })
    }
    @objc func didRadioButtonTapped(_ sender: UIButton) {
        shellButton.isSelected = false
        psoButton.isSelected = false
        attockButton.isSelected = false
        if sender == shellButton {
            selectedButton = "Shell"
        } else if sender == psoButton {
            selectedButton = "Pso"
        } else if sender == attockButton {
            selectedButton = "Attock"
        }
        sender.isSelected = true
        shellButton.setImage(UIImage(systemName: shellButton.isSelected ? "circle.fill" : "circle"), for: .normal)
        psoButton.setImage(UIImage(systemName: psoButton.isSelected ? "circle.fill" : "circle"), for: .normal)
        attockButton.setImage(UIImage(systemName: attockButton.isSelected ? "circle.fill" : "circle"), for: .normal)
    }
}
