//
//  FuelViewModel.swift
//  FuelManagementApp
//
//  Created by ADJ on 07/09/2024.
//

import CoreData

class FuelViewModel {
    private var fuel: [Fuel] = []
    // MARK: Fetch Vehicle Fuel Details
    func fetchFuelDetails(objectID: NSManagedObjectID, emptyLogs: () -> Void, completion: ([Fuel]) -> Void) {
        var vehicle: Vehicle?
        do {
            vehicle = try DataBaseHandler.context.existingObject(with: objectID) as? Vehicle
            let fuelRecords = vehicle?.fuel?.allObjects as? [Fuel] ?? []
            self.fuel = fuelRecords
            if fuelRecords.isEmpty {
                emptyLogs()
            } else {
                for record in fuelRecords {
                    print("Fuel ID is  \(record.objectID) and Vehicle ObjectID is \(objectID)")
                }
                completion(fuelRecords)
            }
        } catch {
            print("Error While Fetching Data")
        }
        return
    }
    // MARK: Change Date Formate To String
    func changeDateTimeFormat(date: DateTimePicker) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM, yyyy h:mm a\nEEEE"
        let dateString = dateFormatter.string(from: date.date)
        return dateString
    }
    // MARK: Change Fetched DateTime Format To Date
    func changeFetchedDateFormat(date: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM, yyyy h:mm a\nEEEE"
        if let formattedDate = dateFormatter.date(from: date){
            return formattedDate
        }
        else {
            return Date()
        }
    }
    // MARK: For Navigation To Refill Controller
    func refillButton(objectID: NSManagedObjectID, navigate: (RefillViewController) -> Void) {
        guard let fuel = self.fuel.first else {
            return
        }
        let fuelRecords = FuelModel(objectID: fuel.objectID, fuelStation: fuel.fuelStation ?? "", filledDate: changeFetchedDateFormat(date: fuel.filledDate ?? ""), filledLiters: fuel.filledLiters ?? "", fuelEconomy: fuel.fuelEconomy ?? "", fuelAverageLkm: fuel.fuelAverageLkm ?? "")
        let controller = RefillViewController(fuelRecords: fuelRecords)
        navigate(controller)
    }
    // MARK: For Navigation To MaintainController
    func maintenanceButton(objectID: NSManagedObjectID, image: Data, navigate:  (MaintenanceLogsViewController) -> Void) {
        guard let fuel = self.fuel.first else {
            return
        }
        if let quantity = Int(fuel.filledLiters ?? ""), let cost = Int(fuel.fuelEconomy ?? "") {
            let totalPrice = quantity * cost
            let fuelRecords = VehicleModel(objectID: objectID, vehicleImage: image, purchaseDate: fuel.filledDate ?? "", fuelPrice: totalPrice)
            let maintenance = MaintenanceLogsViewController(vehicleRecords: fuelRecords)
            navigate(maintenance)
        }
    }
    // MARK: For Add Fuel
    func addFuel(objectID: NSManagedObjectID, station: String, date: String, quantity: String?, cost: String?, mileage: String?, onSuccess: () -> Void, onFailure: () -> Void) {
        guard let quantity = quantity,
              let cost = cost,
              let mileage = mileage else {
            return
        }
        var vehicle: Vehicle?
        do {
            vehicle = try DataBaseHandler.context.existingObject(with: objectID) as? Vehicle
        } catch {
            print("Error fetching vehicle: \(error)")
            return
        }
        let fillup = Fuel(context: DataBaseHandler.context)
        fillup.fuelStation = station
        fillup.filledDate = date
        fillup.filledLiters = quantity
        fillup.fuelEconomy = cost
        fillup.fuelAverageLkm = mileage
        vehicle?.addToFuel(fillup)
        do {
            try DataBaseHandler.context.save()
            onSuccess()
            print("New fuel record saved for vehicle: \(vehicle?.vehicleName ?? "") and Fillup Details is : \(fillup)")
        } catch {
            onFailure()
            print("Error while saving data: \(error)")
        }
    }
    // MARK: To Update Fuel
    func refillFuel(objectID: NSManagedObjectID, station: String, date: String,  quantity: String?, cost: String?, mileage: String?, onSuccess: () -> Void, onFailure: () -> Void) {
        guard let quantity = quantity,
              let cost = cost,
              let mileage = mileage  else {
            return
        }
        let vehicle: Fuel
        do {
            vehicle = try DataBaseHandler.context.existingObject(with: objectID) as! Fuel
        } catch {
            return
        }
        vehicle.fuelStation = station
        vehicle.filledDate = date
        vehicle.filledLiters = quantity
        vehicle.fuelEconomy = cost
        vehicle.fuelAverageLkm = mileage
        do {
            try DataBaseHandler.context.save()
            onSuccess()
        } catch {
            onFailure()
        }
    }
    // MARK: Validate TextField Should Not Be Empty
    func validateTextFields(leter: String, economy: String, average: String, visible: (Bool) -> Void){
        let isFilled = leter.isEmpty == false && economy.isEmpty == false && average.isEmpty == false
        visible(isFilled)
    }
    // MARK: Validating on Updating that TextField Must Not Be Empty & New Text != Existing
    func didTextEditingChanged(leters: String?, cost: String?, average: String?, date: DateTimePicker, station: String, fuelRecords: FuelModel, validate: (Bool) -> Void) {
        let isEditingChanged = (leters?.trimmingCharacters(in: .whitespaces).isEmpty == false &&
                                cost?.trimmingCharacters(in: .whitespaces).isEmpty == false &&
                                average?.trimmingCharacters(in: .whitespaces).isEmpty == false) && (leters?.trimmingCharacters(in: .whitespaces) != fuelRecords.filledLiters || cost?.trimmingCharacters(in: .whitespaces) != fuelRecords.fuelEconomy || average?.trimmingCharacters(in: .whitespaces) != fuelRecords.fuelAverageLkm || date.date > fuelRecords.filledDate || station != fuelRecords.fuelStation)
        validate(isEditingChanged)
    }
}
