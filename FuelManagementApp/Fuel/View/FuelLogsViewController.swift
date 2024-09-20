//
//  VehicleLogsViewController.swift
//  FuelManagementApp
//
//  Created by ADJ on 11/08/2024.
//

import UIKit

class FuelLogsViewController: BaseViewController {
    private let logsView = GradientView()
    private let lastFillup = Label(text: "Last Fillup Detail", textColor: .black, textFont: .bold(ofSize: 20))
    private var refillstation = Label(textColor: .black, textFont: .bold(ofSize: 16))
    let refillDate = Label(textColor: .black, textFont: .bold(ofSize: 16))
    private let refillQuantity = Label(textColor: .black, textFont: .bold(ofSize: 16))
    private let refillCost = Label(textColor: .black, textFont: .bold(ofSize: 16))
    private let refillMileage = Label(textColor: .black, textFont: .bold(ofSize: 16))
    let refillPrice = Label(textColor: .systemBlue, textFont: .bold(ofSize: 16))
    private let refillMove = Label(textColor: .systemBlue, textFont: .bold(ofSize: 16))
    private let maintenanceButton = SystemImageButton(image: UIImage(systemName: "engine.combustion.badge.exclamationmark.fill"), size: UIImage.SymbolConfiguration(pointSize: 30), tintColor: .systemYellow)

    private var fuelViewModel = FuelViewModel()
    private var vehicleRecords: VehicleModel
    
    init(vehicleRecords: VehicleModel) {
        self.vehicleRecords = vehicleRecords
        super.init(screenTitle: "Fuel Logs", actionTitle: "Refill Vehicle Now")
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchFuelLogs()
    }
    override func setupViews() {
        super.setupViews()
        view.addSubview(logsView)
        logsView.addSubview(lastFillup)
        logsView.addSubview(refillstation)
        logsView.addSubview(refillDate)
        logsView.addSubview(refillQuantity)
        logsView.addSubview(refillCost)
        logsView.addSubview(refillMileage)
        logsView.addSubview(refillPrice)
        logsView.addSubview(refillMove)
        view.addSubview(maintenanceButton)
        
        NSLayoutConstraint.activate([
            logsView.heightAnchor.constraint(equalToConstant: 450.autoSized),
            logsView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -25.autoSized),
            logsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10.widthRatio),
            logsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10.widthRatio),
            
            lastFillup.topAnchor.constraint(equalTo: logsView.topAnchor, constant: 25.autoSized),
            lastFillup.centerXAnchor.constraint(equalTo: logsView.centerXAnchor),
            
            refillstation.topAnchor.constraint(equalTo: lastFillup.bottomAnchor, constant: 25.autoSized),
            refillstation.leadingAnchor.constraint(equalTo: logsView.leadingAnchor, constant: 25.widthRatio),
            
            refillDate.topAnchor.constraint(equalTo: refillstation.bottomAnchor, constant: 15.autoSized),
            refillDate.leadingAnchor.constraint(equalTo: logsView.leadingAnchor, constant: 25.widthRatio),
            
            refillQuantity.topAnchor.constraint(equalTo: refillDate.bottomAnchor, constant: 15.autoSized),
            refillQuantity.leadingAnchor.constraint(equalTo: logsView.leadingAnchor, constant: 25.widthRatio),
            
            refillCost.topAnchor.constraint(equalTo: refillQuantity.bottomAnchor, constant: 15.autoSized),
            refillCost.leadingAnchor.constraint(equalTo: logsView.leadingAnchor, constant: 25.widthRatio),
            
            refillMileage.topAnchor.constraint(equalTo: refillCost.bottomAnchor, constant: 15.autoSized),
            refillMileage.leadingAnchor.constraint(equalTo: logsView.leadingAnchor, constant: 25.widthRatio),
            
            refillPrice.topAnchor.constraint(equalTo: refillMileage.bottomAnchor, constant: 25.autoSized),
            refillPrice.leadingAnchor.constraint(equalTo: logsView.leadingAnchor, constant: 25.widthRatio),
            
            refillMove.topAnchor.constraint(equalTo: refillMileage.bottomAnchor, constant: 25.autoSized),
            refillMove.trailingAnchor.constraint(equalTo: logsView.trailingAnchor, constant: -25.widthRatio),
            
            maintenanceButton.topAnchor.constraint(equalTo: logsView.bottomAnchor, constant: 25),
            maintenanceButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
        ])
    }
    override func addTargets() {
        super.addTargets()
        maintenanceButton.addTarget(self, action: #selector(didTappedMaintenanceButton), for: .touchUpInside)
        actionButton.addTarget(self, action: #selector(didRefillButtonTapped), for: .touchUpInside)
    }
    
    private func fetchFuelLogs() {
        fuelViewModel.fetchFuelDetails(objectID: vehicleRecords.objectID, emptyLogs: {
            popupAlert(title: "Empty Logs", message: "You have not refill your vehicle Yet!", style: .alert, actionTitles: ["Go Back","Fill Now"], actionStyles: [.cancel,.default], actions: [{ _ in
                self.navigationController?.popViewController(animated: true)
            },{ _ in
                let objectID = VehicleModel(objectID: self.vehicleRecords.objectID)
                self.navigationController?.pushViewController(AddFuelViewController(vehicleRecords: objectID), animated: true)
            }])
        }, completion: { fuelRecords in
            let records = fuelRecords.first
            self.refillstation.text = "Gas Station \n\(records?.fuelStation ?? "")"
            self.refillDate.text = "Filled Date \n\(records?.filledDate ?? "")"
            self.refillQuantity.text = "Filled Leters \n\(records?.filledLiters ?? "")"
            self.refillCost.text = "Fuel Economy \n\(records?.fuelEconomy ?? "")"
            self.refillMileage.text = "Vehicle Average L/km \n\(records?.fuelAverageLkm ?? "")"
            if let liters = Int(records?.filledLiters ?? ""), let cost = Int(records?.fuelEconomy ?? ""), let average = Int(records?.fuelAverageLkm ?? "") {
                let totalPrice = liters * cost
                let willRun = average * liters
                self.refillPrice.text = "Total Price \n\(totalPrice)"
                self.refillMove.text = "Will Move \n\(willRun) KM"
            }
        })
    }
    
    @objc func didRefillButtonTapped() {
        fuelViewModel.refillButton(objectID: vehicleRecords.objectID, navigate: { controller in
            self.navigationController?.pushViewController(controller, animated: true)
        })
    }
    @objc func didTappedMaintenanceButton() {
        fuelViewModel.maintenanceButton(objectID: vehicleRecords.objectID, image: vehicleRecords.vehicleImage, navigate: { controller in
            self.navigationController?.pushViewController(controller, animated: true)
        })
    }
}
