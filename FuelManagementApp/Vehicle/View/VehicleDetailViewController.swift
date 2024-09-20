//
//  VehicleDetailViewController.swift
//  FuelManagementApp
//
//  Created by Arsalan Daud on 08/08/2024.
//

import UIKit

class VehicleDetailViewController: BaseViewController {
    private let detailsView = GradientView(colors: [UIColor.systemBlue.withAlphaComponent(0.6),UIColor.systemPurple])
    private let vehicleImage = ImagePickerView()
    private let vehicleName = Label(textColor: .black, textFont: .bold(ofSize: 30))
    private let vehicleCostLkm = Label(textColor: .black, textFont: .regular(ofSize: 20))
    private let filledPriceTextField = TextFieldView(placeholder: "Fuel Filled Price in Rupees", keyboardType: .decimalPad)
    private let distanceCoveredTextField = TextFieldView(placeholder: "Total Distance Covered in KM", keyboardType: .decimalPad)
    private let remainingFuelPrice = Label(textFont: .regular(ofSize: 18))
    private let selectVehicle = Button(backgroundColor: .clear, setTitle: "Select Vehicle", setTitleColor: .systemBlue)
    
    private let purchaseDate = Label(textColor: .black, textFont: .bold(ofSize: 18))

    private var selectedVehicleCostLkm: String?
    private var vehicleList: [Vehicle] = []
    private var menuItem: [UIMenuElement] = []
    private let vehicleRecords: VehicleModel
    private let vehicleViewModel = VehicleViewModel()
    
    init(vehicleRecords: VehicleModel) {
        self.vehicleRecords = vehicleRecords
        super.init(screenTitle: "Vehicle Details", actionTitle: "Check Fuel Logs")
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupValues()
        vehicleViewModel.fetchVehicles(emptyRecords: { print("No Vehicle Found") }, completion: { vehicles in
            DispatchQueue.main.async {
                self.vehicleList = vehicles
                self.showVehicleMenu()
            }
        })
    }
    override func setupViews() {
        super.setupViews()
        view.addSubview(selectVehicle)
        view.addSubview(detailsView)
        detailsView.addSubview(vehicleName)
        detailsView.addSubview(vehicleCostLkm)
        detailsView.addSubview(filledPriceTextField)
        detailsView.addSubview(distanceCoveredTextField)
        detailsView.addSubview(remainingFuelPrice)
        view.addSubview(vehicleImage)
        view.addSubview(purchaseDate)
        
        NSLayoutConstraint.activate([
            selectVehicle.heightAnchor.constraint(equalToConstant: 50.autoSized),
            selectVehicle.topAnchor.constraint(equalTo: screenTitleText.bottomAnchor, constant: 10.autoSized),
            selectVehicle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25.widthRatio),
            
            detailsView.heightAnchor.constraint(equalToConstant: 320.autoSized),
            detailsView.topAnchor.constraint(equalTo: selectVehicle.bottomAnchor),
            detailsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10.widthRatio),
            detailsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10.widthRatio),
            
            vehicleName.topAnchor.constraint(equalTo: detailsView.topAnchor, constant: 25.autoSized),
            vehicleName.centerXAnchor.constraint(equalTo: detailsView.centerXAnchor),
           
            vehicleCostLkm.topAnchor.constraint(equalTo: vehicleName.bottomAnchor, constant: 25.autoSized),
            vehicleCostLkm.leadingAnchor.constraint(equalTo: detailsView.leadingAnchor, constant: 25.widthRatio),
            
            filledPriceTextField.heightAnchor.constraint(equalToConstant: 50.autoSized),
            filledPriceTextField.topAnchor.constraint(equalTo: vehicleCostLkm.bottomAnchor, constant: 25.autoSized),
            filledPriceTextField.leadingAnchor.constraint(equalTo: detailsView.leadingAnchor, constant: 25.widthRatio),
            filledPriceTextField.trailingAnchor.constraint(equalTo: detailsView.trailingAnchor, constant: -25.widthRatio),
            
            distanceCoveredTextField.heightAnchor.constraint(equalToConstant: 50.autoSized),
            distanceCoveredTextField.topAnchor.constraint(equalTo: filledPriceTextField.bottomAnchor, constant: 25.autoSized),
            distanceCoveredTextField.leadingAnchor.constraint(equalTo: detailsView.leadingAnchor, constant: 25.widthRatio),
            distanceCoveredTextField.trailingAnchor.constraint(equalTo: detailsView.trailingAnchor, constant: -25.widthRatio),

            remainingFuelPrice.topAnchor.constraint(equalTo: distanceCoveredTextField.bottomAnchor, constant: 25.autoSized),
            remainingFuelPrice.leadingAnchor.constraint(equalTo: detailsView.leadingAnchor, constant: 25.widthRatio),
            
            vehicleImage.heightAnchor.constraint(equalToConstant: 150.autoSized),
            vehicleImage.topAnchor.constraint(equalTo: detailsView.bottomAnchor, constant: 25.autoSized),
            vehicleImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25.widthRatio),
            vehicleImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25.widthRatio),
            
            purchaseDate.topAnchor.constraint(equalTo: vehicleImage.bottomAnchor, constant: 25.autoSized),
            purchaseDate.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25.widthRatio),
        ])
    }
    override func addTargets() {
        super.addTargets()
        actionButton.addTarget(self, action: #selector(didLogsButtonTapped), for: .touchUpInside)
        filledPriceTextField.textField.addTarget(self, action: #selector(calculateFuel), for: .editingChanged)
        distanceCoveredTextField.textField.addTarget(self, action: #selector(calculateFuel), for: .editingChanged)
    }
    
    private func setupValues() {
        self.vehicleName.text = vehicleRecords.vehicleName
        self.vehicleCostLkm.text = "Fuel Cost in L/km : \(vehicleRecords.vehicleCostLkm)"
        self.vehicleImage.image = UIImage(data: vehicleRecords.vehicleImage)
        self.purchaseDate.text = "Purchase Date  \n\(vehicleRecords.purchaseDate)"
    }
    
    @objc func calculateFuel() {
        guard let price = filledPriceTextField.textField.text, !price.isEmpty, let distance = distanceCoveredTextField.textField.text, !distance.isEmpty else {
            self.remainingFuelPrice.text = ""
            return
        }
        let vehicleCostPerKm = selectedVehicleCostLkm ?? vehicleRecords.vehicleCostLkm
        vehicleViewModel.calculateFuel(price: price, distance: distance, costperkm: vehicleCostPerKm, calculate: { remaining in
            self.remainingFuelPrice.text = "Remaining Fuel Price : \(remaining)"
        })
    }
    @objc func didLogsButtonTapped() {
        vehicleViewModel.pushToFuelLogs(objectID: vehicleRecords.objectID, image: vehicleRecords.vehicleImage, date: vehicleRecords.purchaseDate, push: { push in navigationController?.pushViewController(push, animated: true)
            self.filledPriceTextField.textField.text = ""
            self.distanceCoveredTextField.textField.text = ""
            self.remainingFuelPrice.text = ""
        })
    }
    private func showVehicleMenu() {
        menuItem.removeAll()
        let action = { (action: UIAction) in
            self.selectVehicle.setTitle(action.title, for: .normal)
            
            if let selectedSubject = self.vehicleList.first(where: { $0.vehicleName == action.title }) {
                let vehicleName = selectedSubject.vehicleName ?? ""
                let vehicleFuelCost = selectedSubject.vehicleCostLkm ?? ""
                self.vehicleName.text = vehicleName
                self.vehicleCostLkm.text = "Fuel Cost in L/km : \(vehicleFuelCost)"
                self.selectedVehicleCostLkm = vehicleFuelCost
            }
        }
        for vehicle in vehicleList {
            menuItem.append(UIAction(title: vehicle.vehicleName ?? "", handler: action))
        }
        selectVehicle.menu = UIMenu(title: "Select Vehicle", options: .displayInline, children: menuItem)
        selectVehicle.showsMenuAsPrimaryAction = true
        selectVehicle.changesSelectionAsPrimaryAction = false
    }
}
