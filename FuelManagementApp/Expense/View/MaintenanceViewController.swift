//
//  VehicleRefillViewController.swift
//  FuelManagementApp
//
//  Created by ADJ on 11/08/2024.
//

import UIKit

class MaintenanceViewController: BaseViewController {
    private let stationLabel = Label(text: "Vehicle Condition", textFont: .bold(ofSize: 20))
    private let cleanButton = SystemImageButton(image: UIImage(systemName: "circle"), setTitle: "Clean", setTitleColor: .white)
    private let dustyButton = SystemImageButton(image: UIImage(systemName: "circle"), setTitle: "Dusty", setTitleColor: .white)
    private let faultyButton = SystemImageButton(image: UIImage(systemName: "circle"), setTitle: "Faulty", setTitleColor: .white)
    private var refilDate = DateTimePicker(minimumDate: nil)
    private let maintenanceLabel = Label(text: "Maintenance Cost", textFont: .regular(ofSize: 17))
    private let maintenanceTextField = TextFieldView(placeholder: "Maintenance Cost", keyboardType: .numberPad)
    private let repairLabel = Label(text: "Repair Cost", textFont: .regular(ofSize: 17))
    private let repairTextField = TextFieldView(placeholder: "Repair Cost", keyboardType: .phonePad)

    private var selectedButton = ""
    private var expenseViewModel = ExpenseViewModel()
    private var expenseRecords: ExpenseModel
    
    init(expenseRecords: ExpenseModel) {
        self.expenseRecords = expenseRecords
        super.init(screenTitle: "Maintenance", actionTitle: "Maintain Now")
        selectedButton = expenseRecords.maintenanceCondition
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setValues()
        updateRadioButton()
        actionButton.alpha = 0.2
        actionButton.isUserInteractionEnabled = false
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    override func setupViews() {
        super.setupViews()
        view.addSubview(stationLabel)
        view.addSubview(cleanButton)
        view.addSubview(dustyButton)
        view.addSubview(faultyButton)
        view.addSubview(refilDate)
        view.addSubview(maintenanceLabel)
        view.addSubview(maintenanceTextField)
        view.addSubview(repairLabel)
        view.addSubview(repairTextField)
        
        NSLayoutConstraint.activate([
            stationLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 15.autoSized),
            stationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25.widthRatio),
            
            cleanButton.topAnchor.constraint(equalTo: stationLabel.bottomAnchor, constant: 15.autoSized),
            cleanButton.leadingAnchor.constraint(equalTo: stationLabel.leadingAnchor, constant: 25.widthRatio),
            
            dustyButton.topAnchor.constraint(equalTo: stationLabel.bottomAnchor, constant: 15.autoSized),
            dustyButton.leadingAnchor.constraint(equalTo: cleanButton.trailingAnchor, constant: 25.widthRatio),
            
            faultyButton.topAnchor.constraint(equalTo: stationLabel.bottomAnchor, constant: 15.autoSized),
            faultyButton.leadingAnchor.constraint(equalTo: dustyButton.trailingAnchor, constant: 25.widthRatio),

            refilDate.topAnchor.constraint(equalTo: cleanButton.bottomAnchor, constant: 20.autoSized),
            refilDate.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25.widthRatio),
            
            maintenanceLabel.topAnchor.constraint(equalTo: refilDate.bottomAnchor, constant: 25.autoSized),
            maintenanceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25.widthRatio),
            
            maintenanceTextField.heightAnchor.constraint(equalToConstant: 50.autoSized),
            maintenanceTextField.topAnchor.constraint(equalTo: maintenanceLabel.bottomAnchor, constant: 10.autoSized),
            maintenanceTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25.widthRatio),
            maintenanceTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25.widthRatio),

            repairLabel.topAnchor.constraint(equalTo: maintenanceTextField.bottomAnchor, constant: 10.autoSized),
            repairLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25.widthRatio),
            
            repairTextField.heightAnchor.constraint(equalToConstant: 50.autoSized),
            repairTextField.topAnchor.constraint(equalTo: repairLabel.bottomAnchor, constant: 10.autoSized),
            repairTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25.widthRatio),
            repairTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25.widthRatio),
        ])
    }
    override func addTargets() {
        super.addTargets()
        actionButton.addTarget(self, action: #selector(maintainVehicle), for: .touchUpInside)
        cleanButton.addTarget(self, action: #selector(didRadioButtonTapped), for: .touchUpInside)
        dustyButton.addTarget(self, action: #selector(didRadioButtonTapped), for: .touchUpInside)
        faultyButton.addTarget(self, action: #selector(didRadioButtonTapped), for: .touchUpInside)
        maintenanceTextField.textField.addTarget(self, action: #selector(didTextEditingChanged), for: .editingChanged)
        repairTextField.textField.addTarget(self, action: #selector(didTextEditingChanged), for: .editingChanged)
        refilDate.addTarget(self, action: #selector(didTextEditingChanged), for: .valueChanged)
    }
    
    private func setValues() {
        self.selectedButton = expenseRecords.maintenanceCondition
        self.refilDate.date = expenseRecords.maintenanceDate
        self.maintenanceTextField.textField.text = expenseRecords.maintenanceCost
        self.repairTextField.textField.text = expenseRecords.repairCost
    }
    private func updateRadioButton() {
        cleanButton.isSelected = expenseRecords.maintenanceCondition == "Clean"
        dustyButton.isSelected = expenseRecords.maintenanceCondition == "Dusty"
        faultyButton.isSelected = expenseRecords.maintenanceCondition == "Faulty"
        
        cleanButton.setImage(UIImage(systemName: cleanButton.isSelected ? "circle.fill" : "circle"), for: .normal)
        dustyButton.setImage(UIImage(systemName: dustyButton.isSelected ? "circle.fill" : "circle"), for: .normal)
        faultyButton.setImage(UIImage(systemName: faultyButton.isSelected ? "circle.fill" : "circle"), for: .normal)
    }
    private func changedDateFormat() -> String {
        return expenseViewModel.changeDateTimeFormat(date: refilDate)
    }
    
    @objc func didRadioButtonTapped(_ sender: UIButton) {
        cleanButton.isSelected = false
        dustyButton.isSelected = false
        faultyButton.isSelected = false
        if sender == cleanButton {
            selectedButton = "Clean"
        } else if sender == dustyButton {
            selectedButton = "Dusty"
        } else if sender == faultyButton {
            selectedButton = "Faulty"
        }
        sender.isSelected = true
        cleanButton.setImage(UIImage(systemName: cleanButton.isSelected ? "circle.fill" : "circle"), for: .normal)
        dustyButton.setImage(UIImage(systemName: dustyButton.isSelected ? "circle.fill" : "circle"), for: .normal)
        faultyButton.setImage(UIImage(systemName: faultyButton.isSelected ? "circle.fill" : "circle"), for: .normal)
    }
    @objc func maintainVehicle() {
        expenseViewModel.maintainVehicle(objectID: expenseRecords.objectID, selectedButton: selectedButton, date: changedDateFormat(), maintenance: maintenanceTextField.textField.text, repair: repairTextField.textField.text, onSuccess: {
            popupAlert(title: "Successful", message: "Vehicle Maintained Successfully", actionTitles: ["OK"], actionStyles: [.default], actions: [{ _ in
                self.navigationController?.popViewController(animated: true)
            }])
        }, onFailure: {
            popupAlert(title: "Unknown Error", message: "Failed To Maintained Vehicle", actionTitles: ["Try Again"], actionStyles: [.default], actions: [{ _ in print("Try Again") }])
        })
    }
    @objc func didTextEditingChanged() {
        expenseViewModel.didTextEditingChanged(maintenance: maintenanceTextField.textField.text, repair: repairTextField.textField.text, date: refilDate, expenseRecords: expenseRecords, validate: { visibleButton in
            actionButton.alpha = visibleButton ? 1.0 : 0.2
            actionButton.isUserInteractionEnabled = visibleButton
        })
    }
}
