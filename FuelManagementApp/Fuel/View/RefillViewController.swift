//
//  VehicleRefillViewController.swift
//  FuelManagementApp
//
//  Created by ADJ on 11/08/2024.
//

import UIKit

class RefillViewController: BaseViewController {
    private let stationLabel = Label(text: "Select Gas Station", textFont: .bold(ofSize: 23))
    private let shellButton = SystemImageButton(image: UIImage(systemName: "circle"), setTitle: "Shell", setTitleColor: .white)
    private let psoButton = SystemImageButton(image: UIImage(systemName: "circle"), setTitle: "Pso", setTitleColor: .white)
    private let attockButton = SystemImageButton(image: UIImage(systemName: "circle"), setTitle: "Attock", setTitleColor: .white)
    private var refilDate = DateTimePicker(minimumDate: nil)
    private let leterLabel = Label(text: "Fuel in leter", textFont: .regular(ofSize: 17))
    private let leterTextField = TextFieldView(placeholder: "Fuel in Leter", keyboardType: .decimalPad)
    private let economyLabel = Label(text: "Fuel economy", textFont: .regular(ofSize: 17))
    private let economyTextField = TextFieldView(placeholder: "Fuel economy", keyboardType: .phonePad)
    private let averageLabel = Label(text: "Average L/km", textFont: .regular(ofSize: 17))
    private let averageTextField = TextFieldView(placeholder: "Average L/km",keyboardType: .numberPad)
    
    private var selectedButton = ""
    private var fuelViewModel = FuelViewModel()
    private let fuelRecords: FuelModel
    
    init(fuelRecords: FuelModel) {
        self.fuelRecords = fuelRecords
        selectedButton = fuelRecords.fuelStation
        super.init(screenTitle: "Refill", actionTitle: "Fill Now")
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateRadioButton()
        setValues()
        actionButton.alpha = 0.2
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
        view.addSubview(leterLabel)
        view.addSubview(leterTextField)
        view.addSubview(economyLabel)
        view.addSubview(economyTextField)
        view.addSubview(averageLabel)
        view.addSubview(averageTextField)
        
        NSLayoutConstraint.activate([
            stationLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 15.autoSized),
            stationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25.widthRatio),
            
            shellButton.topAnchor.constraint(equalTo: stationLabel.bottomAnchor, constant: 15.autoSized),
            shellButton.leadingAnchor.constraint(equalTo: stationLabel.leadingAnchor, constant: 25.widthRatio),
            
            psoButton.topAnchor.constraint(equalTo: stationLabel.bottomAnchor, constant: 15.autoSized),
            psoButton.leadingAnchor.constraint(equalTo: shellButton.trailingAnchor, constant: 25.widthRatio),
            
            attockButton.topAnchor.constraint(equalTo: stationLabel.bottomAnchor, constant: 15.autoSized),
            attockButton.leadingAnchor.constraint(equalTo: psoButton.trailingAnchor, constant: 25.widthRatio),
            
            refilDate.topAnchor.constraint(equalTo: shellButton.bottomAnchor, constant: 20.autoSized),
            refilDate.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25.widthRatio),
            
            leterLabel.topAnchor.constraint(equalTo: refilDate.bottomAnchor, constant: 10.autoSized),
            leterLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25.widthRatio),
            
            leterTextField.heightAnchor.constraint(equalToConstant: 50.autoSized),
            leterTextField.topAnchor.constraint(equalTo: leterLabel.bottomAnchor, constant: 10.autoSized),
            leterTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25.widthRatio),
            leterTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25.widthRatio),
            
            economyLabel.topAnchor.constraint(equalTo: leterTextField.bottomAnchor, constant: 10.autoSized),
            economyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25.widthRatio),
            
            economyTextField.heightAnchor.constraint(equalToConstant: 50.autoSized),
            economyTextField.topAnchor.constraint(equalTo: economyLabel.bottomAnchor, constant: 10.autoSized),
            economyTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25.widthRatio),
            economyTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25.widthRatio),
            
            averageLabel.topAnchor.constraint(equalTo: economyTextField.bottomAnchor, constant: 10.autoSized),
            averageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25.widthRatio),
            
            averageTextField.heightAnchor.constraint(equalToConstant: 50.autoSized),
            averageTextField.topAnchor.constraint(equalTo: averageLabel.bottomAnchor, constant: 10.autoSized),
            averageTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25.widthRatio),
            averageTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25.widthRatio),
        ])
    }
    override func addTargets() {
        super.addTargets()
        actionButton.addTarget(self, action: #selector(refillFuel), for: .touchUpInside)
        shellButton.addTarget(self, action: #selector(didRadioButtonTapped), for: .touchUpInside)
        psoButton.addTarget(self, action: #selector(didRadioButtonTapped), for: .touchUpInside)
        attockButton.addTarget(self, action: #selector(didRadioButtonTapped), for: .touchUpInside)
        leterTextField.textField.addTarget(self, action: #selector(didTextEditingChanged), for: .editingChanged)
        economyTextField.textField.addTarget(self, action: #selector(didTextEditingChanged), for: .editingChanged)
        averageTextField.textField.addTarget(self, action: #selector(didTextEditingChanged), for: .editingChanged)
        refilDate.addTarget(self, action: #selector(didTextEditingChanged), for: .valueChanged)
    }
    
    private func changedDateFormat() -> String {
        return fuelViewModel.changeDateTimeFormat(date: refilDate)
    }
    private func updateRadioButton() {
        shellButton.isSelected = fuelRecords.fuelStation == "Shell"
        psoButton.isSelected = fuelRecords.fuelStation == "Pso"
        attockButton.isSelected = fuelRecords.fuelStation == "Attock"
        
        shellButton.setImage(UIImage(systemName: shellButton.isSelected ? "circle.fill" : "circle"), for: .normal)
        psoButton.setImage(UIImage(systemName: psoButton.isSelected ? "circle.fill" : "circle"), for: .normal)
        attockButton.setImage(UIImage(systemName: attockButton.isSelected ? "circle.fill" : "circle"), for: .normal)
    }
    private func setValues() {
        self.selectedButton = fuelRecords.fuelStation
        self.refilDate.date = fuelRecords.filledDate
        self.leterTextField.textField.text = fuelRecords.filledLiters
        self.economyTextField.textField.text = fuelRecords.fuelEconomy
        self.averageTextField.textField.text = fuelRecords.fuelAverageLkm
    }
    
    @objc func didRadioButtonTapped(_ sender: UIButton) {
        shellButton.isSelected = false
        psoButton.isSelected = false
        attockButton.isSelected = false
        if sender == shellButton {
            selectedButton = "SHELL"
        } else if sender == psoButton {
            selectedButton = "PSO"
        } else if sender == attockButton {
            selectedButton = "ATTOCK"
        }
        sender.isSelected = true
        shellButton.setImage(UIImage(systemName: shellButton.isSelected ? "circle.fill" : "circle"), for: .normal)
        psoButton.setImage(UIImage(systemName: psoButton.isSelected ? "circle.fill" : "circle"), for: .normal)
        attockButton.setImage(UIImage(systemName: attockButton.isSelected ? "circle.fill" : "circle"), for: .normal)
    }
    @objc func refillFuel() {
        fuelViewModel.refillFuel(objectID: fuelRecords.objectID, station: selectedButton, date: changedDateFormat(), quantity: leterTextField.textField.text, cost: economyTextField.textField.text, mileage: averageTextField.textField.text, onSuccess: {
            popupAlert(title: "Successful", message: "Fuel Added Successfully", actionTitles: ["OK"], actionStyles: [.default], actions: [{ _ in
                self.navigationController?.popViewController(animated: true)
            }])
        }, onFailure: {
            popupAlert(title: "Error", message: "Failed to update Fuel", actionTitles: ["Try Again"], actionStyles: [.default], actions: [{ _ in
                print("Try Again")
            }])
        })
    }
    @objc func didTextEditingChanged() {
        fuelViewModel.didTextEditingChanged(leters: leterTextField.textField.text, cost: economyTextField.textField.text, average: averageTextField.textField.text, date: refilDate, station: selectedButton, fuelRecords: fuelRecords, validate: { visibleButton in
            actionButton.alpha = visibleButton ? 1.0 : 0.2
            actionButton.isUserInteractionEnabled = visibleButton
        })
    }
}
