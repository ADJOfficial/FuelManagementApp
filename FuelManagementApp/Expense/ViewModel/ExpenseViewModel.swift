//
//  ExpenseViewModel.swift
//  FuelManagementApp
//
//  Created by Arsalan Daud on 05/09/2024.
//

import CoreData

class ExpenseViewModel {
    private var expense: [Expense] = []
    // MARK: Fetch All Expenses Details
    func fetchExpenseDetails(objectID: NSManagedObjectID, emptyLogs: () -> Void, completion: ([Expense]) -> Void) {
        var vehicle: Vehicle?
        do {
            vehicle = try DataBaseHandler.context.existingObject(with: objectID) as? Vehicle
            let expenseRecords = vehicle?.expense?.allObjects as? [Expense] ?? []
            self.expense = expenseRecords
            if expenseRecords.isEmpty {
                emptyLogs()
            } else {
                for record in expenseRecords {
                    print("Expense Record \(record.objectID)")
                }
                completion(expenseRecords)
            }
        } catch {
            print("Error While Fetching Data")
        }
        return
    }
    // MARK: To Maintain Vehicle
    func maintainVehicle(objectID: NSManagedObjectID, selectedButton: String, date: String, maintenance: String?, repair: String?, onSuccess: () -> Void, onFailure: () -> Void) {
        guard let maintenance = maintenance,
              let repair = repair else {
            return
        }
        let vehicle: Expense
        do {
            vehicle = try DataBaseHandler.context.existingObject(with: objectID) as! Expense
        } catch {
            return
        }
        vehicle.maintenanceCondition = selectedButton
        vehicle.maintenanceDate = date
        vehicle.maintenanceCost = maintenance
        vehicle.repairCost = repair
        do {
            try DataBaseHandler.context.save()
            onSuccess()
        } catch { 
            onFailure()
        }
    }
    // MARK: To Apply New Maintenance Against Vehicle
    func applyMaintenance(objectID: NSManagedObjectID, selectedButton: String?, date: String, maintenance: String?, repair: String?, onSuccess: () -> Void, onFailure: () -> Void) {
        guard let maintenance = maintenance,
              let repair = repair else {
            return
        }
        var vehicle: Vehicle?
        do {
            vehicle = try DataBaseHandler.context.existingObject(with: objectID) as? Vehicle
        } catch {
            print("Error fetching vehicle: \(error)")
            return
        }
        let maintain = Expense(context: DataBaseHandler.context)
        maintain.maintenanceCondition = selectedButton
        maintain.maintenanceDate = date
        maintain.maintenanceCost = maintenance
        maintain.repairCost = repair
        vehicle?.addToExpense(maintain)
        do {
            try DataBaseHandler.context.save()
            onSuccess()
            print("New fuel record saved for vehicle: \(vehicle?.vehicleName ?? "") and Fillup Details is : \(maintain)")
        } catch {
            onFailure()
            print("Error while saving data: \(error)")
        }
    }
    // MARK: Calculate Total Expense
    func totalExpense(fuelCost: Int, maintenanceCost: String, repairCost: String) -> Int{
        let cost = Int(fuelCost)
        let maintenance = Int(maintenanceCost) ?? 0
        let repair = Int(repairCost) ?? 0
        let total = cost + maintenance + repair
        return total
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
    // MARK: Maintenance Button Tapped
    func maintenanceButton(navigate: @escaping (MaintenanceViewController) -> Void) {
        guard let expense = self.expense.first else {
            return
        }
        let maintenance = ExpenseModel(objectID: expense.objectID, maintenanceCondition: expense.maintenanceCondition ?? "", maintenanceDate: changeFetchedDateFormat(date: expense.maintenanceDate ?? ""), maintenanceCost: expense.maintenanceCost ?? "", repairCost: expense.repairCost ?? "")
        let refillController = MaintenanceViewController(expenseRecords: maintenance)
        navigate(refillController)
    }
    // MARK: Expense Button Tapped
    func expenseButton(objectID: NSManagedObjectID, image: Data, date: String, fuelPrice: Int, navigate: @escaping (ExpenseViewController) -> Void) {
        guard let expense = self.expense.first else {
            return
        }
        let expenseModel = VehicleModel(objectID: objectID, vehicleImage: image, purchaseDate: date, fuelPrice: fuelPrice, maintenanceCost: expense.maintenanceCost ?? "", repairCost: expense.repairCost ?? "")
        let expenseController = ExpenseViewController(expense: expenseModel)
        navigate(expenseController)
    }
    // MARK: Validate TextField Should Not Be Empty
    func validateTextFields(maintenance: String, repair: String, visible: (Bool) -> Void){
        let isFilled = maintenance.isEmpty == false && repair.isEmpty == false
        visible(isFilled)
    }
    // MARK: Validating on Updating that TextField Must Not Be Empty & New Text != Existing
    func didTextEditingChanged(maintenance: String?, repair: String?, date: DateTimePicker, expenseRecords: ExpenseModel, validate: (Bool) -> Void) {
        let isEditingChanged = (maintenance?.trimmingCharacters(in: .whitespaces).isEmpty == false &&
                                repair?.trimmingCharacters(in: .whitespaces).isEmpty == false) &&
                                (maintenance?.trimmingCharacters(in: .whitespaces) != expenseRecords.maintenanceCost || repair?.trimmingCharacters(in: .whitespaces) != expenseRecords.repairCost || date.date > expenseRecords.maintenanceDate)
        validate(isEditingChanged)
    }
}
