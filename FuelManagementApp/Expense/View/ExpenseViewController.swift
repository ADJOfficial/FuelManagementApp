//
//  VehicleExpenseViewController.swift
//  FuelManagementApp
//
//  Created by Arsalan Daud on 12/08/2024.
//

import UIKit

class ExpenseViewController: BaseViewController {
    private let trackExpense = Label(text: "Track Your Vehicle Expense include Fuel, Maintenance, Repairs & other Vehicle Related Cost.", textFont: .medium(ofSize: 15))
    private let vehicleView = ImagePickerView()
    private let fuelExpense = Label(textColor: .black.withAlphaComponent(0.6), textFont: .bold(ofSize: 17))
    private let maintenanceExpense = Label(textColor: .black.withAlphaComponent(0.6), textFont: .bold(ofSize: 17))
    private var fuelDate = DateTimePicker(minimumDate: nil, maximumDate: nil)
    private let repairExpense = Label(textColor: .black.withAlphaComponent(0.6), textFont: .bold(ofSize: 17))
    private var expenseLabel = Label(textColor: .black.withAlphaComponent(0.6), textFont: .bold(ofSize: 17))
    
    private var expenseViewModel = ExpenseViewModel()
    private var expense: VehicleModel
    
    init(expense: VehicleModel) {
        self.expense = expense
        super.init(screenTitle: "Vehicle Expense", isActionButtonVisible: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fuelDate.date = changedDateFormat(date: expense.purchaseDate)
        setValues()
        totalExpense()
        fuelDate.isUserInteractionEnabled = false
    }
    
    override func setupViews() {
        super.setupViews()
        view.addSubview(trackExpense)
        view.addSubview(vehicleView)
        view.addSubview(fuelExpense)
        view.addSubview(maintenanceExpense)
        view.addSubview(repairExpense)
        view.addSubview(fuelDate)
        view.addSubview(expenseLabel)
        
        NSLayoutConstraint.activate([
            trackExpense.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 25.autoSized),
            trackExpense.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25.widthRatio),
            trackExpense.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25.widthRatio),
            
            vehicleView.heightAnchor.constraint(equalToConstant: 250.autoSized),
            vehicleView.topAnchor.constraint(equalTo: trackExpense.bottomAnchor, constant: 25.autoSized),
            vehicleView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5.widthRatio),
            vehicleView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5.widthRatio),
            
            fuelExpense.topAnchor.constraint(equalTo: vehicleView.bottomAnchor, constant: 25.autoSized),
            fuelExpense.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25.widthRatio),
            
            maintenanceExpense.topAnchor.constraint(equalTo: fuelExpense.bottomAnchor, constant: 25.autoSized),
            maintenanceExpense.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25.widthRatio),
            
            repairExpense.topAnchor.constraint(equalTo: maintenanceExpense.bottomAnchor, constant: 25.autoSized),
            repairExpense.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25.widthRatio),
            
            fuelDate.topAnchor.constraint(equalTo: repairExpense.bottomAnchor, constant: 25.autoSized),
            fuelDate.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            expenseLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25.widthRatio),
            expenseLabel.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -25.autoSized),
        ])
    }
    private func changedDateFormat(date: String) -> Date {
        return expenseViewModel.changeFetchedDateFormat(date: date)
    }
    private func setValues() {
        self.vehicleView.image = UIImage(data: expense.vehicleImage)
        self.fuelExpense.text = "Fuel Expense  :  \(expense.fuelPrice)"
        self.maintenanceExpense.text = "Maintenance Expense  :  \(expense.maintenanceCost)"
        self.repairExpense.text = "Repair Expense  :  \(expense.repairCost)"
    }
    private func totalExpense() {
        let total = expenseViewModel.totalExpense(fuelCost: expense.fuelPrice, maintenanceCost: expense.maintenanceCost, repairCost: expense.repairCost)
        expenseLabel.text = " Total Vehicle Expense  :  \(total)"
    }
}
