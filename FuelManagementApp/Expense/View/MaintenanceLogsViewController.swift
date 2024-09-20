//
//  VehicleLogsViewController.swift
//  FuelManagementApp
//
//  Created by ADJ on 11/08/2024.
//

import UIKit

class MaintenanceLogsViewController: BaseViewController {
    let logsView = GradientView()
    private let lastFillup = Label(text: "Last Maintenance Detail", textColor: .black, textFont: .bold(ofSize: 20))
    private let maintenanceCondition = Label(textColor: .black, textFont: .bold(ofSize: 16))
    private let maintenancedate = Label(textColor: .black, textFont: .bold(ofSize: 16))
    private let maintenanceCost = Label(textColor: .black, textFont: .bold(ofSize: 16))
    private let repairCost = Label(textColor: .black, textFont: .bold(ofSize: 16))
    private let ExpenseButton = SystemImageButton(image: UIImage(systemName: "dollarsign.circle.fill"), size: UIImage.SymbolConfiguration(pointSize: 35), tintColor: .systemGreen)

    private var expenseViewModel = ExpenseViewModel()
    private var vehicleRecords: VehicleModel
    
    init(vehicleRecords: VehicleModel) {
        self.vehicleRecords = vehicleRecords
        super.init(screenTitle: "Maintenance Logs", actionTitle: "New Maintenance")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchExpenseDatails()
    }
    override func setupViews() {
        super.setupViews()
        view.addSubview(logsView)
        logsView.addSubview(lastFillup)
        logsView.addSubview(maintenanceCondition)
        logsView.addSubview(maintenancedate)
        logsView.addSubview(maintenanceCost)
        logsView.addSubview(repairCost)
        view.addSubview(ExpenseButton)

        NSLayoutConstraint.activate([
            logsView.heightAnchor.constraint(equalToConstant: 350.autoSized),
            logsView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10.widthRatio),
            logsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10.widthRatio),

            lastFillup.topAnchor.constraint(equalTo: logsView.topAnchor, constant: 25.autoSized),
            lastFillup.centerXAnchor.constraint(equalTo: logsView.centerXAnchor),
            
            maintenanceCondition.topAnchor.constraint(equalTo: lastFillup.bottomAnchor, constant: 25.autoSized),
            maintenanceCondition.leadingAnchor.constraint(equalTo: logsView.leadingAnchor, constant: 25.widthRatio),
            
            maintenancedate.topAnchor.constraint(equalTo: maintenanceCondition.bottomAnchor, constant: 15.autoSized),
            maintenancedate.leadingAnchor.constraint(equalTo: logsView.leadingAnchor, constant: 25.widthRatio),
            
            maintenanceCost.topAnchor.constraint(equalTo: maintenancedate.bottomAnchor, constant: 15.autoSized),
            maintenanceCost.leadingAnchor.constraint(equalTo: logsView.leadingAnchor, constant: 25.widthRatio),
            
            repairCost.topAnchor.constraint(equalTo: maintenanceCost.bottomAnchor, constant: 15.autoSized),
            repairCost.leadingAnchor.constraint(equalTo: logsView.leadingAnchor, constant: 25.widthRatio),
            
            ExpenseButton.topAnchor.constraint(equalTo: logsView.bottomAnchor, constant: 25.autoSized),
            ExpenseButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25.widthRatio),
        ])
    }
    override func addTargets() {
        super.addTargets()
        actionButton.addTarget(self, action: #selector(didMaintenanceButtonTapped), for: .touchUpInside)
        ExpenseButton.addTarget(self, action: #selector(didExpenseButtonTapped), for: .touchUpInside)
    }
    
    private func changedDateFormat(date: String) -> Date {
        return expenseViewModel.changeFetchedDateFormat(date: date)
    }
    private func fetchExpenseDatails() {
        expenseViewModel.fetchExpenseDetails(objectID: vehicleRecords.objectID, emptyLogs: {
            popupAlert(title: "Empty Logs", message: "You have not Maintain your vehicle Yet!", style: .alert, actionTitles: ["Cancel","Maintain Now"], actionStyles: [.cancel,.default], actions: [{ _ in
                print("Operation Cancelled")
            },{ _ in
                let objectID = VehicleModel(objectID: self.vehicleRecords.objectID)
                self.navigationController?.pushViewController(AddMaintenanceViewController(vehicleRecords: objectID), animated: true)
            }])
        }, completion: { expenseRecords in
            let expense = expenseRecords.first
            self.maintenanceCondition.text = "Vehicle Condition \n\(expense?.maintenanceCondition ?? "")"
            self.maintenancedate.text = "Maintenance Date \n\(expense?.maintenanceDate ?? "")"
            self.maintenanceCost.text = "Maintenance Cost \n\(expense?.maintenanceCost ?? "")"
            self.repairCost.text = "Repair Cost \n\(expense?.repairCost ?? "")"
        })
    }
    
    @objc func didExpenseButtonTapped() {
        expenseViewModel.expenseButton(objectID: vehicleRecords.objectID, image: vehicleRecords.vehicleImage, date: vehicleRecords.purchaseDate, fuelPrice: vehicleRecords.fuelPrice, navigate: { expenseController in
            self.navigationController?.pushViewController(expenseController, animated: true)
        })
    }
    @objc func didMaintenanceButtonTapped() {
        expenseViewModel.maintenanceButton(navigate: { refillController in
            self.navigationController?.pushViewController(refillController, animated: true)
        })
    }
}
