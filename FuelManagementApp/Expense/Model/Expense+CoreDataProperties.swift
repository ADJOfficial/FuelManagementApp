//
//  Expense+CoreDataProperties.swift
//  FuelManagementApp
//
//  Created by Arsalan Daud on 16/09/2024.
//
//

import Foundation
import CoreData


extension Expense {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Expense> {
        return NSFetchRequest<Expense>(entityName: "Expense")
    }

    @NSManaged public var maintenanceCondition: String?
    @NSManaged public var maintenanceDate: String?
    @NSManaged public var maintenanceCost: String?
    @NSManaged public var repairCost: String?
    @NSManaged public var expense: Vehicle?

}

extension Expense : Identifiable {

}
