//
//  Vehicle+CoreDataProperties.swift
//  FuelManagementApp
//
//  Created by Arsalan Daud on 10/09/2024.
//
//

import Foundation
import CoreData


extension Vehicle {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Vehicle> {
        return NSFetchRequest<Vehicle>(entityName: "Vehicle")
    }

    @NSManaged public var vehicleImage: Data?
    @NSManaged public var purchaseDate: String?
    @NSManaged public var vehicleCostLkm: String?
    @NSManaged public var vehicleName: String?
    @NSManaged public var fuel: NSSet?
    @NSManaged public var expense: NSSet?

}

// MARK: Generated accessors for fuel
extension Vehicle {

    @objc(addFuelObject:)
    @NSManaged public func addToFuel(_ value: Fuel)

    @objc(removeFuelObject:)
    @NSManaged public func removeFromFuel(_ value: Fuel)

    @objc(addFuel:)
    @NSManaged public func addToFuel(_ values: NSSet)

    @objc(removeFuel:)
    @NSManaged public func removeFromFuel(_ values: NSSet)

}

// MARK: Generated accessors for expense
extension Vehicle {

    @objc(addExpenseObject:)
    @NSManaged public func addToExpense(_ value: Expense)

    @objc(removeExpenseObject:)
    @NSManaged public func removeFromExpense(_ value: Expense)

    @objc(addExpense:)
    @NSManaged public func addToExpense(_ values: NSSet)

    @objc(removeExpense:)
    @NSManaged public func removeFromExpense(_ values: NSSet)

}

extension Vehicle : Identifiable {

}
