//
//  ExpenseModel.swift
//  FuelManagementApp
//
//  Created by Arsalan Daud on 10/09/2024.
//

import CoreData

struct ExpenseModel {
    var objectID: NSManagedObjectID
    var maintenanceCondition: String
    var maintenanceDate: Date
    var maintenanceCost: String
    var repairCost: String
}
