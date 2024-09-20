//
//  VehicleViewModel.swift
//  FuelManagementApp
//
//  Created by Arsalan Daud on 05/09/2024.
//

import CoreData

class VehicleViewModel {
    private var vehicle: [Vehicle] = []
    // MARK: Fetch All Vehicles
    func fetchVehicles(emptyRecords: () -> Void, completion: ([Vehicle]) -> Void) {
        do {
            vehicle = try DataBaseHandler.context.fetch(Vehicle.fetchRequest())
            if vehicle.isEmpty {
                emptyRecords()
            } else {
                for task in vehicle {
                    print("ID is \(task.objectID) and Vehicle Name is \(task.vehicleName ?? "")")
                    completion(vehicle)
                }
            }
        } catch {
            print("Error While Fetching Data")
        }
        return
    }
    // MARK: TableView CellForRowAt Logic
    func cellForRowAt(task: Vehicle, cell: CustomTableCellView, tableView: TableView, push: @escaping (VehicleDetailViewController) -> Void) {
        let objectID = task.objectID
        cell.vehicleTitle.text = task.vehicleName
        if let image = DataBaseHandler.getImage(task) {
            cell.vehicleImage.image = image
        } else {
            cell.vehicleImage.imageName = "placeholder"
        }
        cell.vehicleCostLkm.text = task.vehicleCostLkm
        cell.purchaseDate.text = task.purchaseDate
        
        cell.didTappedDetailsButton = {
            let imageData = cell.vehicleImage.image?.pngData() ?? Data()
            let vehicle = VehicleModel(objectID : objectID, vehicleName: cell.vehicleTitle.text ?? "", vehicleImage: imageData, vehicleCostLkm: cell.vehicleCostLkm.text ?? "", purchaseDate: cell.purchaseDate.text ?? "")
            let details = VehicleDetailViewController(vehicleRecords: vehicle)
            push(details)
        }
    }
    // MARK: To Validate TextFields on Add Vehicle C0ntroller
    func validateTextFields(name: String, costLkm: String, visible: (Bool) -> Void){
        let isFilled = name.isEmpty == false && costLkm.isEmpty == false
        visible(isFilled)
    }
    // MARK: To Validate TextFields on Vehicle Details Controller To Calculate
    func validateTextFields(price: String, distance: String, visible: (Bool) -> Void){
        let isFilled = price.isEmpty == false && distance.isEmpty == false
        visible(isFilled)
    }
    // MARK: Change Date Time From String To String
    func changeDateTimeFormat(date: DateTimePicker) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM, yyyy h:mm a\nEEEE"
        let dateString = dateFormatter.string(from: date.date)
        return dateString
    }
    // MARK: To Add New Vehicle
    func AddVehicle(name: String?, costLkm: String?, image: ImagePickerView, date: String, onSucces: @escaping () ->Void, onFailure: @escaping (Error) -> Void) {
        guard let vehicleName = name, let costLkm = costLkm else {
            return
        }
        let newVehicle = Vehicle(context: DataBaseHandler.context)
        newVehicle.vehicleName = vehicleName
        newVehicle.vehicleCostLkm = costLkm
        newVehicle.purchaseDate = date
        if let image = image.image {
            DataBaseHandler.saveImage(image, for: newVehicle)
        } else {
            newVehicle.vehicleImage = nil
        }
        do {
            try DataBaseHandler.context.save()
            onSucces()
            print("New Vehicle Saved Successfully As Name: \(newVehicle), Make: \(newVehicle)")
        } catch {
            print("Error While Saving Data")
            onFailure(error)
        }
    }
    // MARK: To calculate Total Price Ramaining
    func calculateFuel(price: String?, distance: String?, costperkm: String?, calculate: (Int) -> Void) {
        guard let price = price, let distance = distance, let costperkm = costperkm,
              let priceInt = Int(price), let distanceInt = Int(distance),
              let costPerKM = Int(costperkm) else {
            return
        }
        let totalFuelCost = costPerKM * distanceInt
        let remainingPrice = max(priceInt - totalFuelCost, 0)
        calculate(Int(remainingPrice))
    }
    func pushToFuelLogs(objectID: NSManagedObjectID, image: Data, date: String, push: (FuelLogsViewController) -> Void) {
        let vehicle = VehicleModel(objectID: objectID, vehicleImage: image, purchaseDate: date)
        let vehicleRecords = FuelLogsViewController(vehicleRecords: vehicle)
        push(vehicleRecords)
    }
}
